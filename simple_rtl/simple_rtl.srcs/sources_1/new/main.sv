`timescale 1ns / 1ns
`define REGFILE_LOAD 1'b0
`define REGFILE_READ 1'b1

`define WORD_SIZE 4
`define WORD_BITS (8 * `WORD_SIZE) - 1

//module main(input sysclk, input [3:0] in, output reg [3:0] out);
    
//endmodule

module processor(input clk, input rst, output reg [15:0] ir_addr, input [`WORD_BITS:0] ir_data, output reg [15:0] data_addr, input [15:0] data_in, output reg [15:0] data_out, output reg data_rw, output reg [15:0] dbg_out);  
    
    //make every stage a seperate module and have them pass through un-needed signals!!
    //module regfile(input clk, input en, input rst, input load_store, input [`REGS_BITS:0] sel_a, input [`REGS_BITS:0] sel_b, input [`REGS_BITS:0] sel_write, input [15:0] reg_in, output reg [15:0] out_a, output reg [15:0] out_b);
    //module pc(input clk, input en, input rst, input load_count, input [15:0] load, output reg [15:0] pc);
    //module branch(input [2:0] cond, input [15:0] op_a, input [15:0] op_b, output branch);
    //module alu(input clk, input en, input rst, input [15:0] reg_a, input [15:0] reg_b, output reg [15:0] out, input [2:0] op);
    
    
    
    /*
        Instruction decodings:
        15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
        |       11-bit imm              |   opcode   |  jr x (jump relative to pc)
        |xxxx|  dest  |  srcB  |  srcA  |   opcode   |  add r0, r1, r2
        |xxxxxxxxxxxxx|  dest  |  srcA  |   opcode   |  mv r0, r1
        |xxxxxxxxxxxxxxxxxxxxxx|  srcA  |   opcode   |  push r0
 [...]  |xxxxxxxxxxxxxxxxxxxxxx|  srcA  |   opcode   |  mov r0, $3
       
    */
endmodule

/*
    To add
        Hazard detection and resolution unit
            Use nops in between instructions until this is built
        Structural hazards
            processor has to stall itself, or add redundant hardware
            Use nops in between instructions until this is built
        Branch prediction?
        More instructions - multiply/divide support?
        Sign extension
        Correct PC behavior when used in RMW operations
    To optimize
*/








