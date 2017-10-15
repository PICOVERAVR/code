#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>
#include <setjmp.h>
#include <stdint.h>
#include <ctype.h>

#define DSTACK_LIM 255
#define add_core(name, ext_name, funcptr) dict_entry name = {ext_name, funcptr, NULL, NULL}; add_func(name);

int dstack[DSTACK_LIM]; //data stack for all things
int dp; //this is slow and might be a bad idea in the future, but i'm out of ideas rn

int *heaptr;

typedef struct dict_entry {
    char name[20]; //name of word
    void (*funcptr)(void); //function pointer to start of code
    struct dict_entry *prev; //ptr to previous entry
    struct dict_entry *next; //ptr to next entry
    //two above lines provided for operator overloading
} dict_entry;

dict_entry functab[65535]; //lookup table of all known functions, all params on stack

void push(int x);
int pop(void);

void pstack_fn(void);
void CR_fn(void);

void add_fn(void);
void sub_fn(void);
void mul_fn(void);
void div_fn(void);
void AND_fn(void);
void OR_fn(void);
void XOR_fn(void);
void NOT_fn(void);
void muldiv_fn(void);

void DUP_fn(void);
void DROP_fn(void);
void SWAP_fn(void);
void cDUP_fn(void);

void store_fn(void);
void fetch_fn(void);
void add_store_fn(void);

void zero_less_fn(void);
void zero_equals_fn(void);
void zero_greater_fn(void);

long hash(char *str);
void add_func(dict_entry x);

void add_core_all(void);
