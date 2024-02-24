# EMGCapturingDevice
 This device contains a SoC architecture within a Zybo Z7-10 for capturing EMG signals.

Version 1: Establishes a direct connection between AFE ADS1298R and the transmission, made via serial port. The transmission is quite slow, it is not recommended to use it without previous changes.

Version 2: Transmits data from the AFE ADS1298R to the DDR memory of the Zybo Z7-10 using DMA. This prevents uncontrolled data loss. The processor reads the data when it needs it and transmits it to the computer via the serial port. The transmission is quite slow.

Version 2: Same as version 2, but transmitting the information via Ethernet to the computer. As DMA is faster than ethernet transmission, it will eventually catch up with the transmission, resulting in the loss of a fragment of the data that was unable to transmit in time. It is capable of transmitting about 7 minutes and 38 seconds for continuous data until the loss occurs.

