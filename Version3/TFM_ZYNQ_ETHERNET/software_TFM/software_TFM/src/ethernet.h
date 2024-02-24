/*
*  Ethernet.h
*
*  Created on: 11th march 2023
*  Author: Victor Manuel Navarro Perez (UAH)
*/

#include <stdio.h>
#include "xparameters.h"
#include "netif/xadapter.h"
#include "platform.h"
#include "platform_config.h"
#if defined (__arm__) || defined(__aarch64__)
#include "xil_printf.h"
#endif
#include "lwip/tcp.h"
#include "xil_cache.h"

/* defined by each RAW mode application */
void print_app_header();
int start_application();
err_t transfer_data(float data1, float data2, float data3, float data4);
err_t transfer_data1(float data2, float data3, float data4, float data5);
err_t transfer_data2(float data6, float data7, float data8, float data9);
void tcp_fasttmr(void);
void tcp_slowtmr(void);

/* missing declaration in lwIP */
void lwip_init();

extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;

int configure_ethernet();
int enable_ethernet();
