/*
 * 	dma_api.h
 *
 *  Created on: 11th march 2023
 *      Author: Víctor Manuel Navarro Pérez (URJC)
 */

#include <stdio.h>
#include "xil_printf.h"
#include "ps7_init.h"
#include <xil_io.h>
#include "xscugic.h"
#include "xparameters.h"

#define NUM_OF_WORDS 64
#define FRAME_COUNT_MAX 9000//524288 // Comprobar!!! LA DMA SE ACTIVARÍA 9000 VECES Y SE OBTENDRÍAN 64000 DATOS POR CANAL, EQUIVALENTE A 8 SEGUNDOS POR VUELTA

#define OFFSET_MEM_WRITE 0x1A000000 // Memory write offset
#define OFFSET_S2MM_DMACR 0x30 // S2MM DMA control register
#define OFFSET_S2MM_DMASR 0x34 // S2MM DMA status register
#define OFFSET_S2MMDA 0x48 // S2MM destination address
#define OFFSET_S2MM_LENGTH 0x58 // S2MM buffer length

//#define DMA_DEV_ID		XPAR_AXIDMA_0_DEVICE_ID
//
//#define MEM_BASE_ADDR		XPAR_PS7_DDR_0_S_AXI_BASEADDR
//#define RX_INTR_ID			XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR
//
//#define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x0010000)
//#define RX_BUFFER_HIGH		(MEM_BASE_ADDR + 0x004FFFF)
//
//#define MAX_PKT_LEN		64+4

void DMAConfig(void);
int SetupInterruptSystem(XScuGic *xScuGicInstancePtr);
void dmaIRQ_Handler(void);

void Xil_SetTlbAttributes(UINTPTR Addr, u32 attrib);
