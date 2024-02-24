/*****************************************************************************/
/**
* @file main.c
* This file contains a design example using the Spi driver for ADS1298R.
*
******************************************************************************/

/***************************** Include Files *********************************/



#include "xparameters.h"	/* XPAR parameters */
#include "xspi.h"			/* SPI device driver */
#include "xil_exception.h"
#include "xil_printf.h"
#include "ads1298r_api.h"
#include "spi_api.h"
#include "gic_api.h"
#include "dma_api.h" // Para memoria
#include "ads_spi_mux.h"
#include "ads_spi_ctrl_top.h"
#include "xaxidma.h"

#include "xtime_l.h"

#include "ads1298r.h"

// data
uint8_t hasNewData = 0;
//uint8_t hasErr_IRQ = 0;
ads_data_t *adsData;

//uint32_t test_time;

//XTime gbl_time_before_test;
//XTime *p_gbl_time_before_test = &gbl_time_before_test;
//XTime gbl_time_after_test;
//XTime *p_gbl_time_after_test = &gbl_time_after_test;
uint32_t dataCount;
//static int inter = 0;
unsigned int inicio = 0;
unsigned int fin = 72;
unsigned int columini = 0;
uint8_t contadornueve;
unsigned int filascont;
//static int interR = 0;
//static int interErr = 0;
//
//extern XAxiDma AxiDma;		/* Instance of the XAxiDma */
//
//u32 checkHalted(u32 BaseAddress, u32 RegOffset){
//	u32 status;
//	status = (XAxiDma_ReadReg(BaseAddress, RegOffset));
//	return status;
//}
//
//void WriteRegisterDMA(u32 BaseAddress, u32 RegOffset, u32 Data){
//	XAxiDma_WriteReg(BaseAddress, RegOffset, Data);
//}



/****************************************************************************
*
* Main function to call the Spi interrupt example.
* @return	XST_SUCCESS if successful, otherwise XST_FAILURE.
*
******************************************************************************/
int main(void)
{


//	u32 *RxBufferPtr;
//	u32 *ReadBufferPtr;
//
//	RxBufferPtr = RX_BUFFER_BASE;
//	// RxBufferPtr = malloc(sizeof(u32)*MAX_PKT_LEN);
//
//	if(RxBufferPtr <= 0){
//		xil_printf("[ERROR] Memory allocation failed\r\n");
//		return -1;
//	}

	// ENVIAR A slv_reg0 DEL MUX (adrss 0x43c0_0000 + ADRESS reg 0) un 01 con S_AXI_WDATA
	// LA DIRECCIÓN SE MANDA POR S_AXI_AWADDR
	ADS_SPI_MUX_mWriteReg(XPAR_ADS_SPI_MUX_0_S00_AXI_BASEADDR, ADS_SPI_MUX_S00_AXI_SLV_REG0_OFFSET, 0x00);
	usleep(1);
	ADS_SPI_MUX_mWriteReg(XPAR_ADS_SPI_MUX_0_S00_AXI_BASEADDR, ADS_SPI_MUX_S00_AXI_SLV_REG0_OFFSET, 0x01);
	usleep(1);

	ADS_SPI_CTRL_TOP_mWriteReg(XPAR_ADS_SPI_CTRL_TOP_0_S00_AXI_BASEADDR, ADS_SPI_MUX_S00_AXI_SLV_REG0_OFFSET, 0x00);

	int Status;
	uint8_t adsID;
	uint8_t readDATA;

	xil_printf("[INFO] Init ADS Example\r\n");


	ADS_begin();



	// Initialize DMA (Set bits 0 and 12 of the DMA control register)


	// It is not need. Only for example purposes
	xil_printf("[INFO] Example: reset value for all registers without reset command\r\n");
	ADS_setAllRegisterToReset();

	// Read ADS129x ID: 0xD2 for ADS1298R
	Status = SPIreadREGISTER(REGID_REG_ADDR, &adsID);
	if (Status != 0) {
		xil_printf("[ERROR] SPI Configuration Failed\r\n");
	}
	// Check ADS ID
	xil_printf("[INFO] Data read at ID_REG (Used: 0x%x): 0x%x \r\n", REGID_ID_ADS1298R, adsID);


	xil_printf("[INFO] Set sampling read to 1 kHz and low-power mode\r\n");
	xil_printf("[INFO] Keep in mind that when config1 or resp registers are changed, internal reset is performed. See the datasheet, section Reset\r\n");
	Status = SPIreadREGISTER(CONFIG1_REG_ADDR, &readDATA);
	xil_printf("[INFO] The previous value CONFIG1 register is: 0x%x \r\n", readDATA);

	// By default, ADS12xx is in low-power consumption and with a sample frequency of 250 Hz
	SPIwriteREGISTER(CONFIG1_REG_ADDR, CONFIG1_HIGH_RES_8k_SPS);
	Status = SPIreadREGISTER(CONFIG1_REG_ADDR, &readDATA);
 	xil_printf("[INFO] The new value CONFIG1 register is (Configured 0x%x): 0x%x \r\n", CONFIG1_HIGH_RES_8k_SPS, readDATA);

	// Setup of my circuit. In my case, it hadn't external reference,
	xil_printf("[INFO] Enabling internal reference buffer --> set PD_REFBUF to 1\r\n");
	// If you change individual bits with constants B_xx, you must add with the RESERVED_BITS constant value to be sure that you will
	// write the right bits in the reserved bits in the register.
	// Remember to write all desired configuration in a register  simultaneously. When you write a register, you delete all previous values

	Status = SPIreadREGISTER(CONFIG3_REG_ADDR, &readDATA);
	xil_printf("[INFO] The previous value CONFIG3 register is: 0x%x \r\n", readDATA);
	SPIwriteREGISTER(CONFIG3_REG_ADDR, CONFIG3_B_PD_REFBUF | CONFIG3_RESERVED_BITS);
	Status = SPIreadREGISTER(CONFIG3_REG_ADDR, &readDATA);
	xil_printf("[INFO] The value CONFIG3 register is: 0x%x \r\n", readDATA);

	// Wait for internal reference to wake up. See page 15, section Electrical Characteristics in the datasheet,
	usleep(150000); // 150 ms

	// Select test signal from chip
	// As example, this 2 methods will keep the SPI open for ADS129x chip for faster configuration. The difference It's not noticeable for humans
	// Be careful when you use this option. Read the documentation before using it.
	Status = SPIreadREGISTER(CONFIG2_REG_ADDR, &readDATA);
	xil_printf("[INFO] The previous value CONFIG2 register is: 0x%x \r\n", readDATA);
//	SPIwriteREGISTER(CONFIG2_REG_ADDR, CONFIG2_TEST_SOURCE_INTERNAL);

	// We will use the square signal at 4 Hz
	SPIwriteREGISTER(CONFIG2_REG_ADDR, CONFIG2_TEST_FREQ_4HZ);
	Status = SPIreadREGISTER(CONFIG2_REG_ADDR, &readDATA);
	xil_printf("[INFO] The value CONFIG2 register is: 0x%x \r\n", readDATA);

	xil_printf("[INFO] Starting channels configuration.\r\n");
	xil_printf("[INFO] Channel 1: gain 1 and test signal as input.\r\n");
	ADS_enableChannelAndSetGain(1, CHNSET_GAIN_6X, CHNSET_TEST_SIGNAL);

	xil_printf("[INFO] Channel 2: gain 1 and test signal as input.\r\n");
	ADS_enableChannelAndSetGain(2, CHNSET_GAIN_6X, CHNSET_TEST_SIGNAL); //CHNSET_GAIN_6X

	// xil_printf("[INFO] Channel 3: power-down and its inputs shorted (as Texas Instruments recommends).\r\n");
	xil_printf("[INFO] Channel 3: gain 1 and test signal as input.\r\n");
	ADS_enableChannelAndSetGain(3, CHNSET_GAIN_6X, CHNSET_ELECTRODE_INPUT); //CHNSET_TEST_SIGNAL
	// ADS_disableChannel(3);

	xil_printf("[INFO] Channel 4 to 8 channel: set gain 1 and test signal as input.\r\n");
	for (uint8_t i = 4; i <= ADS_N_CHANNELS; i++)
		ADS_enableChannelAndSetGain(i, CHNSET_GAIN_6X, CHNSET_TEST_SIGNAL); // CHNSET_ELECTRODE_INPUT

	xil_printf("[INFO] Starting channels configuration.\r\n");
	SendSPICommandSTART(0);

	// enable interrupts for DRY
//	enable_dry_irq();
	DMAConfig();

	uint8_t registerValue = 0x00;
	SPIreadREGISTER(CHNSET__BASE_REG_ADDR + 1, &registerValue);
	xil_printf("[INFO] Config final canal %0x es: %0x\n\r", 1, registerValue);
//	Status = SPIreadREGISTER(CONFIG1_REG_ADDR, &readDATA);
//	xil_printf("[INFO] The value CONFIG1 register is: 0x%x \r\n", readDATA);
//	Status = SPIreadREGISTER(CONFIG2_REG_ADDR, &readDATA);
//	xil_printf("[INFO] The value CONFIG2 register is: 0x%x \r\n", readDATA);
//	Status = SPIreadREGISTER(CONFIG3_REG_ADDR, &readDATA);
//	xil_printf("[INFO] The value CONFIG3 register is: 0x%x \r\n", readDATA);

	// We need to put ADS in DATA or RDATC mode to receive new data
	// Remember that in RDATAC mode, ADS ignores any SPI command sent if it is not SDATAC command
	xil_printf("[INFO] Set ADS chip in read data (RDATAC) mode.\r\n");
	sendSPICommandRDATAC(0);

	//ENVIAR A slv_reg0 DEL MUX (adrss 0x43c0_0000 + ADRESS reg 0) un 11
	xil_printf("[INFO] SPI Control to MUX.\r\n");
	ADS_SPI_MUX_mWriteReg(XPAR_ADS_SPI_MUX_0_S00_AXI_BASEADDR, ADS_SPI_MUX_S00_AXI_SLV_REG0_OFFSET, 0x03);

//	disable_dry_irq();




//	enable_DMA_irq();
	// Enable signal ss in SPI
	// XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xfffffffe);

	// ADS_SPI_CTRL_TOP_mWriteReg(XPAR_ADS_SPI_CTRL_TOP_0_S00_AXI_BASEADDR, ADS_SPI_MUX_S00_AXI_SLV_REG0_OFFSET, 0x01);


//	xil_printf("[INFO] Status RxBufferPtr %0x\n\r", RxBufferPtr);
//	xil_printf("[INFO] Status &RxBufferPtr %0x\n\r", &RxBufferPtr);
	//xil_printf("[INFO] Status *RxBufferPtr %0x\n\r", *RxBufferPtr[0]);

//	WriteRegisterDMA(XPAR_AXIDMA_0_BASEADDR, 0x48, (u32) RxBufferPtr);
//	// WriteRegisterDMA(XPAR_AXIDMA_0_BASEADDR, 0x4C, (u32) (RxBufferPtr+sizeof(u32)*MAX_PKT_LEN));
//	WriteRegisterDMA(XPAR_AXIDMA_0_BASEADDR, 0x58, sizeof(u32)*MAX_PKT_LEN);

//	u32 status = checkHalted(XPAR_AXIDMA_0_BASEADDR, 0x30);
//	xil_printf("[INFO] Status S2MM_DMACR %0x\n\r", status);
//	status = checkHalted(XPAR_AXIDMA_0_BASEADDR, 0x34);
//	xil_printf("[INFO] Status S2MM_DMASR %0x\n\r", status);
//	status = checkHalted(XPAR_AXIDMA_0_BASEADDR, 0x48);
//	xil_printf("[INFO] Status S2MM_DA %0x\n\r", status);
//	status = checkHalted(XPAR_AXIDMA_0_BASEADDR, 0x4C);
//	xil_printf("[INFO] Status S2MM_DA_MSB %0x\n\r", status);
//	status = checkHalted(XPAR_AXIDMA_0_BASEADDR, 0x58);
//	xil_printf("[INFO] Status S2MM_LENGTH %0x\n\r", status);
	// Non-cached memory
	// Xil_SetTlbAttributes(RX_BUFFER_BASE, 0x14de2);

	// xil_printf("[INFO] Flush Buffer Rx\n\r");
//	Xil_DCacheFlushRange((INTPTR) RxBufferPtr, sizeof(u32)*(MAX_PKT_LEN+1));
	// Xil_DCacheFlush();

//	Status = XAxiDma_SimpleTransfer(&AxiDma, (INTPTR) RxBufferPtr,
//			sizeof(u32)*(MAX_PKT_LEN), XAXIDMA_DEVICE_TO_DMA);
//	if (Status != XST_SUCCESS) {
//		xil_printf("[ERROR] XAxiDma_SimpleTransfer 1\n\r");
//		return XST_FAILURE;
//	}
//	status = checkHalted(XPAR_AXIDMA_0_BASEADDR, 0x34);
//	xil_printf("[INFO] Status after transfer %0x\n\r", status);
	// https://github.com/wincle626/ZCU106_DMA_REF_DESIGN/blob/main/software/xaxidma_simple_poll_ddr_32bits/src/main.c

	xil_printf("[INFO] Start loop obtaining the new data.\r\n");

	while (Xil_In32(OFFSET_MEM_WRITE +4*(columini)) != 0xFFC00000){
		columini++;
		contadornueve++;
		if (contadornueve == 9) {
			contadornueve = 0;
			filascont++;
		}
	}

	columini = columini - (filascont*9);

	inicio = columini;
	fin = fin + inicio;

//	usleep(150);

	while(1){

		// COMENTADO!!

//		XTime_GetTime(p_gbl_time_after_test);
//		test_time = (u64) gbl_time_after_test - (u64) gbl_time_before_test;
//		if(test_time > 333333333) // 333  1us
//		{
//	    	//xil_printf("[INFO] Err =  %d / %d.\r\n", interErr, inter);
//	    	//inter = 0;
//	    	XTime_GetTime(p_gbl_time_before_test);
//	    }

		// FIN COMENTADO!!

//		if(hasNewData){
//
//			xil_printf("[INFO] New data available.\r\n");
//			hasNewData = 0;
//
//			// Print raw data and format the data
//			xil_printf("Status Word: 0x%x. \r\n", ((adsData->rawData[0] << 16) | (adsData->rawData[1] << 8) | adsData->rawData[2]));
//			xil_printf("Data Ch1: 0x%x. \r\n", ((adsData->rawData[3] << 16) | (adsData->rawData[4] << 8) | adsData->rawData[5]));
//			xil_printf("Data Ch2: 0x%x. \r\n", ((adsData->rawData[6] << 16) | (adsData->rawData[7] << 8) | adsData->rawData[8]));
//			xil_printf("Data Ch3: 0x%x. \r\n", ((adsData->rawData[9] << 16) | (adsData->rawData[10] << 8) | adsData->rawData[11]));
//			xil_printf("Data Ch4: 0x%x. \r\n", ((adsData->rawData[12] << 16) | (adsData->rawData[13] << 8) | adsData->rawData[14]));
//			xil_printf("Data Ch5: 0x%x. \r\n", ((adsData->rawData[15] << 16) | (adsData->rawData[16] << 8) | adsData->rawData[17]));
//			xil_printf("Data Ch6: 0x%x. \r\n", ((adsData->rawData[18] << 16) | (adsData->rawData[19] << 8) | adsData->rawData[20]));
//			xil_printf("Data Ch7: 0x%x. \r\n", ((adsData->rawData[21] << 16) | (adsData->rawData[22] << 8) | adsData->rawData[23]));
//			xil_printf("Data Ch8: 0x%x. \r\n", ((adsData->rawData[24] << 16) | (adsData->rawData[25] << 8) | adsData->rawData[26]));
//
//			// ToDo: Apply transformation.
//
//		}

//		if(hasNewData){
//
//			// xil_printf("[INFO] New data available.\r\n");
//			hasNewData = 0;

//			// Print raw data and format the data
//			xil_printf("%x\t", ((adsData->rawData[0] << 16) | (adsData->rawData[1] << 8) | adsData->rawData[2]));
//			xil_printf("%x\t", ((adsData->rawData[3] << 16) | (adsData->rawData[4] << 8) | adsData->rawData[5]));
//			xil_printf("%x\t", ((adsData->rawData[6] << 16) | (adsData->rawData[7] << 8) | adsData->rawData[8]));
//			xil_printf("%x\t", ((adsData->rawData[9] << 16) | (adsData->rawData[10] << 8) | adsData->rawData[11]));
//			xil_printf("%x\t", ((adsData->rawData[12] << 16) | (adsData->rawData[13] << 8) | adsData->rawData[14]));
//			xil_printf("%x\t", ((adsData->rawData[15] << 16) | (adsData->rawData[16] << 8) | adsData->rawData[17]));
//			xil_printf("%x\t", ((adsData->rawData[18] << 16) | (adsData->rawData[19] << 8) | adsData->rawData[20]));
//			xil_printf("%x\t", ((adsData->rawData[21] << 16) | (adsData->rawData[22] << 8) | adsData->rawData[23]));
//			xil_printf("%x\r\n", ((adsData->rawData[24] << 16) | (adsData->rawData[25] << 8) | adsData->rawData[26]));

			// ToDo: Apply transformation.

//		}

//		if(hasErr_IRQ){
//			Xil_DCacheFlushRange((INTPTR) RxBufferPtr, sizeof(u32)*(MAX_PKT_LEN));
//			Status = XAxiDma_SimpleTransfer(&AxiDma, (INTPTR) RxBufferPtr,
//					sizeof(u32)*(MAX_PKT_LEN), XAXIDMA_DEVICE_TO_DMA);
//			if (Status != XST_SUCCESS) {
//				xil_printf("[ERROR] XAxiDma_SimpleTransfer 3\n\r");
//				return XST_FAILURE;
//			}
//			hasErr_IRQ = 0;
//			interErr++;
//		}

//		if(inter>interR){
//			ReadBufferPtr = RX_BUFFER_BASE+(sizeof(u32)*(MAX_PKT_LEN))*interR;
//			for(int k = 0; k < MAX_PKT_LEN-4; k++){
//				xil_printf("[Data] dataR[%d] = %x\n\r", k, ReadBufferPtr[k]);
//			}
//			interR++;
//		}

		if(hasNewData){

			// xil_printf("[INFO] New data available.\r\n");
			hasNewData = 0;
//			xil_printf("[INFO] nuevos datos.\r\n");

//			inter++;
			// xil_printf("[INFO] inter %d\r\n", inter);


//			Xil_DCacheFlushRange((INTPTR) RxBufferPtr, sizeof(u32)*(MAX_PKT_LEN));
//
//			Status = XAxiDma_SimpleTransfer(&AxiDma, (INTPTR) RxBufferPtr+(sizeof(u32)*(MAX_PKT_LEN))*inter,
//					sizeof(u32)*(MAX_PKT_LEN), XAXIDMA_DEVICE_TO_DMA);
//			if (Status != XST_SUCCESS) {
//				xil_printf("[ERROR] XAxiDma_SimpleTransfer 2\n\r");
//				return XST_FAILURE;
//			}

//			if (inter == 1024) {

//			for (int k=0; k<=8; k++){
//				if (Xil_In32(OFFSET_MEM_WRITE +4*(k)) == 0xFFC00000) {
//					inicio = k;
//					columini = k;
//				}
//			}

//				xil_printf("[INFO] DENTRO DE OTRO BUCLE.\r\n");
				for (int i=inicio; i<=fin; i++){

//					xil_printf("[INFO] BUCLE FOR.\r\n");

//					//int datach0 = ((Xil_In32(OFFSET_MEM_WRITE +4*i) && 0xFF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*i) && 0xFF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*i) && 0xFF0000);
//					int datach1 = ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) && 0x0000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) && 0x00FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) && 0xFF0000);
//					int datach2 = ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) && 0x0000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) && 0x00FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) && 0xFF0000);
//					int datach3 = ((Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) && 0x0000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) && 0x00FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) && 0xFF0000);
//					int datach4 = ((Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) && 0x0000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) && 0x00FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) && 0xFF0000);
//					int datach5 = ((Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) && 0x0000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) && 0x00FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) && 0xFF0000);
//					int datach6 = ((Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) && 0x0000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) && 0x00FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) && 0xFF0000);
//					int datach7 = ((Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) && 0x0000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) && 0x00FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) && 0xFF0000);
//					int datach8 = ((Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) && 0x0000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) && 0x00FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) && 0xFF0000);
//
//					//printf("%.4f\t", (2.4*(float)(datach0))/(6*((1<<23)-1))); // Status
//					printf("%.4f\t", (2.4*(float)(datach1))/(6*((1<<23)-1))); // Canal 1
//					printf("%.4f\t", (2.4*(float)(datach2))/(6*((1<<23)-1))); // Canal 2
//					printf("%.4f\t", (2.4*(float)(datach3))/(6*((1<<23)-1))); // Canal 3
//					printf("%.4f\t", (2.4*(float)(datach4))/(6*((1<<23)-1))); // Canal 4
//					printf("%.4f\t", (2.4*(float)(datach5))/(6*((1<<23)-1))); // Canal 5
//					printf("%.4f\t", (2.4*(float)(datach6))/(6*((1<<23)-1))); // Canal 6
//					printf("%.4f\t", (2.4*(float)(datach7))/(6*((1<<23)-1))); // Canal 7
//					printf("%.4f\r\n", (2.4*(float)(datach8))/(6*((1<<23)-1))); // Canal 8

//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x00FF0000));
////					printf("%.4f\t", (2.4*(float)(datach0))/(6*((1<<23)-1))); // Status
//
//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x00FF0000));
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0xFF000000))>>24);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x00FFFFFF)));
//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x0000FF00))| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x00FF0000))>>16);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) & 0xFF000000))>>24);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) & 0x00FFFFFF)));
//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) & 0x0000FF00))| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) & 0x00FF0000))>>16);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) & 0xFF000000))>>24);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) & 0x00FFFFFF)));
//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) & 0x0000FF00))| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) & 0x00FF0000))>>16);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) & 0xFF000000))>>24);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) & 0x00FFFFFF)));
//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) & 0x0000FF00))| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) & 0x00FF0000))>>16);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) & 0xFF000000))>>24);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) & 0x00FFFFFF)));
//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) & 0x0000FF00))| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) & 0x00FF0000))>>16);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) & 0xFF000000))>>24);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) & 0x00FFFFFF)));
//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) & 0x0000FF00))| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) & 0x00FF0000))>>16);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) & 0xFF000000))>>24);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) & 0x00FFFFFF)));
//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) & 0x0000FF00))| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) & 0x00FF0000))>>16);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0xFF000000))>>24);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x00FFFFFF)));
//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x0000FF00))| ((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x00FF0000))>>16);
//					xil_printf("%d\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0xFF000000))>>24);
//					xil_printf("%d\r\n", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x00FFFFFF)));
//					xil_printf("%x\r\n", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x0000FF00))| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x00FF0000))>>16);
//					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 1
//					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 1

//					xil_printf("%x\t", ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x00FF0000));
////					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+2)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 2
//					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+3)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 3
//					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+4)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 4
//					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+5)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 5
//					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+6)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 6
//					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+7)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 7
//					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+8)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 8
//					printf("%.4f\t", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 1
//					printf("%.4f\r\n", (2.4*(float)(((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x000000FF) << 16)| ((Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x0000FF00) << 8)| (Xil_In32(OFFSET_MEM_WRITE +4*(i+1)) & 0x00FF0000)))/(6*((1<<24)-1))); // Canal 1


//					long Canal0 = Xil_In32(OFFSET_MEM_WRITE +4*(i));
//					long Canal1 = Xil_In32(OFFSET_MEM_WRITE +4*(i+1));
//					long Canal2 = Xil_In32(OFFSET_MEM_WRITE +4*(i+2));
//					long Canal3 = Xil_In32(OFFSET_MEM_WRITE +4*(i+3));
//					long Canal4 = Xil_In32(OFFSET_MEM_WRITE +4*(i+4));
//					long Canal5 = Xil_In32(OFFSET_MEM_WRITE +4*(i+5));
//					long Canal6 = Xil_In32(OFFSET_MEM_WRITE +4*(i+6));
//					long Canal7 = Xil_In32(OFFSET_MEM_WRITE +4*(i+7));
//					long Canal8 = Xil_In32(OFFSET_MEM_WRITE +4*(i+8));



//					printf("%.4f\t", (2.4*(float)(Canal0)) /(6*((1<<24)-1))); // Canal 2 // .4f
//					printf("%.4f\t", (2.4*(float)(Canal1)) /(6*((1<<24)-1))); // Canal 3
//					printf("%.4f\t", (2.4*(float)(Canal2)) /(6*((1<<24)-1))); // Canal 4
//					printf("%.4f\t", (2.4*(float)(Canal3)) /(6*((1<<24)-1))); // Canal 5
//					printf("%.4f\t", (2.4*(float)(Canal4))/(6*((1<<24)-1))); // Canal 6
//					printf("%.4f\t", (2.4*(float)(Canal5)) /(6*((1<<24)-1))); // Canal 7
//					printf("%.4f\t", (2.4*(float)(Canal6)) /(6*((1<<24)-1))); // Canal 8
//					printf("%.4f\t", (2.4*(float)(Canal7)) /(6*((1<<24)-1))); // Canal 1
//					printf("%.4f\r\n", (2.4*(float)(Canal8)) /(6*((1<<24)-1))); // Canal 1


					int Canal1 = complementoADosADecimal(Xil_In32(OFFSET_MEM_WRITE +4*(i+1)), 0x20);
					int Canal2 = complementoADosADecimal(Xil_In32(OFFSET_MEM_WRITE +4*(i+2)), 0x20);
					int Canal3 = complementoADosADecimal(Xil_In32(OFFSET_MEM_WRITE +4*(i+3)), 0x20);
					int Canal4 = complementoADosADecimal(Xil_In32(OFFSET_MEM_WRITE +4*(i+4)), 0x20);
					int Canal5 = complementoADosADecimal(Xil_In32(OFFSET_MEM_WRITE +4*(i+5)), 0x20);
					int Canal6 = complementoADosADecimal(Xil_In32(OFFSET_MEM_WRITE +4*(i+6)), 0x20);
					int Canal7 = complementoADosADecimal(Xil_In32(OFFSET_MEM_WRITE +4*(i+7)), 0x20);
					int Canal8 = complementoADosADecimal(Xil_In32(OFFSET_MEM_WRITE +4*(i+8)), 0x20);

	//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i))); // Canal 2 // .4f
	//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i+1))); // Canal 3
	//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i+2))); // Canal 4
	//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i+3))); // Canal 5
	//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i+4))); // Canal 6
	//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i+5))); // Canal 7
	//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i+6))); // Canal 8
	//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i+7))); // Canal 1
	//					xil_printf("%x\r\n", Xil_In32(OFFSET_MEM_WRITE +4*(i+8))); // Canal 1

//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i))); // Canal 0 // .4f
//					printf("%.4f\t", ((2*2.4*(float)(Canal1)) /((1<<24)-1))-2.4); // Canal 1
//					printf("%.4f\t", ((2*2.4*(float)(Canal2)) /((1<<24)-1))-2.4); // Canal 2
//					printf("%.4f\t", ((2*2.4*(float)(Canal3)) /((1<<24)-1))-2.4); // Canal 3
//					printf("%.4f\t", ((2*2.4*(float)(Canal4)) /((1<<24)-1))-2.4); // Canal 4
//					printf("%.4f\t", ((2*2.4*(float)(Canal5)) /((1<<24)-1))-2.4); // Canal 5
//					printf("%.4f\t", ((2*2.4*(float)(Canal6)) /((1<<24)-1))-2.4); // Canal 6
//					printf("%.4f\t", ((2*2.4*(float)(Canal7)) /((1<<24)-1))-2.4); // Canal 7
//					printf("%.4f\r\n", ((2*2.4*(float)(Canal8)) /((1<<24)-1))-2.4); // Canal 8

					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i))); // Canal 0 // .4f
					printf("%.8f\t", ((2.4*(float)(Canal1)) /(6*((1<<23)-1)))); // Canal 1
					printf("%.8f\t", ((2.4*(float)(Canal2)) /(6*((1<<23)-1)))); // Canal 2
					printf("%.8f\t", ((2.4*(float)(Canal3)) /(6*((1<<23)-1)))); // Canal 3
					printf("%.8f\t", ((2.4*(float)(Canal4)) /(6*((1<<23)-1)))); // Canal 4
					printf("%.8f\t", ((2.4*(float)(Canal5)) /(6*((1<<23)-1)))); // Canal 5
					printf("%.8f\t", ((2.4*(float)(Canal6)) /(6*((1<<23)-1)))); // Canal 6
					printf("%.8f\t", ((2.4*(float)(Canal7)) /(6*((1<<23)-1)))); // Canal 7
					printf("%.8f\r\n", ((2.4*(float)(Canal8)) /(6*((1<<23)-1)))); // Canal 8

//					xil_printf("%x\t", Xil_In32(OFFSET_MEM_WRITE +4*(i))); // Canal 0 // .4f
//					printf("%d\t", Canal1); // Canal 1
//					printf("%d\t", Canal2); // Canal 2
//					printf("%d\t", Canal3); // Canal 3
//					printf("%d\t", Canal4); // Canal 4
//					printf("%d\t", Canal5); // Canal 5
//					printf("%d\t", Canal6); // Canal 6
//					printf("%d\t", Canal7); // Canal 7
//					printf("%d\r\n", Canal8); // Canal 8

					i = i+8;
				}

				if (fin>=FRAME_COUNT_MAX) // Cuando se llega al final de la memoria que usa la DMA
				      			fin = columini; // Se resetea el cursor de lectura

				inicio = fin;
				fin = fin+72;

//				inter = 0;
//				xil_printf("[INFO] SALGO DE BUCLE.\r\n");
			}
		}


			// Print raw data and format the data
			// xil_printf("Status Word: 0x%x. \r\n", ((adsData->rawData[0] << 16) | (adsData->rawData[1] << 8) | adsData->rawData[2]));
//			int datach1 = (adsData->rawData[3] << 16) | (adsData->rawData[4] << 8) | (adsData->rawData[5]);
//			int datach2 = (adsData->rawData[6] << 16) | (adsData->rawData[7] << 8) | (adsData->rawData[8]);
//			int datach3 = (adsData->rawData[9] << 16) | (adsData->rawData[10] << 8) | (adsData->rawData[11]);
//			int datach4 = (adsData->rawData[12] << 16) | (adsData->rawData[13] << 8) | (adsData->rawData[14]);
//			int datach5 = (adsData->rawData[15] << 16) | (adsData->rawData[16] << 8) | (adsData->rawData[17]);
//			int datach6 = (adsData->rawData[18] << 16) | (adsData->rawData[19] << 8) | (adsData->rawData[20]);
//			int datach7 = (adsData->rawData[21] << 16) | (adsData->rawData[22] << 8) | (adsData->rawData[23]);
//			int datach8 = (adsData->rawData[24] << 16) | (adsData->rawData[25] << 8) | (adsData->rawData[26]);
//
//			printf("%.4f\t", (2.4*(float)(datach1))/(6*((1<<23)-1)));
//			printf("%.4f\t", (2.4*(float)(datach2))/(6*((1<<23)-1)));
//			printf("%.4f\t", (2.4*(float)(datach3))/(6*((1<<23)-1)));
//			printf("%.4f\t", (2.4*(float)(datach4))/(6*((1<<23)-1)));
//			printf("%.4f\t", (2.4*(float)(datach5))/(6*((1<<23)-1)));
//			printf("%.4f\t", (2.4*(float)(datach6))/(6*((1<<23)-1)));
//			printf("%.4f\t", (2.4*(float)(datach7))/(6*((1<<23)-1)));
//			printf("%.4f\r\n", (2.4*(float)(datach8))/(6*((1<<23)-1)));}

			// ToDo: Apply transformation.

		// usleep(1000000);
//	}

	// You can could the method end() to free GPIO used pins and resources. if you don't need any more de ADS
	// You have to call begin() if you want to use again the ADS
	ADS_end();

	xil_printf("[INFO] Successfully ran ADS Example.\r\n");
	return XST_SUCCESS;
}


