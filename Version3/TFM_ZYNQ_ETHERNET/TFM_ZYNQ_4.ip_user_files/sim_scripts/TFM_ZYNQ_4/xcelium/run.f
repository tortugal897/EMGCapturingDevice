-makelib xcelium_lib/xilinx_vip -sv \
  "C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "C:/Xilinx/Vivado/2019.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_6 -sv \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/dc12/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/processing_system7_vip_v1_0_8 -sv \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/2d50/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_processing_system7_0_0/sim/TFM_ZYNQ_4_processing_system7_0_0.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_5 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0/src/fifo64x32_1/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_5 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0/src/fifo64x32_1/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_5 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0/src/fifo64x32_1/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ads_spi_ctrl_top_0_0/src/fifo64x32_1/sim/fifo64x32.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
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
-endlib
-makelib xcelium_lib/dist_mem_gen_v8_0_13 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/0bf5/simulation/dist_mem_gen_v8_0.v" \
-endlib
-makelib xcelium_lib/lib_pkg_v1_0_2 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_srl_fifo_v1_0_2 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_fifo_v1_0_14 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/a5cb/hdl/lib_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_lite_ipif_v3_0_4 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/interrupt_control_v3_1_4 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_quad_spi_v3_2_19 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/58f3/hdl/axi_quad_spi_v3_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_axi_quad_spi_0_0/sim/TFM_ZYNQ_4_axi_quad_spi_0_0.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_20 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/72d4/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_19 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/60de/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_21 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/6b0d/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_xbar_0/sim/TFM_ZYNQ_4_xbar_0.v" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_rst_ps7_0_50M_0/sim/TFM_ZYNQ_4_rst_ps7_0_50M_0.vhd" \
-endlib
-makelib xcelium_lib/axi_datamover_v5_1_22 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/1e40/hdl/axi_datamover_v5_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_sg_v4_1_13 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/4919/hdl/axi_sg_v4_1_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_dma_v7_1_21 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/ec2a/hdl/axi_dma_v7_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_axi_dma_0_0/sim/TFM_ZYNQ_4_axi_dma_0_0.vhd" \
-endlib
-makelib xcelium_lib/xlconcat_v2_1_3 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/442e/hdl/xlconcat_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_xlconcat_0_0/sim/TFM_ZYNQ_4_xlconcat_0_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_ila_0_0/sim/TFM_ZYNQ_4_ila_0_0.vhd" \
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_20 \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ipshared/c4a6/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_auto_pc_0/sim/TFM_ZYNQ_4_auto_pc_0.v" \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/ip/TFM_ZYNQ_4_auto_pc_1/sim/TFM_ZYNQ_4_auto_pc_1.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TFM_ZYNQ_4.srcs/sources_1/bd/TFM_ZYNQ_4/sim/TFM_ZYNQ_4.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

