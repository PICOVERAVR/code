#include "execute_check.h"

#define R0 0
#define R1 1
#define R2 2
#define R3 3
#define R4 4

// sets the contents of each register to register number
// makes testing easier
static void init_proc_vec(proc *p) {
	for (int i = 0; i < 32; i++) {
		p->regfile[i] = i;
	}
	
	// standard sources
	p->i.f_s0 = R1;
	p->i.f_s1 = R2;
}

START_TEST(add_test) {
	proc *p = malloc(sizeof(proc));
	init_proc_vec(p);
	
	p->i.f_d = R3;
	
	instr_add(p);
	
	ck_assert_int_eq(p->regfile[R3], 3);
	
	free(p);
} END_TEST


START_TEST(add_test_dest_r0) {
	proc *p = malloc(sizeof(proc));
	init_proc_vec(p);
	
	p->i.f_d = R0;
	
	instr_add(p);
	
	ck_assert_int_eq(p->regfile[R0], 0); // no checks for R0 destination
	
	free(p);
} END_TEST

START_TEST(mul_test) {
	proc *p = malloc(sizeof(proc));
	init_proc_vec(p);
	
	p->i.g_l = R3;
	p->i.g_h = R4;
	
	instr_mul(p);
	
	ck_assert_int_eq(p->regfile[R3], 2);
	
	free(p);
} END_TEST

Suite *arith_suite(void) {
	Suite *s;
	TCase *t;
	
	s = suite_create("Arithmetic Test Suite");
	t = tcase_create("Core");
	
	tcase_add_test(t, add_test);
	tcase_add_test(t, add_test_dest_r0);
	tcase_add_test(t, mul_test);
	
	suite_add_tcase(s, t);
	
	
	return s;
}
