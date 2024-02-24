connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zybo Z7 210351B0FE1AA" && level==0} -index 1
fpga -file C:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_4/software/software_TFM/_ide/bitstream/TFM_ZYNQ_4_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_4/software/TFM_ZYNQ_4_wrapper/export/TFM_ZYNQ_4_wrapper/hw/TFM_ZYNQ_4_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_4/software/software_TFM/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_4/software/software_TFM/Debug/software_TFM.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
