#include "core.h"

extern sig_atomic_t interrupt_requested;
// misc functions to assist main.c

void trap_service(proc *p, int trap_vector) {
    // p->roc_ext_state = trap_vector / 4; NOT SHIFTED PROPERLY
    p->SP = p->PC; // save PC, keep SP
    p->SP -= 4;
    p->PC = trap_vector; // jump to trap
}

void interrupt_handle(proc *p) {
    unsigned int interrupt_level;
    dbprintf("caught interrupt, PC 0x%x", p->PC);
    printf("3bu ilevel: ");
    int err = scanf("%d", &interrupt_level);
    if (err < 0) {
        perror("scanf");
    }   

    if (interrupt_level > 7) {
        printf("WARN: invalid interrupt level!\n");
    }   
        
    p->BP = p->PC; // save PC and jump
    p->BP -= 4;
    p->PC = (4 * interrupt_level) + SYSTEM_TRAP_VEC_SIZE; // jump to interrupt vector, skip trap table
}

void signal_handler(int signum) {
    dbprintf("caught interrupt signal %d", signum);
	interrupt_requested = 1;
}

void proc_feat_set(proc *p, int bitpos, int val) {
    p->proc_ext_state |= val << bitpos;
}

uint16_t proc_feat_get(proc *p, int bitpos) {
    return (p->proc_ext_state >> bitpos);
}

