#include "header.h"

long hash(char *str) {
    unsigned long seed = 5381;
    int c;
    
    while (c = *str++) {
        seed = ((seed << 5) + seed) + c; /* seed * 33 + c */
    }
    
    return seed;
}

void add_func(dict_entry x) {
    if (functab[(uint16_t)hash(x.name)].funcptr == NULL) {
        functab[(uint16_t)hash(x.name)].funcptr = x.funcptr;
    } else {
        printf("hash conflict, %s cannot fill!\n", x.name);
    }
}

void add_core_all(void) {
	add_core(pstack, ".", pstack_fn);
	add_core(CR, "CR", CR_fn);
	add_core(add, "+", add_fn);
	add_core(sub, "-", sub_fn);
	add_core(mul, "*", mul_fn);
	add_core(AND, "AND", AND_fn);
	add_core(OR, "OR", OR_fn);
	add_core(DUP, "DUP", DUP_fn);
    	add_core(DROP, "DROP", DROP_fn);
   	add_core(muldiv, "*/", muldiv_fn);
	add_core(SWAP, "SWAP", SWAP_fn);
	add_core(cDUP, "?DUP", cDUP_fn);
	add_core(store, "!", store_fn);
	add_core(fetch, "@", fetch_fn);
	add_core(XOR, "XOR", XOR_fn);
	add_core(NOT, "NOT", NOT_fn);
	add_core(add_store, "+!", add_store_fn);
	add_core(zero_less, "0<", zero_less_fn);
	add_core(zero_equal, "0=", zero_equals_fn);
	add_core(zero_greater, "0>", zero_greater_fn);
	
}

