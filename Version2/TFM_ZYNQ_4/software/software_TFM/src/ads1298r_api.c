/*
 * 	ads1298r_api.c
 *
 *  Created on: 27th Jan. 2023
 *      Author: Ruben Nieto (URJC)
 */

#include "ads1298r_api.h"
#include "spi_api.h"
#include "sleep.h"
#include "gic_api.h"
#include "xscugic.h"
#include "dma_api.h"

extern XScuGic intc;

void ADS_begin(void){
	int Status;
	uint8_t adsID;

	// Init SPI Configuration.
	SPI_init();

	// DRDY (data ready) pin IRQ configuration
//	setup_pl_irq(&intc);

	// ADS configuration
	// See page 85 in the datashhet for more information about ADS129XX boot up sequency.
	// See page page 84, 10.1.1 Setting the Device for Basic Data Capture, in the datasheet
	usleep(_ADS_POWER_UP_DELAY_US);

	// Reset ADS by hardware or software reset. It is indifferent. Hardware reset is the prefered method
	ADS_reset();
	// Stop RDATAC mode (ads129x restart by default in this configuration). See page 62, section 9.5.2.6 RDATAC: Read Data Continuous, in the datasheet
	sendSPICommandSDATAC(0);

	// Read ADS129x ID: 0xD2 for ADS1298R
	Status = SPIreadREGISTER(REGID_REG_ADDR, &adsID);
	if (Status != 0) {
		xil_printf("[ERROR] SPI Configuration Failed\r\n");
	}
	// Check ADS ID
	if (adsID != REGID_ID_ADS1298R) // {
		xil_printf("[ERROR] Data read at ID_REG (Used: 0x%x): 0x%x \r\n", REGID_ID_ADS1298R, adsID);
	//	}else {
	//		xil_printf("[INFO] Data read at ID_REG (Used: 0x%x): 0x%x \r\n", ADS_USED, adsID);
	//	}

	// Power up sequence completed
	xil_printf("[INFO] Power-up sequence completed \r\n");
}

void enable_dry_irq(void){
	XScuGic_Enable(&intc, DRY_IRQ_ID);
}

void disable_dry_irq(void){
	XScuGic_Disable(&intc, DRY_IRQ_ID);
}

void enable_DMA_irq(void){
	XScuGic_Enable(&intc, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR);

//	/* Enable all interrupts */
//		XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
//								XAXIDMA_DEVICE_TO_DMA);

	//Program DMA transfer parameters (i) destination address (ii) length
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR+OFFSET_S2MMDA, OFFSET_MEM_WRITE);
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR+OFFSET_S2MM_LENGTH, 4*NUM_OF_WORDS);
}

void disable_DMA_irq(void){
	XScuGic_Disable(&intc, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR);
}

void ADS_end(void){
	XScuGic_Disconnect(&intc, DRY_IRQ_ID);
	XScuGic_Disconnect(&intc, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR);
	XScuGic_Disable(&intc, DRY_IRQ_ID);
	XScuGic_Disable(&intc, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR);
	// You can use the ADS_end() method to free GPIO used pins and resources if you don't need any more de ADS.
	// You have to call ADS_begin() if you want to use again the ADS.
	sendSPICommandSDATAC(1);
	sendSPICommandSTOP(1);
}

void ADS_reset(void){
	// Software reset is performed
	// If ADS129X is in read data continuous mode (RDATAC), SDATAC command must be issued before any other
	// commands can be sent to the device. If ADS129X is not in RDATAC mode, this command is ignore by chip.
	// See page 63, section 9.5.2.7 SDATAC: Stop Read Data Continuous, in the datasheet

	// Note: I am aware that readingStatus attribute reflect the status of the ADS129X with respect to read mode-
	//       However, if I used it and in some piece of code has a bug, chip could be not reseted. So, I prefer to
	//       make sure that chip ALWAYS is reseted.
	sendSPICommandSDATAC(1);
	SendSPICommandRESET(1);
    // Remember that ADS12XX enters in read data continuous mode (RDATAC) after reset command. See page 62, section 9.5.2.6 RDATAC: Read Data Continuous, in the datasheet
}


void ADS_setAllRegisterToReset(void) {

	// ID register is read only
	SPIwriteREGISTER(CONFIG1_REG_ADDR, CONFIG1_RESET_VALUE | CONFIG1_RESERVED_BITS);
	SPIwriteREGISTER(CONFIG2_REG_ADDR, CONFIG2_RESET_VALUE | CONFIG2_RESERVED_BITS);
	SPIwriteREGISTER(CONFIG3_REG_ADDR, CONFIG3_RESET_VALUE | CONFIG3_RESERVED_BITS);
	SPIwriteREGISTER(LOFF_REG_ADDR, LOFF_RESET_VALUE | LOFF_RESERVED_BITS);

	// Channels registers
	for (uint8_t i = 0; i < ADS_N_CHANNELS; i++)
		SPIwriteREGISTER(CHNSET__BASE_REG_ADDR + i, CHNSET_RESET_VALUE | CHNSET_RESERVED_BITS);

	SPIwriteREGISTER(RLDSENSP_REG_ADDR, RLDSENSP_RESET_VALUE | RLDSENSP_RESERVED_BITS);
	SPIwriteREGISTER(RLDSENSN_REG_ADDR, RLDSENSN_RESET_VALUE | RLDSENSN_RESERVED_BITS);
	SPIwriteREGISTER(LOFFSENSP_REG_ADDR, LOFFSENSP_RESET_VALUE | LOFFSENSP_RESERVED_BITS);
	SPIwriteREGISTER(LOFFSENSN_REG_ADDR, LOFFSENSN_RESET_VALUE | LOFFSENSN_RESERVED_BITS);
	SPIwriteREGISTER(LOFFFLIP_REG_ADDR, LOFFFLIP_RESET_VALUE | LOFFFLIP_RESERVED_BITS);

	// loff_statp and loff_statn are read-only registers
	SPIwriteREGISTER(GPIO_REG_ADDR, GPIO_RESET_VALUE | GPIO_RESERVED_BITS);
	SPIwriteREGISTER(PACE_REG_ADDR, PACE_RESET_VALUE | PACE_RESERVED_BITS);
	SPIwriteREGISTER(RESP_REG_ADDR, RESP_RESET_VALUE | RESP_RESERVED_BITS);
	SPIwriteREGISTER(CONFIG4_REG_ADDR, CONFIG4_RESET_VALUE | CONFIG4_RESERVED_BITS);
	SPIwriteREGISTER(WCT1_REG_ADDR, WCT1_RESET_VALUE | WCT1_RESERVED_BITS);
	SPIwriteREGISTER(WCT2_REG_ADDR, WCT2_RESET_VALUE | WCT2_RESERVED_BITS);
}


/* ======= Methods related to send ADS commands (except read/write registers) ============= */
// To send SPI command to ADS, you must use the method sendSPICommand{Command name in datasheet}(boolean keepSpiOpen = false)
// Commands available in ADS12XX (see page 61, section 9.5.2 SPI Command Definitions, in the datasheet)
//
// If the argumment keepSpiOpen is true, SPI communication with chip is left open (SPI
// bus can't be used be other peripherals and no new data is received from ADS) and ready
// to send more SPI commands/ read or write registers to the chip. Then, the following commands
// or read/write registers are sent more quickly.
//
// You might use keepSpiOpen = true when you can't spend much time to configure the chip. For example, you are in the middle of a
// measurement and you want to power down two channels (write two different registers) due to electrode disconnection. In this
// situation, you  want to configure the ADS as fast as possible in order to not loss any sample (or minimize the samples loss).
// So, using keepSpiOpen = true, you will avoid to open and close SPI communication between consecutive register writings.
//
// If time is not critical (no matter how many miliseconds you waste configurating ADS), it won't be benefical to use the methods
// with keepSpiOpen = true.
//
// Be aware (it's said above) that no new data will be receive until you send command with keepSpiOpen = false
// receive more SPI commands or read/write register. For that reason,
//
// Finally, time restriction specific for each SPI command sent is taken in acccount. So, you don't need to worry to,
// for example, wait 4 clock periods before send another SPI command after sent WAKEUP command.

// WAKEUP Command for ADS129xX.
void sendSPICommandWAKEUP(uint8_t keepSpiOpen){
	// WAKEUP for ADS1298R
	SPIwriteCOMMAND(COMMAND_WAKEUP, keepSpiOpen);
	//After execute WAKEUP command, the next command must wait for 4*_ADS_T_CLK cycles (see page 61 in the datasheet)
	// usleep(_ADS_T_CLK_4);

}

// STANDBY Command for ADS129xX.
void sendSPICommandSTANDBY(uint8_t keepSpiOpen){
	// STANDBY for ADS1298R
	SPIwriteCOMMAND(COMMAND_STANDBY, keepSpiOpen);
  // No wait time needed
}

// Be careful! It can't be used if RESET pin is specified
// RESET Command for ADS129xX.
void SendSPICommandRESET(uint8_t keepSpiOpen){
	// RESET for ADS1298R
	SPIwriteCOMMAND(COMMAND_RESET, keepSpiOpen);
	// 18*t_clk cycles are required to execute the RESET command. Do not send any commands during this time. (see page 62 in datasheet)
	// usleep(_ADS_T_CLK_18);
}

// Be careful! It can't be used if START pin is specified
// START Command for ADS129xX.
void SendSPICommandSTART(uint8_t keepSpiOpen){
	// START for ADS1298R
	SPIwriteCOMMAND(COMMAND_START, keepSpiOpen);
	//After execute START command, the next command must wait for 4*_ADS_T_CLK cycles (see page 62 in the datasheet)
	// usleep(_ADS_T_CLK_4); // Only is necesarry if just after is sent STOP command
}

// Be careful! It can't be used if STOP pin is specified
void sendSPICommandSTOP(uint8_t keepSpiOpen){
	// STOP for ADS1298R
	SPIwriteCOMMAND(COMMAND_STOP, keepSpiOpen);
  // No wait time needed
}

// Be aware that when RDATAC command is sent, the any other command except SDATAC will be ignored
void sendSPICommandRDATAC(uint8_t keepSpiOpen){
	// RDATAC for ADS1298R
	SPIwriteCOMMAND(COMMAND_RDATAC, keepSpiOpen);
	//After execute RDATAC command, the next command must wait for 4*_ADS_T_CLK cycles (see page 62 in the datasheet)
	// usleep(_ADS_T_CLK_4);
	// ToDO: readingStatus = _ADS_READING_DATA_IN_RDATAC_MODE; // It is usefull?
}

void sendSPICommandSDATAC(uint8_t keepSpiOpen){
	// SDATAC for ADS1298R
	SPIwriteCOMMAND(COMMAND_SDATAC, keepSpiOpen);
	//After return execute SDATAC command, the next command must wait for 4*_ADS_T_CLK cycles (see page 63 in the datasheet)
	// usleep(_ADS_T_CLK_4);
	// ToDO: readingStatus = _ADS_NO_READING_NEW_DATA;
}

// Be careful! This method tells the ADS driver to issue the RDATA SPI command and read the sample
// when DRDY pin goes low. So you need to worry if DRDY is low or not. New data will be available
// the next time thats DRDY goes low.
void sendSPICommandRDATA(uint8_t keepSpiOpen){
	// WARNING: NOT IMPLEMENTED!
	// RDATA command will be send when new data is available
}


/* ======= Methods implementing typical ADS configurations  =============  */
void ADS_disableChannel(uint8_t nChannel) {
	uint8_t registerValue = 0x00;
	uint8_t registerAddress = CHNSET__BASE_REG_ADDR + nChannel;
	SPIreadREGISTER(registerAddress, &registerValue);
	// Power down the channel --> write 1 in bit 7
	SPIwriteREGISTER(registerAddress, registerValue | CHNSET_B_PDn);
}


void ADS_enableChannel(uint8_t nChannel, uint8_t channelInput) {
  if (nChannel == 0)
    xil_printf("[ERROR] nChannel is zero.\r\n");

  if (nChannel > ADS_N_CHANNELS)
	  xil_printf("[ERROR] nChannel is bigger than the number of channels that has the chip ADS.\r\n");

  uint8_t registerValue = 0x00;
  uint8_t registerAddress = CHNSET__BASE_REG_ADDR + nChannel;

  SPIreadREGISTER(registerAddress, &registerValue);
  if (channelInput != -1) {
	 uint8_t mask = CHNSET_B_MUXn2 | CHNSET_B_MUXn1 | CHNSET_B_MUXn0;
    registerValue = registerValue & ~mask; // Remove current channel input configuration
    registerValue = registerValue | (channelInput & mask); // Set the new channel input configuration
  }
  // Power up the channel --> write 0 in bit _PDn
  SPIwriteREGISTER(registerAddress, registerValue & (~CHNSET_B_PDn));
}

void ADS_enableChannelAndSetGain(uint8_t nChannel, uint8_t channelGainConstant, uint8_t channelInput) {
	uint8_t registerValue = 0x00;
	uint8_t registerAddress = CHNSET__BASE_REG_ADDR + nChannel;
	SPIreadREGISTER(registerAddress, &registerValue);
	xil_printf("[INFO] Config inicial canal %0x es: %0x\n\r", nChannel, registerValue);
	// Set 0 the gain bits
	registerValue = registerValue & (~(CHNSET_B_GAINn0 | CHNSET_B_GAINn1 | CHNSET_B_GAINn2));
	// Set the channel gain
	registerValue = registerValue | channelGainConstant;
	SPIwriteREGISTER(registerAddress, registerValue);

	SPIreadREGISTER(registerAddress, &registerValue);
	xil_printf("[INFO] Config final canal %0x es: %0x\n\r", nChannel, registerValue);

	// Power up the channel
	ADS_enableChannel(nChannel, channelInput);
}

int complementoADosADecimal(int num, int bits) {
    // Verificar si el número es negativo (bit de signo en 1)
    if (num & (1 << (bits - 1))) {
        // Realizar la conversión a complemento a dos negativo
        num = num - (1 << bits);
    }
    return num;
}
