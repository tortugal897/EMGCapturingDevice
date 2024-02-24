-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Sun Feb 26 13:25:23 2023
-- Host        : DESKTOP-IJFGPI6 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/victo/Desktop/TFM/Zynq/TFM_ZINQ/TFM_ZINQ.srcs/sources_1/bd/TFM_ZYNQ/ip/TFM_ZYNQ_not_irq_0_0/TFM_ZYNQ_not_irq_0_0_stub.vhdl
-- Design      : TFM_ZYNQ_not_irq_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TFM_ZYNQ_not_irq_0_0 is
  Port ( 
    in_irq : in STD_LOGIC;
    not_irq : out STD_LOGIC
  );

end TFM_ZYNQ_not_irq_0_0;

architecture stub of TFM_ZYNQ_not_irq_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "in_irq,not_irq";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "not_irq_v1_0,Vivado 2019.2";
begin
end;
