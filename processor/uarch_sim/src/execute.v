/*
	simple ALU
	op list:
		ADD: 0
		SUB: 1
		MUL: 2
		DIV: 3
		AND: 4
		OR:  5
		XOR: 6
		NOT: 7
		INV: 8
		left and right shift
		PA:  9 // pass A through
		PB:  A // pass B through

		NOP: end
	type list:
		0: signed
		1: byte
	TODO:
		figure out how to write signed + byte
		test!!
		assign to arith_error on a divide by zero
*/

module alu_unit (
	input clk_i,
	input en_i,
	
	input [3:0] op,
	input [1:0] type,
	input [15:0] reg_a,
	input [15:0] reg_b,
	
	output [15:0] result,
	output reg arith_error
);

reg [15:0] temp_result;

// should be clocked for now, might need to add more stages later
always @(posedge clk) begin
	if (en_i) begin
		case (op)
			4'h0: temp_result <= reg_a + reg_b;
			4'h1: temp_result <= reg_a - reg_b;
			4'h2: temp_result <= reg_a * reg_b;
			4'h3: temp_result <= 16'b1; // implement divide here
			4'h4: temp_result <= reg_a & reg_b;
			4'h5: temp_result <= reg_a | reg_b;
			4'h6: temp_result <= reg_a ^ reg_b;
			4'h7: temp_result <= ~reg_a;
			4'h8: temp_result <= !reg_a;
			4'h9: // left and right shift
			default:
				temp_result <= 16'h0;
				arith_error <= 1'b1;
		endcase
	end
end


endmodule
