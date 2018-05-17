`timescale 1ns / 1ns

module main_testbench();
    reg clk = 0;
    reg rst = 0;
    
    wire [15:0] ir_addr;
    reg[31:0] ir_data = 0;
    
    wire [15:0] data_addr;
    reg [15:0] data_data = 0;
    
    reg data_rw = 0;
    
    reg [31:0] instruction_mem [15:0]; //toy amount of memory for testing
    reg [15:0] data_mem [15:0];
    
    wire [15:0] dbg_out;
    
    integer i;
    
    //module processor(input clk, input rst, output reg [`WORD_BITS:0] ir_addr, input [`WORD_BITS:0] ir_data, output reg [15:0] data_addr, input [`WORD_BITS:0] data_data, input data_rw);
    processor p(.clk(clk), .rst(rst), .ir_addr(ir_addr), .ir_data(ir_data), .data_addr(data_addr), .data_data(data_data), .data_rw(data_rw), .dbg_out(dbg_out));
    
    always #(1) begin
        clk <= ~clk;
    end
    
    always @(clk) begin //feed memory to the processor every clock cycle
        ir_data <= instruction_mem[ir_addr];
        if (data_rw) begin
            data_mem[data_addr] <= data_data;
        end
        data_data <= data_mem[data_addr];
    end
    
    /*
        Instruction decodings:
        15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
        |       11-bit imm              |   opcode   |  jr x (jump relative to pc)
        |xxxx|  dest  |  srcB  |  srcA  |   opcode   |  add r0, r1, r2
        |xxxxxxxxxxxxx|  dest  |  srcA  |   opcode   |  mv r0, r1
        |xxxxxxxxxxxxxxxxxxxxxxx  srcA  |   opcode   |  push r0
       
    */
    
    initial begin
        rst <= 1;
        
        for (i = 0; i < 16; i = i + 1) begin //init instruction memory
            instruction_mem[i] <= 0;
            data_mem[i] <= 0;
        end
        
        instruction_mem[1] <= {16'hFFFF, 16'b000000000000_000_00010}; //ld r0, 0x????
        instruction_mem[8] <= {16'hFFFF, 16'b000000000_001_000_00001}; //mv r1, r0
        
        @(posedge clk); //reset all internal registers
        rst <= 0;
        
        @(posedge clk);
        
    end
endmodule