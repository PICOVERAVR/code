//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
//Date        : Fri Oct 19 21:35:22 2018
//Host        : KYLE-PC running 64-bit major release  (build 9200)
//Command     : generate_target microblaze_wrapper.bd
//Design      : microblaze_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module microblaze_wrapper
   (led_2bits_tri_io,
    push_buttons_2bits_tri_i,
    reset,
    sys_clock,
    usb_uart_rxd,
    usb_uart_txd);
  inout [1:0]led_2bits_tri_io;
  input push_buttons_2bits_tri_i;
  input reset;
  input sys_clock;
  input usb_uart_rxd;
  output usb_uart_txd;

  wire [0:0]led_2bits_tri_i_0;
  wire [1:1]led_2bits_tri_i_1;
  wire [0:0]led_2bits_tri_io_0;
  wire [1:1]led_2bits_tri_io_1;
  wire [0:0]led_2bits_tri_o_0;
  wire [1:1]led_2bits_tri_o_1;
  wire [0:0]led_2bits_tri_t_0;
  wire [1:1]led_2bits_tri_t_1;
  wire push_buttons_2bits_tri_i;
  wire reset;
  wire sys_clock;
  wire usb_uart_rxd;
  wire usb_uart_txd;

  IOBUF led_2bits_tri_iobuf_0
       (.I(led_2bits_tri_o_0),
        .IO(led_2bits_tri_io[0]),
        .O(led_2bits_tri_i_0),
        .T(led_2bits_tri_t_0));
  IOBUF led_2bits_tri_iobuf_1
       (.I(led_2bits_tri_o_1),
        .IO(led_2bits_tri_io[1]),
        .O(led_2bits_tri_i_1),
        .T(led_2bits_tri_t_1));
  microblaze microblaze_i
       (.led_2bits_tri_i({led_2bits_tri_i_1,led_2bits_tri_i_0}),
        .led_2bits_tri_o({led_2bits_tri_o_1,led_2bits_tri_o_0}),
        .led_2bits_tri_t({led_2bits_tri_t_1,led_2bits_tri_t_0}),
        .push_buttons_2bits_tri_i(push_buttons_2bits_tri_i),
        .reset(reset),
        .sys_clock(sys_clock),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd));
endmodule
