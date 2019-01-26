#include <linux/kvm_types.h>

#define DEBUG_INFO 1
#define HYPERFRESH_SL1 1

struct l1_map{
	unsigned long *l2gfn;
	unsigned long *l1gfn;
	long map_count;
};

struct gpa_pages{
	unsigned long gfn_of_l2page;
	unsigned long gfn_of_l1page;
};
