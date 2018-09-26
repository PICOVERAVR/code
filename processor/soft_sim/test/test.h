#include <stdio.h>
#include "proc.h"
#include "execute.h"
#include "dispatch.h" // used to test r0 writes, since individual functions don't
			 // handle it
enum registers {
	R0,
	R1,
	R2,
	R3,
	R4,
	R5,
	R6,
};

void proc_set_vec(proc *p) {
	for (int i = 0; i < 32; i++) {
		p->regfile[i] = i;
	}
	
	p->i.f_s0 = R1;
	p->i.f_s1 = R2;
	p->i.f_d = R3;
}

// lots of identical code here, should really clean this up
// no isolation argument because check already does that

#test add_1
	proc *p = malloc(sizeof(proc));
	proc_set_vec(p);

	p->i.f_d = R3;
	
	p->regfile[R1] = 44;
	p->regfile[R2] = 32;

	instr_add(p);
	
	ck_assert_int_eq(p->regfile[R3], 76);
	
	free(p);

#test add_2
	proc *p = malloc(sizeof(proc));
	proc_set_vec(p);
	
	p->i.f_d = R3;
	
	instr_add(p);
	
	ck_assert_int_eq(p->regfile[R3], 3);
	
	free(p);

#test add_dest_r0
	state *s = malloc(sizeof(state));
	proc_set_vec(&(s->p));
	
	s->p.i.f_d = R0;
	s->p.i.f_opcode = ADD;

	int err = disp(s, NULL); // not executing an instruction that needs RAM
	
	ck_assert_int_eq(s->p.regfile[R0], 0);
	ck_assert_int_eq(err, 0);

	free(s);

#test mul_1
	proc *p = malloc(sizeof(proc));
	proc_set_vec(p);
	
	p->i.g_s0 = R6;
	p->i.g_s1 = R6;
	
	p->i.g_l = R3;
	p->i.g_h = R4;
	
	instr_mul(p);
	
	ck_assert_int_eq(p->regfile[R3], 36);

	free(p);
