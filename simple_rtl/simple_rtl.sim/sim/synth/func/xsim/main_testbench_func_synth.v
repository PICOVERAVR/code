// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.3 (win64) Build 2018833 Wed Oct  4 19:58:22 MDT 2017
// Date        : Mon Nov  6 22:37:20 2017
// Host        : KYLE-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               C:/Users/kyle/Desktop/simple_rtl/simple_rtl.sim/sim/synth/func/xsim/main_testbench_func_synth.v
// Design      : main
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module main
   (sysclk,
    pio);
  input sysclk;
  output [8:1]pio;

  wire [8:1]pio;

  OBUFT \pio_OBUF[1]_inst 
       (.I(1'b0),
        .O(pio[1]),
        .T(1'b1));
  OBUFT \pio_OBUF[2]_inst 
       (.I(1'b0),
        .O(pio[2]),
        .T(1'b1));
  OBUFT \pio_OBUF[3]_inst 
       (.I(1'b0),
        .O(pio[3]),
        .T(1'b1));
  OBUFT \pio_OBUF[4]_inst 
       (.I(1'b0),
        .O(pio[4]),
        .T(1'b1));
  OBUFT \pio_OBUF[5]_inst 
       (.I(1'b0),
        .O(pio[5]),
        .T(1'b1));
  OBUFT \pio_OBUF[6]_inst 
       (.I(1'b0),
        .O(pio[6]),
        .T(1'b1));
  OBUFT \pio_OBUF[7]_inst 
       (.I(1'b0),
        .O(pio[7]),
        .T(1'b1));
  OBUFT \pio_OBUF[8]_inst 
       (.I(1'b0),
        .O(pio[8]),
        .T(1'b1));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
