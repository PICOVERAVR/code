/*
    Instruction fetch unit
    instantiate PC, fetch instruction
*/

module fetch(clk, rst, ir_addr, ir_data, instr, dbg_out);
    input clk;
    input rst;
    
    input [15:0] ir_addr;
    input [15:0] ir_data;
    
    output [15:0] instr;
    
    output [15:0] dbg_out;
    
    
    //module pc(input clk, input en, input rst, input load_count, input [15:0] load, output reg [15:0] pc);
    //pc p(.clk(clk), .en(1), .rst(rst), 
    
    
    
    
    
endmodule
