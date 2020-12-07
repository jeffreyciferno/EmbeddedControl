/*
 * Copyright 2016-2020 NXP
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * o Redistributions of source code must retain the above copyright notice, this list
 *   of conditions and the following disclaimer.
 *
 * o Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 *
 * o Neither the name of NXP Semiconductor, Inc. nor the names of its
 *   contributors may be used to endorse or promote products derived from this
 *   software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
/**
 * @file    Project_5_GAMETIME.c
 * @brief   Application entry point.
 */
#include <stdio.h>
#include "board.h"
#include "peripherals.h"
#include "pin_mux.h"
#include "clock_config.h"
#include "MKL46Z4.h"
#include "fsl_debug_console.h"

#include "lcd_shield.h"
#include "timer.h"

unsigned int dummy = 0;
float distance = 0.0;
float height = 0.0;
float maxHeight = 0.0;
float bottomDistance = 71.5;

void initPins()
{
	//enable C1 and C2
	SIM->SCGC5 |= (1 << 11) | (1 << 13);
	PORTC->PCR[2] &= ~0x700;
	PORTC->PCR[1] &= ~0xF0703;

	PORTC->PCR[2] |= 0x700 & (1 << 8);
	PORTC->PCR[1] |= 0xF0703 & ((0xB << 16) | (1 << 8));	//sets MUX bits, interrupt on both edges

	GPIOC->PDDR |= (1 << 2);		//C2 is input for PULSE
	GPIOC->PDDR &= ~(1 << 1);			//C1 is output for ECHO

	GPIOC->PDOR &= ~(1 << 2);		//clear C2
}
void enableSW1()
{
	//enable SW1
  	SIM->SCGC5 |= (1<<11);  // Enable Port C Clock
  	PORTC->PCR[3] &= 0xF0703; // Clear First
  	PORTC->PCR[3] |= 0xF0703 & ((1 << 8) | 0x3); // Set MUX bits, enable pullups
  	GPIOC->PDDR &= ~(1 << 3); // Setup Pin 3 Port C as input

}
void initMicrosecondTimer()
{
	SIM->SCGC6 |= 1 << 24;		//enable clock for TPM0
	TPM0->SC |= 0x4; //Prescaler = 16
	TPM0->MOD = 0xFFFF; //Set the MOD to max

	SIM->SOPT2 |= (0x1 << 24); // TPM Clock Source MCGPLL (48Mhz)
	TPM0->CONF |= 0x3 << 6;				//continue counting during debug mode
}
void sendPulse()
{
	//reset microsecond timer

	//enable the microsecond timer

	//set PULSE HIGH for ~10 us
	GPIOC->PDOR |= 1 << 2;		//set high
	delay(1);
	GPIOC->PDOR &= ~(1 << 2);	//set low
}

/*
 * @brief   Application entry point.
 */
int main(void) {

  	/* Init board hardware. */
    BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitBootPeripherals();
  	/* Init FSL debug console. */
    BOARD_InitDebugConsole();

    enableSW1();
    initMillisTimer();
    initMicrosecondTimer();
    initPins();

    lcd_init();
    lcd_clear();
    lcd_print("Cur H: ");
    lcd_setCursor(2, 0);
    lcd_print("Max H: ");
    lcd_setCursor(1, 7);

    while(1)
    {
    	if(!(GPIOC->PDIR & (1 << 3)))
    	{
    		maxHeight = 0.0;
    	}
    	if(millis % 100 == 0)
    	{
    		sendPulse();


    		while(!(GPIOC->PDIR & (1 << 1))) dummy++;
    		TPM0->SC |= 1 << 3;
    		while(GPIOC->PDIR & (1 << 1))
    		{
    			if(TPM0->STATUS & (1 << 8))
    				break;
    			dummy++;
    		}
    		TPM0->SC &= ~(0x3 << 3);

    		delay(1);

    		if(!(TPM0->STATUS & (1 << 8)))
    		{
    			float counter = TPM0->CNT;
    			if(counter < 36000 && counter > 5)
    				distance = (counter / 6) * 0.0343;
    			//PRINTF("Distance: %f\n", distance);
    			height = bottomDistance - distance;
    			lcd_printFloat(height, 2);
    			lcd_setCursor(1, 7);
    			if(height > maxHeight)
    			{
    				lcd_setCursor(2, 7);
    				maxHeight = height;
    				lcd_printFloat(maxHeight, 2);
    				lcd_setCursor(1, 7);
    			}
    		}

    		TPM0->STATUS |= 1 << 8;
    		TPM0->CNT = 0;
    	}
    }
    return 0 ;
}
