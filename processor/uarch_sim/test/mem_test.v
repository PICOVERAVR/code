/*
	using this as an initial testbench
*/

`timescale 1ns / 1ns

module main();
	
	reg clk = 0;
	reg en = 0;

	reg wr = 0;
	reg [10:0] addr = 0;
	reg [31:0] data_i = 0;

	wire [31:0] data_o;
	
	// make sure to use parameters as well
	mem_unit m(.clk_i(clk), .en_i(en), .wr_i(wr), .addr_i(addr), .data_i(data_i), .data_o(data_o));

	always #(1) begin
		clk <= ~clk;	
	end
	
	initial begin
		$display("Running mem_unit testbench...");
		$dumpfile("proc_dump.vcd");
		$dumpvars(0, main);
		
		#1;
		en <= 1'b1;
		addr <= 11'h3;
		data_i <= 32'hFF;
		wr <= 1'b1;
		#4;
		wr <= 1'b0;
		addr <= 11'h2;
		#1;
		en <= 1'b0;

		#16;
		
		$display("Finished.");
		$finish;
	end
endmodule
