`timescale 1ns / 1ns

module main_testbench();
    reg clk = 0;    
    reg en = 0;
    reg rst = 0;
    
    always #(1) begin
        clk <= ~clk;
    end
    
    initial begin
        
    
    end
    
    
    /*
        Instruction decodings:
        15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
        |       11-bit imm              |   opcode   |
        |       new_pc                  |   jr       |  jr x (jump relative to pc)
        |       addr           |   d    |   ld       |  ld m, d
        
        |xxxx|  dest  |  srcB  |  srcA  |   opcode   |  add s0, s1, d
        
        |xxxxxxxxxxxxx|  dest  |  srcA  |   opcode   |  mv s, d
        
        |xxxxxxxxxxxxxxxxxxxxxx|  srcA  |   opcode   |  push r0
        
       
    */
    
endmodule