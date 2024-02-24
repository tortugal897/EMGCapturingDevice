

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "not_irq" "NUM_INSTANCES" "DEVICE_ID"  "C_in_irq_BASEADDR" "C_in_irq_HIGHADDR"
}
