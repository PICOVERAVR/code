`timescale 1ns / 1ns

//module main(input sysclk, input [3:0] in, output reg [3:0] out);
    
//endmodule

module processor(input clk);  
    
    //make every stage a seperate module and have them pass through un-needed signals!!
    
    
    
    /*
        Instruction decodings:
        15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
        |       11-bit imm              |   opcode   |  jr x (jump relative to pc)
        |xxxx|  dest  |  srcB  |  srcA  |   opcode   |  add s0, s1, d
        |xxxxxxxxxxxxx|  dest  |  srcA  |   opcode   |  mv s, d
        |xxxxxxxxxxxxxxxxxxxxxx|  srcA  |   opcode   |  push r0
       
    */
endmodule
