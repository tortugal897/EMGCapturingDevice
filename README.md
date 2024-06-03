# EMGCapturingDevice
 This device contains a SoC architecture within a Zybo Z7-10 for capturing EMG signals.

- Version 1: Establishes a direct connection between AFE ADS1298R and the transmission, made via serial port. The transmission is quite slow, it is not recommended to use it without previous changes.

- Version 2: Transmits data from the AFE ADS1298R to the DDR memory of the Zybo Z7-10 using DMA. This prevents uncontrolled data loss. The processor reads the data when it needs it and transmits it to the computer via the serial port. The transmission is quite slow.

- Version 2: Same as version 2, but transmitting the information via Ethernet to the computer. As DMA is faster than ethernet transmission, it will eventually catch up with the transmission, resulting in the loss of a fragment of the data that was unable to transmit in time. It is capable of transmitting about 7 minutes and 38 seconds for continuous data until the loss occurs.

A common use of this code would be to open the software project in Vitis (from Xilinx) and change the channel configuration lines using the function ADS_enableChannelAndSetGain(Channel Number, Channel Gain, Data source); located around line 150 of the main.c code. The sampling rate can also be changed using the SPIwriteREGISTER(CONFIG1_REG_ADDR, Sampling Rate) function; located around line 120 of the main.c code.

An additional Arduino version has been added to the repository, based on the work of hal-314 and Adam Feuer.
