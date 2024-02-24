// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2.1 (win64) Build 2729669 Thu Dec  5 04:49:17 MST 2019
// Date        : Fri Apr 14 09:11:28 2023
// Host        : MP-5CG0326R5C running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/workspace/Vivado/ip_repo/ads_spi_ctrl_top_2.0/src/fifo64x32_1/fifo64x32_stub.v
// Design      : fifo64x32
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2019.2.1" *)
module fifo64x32(clk, srst, din, wr_en, rd_en, dout, full, almost_full, 
  empty, almost_empty, prog_full)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[31:0],wr_en,rd_en,dout[31:0],full,almost_full,empty,almost_empty,prog_full" */;
  input clk;
  input srst;
  input [31:0]din;
  input wr_en;
  input rd_en;
  output [31:0]dout;
  output full;
  output almost_full;
  output empty;
  output almost_empty;
  output prog_full;
endmodule
