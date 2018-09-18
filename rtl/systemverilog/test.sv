`define SIM_CLOCKS 1000

module test();
	
	reg simclk = 0;
	reg [3:0] in_a = 0;
	reg [3:0] in_b = 0;
	wire [3:0] out;
	
	main m(.sysclk(simclk), .in_a(in_a), .in_b(in_b), .out(out));
	integer i = 0;
	
	always #(1) begin
		simclk <= ~simclk;
		if (i++ >= `SIM_CLOCKS) begin // run for a finite amount of clocks
			$finish;
		end
	end
	
	initial begin		
		$dumpfile("dump.vcd");
		$dumpvars(0, m);
		
		@(posedge simclk);
		in_a = 1;
		@(posedge simclk);
		in_a = 0;
		
		
	end
endmodule
