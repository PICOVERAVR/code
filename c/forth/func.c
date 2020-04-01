#include "header.h"

void push(int x) {
	if (dp > DSTACK_LIM) {
		dp = DSTACK_LIM;
		printf("Stack overflow!");
	} else dstack[dp++] = x;
}

int pop(void) {
	if (dp <= 0) {
		dp = 0;
		printf("Stack underflow!\n");
		return 0; //this is bad in case of exceptions
	}
	int x = dstack[--dp];
	return x;
}

void pstack_fn(void) {
	printf("%d\n", pop());
}

void CR_fn(void) {
	printf("\n");
}

void add_fn(void) {
	push(pop() + pop());
}

void sub_fn(void) {
	int x = pop();
	push(x - pop());
}

void mul_fn(void) {
	push(pop() * pop());
}

void AND_fn(void) {
	push(pop() & pop());
}

void OR_fn(void) {
	push(pop() | pop());
}

void XOR_fn(void) {
	push(pop() ^ pop()); //check these functions to see if they allow for communititve property
}

void NOT_fn(void) {
	push(~pop());
}

void muldiv_fn(void) {
	push((pop() * pop()) / pop());
}

void DUP_fn(void) {
	int x = pop();
	push(x);
	push(x);
}

void DROP_fn(void) {
	pop();
}

void SWAP_fn(void) {
	int x = pop();
	int y = pop();
	push(x);
	push(y);
}

void cDUP_fn(void) {
	int x = pop();
	if (x != 0) {
		push(x);
		push(x);
	}
}

void store_fn(void) {
	int x = pop();
	*(heaptr + pop()) = x;
}

void fetch_fn(void) {
	push(*(heaptr + pop()));
}

void add_store_fn(void) {
	*(heaptr + pop()) = pop();
}

void zero_less_fn(void) {
	push(pop() < 0);
}

void zero_equals_fn(void) {
	push(pop() == 0);
}

void zero_greater_fn(void) {
	push(pop() > 0);
}


