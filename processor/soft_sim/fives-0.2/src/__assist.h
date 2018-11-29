#ifndef ASSIST
#define ASSIST

#include <stdarg.h>
#include <stdlib.h>

// function to free all parameters passed to it
// first parameter is how many parameters there are
void __assist_free_all(int numfree, void *arg1, ...) {
    va_list args;
    void *vp;
    free(arg1);
    va_start(args, arg1);

    for(int i = 0; i < numfree-1; i++) {
        vp = va_arg(args, void *);
        free(vp);
    }

    va_end(args);
}

#endif
