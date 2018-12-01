/*
	simple regfile implementation
	32 16-bit registers
	seperate write port, should be muxed elsewhere
		idk if this is a good idea
	register outputs go hi-z if not selected
*/

`timescale 1ns / 1ns

module regfile_unit(
	input clk_i,
	input en_i,
	input rst_i,

	input wr_i,
	input [15:0] reg_ld_i,
	
	input [4:0] sel_a_i,
	input [4:0] sel_b_i,

	input [4:0] wr_sel_i,

	output reg [15:0] reg_a_o,
	output reg [15:0] reg_b_o
);
	
	reg [15:0] reg_array[4:0]; // fixed 32 registers
	
	always @(posedge clk_i) begin
		if (rst_i) begin
			// reset everything pls
		end else if (en_i) begin
			if (wr_i) begin
				reg_array[wr_sel_i] <= reg_ld_i;
			end
			reg_a_o <= reg_array[sel_a_i];
			reg_b_o <= reg_array[sel_b_i];
		end else begin
			reg_a_o <= {16{1'hz}};
			reg_b_o <= {16{1'hz}};
		end
	end
	
endmodule
