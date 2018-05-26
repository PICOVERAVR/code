`define MEM_SIZE 2048

/*
    memory module

*/

module memory(input clk, input read_write, input [15:0] addr, input [15:0] in, output reg [15:0] out);
    reg [`MEM_SIZE-1:0] memory [15:0];
    
    initial begin
        $readmemh("mem.mem", memory);
    end
    
    always @(posedge clk) begin
        if (read_write) begin
            memory[addr] <= in;
        end
        out <= memory[addr];
    end

endmodule