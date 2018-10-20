//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
//Date        : Sat Oct 20 00:50:47 2018
//Host        : KYLE-PC running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (led_2bits_tri_io,
    push_buttons_2bits_tri_i,
    reset,
    rgb_led_1_tri_io,
    sys_clock,
    usb_uart_rxd,
    usb_uart_txd);
  inout [1:0]led_2bits_tri_io;
  input push_buttons_2bits_tri_i;
  input reset;
  inout [2:0]rgb_led_1_tri_io;
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
  wire [0:0]rgb_led_1_tri_i_0;
  wire [1:1]rgb_led_1_tri_i_1;
  wire [2:2]rgb_led_1_tri_i_2;
  wire [0:0]rgb_led_1_tri_io_0;
  wire [1:1]rgb_led_1_tri_io_1;
  wire [2:2]rgb_led_1_tri_io_2;
  wire [0:0]rgb_led_1_tri_o_0;
  wire [1:1]rgb_led_1_tri_o_1;
  wire [2:2]rgb_led_1_tri_o_2;
  wire [0:0]rgb_led_1_tri_t_0;
  wire [1:1]rgb_led_1_tri_t_1;
  wire [2:2]rgb_led_1_tri_t_2;
  wire sys_clock;
  wire usb_uart_rxd;
  wire usb_uart_txd;

  design_1 design_1_i
       (.led_2bits_tri_i({led_2bits_tri_i_1,led_2bits_tri_i_0}),
        .led_2bits_tri_o({led_2bits_tri_o_1,led_2bits_tri_o_0}),
        .led_2bits_tri_t({led_2bits_tri_t_1,led_2bits_tri_t_0}),
        .push_buttons_2bits_tri_i(push_buttons_2bits_tri_i),
        .reset(reset),
        .rgb_led_1_tri_i({rgb_led_1_tri_i_2,rgb_led_1_tri_i_1,rgb_led_1_tri_i_0}),
        .rgb_led_1_tri_o({rgb_led_1_tri_o_2,rgb_led_1_tri_o_1,rgb_led_1_tri_o_0}),
        .rgb_led_1_tri_t({rgb_led_1_tri_t_2,rgb_led_1_tri_t_1,rgb_led_1_tri_t_0}),
        .sys_clock(sys_clock),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd));
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
  IOBUF rgb_led_1_tri_iobuf_0
       (.I(rgb_led_1_tri_o_0),
        .IO(rgb_led_1_tri_io[0]),
        .O(rgb_led_1_tri_i_0),
        .T(rgb_led_1_tri_t_0));
  IOBUF rgb_led_1_tri_iobuf_1
       (.I(rgb_led_1_tri_o_1),
        .IO(rgb_led_1_tri_io[1]),
        .O(rgb_led_1_tri_i_1),
        .T(rgb_led_1_tri_t_1));
  IOBUF rgb_led_1_tri_iobuf_2
       (.I(rgb_led_1_tri_o_2),
        .IO(rgb_led_1_tri_io[2]),
        .O(rgb_led_1_tri_i_2),
        .T(rgb_led_1_tri_t_2));
endmodule
