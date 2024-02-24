-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Sun Feb 26 13:25:23 2023
-- Host        : DESKTOP-IJFGPI6 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ TFM_ZYNQ_not_irq_0_0_sim_netlist.vhdl
-- Design      : TFM_ZYNQ_not_irq_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    in_irq : in STD_LOGIC;
    not_irq : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "TFM_ZYNQ_not_irq_0_0,not_irq_v1_0,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "not_irq_v1_0,Vivado 2019.2";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  attribute x_interface_info : string;
  attribute x_interface_info of in_irq : signal is "xilinx.com:signal:interrupt:1.0 in_irq INTERRUPT";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of in_irq : signal is "XIL_INTERFACENAME in_irq, SENSITIVITY LEVEL_HIGH, PortWidth 1";
  attribute x_interface_info of not_irq : signal is "xilinx.com:signal:interrupt:1.0 not_irq INTERRUPT";
  attribute x_interface_parameter of not_irq : signal is "XIL_INTERFACENAME not_irq, SENSITIVITY LEVEL_HIGH, PortWidth 1";
begin
not_irq_INST_0: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => in_irq,
      O => not_irq
    );
end STRUCTURE;
