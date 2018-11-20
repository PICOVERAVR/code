#ifndef ASSIST // maximum compatibility
#define ASSIST

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

void __assist_free_all(int numfree, void *arg1, ...);

// attribute checks for printf-correctness
int __assist_asprintf(char **str, char *fmt, ...) __attribute__ ((format (printf,2,3)));

#endif
