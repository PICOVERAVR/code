/*
    Instruction fetch unit
    instantiate PC, fetch instruction
*/

//fetch from ROM module

module fetch_buffer(input clk, input en, input [15:0] data_in, output reg [15:0] data_out);
    
    initial begin
        data_out = 16'h00;
    end
    
    always @(clk) begin
        data_out <= data_in;
    end
    
endmodule
