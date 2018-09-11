#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <setjmp.h>
#include <stdarg.h>
#include <assert.h>
#include <signal.h>

#pragma once

#define EXCP_ILL_OPCODE 1

#define INTERNAL_ERROR 2

#define EXCP_NO_HEX 3
#define SIM_STOP 4

#define PROC_RAM 2048
//rom is as big as the hex file

typedef union {
	uint32_t raw_instr;
	struct { // A type instruction
		unsigned int opcode   : 6;
		unsigned int pm       : 3;
	};
	struct { // F type instruction
		unsigned int f_opcode : 6;
		unsigned int f_pm     : 3;
		unsigned int f_d      : 5;
		unsigned int f_s1     : 5;
		unsigned int f_s0     : 5;
	};
	struct { // D type instruction
		unsigned int d_opcode : 6;
		unsigned int d_pm     : 3;
		unsigned int d_d      : 5;
		unsigned int d_s      : 5;
	};
	struct { // C type instruction
		unsigned int c_opcode : 6;
		unsigned int c_pm     : 3;
		unsigned int c_s      : 5;
	};
	struct { // B type instruction
		unsigned int b_code   : 6;
		unsigned int b_pm     : 3;
		unsigned int b_imm    : 16;
	};
	struct { // E type instruction
		unsigned int e_opcode : 6;
		unsigned int e_pm     : 3;
		unsigned int e_s      : 5;
		unsigned int e_imm    : 16;
	};
	struct { // G type instruction
		unsigned int g_opcode : 6;
		unsigned int g_pm     : 3;
		unsigned int g_l      : 5;
		unsigned int g_h      : 5;
		unsigned int g_s1     : 5;
		unsigned int g_s0     : 5;
	};
	
} instr;

typedef union {
	struct {
		uint16_t regfile[32];
		instr raw_i;
	};
	struct {
		const uint16_t R0;
		uint16_t user_regfile[28];
		uint16_t BP;
		uint16_t SP;
		uint16_t PC;
		instr i;
	};
} proc;

typedef struct {
	proc p;
} state;

enum instruction_opcode {
	STOP,
	NOP,
	ADD,
	SUB,
	MUL,
	DIV,
	SEX,
	BN,
	BS,
	Bcc,
	LD,
	RST,
};

uint32_t fetch(uint16_t addr, uint32_t *hex_mem);
void break_ill_opcode();
void break_stop();

void free_state(int num_free, ...);

