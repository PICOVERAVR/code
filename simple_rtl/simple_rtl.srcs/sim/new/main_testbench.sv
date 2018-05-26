`timescale 1ns / 1ns

module main_testbench();
    reg clk = 0;    
    reg en = 0;
    reg rst = 0;
    wire [15:0] instr;
    
    //module fetch(input clk, input en, input rst, output [31:0] instr, output [15:0] dbg_out);
    fetch f(.clk(clk), .en(en), .rst(rst), .instr(instr));
    
    
    always #(1) begin
        clk <= ~clk;
    end
    
    initial begin
        @(posedge clk);
        en <= 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        rst <= 1;
        @(posedge clk);
        rst <= 0;
        en <= 0;
        
    
    end
    
    
    /*
        Instruction decodings:
        15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
        |       11-bit imm              |   opcode   |  jr x (jump relative to pc)
        |xxxx|  dest  |  srcB  |  srcA  |   opcode   |  add r0, r1, r2
        |xxxxxxxxxxxxx|  dest  |  srcA  |   opcode   |  mv r0, r1
        |xxxxxxxxxxxxxxxxxxxxxxx  srcA  |   opcode   |  push r0
       
    */
    
endmodule