onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib TFM_ZYNQ_4_opt

do {wave.do}

view wave
view structure
view signals

do {TFM_ZYNQ_4.udo}

run -all

quit -force
