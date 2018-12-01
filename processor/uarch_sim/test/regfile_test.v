`timescale 1ns / 1ns

module regfile_unit_test();
	
	reg clk = 0;
	reg en = 0;
	reg rst = 0;

	reg wr = 0;
	reg [15:0] reg_ld = 0;

	reg [4:0] sel_a = 0;
	reg [4:0] sel_b = 0;

	reg [4:0] wr_sel = 0;

	wire [15:0] reg_a;
	wire [15:0] reg_b;

	regfile_unit r(
		.clk_i(clk), .en_i(en), .rst_i(rst), .wr_i(wr), .reg_ld_i(reg_ld),
		.sel_a_i(sel_a), .sel_b_i(sel_b), .wr_sel_i(wr_sel), .reg_a_o(reg_a), 
		.reg_b_o(reg_b)
	);

	always #(1) begin
		clk <= ~clk;
	end

	initial begin
		$display("Running regfile_unit testbench...");
		$dumpfile("proc_dump.vcd");
		$dumpvars(0, regfile_unit_test);
		
		#1;
		en <= 1'b1;
		wr <= 1'b1;
		wr_sel <= 5'h3;
		reg_ld <= 16'hFFAA;
		#1;
		wr_sel <= 5'h2;
		reg_ld <= 16'hA000;
		#2;
		wr <= 1'b0;
		sel_a <= 5'h3;
		sel_b <= 5'h2;
		#4;

		en <= 1'b0;
		
		#32;
		
		$display("Finished.");
		$finish;
	end
	
endmodule
