/*
 * 	spi_api.c
 *
 *  Created on: 27th Jan. 2023
 *      Author: Ruben Nieto (URJC)
 */

#include "spi_api.h"
#include "sleep.h"

// SPI_Init function
void SPI_init(void){
	u32 ControlSPI;

	// Disable signal SS in SPI
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xffffffff);

	// Configuration of the SPI Core IP
	// Set up the device and enable master
	ControlSPI = XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_CR_OFFSET);
	ControlSPI |= (XSP_CR_MASTER_MODE_MASK); // Master mode [OK]

	// ControlSPI |= (XSP_CR_CLK_POLARITY_MASK); // Set CLK polarity
	ControlSPI &= (~XSP_CR_CLK_POLARITY_MASK); // Clear polarity [OK]

	ControlSPI |= (XSP_CR_CLK_PHASE_MASK); // Set Phase mask [OK]
	// ControlSPI &= (~XSP_CR_CLK_PHASE_MASK); // Clear Phase mask

	ControlSPI &= (~XSP_CR_LOOPBACK_MASK); // Clear loopback mask [OK]
	// Control &= (~XSP_CR_MANUAL_SS_MASK);
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_CR_OFFSET, ControlSPI);

	// Enable the SPI device.
	ControlSPI = XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_CR_OFFSET);
	ControlSPI |= XSP_CR_ENABLE_MASK;
	ControlSPI &= ~XSP_CR_TRANS_INHIBIT_MASK;
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_CR_OFFSET, ControlSPI);
}


// Creates artificial sclk cycles in the SPI bus
int CreateReadingCLK(int num_bytes) {
	u32 count;
	int i = 0;

	while (i < num_bytes) {
		count = 0;
		while ((XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
				& XSP_SR_TX_FULL_MASK) && (count < TIMEOUT))
			count++;
		if (count >= TIMEOUT)
			return (-1);
		XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_DTR_OFFSET, 0); // 0xFFFF);
		i++;
	}

	return 0;
}


// SPI Reset RX FIFO
int ResetRxFIFO(void){
	u32 ControlSPI;
	// Configuration of the SPI core IP
	ControlSPI = XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_CR_OFFSET);
	ControlSPI |= (XSP_CR_RXFIFO_RESET_MASK);
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_CR_OFFSET, ControlSPI);

	return 0;
}

// SPI Write Command for ADS1298R (8-bit)
// Description: Reads 8bit data from register.
// OpcodeCommand: 8bit OpCommand
// keepSpiOpen: Keep CS low if this is 1, else, keep in 0.
// Return: If error return -1 else 0.
int SPIwriteCOMMAND(uint8_t OpcodeCommand, uint8_t keepSpiOpen) {
	u32 count;

	// Enable signal ss in SPI
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xfffffffe);

	// Fill up the transmitter with data, assuming the receiver can hold the same amount of data.
	count = 0;
	while ((XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_FULL_MASK) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_DTR_OFFSET, OpcodeCommand);

	// Clear received messages
	ResetRxFIFO();

	if (!keepSpiOpen){
		usleep(_ADS_T_CLK_4);
		// Disable signal ss in SPI
		XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xffffffff);
	}

	return 0;
}


// Description: Reads 8bit data from register.
// Address: 8bit Register address
// returnData: 8 bit data
// Return: If error return -1 else 0.
int SPIreadREGISTER(uint8_t Address, uint8_t* returnData) {
	u32 count;
	uint8_t data;

	// Enable signal ss in SPI
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xfffffffe);

	// Fill up the transmitter with data, assuming the receiver can hold the same amount of data.
	count = 0;
	while ((XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_FULL_MASK) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_DTR_OFFSET, (COMMAND_RREG | Address));

	// Wait for the transmit FIFO to transition to empty before checking
	// the receive FIFO, this prevents a fast processor from seeing the
	// receive FIFO as empty
	count = 0;
	while ((!(XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_EMPTY_MASK)) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);

	count = 0;
	while ((XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_FULL_MASK) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_DTR_OFFSET, (uint8_t)(0x00) ) ;

	// Wait for the transmit FIFO to transition to empty before checking
	// the receive FIFO, this prevents a fast processor from seeing the
	// receive FIFO as empty
	count = 0;
	while ((!(XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_EMPTY_MASK)) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);

	// Clear received dummy messages until now
	ResetRxFIFO();

	CreateReadingCLK(1);

	// Reading data
	count = 0;
	while ((XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_RX_EMPTY_MASK) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);
	data = (uint8_t) XSpi_ReadReg((XPAR_AXI_QUAD_SPI_0_BASEADDR),
			XSP_DRR_OFFSET);

	usleep(_ADS_T_CLK_4);

	// Disable signal ss in SPI
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xffffffff);

	// Clear received dummy messages until now
	ResetRxFIFO();

	*returnData = data;

	return 0;
}


// See page 17, section 7.7 Switching Characteristics: Serial Interface, and page 59, section 9.5 Programming, in the datasheet) to understand SPI communication
// Description: Write 8bit data to register.
// Address: 8bit Register address
// returnData: 8 bit data
// Return: If error return -1 else 0.
int SPIwriteREGISTER(uint8_t Address, uint8_t writeData) {
	u32 count;

	// Enable signal ss in SPI
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xfffffffe);

	// Fill up the transmitter with data, assuming the receiver can hold the same amount of data.
	count = 0;
	while ((XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_FULL_MASK) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_DTR_OFFSET, (COMMAND_WREG | Address));

	// Wait for the transmit FIFO to transition to empty before checking
	// the receive FIFO, this prevents a fast processor from seeing the
	// receive FIFO as empty
	count = 0;
	while ((!(XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_EMPTY_MASK)) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);

	count = 0;
	while ((XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_FULL_MASK) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_DTR_OFFSET, (uint8_t)(0x00) ) ;

	// Wait for the transmit FIFO to transition to empty before checking
	// the receive FIFO, this prevents a fast processor from seeing the
	// receive FIFO as empty
	count = 0;
	while ((!(XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_EMPTY_MASK)) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);

	count = 0;
	while ((XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_FULL_MASK) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_DTR_OFFSET, writeData ) ;

	// Wait for the transmit FIFO to transition to empty before checking
	// the receive FIFO, this prevents a fast processor from seeing the
	// receive FIFO as empty
	count = 0;
	while ((!(XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
			& XSP_SR_TX_EMPTY_MASK)) && (count < TIMEOUT))
		count++;
	if (count >= TIMEOUT)
		return (-1);

	if (Address == CONFIG1_REG_ADDR || Address == RESP_REG_ADDR)
		usleep(_ADS_T_CLK_18);

	// Disable signal ss in SPI
	XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xffffffff);

	// Clear received dummy messages until now
	ResetRxFIFO();

	return 0;
}
