#include <linux/linkage.h>
#include <linux/export.h>
#include <linux/time.h>
#include <linux/printk.h>
#include <linux/slab.h>
#include <linux/mm.h>
#include <linux/vmalloc.h>
#include <linux/mmzone.h>
#include <linux/syscalls.h>
#include <linux/mm_types.h>
#include <asm/pgtable_types.h>
#include <linux/highmem.h>
#include <linux/rmap.h>
#include <linux/swap.h>
#include <linux/kvm_para.h>
#include <linux/kvm_host.h>

#define inc_mm_counter_fast(mm, member) inc_mm_counter(mm, member)
/*asmlinkage int sys_new_malloc(void){
 printk(KERN_ALERT "Hello World!\n");
 struct page *pg;
 pg = alloc_pages(0, 1);
 printk(KERN_ALERT "virt %llx\n", page_to_virt(pg));  
 printk(KERN_ALERT "phys %llx\n", page_to_phys(pg));
 return 0;
}
EXPORT_SYMBOL(sys_new_malloc);
*/
#define P4D_ERROR -1
#define PUD_ERROR -2
#define PMD_ERROR -3
#define PTE_ERROR -4
#define PAGE_ERROR -5

int count_nopte = 0;
int count_pte = 0;

static int create_mapping(struct vm_area_struct *vma,
				pmd_t *pmd,
				unsigned long virt_addr,
				unsigned long pfn)
{
	struct page *page;
	pte_t *pte;
	pte_t entry;
	spinlock_t *ptl;
	int ret = 0;

	page = pfn_to_page(pfn);
	atomic_inc(&page->_mapcount);

	if (!page)
		return PAGE_ERROR;

	__SetPageUptodate(page);

	pte = get_locked_pte(vma->vm_mm, virt_addr, &ptl);

        inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);

	entry = mk_pte(page, vma->vm_page_prot);

	if(vma->vm_flags & VM_WRITE)	
		entry = pte_mkwrite(pte_mkdirty(entry));

	set_pte_at(vma->vm_mm, virt_addr, pte, entry);
	update_mmu_cache(vma, virt_addr, pte);

	pte_unmap_unlock(pte, ptl);
	
	count_nopte++;	

	return 0;
}

static int do_anonymous_page(struct vm_area_struct *vma, 
				pmd_t *pmd, 
				unsigned long virt_addr,
				unsigned long pfn)
{
	struct page *page;
	pte_t *pte;
	int ret = 0;

	spinlock_t *ptl;
	pte_t entry;

	if (pte_alloc(vma->vm_mm, pmd, virt_addr))
                return PTE_ERROR;

	page = pfn_to_page(pfn);
	atomic_inc(&page->_mapcount);
	
	if (!page)
		return PAGE_ERROR;

	__SetPageUptodate(page);
	entry = mk_pte(page, vma->vm_page_prot);

	if(vma->vm_flags & VM_WRITE)
		entry = pte_mkwrite(pte_mkdirty(entry));

	pte = pte_offset_map_lock(vma->vm_mm, pmd, virt_addr,
                        &ptl);

        if (!pte_none(*pte))
                goto release;

        inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);

setpte:
        set_pte_at(vma->vm_mm, virt_addr, pte, entry);
	update_mmu_cache(vma, virt_addr, pte);

unlock:
        pte_unmap_unlock(pte, ptl);
	count_pte++;

	return ret;

release:
        put_page(page);
        goto unlock;


}
int handle_new_malloc(struct vm_area_struct *vma, unsigned long virt_addr, unsigned long pfn)
{
	struct mm_struct *mm = vma->vm_mm;

	pgd_t *pgd;
	p4d_t *p4d;
	pud_t *pud;
	pmd_t *pmd;
	pte_t *pte;
	
	pgd = pgd_offset(mm, virt_addr);
	
	p4d = p4d_alloc(mm, pgd, virt_addr);	
	if (!p4d)
                return P4D_ERROR;

	pud = pud_alloc(mm, p4d, virt_addr);

	if (!pud)
		return PUD_ERROR;

	pmd = pmd_alloc(mm, pud, virt_addr);
	if (!pmd)
		return PMD_ERROR;

	pte = pte_offset_map(pmd, virt_addr);

	/* if the entry is not accessed,
	place it as NULL*/
	if (pte_none(*pte)) {
		pte_unmap(pte);
                pte = NULL;
	}

	if (!pte)
	{
		return do_anonymous_page(vma, pmd, virt_addr, pfn);
	}
	else{
		return create_mapping(vma, pmd, virt_addr, pfn);
	}

}

u64 get_cr3(void)
{
#ifdef __x86_64__
    u64 cr0, cr2, cr3;
    __asm__ __volatile__ (
        "mov %%cr0, %%rax\n\t"
        "mov %%rax, %0\n\t"
        "mov %%cr2, %%rax\n\t"
        "mov %%rax, %1\n\t"
        "mov %%cr3, %%rax\n\t"
        "mov %%rax, %2\n\t"
    : "=m" (cr0), "=m" (cr2), "=m" (cr3)
    : /* no input */
    : "%rax"
    );
#elif defined(__i386__)
    u32 cr0, cr2, cr3;
    __asm__ __volatile__ (
        "mov %%cr0, %%eax\n\t"
        "mov %%eax, %0\n\t"
        "mov %%cr2, %%eax\n\t"
        "mov %%eax, %1\n\t"
        "mov %%cr3, %%eax\n\t"
        "mov %%eax, %2\n\t"
    : "=m" (cr0), "=m" (cr2), "=m" (cr3)
    : /* no input */
    : "%eax"
    );
#endif
    return cr3;
}

int disable_kvm_page_allocation(void)
{
	u64 cr3_value;
	cr3_value = get_cr3();	
	return 0;
}
int enable_kvm_page_allocation(void)
{
	return 0;
}

asmlinkage int sys_new_malloc(unsigned long virt_addr, int start_or_end, unsigned long pfn)
{
	int ret;
	struct page *pg;
	struct task_struct *tsk;
	struct mm_struct *mm;
	struct vm_area_struct *vma;

	//check start_or_end
	if (start_or_end == 1)
	{
		disable_kvm_page_allocation();
	}
	else if (start_or_end == 2)
	{
		enable_kvm_page_allocation();
		return 0;
	}

	tsk = current;
        mm = tsk->mm;
	down_read(&mm->mmap_sem);
 	
	vma = find_vma(mm, virt_addr);

	if (unlikely(!vma)) {
		up_read(&mm->mmap_sem);
                return 0;
        }
	else
	{
		ret = handle_new_malloc(vma, virt_addr, pfn);
		if (ret)
		{
			printk(KERN_ALERT "New Accolation Failed: %d!\n", ret);
			up_read(&mm->mmap_sem);
			return -1;
		}
	}
	up_read(&mm->mmap_sem);
 	return 0;
}
EXPORT_SYMBOL(sys_new_malloc);
