`define ROM_SIZE 2048
`timescale 1ns / 1ps

module rom(input [15:0] addr, output [15:0] data);
    reg [`ROM_SIZE-1:0] rom [15:0];
    
    initial begin
        $readmemh("rom.mem", rom);
    end
    
    assign data = rom[addr];
    
endmodule
