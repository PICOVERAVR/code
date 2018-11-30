/*
	basic program counter
	sync reset

	ld_ct_i = 1 for load, 0 for count
	d_r_i = for add to pc, 0 for replace pc
	is_aligned = 1 for properly aligned pc, 0 for misaligned pc

*/

`timescale 1ns / 1ns

module pc_unit (
	input clk_i,
	input en_i,
	input rst_i,
	input ld_ct_i,
	input d_r_i, // add to pc or replace pc

	input [31:0] ld_i,
	output reg [31:0] pc_o,
	output is_aligned_o
);
	parameter INC_BY = 4;
	assign is_aligned_o = (pc_o % 4 == 0) ? 1'b1 : 1'b0;

	always @(posedge clk_i) begin
		if (rst_i) begin
			pc_o <= 32'h0;
		end else if (en_i) begin
			if (ld_ct_i) begin
				if (d_r_i) begin
					pc_o <= pc_o + ld_i;
				end else begin
					pc_o <= ld_i;
				end
			end else begin
				pc_o <= pc_o + INC_BY;
			end
		end
	end
	
endmodule
