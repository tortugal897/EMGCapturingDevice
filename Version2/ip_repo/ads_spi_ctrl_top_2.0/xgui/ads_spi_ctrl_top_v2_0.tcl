# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXIS_TDATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_M00_AXIS_START_COUNT" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADS_SPI_BIT_N { PARAM_VALUE.ADS_SPI_BIT_N } {
	# Procedure called to update ADS_SPI_BIT_N when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADS_SPI_BIT_N { PARAM_VALUE.ADS_SPI_BIT_N } {
	# Procedure called to validate ADS_SPI_BIT_N
	return true
}

proc update_PARAM_VALUE.ADS_SPI_CLK_FREQ { PARAM_VALUE.ADS_SPI_CLK_FREQ } {
	# Procedure called to update ADS_SPI_CLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADS_SPI_CLK_FREQ { PARAM_VALUE.ADS_SPI_CLK_FREQ } {
	# Procedure called to validate ADS_SPI_CLK_FREQ
	return true
}

proc update_PARAM_VALUE.ADS_SPI_FRAME_N { PARAM_VALUE.ADS_SPI_FRAME_N } {
	# Procedure called to update ADS_SPI_FRAME_N when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADS_SPI_FRAME_N { PARAM_VALUE.ADS_SPI_FRAME_N } {
	# Procedure called to validate ADS_SPI_FRAME_N
	return true
}

proc update_PARAM_VALUE.ADS_SPI_SCLK_FREQ { PARAM_VALUE.ADS_SPI_SCLK_FREQ } {
	# Procedure called to update ADS_SPI_SCLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADS_SPI_SCLK_FREQ { PARAM_VALUE.ADS_SPI_SCLK_FREQ } {
	# Procedure called to validate ADS_SPI_SCLK_FREQ
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_START_COUNT { PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to update C_M00_AXIS_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_START_COUNT { PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to validate C_M00_AXIS_START_COUNT
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_START_COUNT { MODELPARAM_VALUE.C_M00_AXIS_START_COUNT PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_START_COUNT}] ${MODELPARAM_VALUE.C_M00_AXIS_START_COUNT}
}

proc update_MODELPARAM_VALUE.ADS_SPI_CLK_FREQ { MODELPARAM_VALUE.ADS_SPI_CLK_FREQ PARAM_VALUE.ADS_SPI_CLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADS_SPI_CLK_FREQ}] ${MODELPARAM_VALUE.ADS_SPI_CLK_FREQ}
}

proc update_MODELPARAM_VALUE.ADS_SPI_SCLK_FREQ { MODELPARAM_VALUE.ADS_SPI_SCLK_FREQ PARAM_VALUE.ADS_SPI_SCLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADS_SPI_SCLK_FREQ}] ${MODELPARAM_VALUE.ADS_SPI_SCLK_FREQ}
}

proc update_MODELPARAM_VALUE.ADS_SPI_FRAME_N { MODELPARAM_VALUE.ADS_SPI_FRAME_N PARAM_VALUE.ADS_SPI_FRAME_N } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADS_SPI_FRAME_N}] ${MODELPARAM_VALUE.ADS_SPI_FRAME_N}
}

proc update_MODELPARAM_VALUE.ADS_SPI_BIT_N { MODELPARAM_VALUE.ADS_SPI_BIT_N PARAM_VALUE.ADS_SPI_BIT_N } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADS_SPI_BIT_N}] ${MODELPARAM_VALUE.ADS_SPI_BIT_N}
}

