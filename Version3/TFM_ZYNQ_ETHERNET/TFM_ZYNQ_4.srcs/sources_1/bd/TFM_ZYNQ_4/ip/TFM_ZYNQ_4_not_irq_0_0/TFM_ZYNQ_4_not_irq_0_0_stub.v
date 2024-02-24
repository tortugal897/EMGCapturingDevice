// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Tue Apr 18 22:40:03 2023
// Host        : DESKTOP-IJFGPI6 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_4/TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_not_irq_0_0/TFM_ZYNQ_4_not_irq_0_0_stub.v
// Design      : TFM_ZYNQ_4_not_irq_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "not_irq_v1_0,Vivado 2019.2" *)
module TFM_ZYNQ_4_not_irq_0_0(in_irq, not_irq)
/* synthesis syn_black_box black_box_pad_pin="in_irq,not_irq" */;
  input in_irq;
  output not_irq;
endmodule