#include <stdio.h>
#include <math.h>
#include <fenv.h>

void show_fe_exceptions(void) {
    printf("exceptions raised:");
    if(fetestexcept(FE_DIVBYZERO)) printf(" FE_DIVBYZERO");
    if(fetestexcept(FE_INEXACT))   printf(" FE_INEXACT");
    if(fetestexcept(FE_INVALID))   printf(" FE_INVALID");
    if(fetestexcept(FE_OVERFLOW))  printf(" FE_OVERFLOW");
    if(fetestexcept(FE_UNDERFLOW)) printf(" FE_UNDERFLOW");
    feclearexcept(FE_ALL_EXCEPT);
    printf("\n");
}

int main() {
	printf("tan(90): %f, ", tan(M_PI / 2));
	show_fe_exceptions();
	printf("sqrt(-1): %f, ", sqrt(-1));
	show_fe_exceptions();
	printf("asin(45): %f, ", asin(45));
	show_fe_exceptions();
	printf("NAN: %f, ", NAN);
	show_fe_exceptions();
	printf("0.0/0.0: %f, ", 0.0/0.0);
	show_fe_exceptions();
	printf("log(0): %f, ", log(0));
	show_fe_exceptions();
}
