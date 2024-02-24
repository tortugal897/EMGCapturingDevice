/*
 * 	ads1298r_api.h
 *
 *  Created on: 20th Jan. 2023
 *      Author: Ruben Nieto (URJC)
 */

#ifndef ads1298r_api_h
#define ads1298r_api_h

#include "ads1298r.h"
#include "xspi_l.h"
#include "xparameters.h"
#include "sleep.h"

// Definitions

// ADS Functions
void ADS_begin(void);
void ADS_end(void);
void ADS_reset(void);
void ADS_setAllRegisterToReset(void);

void enable_dry_irq(void);

void ADS_disableChannel(uint8_t nChannel);
void ADS_enableChannel(uint8_t nChannel, uint8_t channelInput);
void ADS_enableChannelAndSetGain(uint8_t nChannel, uint8_t channelGainConstant, uint8_t channelInput);

// ADS Commands
void sendSPICommandWAKEUP(uint8_t keepSpiOpen);
void sendSPICommandSTANDBY(uint8_t keepSpiOpen);
void SendSPICommandRESET(uint8_t keepSpiOpen);
void SendSPICommandSTART(uint8_t keepSpiOpen);
void sendSPICommandSTOP(uint8_t keepSpiOpen);
void sendSPICommandRDATAC(uint8_t keepSpiOpen);
void sendSPICommandSDATAC(uint8_t keepSpiOpen);
void sendSPICommandRDATA(uint8_t keepSpiOpen); // WARNING: NOT IMPLEMENTED!


/* ======= ads_data_t definition  ============= */
// The size of the data sent by ads129xx depends by the number of bits per channel and the number of channels in the chip.
#if ADS_BITS_PER_CHANNEL == 17

#define _ADS_DATA_PACKAGE_SIZE (3 + 2 * ADS_N_CHANNELS)
typedef struct ads_bits_sample_t {
	uint8_t hi, mid, low;
} ads_bits_sample_t;

#elif ADS_BITS_PER_CHANNEL == 19

#define _ADS_DATA_PACKAGE_SIZE (3 + 2 * ADS_N_CHANNELS)
typedef struct ads_bits_sample_t {
	uint8_t hi, mid, low;
} ads_bits_sample_t;

#elif ADS_BITS_PER_CHANNEL == 24

#define _ADS_DATA_PACKAGE_SIZE (3 + 3 * ADS_N_CHANNELS)
typedef struct ads_bits_sample_t {
  uint8_t hi, mid, low;
} ads_bits_sample_t;
#endif

// Generic union for data receviced from any ADS129xx chip
typedef union {
  uint8_t rawData[_ADS_DATA_PACKAGE_SIZE]; // Max size (ADS1298 in 24 bit per channel): 24 status bits + 24 bits per channel × 4 channels = 216 -> 27 bytes.
  struct {
	  uint8_t statusWord[3];
    ads_bits_sample_t channel[ADS_N_CHANNELS];
  } formatedData;
} ads_data_t;

#endif
