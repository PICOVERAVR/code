/*
	each bit of step corresponds to an enable on a processor function
	step is a ripple counter
	step list:
		0: fetch from memory
		1: decode
		2: register lookup
		3: execute
		4: writeback // 5 stages like in pipelined version...
*/

`timescale 1ns / 1ns

module proc(
	input clk_i
);
	reg [7:0] step;
	
	always @(negedge clk_i) begin // idk about this
		step << 1'b1;
	end
	
	always @(posedge clk_i) begin
		
	end
	
endmodule
