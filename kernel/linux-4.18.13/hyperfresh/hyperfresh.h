#include <linux/kvm_types.h>

#define DEBUG_INFO 1
#define HYPERFRESH_SL1 0
//#define HYPERFRESH_L0 1
//#define HYPERFRESH_KVM_MAP_HASH_BITS 20

//int source_map_count;

struct l1_map{
	unsigned long *l2gfn;
	unsigned long *l1gfn;
	long map_count;
};

struct gpa_pages{
	unsigned long gfn_of_l2page;
	unsigned long gfn_of_l1page;
};

//struct source_mappings{
//        gfn_t source_l2gfn;
//        unsigned long guestid;
//        kvm_pfn_t l0pfn;
//        struct hlist_node node;
//};
//
//struct source_mappings *hyperfresh_global_map;
