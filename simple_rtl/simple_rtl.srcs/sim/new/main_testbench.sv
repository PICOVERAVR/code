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
    
    initial begin
        rst <= 1;
        
        for (i = 0; i < 16; i = i + 1) begin //init instruction memory
            instruction_mem[i] <= 0;
            data_mem[i] <= 0;
        end
        
        @(posedge clk); //reset all internal registers
        rst <= 0;
        
        @(posedge clk);
        
    end
endmodule