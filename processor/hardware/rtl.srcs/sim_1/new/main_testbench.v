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
    
endmodule
