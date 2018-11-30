/*
	using this as an initial testbench
*/

`timescale 1ns / 1ns

module main();
	
	reg clk = 0;
	reg en = 0;
	reg rst = 1;

	reg ld_ct = 0;
	reg d_r_i = 0;
	
	reg [31:0] ld;
	wire [31:0] pc_m;
	wire is_aligned;
	
	pc #(.INC_BY(4))
	p(.clk_i(clk), .en_i(en), .rst_i(rst), .ld_ct_i(ld_ct), .d_r_i(d_r_i), .ld_i(ld), .pc_o(pc_m), .is_aligned_o(is_aligned));
	
	always #(1) begin
		clk <= ~clk;	
	end
	
	initial begin
		$display("Running mem_unit testbench...");
		$dumpfile("proc_dump.vcd");
		$dumpvars(0, main);
		
		#1;
		rst <= 1'b0;
		en <= 1'b1;
		ld_ct <= 1'b1;
		ld <= 32'h0;
		#1;
		ld_ct <= 1'b0;
		#9;
		d_r_i <= 1'b1;
		ld_ct <= 1'b1;
		ld <= 32'h1;
		#2;
		d_r_i <= 1'b0;
		ld <= 32'h3;
		#2;
		ld <= 32'h99;
		ld_ct <= 1'b0;
		#12;
		en <= 1'b0;
		#24;
		
		$display("Finished.");
		$finish;
	end
endmodule
