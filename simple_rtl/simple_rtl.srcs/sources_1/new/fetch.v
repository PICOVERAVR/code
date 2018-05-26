/*
    Instruction fetch unit
    instantiate PC, fetch instruction
*/

<<<<<<< HEAD
module fetch(input clk, input en, input rst, output [15:0] instr);

    reg pc_load_count = 0;
    
    reg mem_read_write = 0;
    reg [15:0] mem_in = 0;
    
    reg [15:0] pc_load = 0;
    wire [15:0] pc_out;
    
    //module memory(input clk, input read_write, input [15:0] addr, input [15:0] in, output reg [15:0] out);
    //module pc(input clk, input en, input rst, input load_count, input [15:0] load, output reg [15:0] pc);
=======
module fetch(input clk, input rst, input [15:0] ir_addr, input [15:0] ir_data, output [15:0] instr, output [15:0] dbg_out);
    
    reg pc_en = 0;
    reg pc_rst = 0;
    reg pc_load_count = 0;
    
    reg mem_read_write = 0;
    
    //module memory(input clk, input read_write, input [15:0] addr, input [15:0] in, output reg [15:0] out);
    //module pc(input clk, input en, input rst, input load_count, input [15:0] load, output reg [15:0] pc);
    
    //pc p(.clk(clk), .en(1), .rst(rst), 
    memory m(.clk(clk), .read_write(mem_read_write), .addr(ir_addr),
    
>>>>>>> bfb3fb82a9f6aaf536d6937c343364f2c47cdefb
    
    pc p(.clk(clk), .en(en), .rst(rst), .load_count(pc_load_count), .load(pc_load), .pc(pc_out));
    memory m(.clk(clk), .read_write(mem_read_write), .addr(pc_out), .in(mem_in), .out(instr));
    
    
endmodule
