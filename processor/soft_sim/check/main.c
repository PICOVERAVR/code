#include "main.h"
#include "execute_check.h"


int main() {
	
	int failed;
	Suite *s;
	SRunner *sr;
	
	s = arith_suite();
	sr = srunner_create(s);
	
	srunner_run_all(sr, CK_VERBOSE);
	failed = srunner_ntests_failed(sr);
	
	srunner_free(sr);
	
	
}
