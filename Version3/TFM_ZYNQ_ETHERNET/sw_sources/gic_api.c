/*
 * 	gic_api.c
 *
 *  Created on: 29th Jan. 2023
 *      Author: Ruben Nieto (URJC)
 */

#include "gic_api.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "spi_api.h"
#include "ads1298r_api.h"
#include "dma_api.h"

extern uint8_t hasNewData;
extern ads_data_t *adsData;

// sets up the interrupt system and enables interrupts for IRQ_F2P[1:0]
//int setup_pl_irq(XScuGic *intc_instance_ptr) {
//
//    int result;
//    XScuGic_Config *intc_config;
//
//    // get config for interrupt controller
//    intc_config = XScuGic_LookupConfig(XPAR_PS7_SCUGIC_0_DEVICE_ID);
//    if (NULL == intc_config) {
//        return XST_FAILURE;
//    }
//
//    // initialize the interrupt controller driver
//    result = XScuGic_CfgInitialize(intc_instance_ptr, intc_config, intc_config->CpuBaseAddress);
//
//    if (result != XST_SUCCESS) {
//        return result;
//    }
//
//    // set the priority of IRQ_F2P[0:0] to 0x00 (lowest 0xF8, highest 0x00) and a trigger for a rising edge 0x3.
//    // XScuGic_SetPriorityTriggerType(intc_instance_ptr, DRY_IRQ_ID, 0x00, 0x3); // Si se activa esto solo atiende a esta interrupción de forma constante.
//
//    Xil_ExceptionInit();
//    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, intc_instance_ptr);
//    // enable non-critical exceptions
//    Xil_ExceptionEnable();
//    return XST_SUCCESS;
//
//    if (result != XST_SUCCESS) {
//        return result;
//    }
//
//    // connect the interrupt service routine isr0 to the interrupt controller
//    result = XScuGic_Connect(intc_instance_ptr, DRY_IRQ_ID, (Xil_ExceptionHandler)dry_irq_handler, (void *)&intc_instance_ptr);
//
//    if (result != XST_SUCCESS) {
//        return result;
//    }
//
//    result = XScuGic_Connect(intc_instance_ptr, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR, (Xil_ExceptionHandler)dmaIRQ_Handler, NULL);
//
//    if (result != XST_SUCCESS) {
//        return result;
//    }
//
//    // enable interrupts for IRQ_F2P[1:1]
//    // XScuGic_Enable(intc_instance_ptr, DRY_IRQ_ID);
//
//    // initialize the exception table and register the interrupt controller handler with the exception table
//
//
//
//}

extern uint32_t dataCount;

// interrupt service routine for IRQ_F2P[0:0]
//void dry_irq_handler (void *intc_inst_ptr) {
//	u32 count;
//
//	dataCount++;
//    // xil_printf("dry_irq called\n\r");
//	// usleep(_ADS_T_CLK);
//
//    // Enable signal ss in SPI
//    XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xfffffffe);
//
//    // Clear received dummy messages until now
//	ResetRxFIFO();
//
//	// Reading the data
//	CreateReadingCLK(_ADS_DATA_PACKAGE_SIZE);
//
//	for(int k = 0; k < _ADS_DATA_PACKAGE_SIZE; k++) {
//		adsData->rawData[k] = 0x00;
//		// Reading data
//		count = 0;
//		while ((XSpi_ReadReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SR_OFFSET)
//				& XSP_SR_RX_EMPTY_MASK) && (count < TIMEOUT))
//			count++;
//		if (count >= TIMEOUT)
//			xil_printf("[ERROR] Timeout SPI transaction. Wrong data.\r\n");
//		adsData->rawData[k] = (uint8_t) XSpi_ReadReg((XPAR_AXI_QUAD_SPI_0_BASEADDR),
//				XSP_DRR_OFFSET);
//	}
//
//	usleep(_ADS_T_CLK_4);
//
//    // Disable signal ss in SPI
//    XSpi_WriteReg(XPAR_AXI_QUAD_SPI_0_BASEADDR, XSP_SSR_OFFSET, 0xffffffff);
//
//    // hasNewData = 1;
//
//    // ToDo: Clear IRQ?
//}
