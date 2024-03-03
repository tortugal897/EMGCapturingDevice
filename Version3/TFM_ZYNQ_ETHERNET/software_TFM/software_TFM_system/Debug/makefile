#
# This file was created by Xilinx Vitis tool.
#


#
# tools
#

RM = rm -f
RMDIR = rm -rf

#
# variables
#

SDCARD_GEN = sdcard_gen
GENERATE_BIF = ::scw::generate_bif

XPFM_PATH = C:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_ETHERNET/software_TFM/TFM_ZYNQ_4_wrapper/export/TFM_ZYNQ_4_wrapper/TFM_ZYNQ_4_wrapper.xpfm
SYS_CONFIG = TFM_ZYNQ_4_wrapper
DOMAINS = standalone_domain
BIF_PATH = C:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_ETHERNET/software_TFM/software_TFM_system/Debug/system.bif

BITSTREAM_PATH = C:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_ETHERNET/software_TFM/software_TFM/_ide/bitstream/TFM_ZYNQ_4_wrapper.bit
SD_FILES = --elf C:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_ETHERNET/software_TFM/software_TFM/Debug/software_TFM.elf,ps7_cortexa9_0

#
# primary build targets
#

all: sd_card

sd_card:
	-@echo Generating bif file for the system project
	generate_system_bif.bat 50128 ${XPFM_PATH} ${DOMAINS} ${BIF_PATH}
	${SDCARD_GEN} --xpfm ${XPFM_PATH} --sys_config ${SYS_CONFIG} --bif ${BIF_PATH} --bitstream ${BITSTREAM_PATH} ${SD_FILES}

clean:
	$(RMDIR) ./_sds
	${RMDIR} sd_card
	${RM} system.bif

.PHONY: all sd_card clean


