/*
 * 	dma_api.h
 *
 *  Created on: 11th march 2023
 *      Author: Víctor Manuel Navarro Pérez (URJC)
 */

#include "xparameters.h"
#include "dma_api.h"
#include "xstatus.h"

unsigned int frame_count = 1;

// GIC
XScuGic intc;
static XScuGic_Config *GicConfig;

// DMA
//XAxiDma AxiDma;		/* Instance of the XAxiDma */
//static XAxiDma_Config *DmaConfig;

extern uint8_t hasNewData;
//extern uint8_t hasErr_IRQ;
//extern uint32_t dataCount;

int ContadorDMA = 0;
unsigned int columini = 0;
int iniciado = 0;

void dmaIRQ_Handler(void)
{
//	xil_printf("Interr DMA \n\r");
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR+OFFSET_S2MM_DMASR, Xil_In32(XPAR_AXI_DMA_0_BASEADDR+OFFSET_S2MM_DMASR) | 0x1000);

	hasNewData = 1;

//	if (frame_count == 8+columini && iniciado == 1){
//		ContadorDMA++;
//	}

	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR+OFFSET_S2MMDA, OFFSET_MEM_WRITE+4*NUM_OF_WORDS*frame_count);
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR+OFFSET_S2MM_LENGTH, 4*NUM_OF_WORDS);

	if (++frame_count>=FRAME_COUNT_MAX) {
		//xil_printf("Vuelta DMA \n\r");
		//return;
		frame_count = 0; // LIMITADOR DE ITERACIONES
	}
}

int SetupInterruptSystem(XScuGic *xScuGicInstancePtr)
{
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, xScuGicInstancePtr);
	Xil_ExceptionEnable();
	return XST_SUCCESS;
}

void DMAConfig(void) {

	////////////////////////////////////////////////////////////////////////////////
	// PARA LO DEL CACHÉ EN LA MEMORIA:

	Xil_SetTlbAttributes(0x1A000000,0x04de2);

	////////////////////////////////////////////////////////////////////////////////

	// Initialize DMA (Set bits 0 and 12 of the DMA control register)
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + OFFSET_S2MM_DMACR, Xil_In32(XPAR_AXI_DMA_0_BASEADDR + OFFSET_S2MM_DMACR) | 0x1001);

//	//Interrupt system and interrupt handling
//	GicConfig = XScuGic_LookupConfig(XPAR_PS7_SCUGIC_0_DEVICE_ID);
//	if (NULL == GicConfig)
//	{
//		return XST_FAILURE;
//	}
//	int status = XScuGic_CfgInitialize(&intc, GicConfig, GicConfig -> CpuBaseAddress);
//	if (status != XST_SUCCESS)
//	{
//		return XST_FAILURE;
//	}
//
//	//Xil_ExceptionInit();
//	//XScuGic_SetPriorityTriggerType(&InterruptController, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR, 0x00, 0x3);
//	status = SetupInterruptSystem(&intc);
//
//	if (status != XST_SUCCESS)
//	{
//		return XST_FAILURE;
//	}
//
//	status = XScuGic_Connect(&intc, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR, (Xil_ExceptionHandler)dmaIRQ_Handler, NULL);
//
//	if (status != XST_SUCCESS)
//	{
//		return XST_FAILURE;
//	}
//	XScuGic_Enable(&intc, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR);

	/////////////////////////////////////////////////////////////////////////////////
	// SI SE TIENE ETHERNET DEJAR SOLO LAS SIGUIENTES LINEAS. SI NO, COMENTARLAS.

	XScuGic_RegisterHandler(XPAR_SCUGIC_0_CPU_BASEADDR, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR, (Xil_ExceptionHandler)dmaIRQ_Handler, NULL);

	XScuGic_EnableIntr (XPAR_SCUGIC_0_DIST_BASEADDR, XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR);

	//////////////////////////////////////////////////////////////////////////////

	//Program DMA transfer parameters (i) destination address (ii) length
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR+OFFSET_S2MMDA, OFFSET_MEM_WRITE);
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR+OFFSET_S2MM_LENGTH, 4*NUM_OF_WORDS);

}

//void dmaIRQ_Handler(void *Callback)
//{
//	u32 IrqStatus;
//	int TimeOut;
//	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;
//
////	xil_printf("[INFO] dmaIRQ_Handler called\n\r");
//	dataCount++;
//
//	// * Read pending interrupts *
//	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DEVICE_TO_DMA);
//
//	// * Acknowledge pending interrupts
//	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DEVICE_TO_DMA);
//
//	if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK)) {
//		// xil_printf("[ERR1] dmaIRQ_Handler\n\r");
//		return;
//	}
//
//	if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK)) {
//		XAxiDma_Reset(AxiDmaInst);
//		TimeOut = 10000;
//
//		while (TimeOut) {
//			if(XAxiDma_ResetIsDone(AxiDmaInst)) {
//				// xil_printf("[ERR2] AxiDmaInst reset\n\r");
//				// DMAConfig();
//				hasErr_IRQ = 1;
//				break;
//			}
//
//			TimeOut -= 1;
//		}
//
//		return;
//	}
//
//	// If completion interrupt is asserted, then set RxDone flag
//	if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
////		xil_printf("[INFO] HAS NEW DATA! \n\r");
//		hasNewData = 1;
//	}
//}
//
//
//void DMAConfig(void) {
//
//	int Status;
//
//	DmaConfig = XAxiDma_LookupConfigBaseAddr(XPAR_AXIDMA_0_BASEADDR);
//	if (!DmaConfig) {
//		xil_printf("No config found for %d\r\n", DMA_DEV_ID);
//
//		return XST_FAILURE;
//	}
//	/* Initialize DMA engine */
//	Status = XAxiDma_CfgInitialize(&AxiDma, DmaConfig);
//	if (Status != XST_SUCCESS) {
//		xil_printf("Initialization failed %d\r\n", Status);
//		return XST_FAILURE;
//	}
//
//	//Interrupt system and interrupt handling
//	GicConfig = XScuGic_LookupConfig(XPAR_PS7_SCUGIC_0_DEVICE_ID); // ToDo
//	if (NULL == GicConfig)
//	{
//		return XST_FAILURE;
//	}
//	int status = XScuGic_CfgInitialize(&intc, GicConfig, GicConfig -> CpuBaseAddress);
//	if (status != XST_SUCCESS)
//	{
//		return XST_FAILURE;
//	}
//
//	XScuGic_SetPriorityTriggerType(&intc, RX_INTR_ID, 0xA0, 0x3);
//
//
//	/*
//	 * Connect the device driver handler that will be called when an
//	 * interrupt for the device occurs, the handler defined above performs
//	 * the specific interrupt processing for the device.
//	 */
//	Status = XScuGic_Connect(&intc, RX_INTR_ID,
//				(Xil_InterruptHandler) dmaIRQ_Handler,
//				&AxiDma);
//	if (Status != XST_SUCCESS) {
//		return Status;
//	}
//
//	XScuGic_Enable(&intc, RX_INTR_ID);
//
//	/* Disable all interrupts before setup */
//	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
//						XAXIDMA_DEVICE_TO_DMA);
//
//	/* Enable all interrupts */
//	XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
//							XAXIDMA_DEVICE_TO_DMA);
//
//}
