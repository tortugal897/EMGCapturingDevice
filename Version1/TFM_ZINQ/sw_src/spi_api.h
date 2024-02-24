/*
 * 	spi_api.h
 *
 *  Created on: 27th Jan. 2023
 *      Author: Ruben Nieto (URJC)
 */

#ifndef spi_api_h
#define spi_api_h

#include "xspi_l.h"
#include "xparameters.h"
#include "sleep.h"
#include "ads1298r.h"

// Definitions
#define TIMEOUT 1e6

// SPI Functions
void SPI_init(void);
int ResetRxFIFO(void);
int CreateReadingCLK(int num_bytes);
int SPIwriteCOMMAND(uint8_t OpcodeCommand, uint8_t keepSpiOpen);
int SPIreadREGISTER(uint8_t Address, uint8_t* returnData);
int SPIwriteREGISTER(uint8_t Address, uint8_t writeData);

#endif
