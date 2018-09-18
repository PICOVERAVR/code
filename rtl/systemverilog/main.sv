module main(
	input sysclk,
	input [3:0] in_a,
	input [3:0] in_b,
	output [3:0] out
);
	
	assign out = {in_a[3:2], in_b[1], sysclk};
		
	
endmodule
