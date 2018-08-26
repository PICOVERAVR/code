#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <setjmp.h>

#pragma once

#define ERR_NO_FILE -1
#define ERR_CANNOT_LOAD_FILE -2
#define EXCP_ILL_OPCODE 1

#define PROC_RAM 2048
#define PROC_ROM 2048

typedef union {
	uint32_t raw_instr;
	struct {
		unsigned int opcode   : 6;
		unsigned int pm       : 3;
		unsigned int ext      : 23;
	};
	struct { // A type instruction
		unsigned int a_opcode : 6;
		unsigned int a_pm     : 3;
		unsigned int a_ext    : 23;
	};
	struct { // F type instruction (also D, C types)
		unsigned int f_opcode : 6;
		unsigned int f_pm     : 3;
		unsigned int f_d      : 5;
		unsigned int f_s1     : 5;
		unsigned int f_s0     : 5;
		unsigned int f_ext    : 8;
	};
	struct { // B type instruction
		unsigned int b_code   : 6;
		unsigned int b_pm     : 3;
		unsigned int b_imm    : 16;
		unsigned int b_ext    : 7;
	};
	struct { // E type instruction
		unsigned int e_opcode : 6;
		unsigned int e_pm     : 3;
		unsigned int e_reg    : 5;
		unsigned int e_imm    : 16;
		unsigned int e_ext    : 2;
	};
	
} instr;

typedef union {
	struct {
		uint16_t regfile[32];
		instr raw_i;
	};
	struct {
		uint16_t R0;
		uint16_t user_regfile[28];
		uint16_t BP;
		uint16_t SP;
		uint16_t PC;
		instr i;
	};
} proc;

typedef struct {
	proc p;
	bool in_reset;
	
} state;

void proc_setup(int argc, char **argv, uint32_t *hex_mem, state *s);
void proc_teardown();

enum instructions {
	NOP = 1,
	ADD,
	SUB,
	MUL,
	DIV,
	HALT,
};
