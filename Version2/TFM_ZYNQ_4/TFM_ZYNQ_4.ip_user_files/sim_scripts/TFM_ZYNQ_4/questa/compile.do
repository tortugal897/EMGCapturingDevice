vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_6
vlib questa_lib/msim/processing_system7_vip_v1_0_8
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/fifo_generator_v13_2_5
vlib questa_lib/msim/dist_mem_gen_v8_0_13
vlib questa_lib/msim/lib_pkg_v1_0_2
vlib questa_lib/msim/lib_cdc_v1_0_2
vlib questa_lib/msim/lib_srl_fifo_v1_0_2
vlib questa_lib/msim/lib_fifo_v1_0_14
vlib questa_lib/msim/axi_lite_ipif_v3_0_4
vlib questa_lib/msim/interrupt_control_v3_1_4
vlib questa_lib/msim/axi_quad_spi_v3_2_19
vlib questa_lib/msim/generic_baseblocks_v2_1_0
vlib questa_lib/msim/axi_register_slice_v2_1_20
vlib questa_lib/msim/axi_data_fifo_v2_1_19
vlib questa_lib/msim/axi_crossbar_v2_1_21
vlib questa_lib/msim/proc_sys_reset_v5_0_13
vlib questa_lib/msim/axi_datamover_v5_1_22
vlib questa_lib/msim/axi_sg_v4_1_13
vlib questa_lib/msim/axi_dma_v7_1_21
vlib questa_lib/msim/xlconcat_v2_1_3
vlib questa_lib/msim/axi_protocol_converter_v2_1_20

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_6 questa_lib/msim/axi_vip_v1_1_6
vmap processing_system7_vip_v1_0_8 questa_lib/msim/processing_system7_vip_v1_0_8
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap fifo_generator_v13_2_5 questa_lib/msim/fifo_generator_v13_2_5
vmap dist_mem_gen_v8_0_13 questa_lib/msim/dist_mem_gen_v8_0_13
vmap lib_pkg_v1_0_2 questa_lib/msim/lib_pkg_v1_0_2
vmap lib_cdc_v1_0_2 questa_lib/msim/lib_cdc_v1_0_2
vmap lib_srl_fifo_v1_0_2 questa_lib/msim/lib_srl_fifo_v1_0_2
vmap lib_fifo_v1_0_14 questa_lib/msim/lib_fifo_v1_0_14
vmap axi_lite_ipif_v3_0_4 questa_lib/msim/axi_lite_ipif_v3_0_4
vmap interrupt_control_v3_1_4 questa_lib/msim/interrupt_control_v3_1_4
vmap axi_quad_spi_v3_2_19 questa_lib/msim/axi_quad_spi_v3_2_19
vmap generic_baseblocks_v2_1_0 questa_lib/msim/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_20 questa_lib/msim/axi_register_slice_v2_1_20
vmap axi_data_fifo_v2_1_19 questa_lib/msim/axi_data_fifo_v2_1_19
vmap axi_crossbar_v2_1_21 questa_lib/msim/axi_crossbar_v2_1_21
vmap proc_sys_reset_v5_0_13 questa_lib/msim/proc_sys_reset_v5_0_13
vmap axi_datamover_v5_1_22 questa_lib/msim/axi_datamover_v5_1_22
vmap axi_sg_v4_1_13 questa_lib/msim/axi_sg_v4_1_13
vmap axi_dma_v7_1_21 questa_lib/msim/axi_dma_v7_1_21
vmap xlconcat_v2_1_3 questa_lib/msim/xlconcat_v2_1_3
vmap axi_protocol_converter_v2_1_20 questa_lib/msim/axi_protocol_converter_v2_1_20

vlog -work xilinx_vip -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_6 -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/dc12/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_8 -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0/sim/TFM_ZYNQ_4_processing_system7_0_0.v" \

vlog -work fifo_generator_v13_2_5 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0/src/fifo64x32_1/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0/src/fifo64x32_1/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0/src/fifo64x32_1/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0/src/fifo64x32_1/sim/fifo64x32.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/a798/src/ads_rdatac_top.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/a798/src/ads_spi_ctrl.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/a798/hdl/ads_spi_ctrl_top_v2_0_S00_AXI.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/a798/src/clk_div_4MHz.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/a798/hdl/ads_spi_ctrl_top_v2_0.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0/sim/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/e0c3/hdl/ads_spi_mux_v1_0_S00_AXI.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/e0c3/src/mux_spi.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/e0c3/hdl/ads_spi_mux_v1_0.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_mux_0_0/sim/TFM_ZYNQ_4_ads_spi_mux_0_0.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/28a3/hdl/not_irq_v1_0.vhd" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_not_irq_0_0/sim/TFM_ZYNQ_4_not_irq_0_0.vhd" \

vlog -work dist_mem_gen_v8_0_13 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/0bf5/simulation/dist_mem_gen_v8_0.v" \

vcom -work lib_pkg_v1_0_2 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work lib_fifo_v1_0_14 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/a5cb/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work axi_lite_ipif_v3_0_4 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work interrupt_control_v3_1_4 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_quad_spi_v3_2_19 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/58f3/hdl/axi_quad_spi_v3_2_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_axi_quad_spi_0_0/sim/TFM_ZYNQ_4_axi_quad_spi_0_0.vhd" \

vlog -work generic_baseblocks_v2_1_0 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_20 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/72d4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work axi_data_fifo_v2_1_19 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/60de/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_21 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/6b0d/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_xbar_0/sim/TFM_ZYNQ_4_xbar_0.v" \

vcom -work proc_sys_reset_v5_0_13 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_rst_ps7_0_50M_0/sim/TFM_ZYNQ_4_rst_ps7_0_50M_0.vhd" \

vcom -work axi_datamover_v5_1_22 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1e40/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_13 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/4919/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_21 -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec2a/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_axi_dma_0_0/sim/TFM_ZYNQ_4_axi_dma_0_0.vhd" \

vlog -work xlconcat_v2_1_3 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/442e/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_xlconcat_0_0/sim/TFM_ZYNQ_4_xlconcat_0_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ila_0_0/sim/TFM_ZYNQ_4_ila_0_0.vhd" \

vlog -work axi_protocol_converter_v2_1_20 -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/c4a6/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1b7e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/122e/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b205/hdl/verilog" "+incdir+../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8f82/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.2/data/xilinx_vip/include" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_auto_pc_0/sim/TFM_ZYNQ_4_auto_pc_0.v" \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_auto_pc_1/sim/TFM_ZYNQ_4_auto_pc_1.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/sim/TFM_ZYNQ_4.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

