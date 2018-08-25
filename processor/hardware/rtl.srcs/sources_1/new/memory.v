`define MEM_SIZE 2048

module memory(input clk, input read_write, input [15:0] addr, input [15:0] in, output reg [15:0] out);
    reg [`MEM_SIZE-1:0] rom [15:0];
    
    initial begin
        $readmemh("rom.mem", rom);
    end
    
    always @(posedge clk) begin
        if (read_write) begin
            rom[addr] <= in;
        end
        out <= rom[addr];
        
    end

endmodule