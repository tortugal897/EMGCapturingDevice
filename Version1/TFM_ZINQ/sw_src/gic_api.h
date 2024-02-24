/*
 * 	gic_api.h
 *
 *  Created on: 29th Jan. 2023
 *      Author: Ruben Nieto (URJC)
 */

#ifndef gic_api_h
#define gic_api_h

#include "xscugic.h"
#include "xil_exception.h"
#include "xparameters.h"

#define DRY_IRQ_ID XPAR_FABRIC_ADS_DRY_INTR

int setup_pl_irq(XScuGic *intc_instance_ptr);
void dry_irq_handler (void *intc_inst_ptr);


#endif
