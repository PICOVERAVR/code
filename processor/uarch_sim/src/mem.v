/*
	fetches instructions from memory.
	initially just makes memory acceses controllable and synchronous.
	
	delay of .5 cycles when writing / reading
	
	if en and wr are 1, write occurs
	if en is 1 and wr is 0, read occurs
	if en is 0, memory goes into hi-z

	instruction will be updated if module is enabled.
	otherwise, instruction will go hi-z
*/

`timescale 1ns / 1ns

module mem_unit (
	input clk_i,
	input en_i,
	input wr_i,

	input [10:0] addr_i,

	input [31:0] data_i,
	output reg [31:0] data_o
);
	parameter ADDR_WIDTH = 11; // 2^11 = 2048 bytes
	reg [31:0] mem_file [ADDR_WIDTH-1:0];

	always @(posedge clk_i or negedge clk_i) begin
		if (en_i) begin
			if (wr_i) begin
				mem_file[addr_i] <= data_i;
			end
			data_o <= mem_file[addr_i];
		end else begin
			data_o <= {32{1'hZ}};
		end
	end
	
endmodule
