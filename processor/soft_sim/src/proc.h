#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <setjmp.h>
#include <stdarg.h>
#include <assert.h>
#include <signal.h>
#include <unistd.h>

// locks us into gcc, but I don't care and enables helpful macros
#define _GNU_SOURCE
#pragma once

#define EXCP_ILL_INSTR 1
#define EXCP_RESET 0
#define EXCP_MISALIGNED_CNTL 2
#define EXCP_DIV_ZERO 3

enum exception_vec {
	EXCP_RESET_VEC = 0x0,
	EXCP_ILL_INSTR_VEC = 0x4,
	EXCP_MISALIGNED_CNTL_VEC = 0x8,
	EXCP_DIV_ZERO_VEC = 0xB,
};

#define SYSTEM_TRAP_VEC_SIZE 4

// organize into enums
#define INTERNAL_ERROR 2
#define NO_HEX_ERROR 3

#define SIM_STOP 4

#define PROC_RAM 2048
//rom is as big as the hex file

#define PROC_FEAT_IE 0

// edit macro below if you want specific debug info
#define DEBUG 0
// see above
#define dbprintf(format, ...) \
	do { if (DEBUG) printf ("DBG: " format "\n", ## __VA_ARGS__); } while(0)

#define REGISTER_R0 0

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
	struct {
		unsigned int f2_opcode : 6;
		unsigned int f2_pm     : 3;
		unsigned int f2_d      : 5;
		unsigned int f2_s      : 5;
		unsigned int f2_short_imm : 12;
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
	uint16_t proc_ext_state;
} proc;

typedef struct { // this is a useless declaration, but I'd have to change a bunch of stuff
		 // to remove it and the compiler probably does it anyways
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
	ST,
	IO,
	AND,
	OR,
	XOR,
	NOT,
	INV,
	CALL,
	RET,
	PS,
	MOV,
	BR,
	RST,
};

uint32_t fetch(uint16_t addr, uint32_t *hex_mem);
void break_ill_opcode();
void break_stop();

void trap_service(proc *p, int exception_vector);
