// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Feb 26 13:25:23 2023
// Host        : DESKTOP-IJFGPI6 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/victo/Desktop/TFM/Zynq/TFM_ZINQ/TFM_ZINQ.srcs/sources_1/bd/TFM_ZYNQ/ip/TFM_ZYNQ_not_irq_0_0/TFM_ZYNQ_not_irq_0_0_sim_netlist.v
// Design      : TFM_ZYNQ_not_irq_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "TFM_ZYNQ_not_irq_0_0,not_irq_v1_0,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "not_irq_v1_0,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module TFM_ZYNQ_not_irq_0_0
   (in_irq,
    not_irq);
  (* x_interface_info = "xilinx.com:signal:interrupt:1.0 in_irq INTERRUPT" *) (* x_interface_parameter = "XIL_INTERFACENAME in_irq, SENSITIVITY LEVEL_HIGH, PortWidth 1" *) input in_irq;
  (* x_interface_info = "xilinx.com:signal:interrupt:1.0 not_irq INTERRUPT" *) (* x_interface_parameter = "XIL_INTERFACENAME not_irq, SENSITIVITY LEVEL_HIGH, PortWidth 1" *) output not_irq;

  wire in_irq;
  wire not_irq;

  LUT1 #(
    .INIT(2'h1)) 
    not_irq_INST_0
       (.I0(in_irq),
        .O(not_irq));
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
