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
 * @file    MKL46Z256xxx4_Project.c
 * @brief   Application entry point.
 */
#include <stdio.h>
#include "board.h"
#include "peripherals.h"
#include "pin_mux.h"
#include "clock_config.h"
#include "MKL46Z4.h"
#include "fsl_debug_console.h"
/* TODO: insert other include files here. */

/* TODO: insert other definitions and declarations here. */

/*
 * @brief   Application entry point.
 */
 void displayMorse(char *message, int length)
    {
    	for (int i=0; i < length; message++)
    	{
    		if (*message == 'A')
    		{
    			dot();
    			dash();
    			delay(5000000);			//LETTER DELAY
    		}

    		if (*message == "B")
    		{
    			dash();
    			dot();
    			dot();
    			dot();
    			delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "C")
    		{
    			dash();
    			dot();
    			dash();
    			dot();
    		    delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "D")
    		{
    			dash();
    			dot();
    			dot();
    			delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "E")
    		{
    			dot();
    			delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "F")
    		{
    			dot();
    			dot();
    			dash();
    			dot();
                delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "G")
    		{
    			dash();
    			dash();
    			dot();
    			delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "H")
    		{
    			dot();
    			dot();
    		    dot();
    			dot();
    			delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "I")
    		{
    			dot();
    			dot();
    			delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "J")
    		{
    			dot();
    			dash();
				dash();
				dash();
    			delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "K")
    		{
    			dash();
    			dot();
    			dash();
    			delay(750);			//LETTER DELAY
    		}

    		else if (*message == "L")
    		{
    			dot();
    			dash();
    			dot();
    			dot();
    			delay(5000000);			//LETTER DELAY
    		}

    		else if (*message == "M")
    		{
    		    dash();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "N")
    		{
    		    dash();
    		    dot();
    		    delay(5000000);
    		}

    		else if (*message == "O")
    		{
    		    dash();
				dash();
				dash();
				delay(5000000);
    		}

    		else if (*message == "P")
    		{
    		    dot();
    		    dash();
    		    dash();
    		    dot();
    		    delay(5000000);
    		}

    		else if (*message == "Q")
    		{
    		    dash();
    		    dash();
    		    dot();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "R")
    		{
    		    dot();
    		    dash();
    		    dot();
    		    delay(5000000);
    		}

    		else if (*message == "S")
    		{
    		    dot();
    		    dot();
    		    dot();
    		    delay(5000000);
    		}

    		else if (*message == "T")
    		{
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "U")
    		{
    		    dot();
    		    dot();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "V")
    		{
    		    dot();
    		    dot();
    		    dot();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "W")
    		{
    			dot();
    			dash();
    			dash();
    			delay(750);
    		}

    		else if (*message == "X")
    		{
    		    dash();
    		    dot();
    		    dot();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "Y")
    		{
    		    dash();
    		    dot();
    		    dash();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "Z")
    		{
    		    dash();
    		    dash();
    		    dot();
    		    dot();
    		    delay(5000000);
    		}

    		else if (*message == "0")
    		{
    		    dash();
    		    dash();
    		    dash();
    		    dash();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "1")
    		{
    			dot();
    			dash();
    			dash();
    			dash();
    			dash();
    			delay(5000000);
    		}

    		else if (*message == "2")
    		{
    		    dot();
    		    dot();
    		    dash();
    		    dash();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "3")
    		{
    		    dot();
    		    dot();
    		    dot();
    		    dash();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "4")
    		{
    		    dot();
    		    dot();
    		    dot();
    		    dot();
    		    dash();
    		    delay(5000000);
    		}

    		else if (*message == "5")
    		{
    		    dot();
    		    dot();
    		    dot();
    		    dot();
    		    dot();
    		    delay(5000000);
    		}

    		else if (*message == "6")
    		{
    		    dash();
    		    dot();
    		    dot();
    		    dot();
    		    dot();
    		    delay(5000000);
    		}

    		else if (*message == "7")
    		{
    		   dash();
    		   dash();
    		   dot();
    		   dot();
    		   dot();
    		   delay(5000000);
    		}

    		else if (*message == "8")
    		{
    		  dash();
    		  dash();
    		  dash();
    		  dot();
    		  dot();
    		  delay(5000000);
    		}

    		else if (*message == "9")
    		{
    		  dash();
    		  dash();
    		  dash();
    		  dash();
    		  dot();
    		  delay(5000000);
    		}
    		else if (message[i] == " ")
    		{
    		  delay(2500000);
    		}
    	}
    }

 void delay(unsigned int n)
    {
    	unsigned int i = 0;
    	unsigned int j;

    	for(i=0; i<n; i++)
    	{
    		j++;
    	}
    }

    void dot()
    {
    	GPIOD->PTOR |= (1<<5);
    	delay(2500000);				//DOT
    	GPIOD->PTOR &= ~(1<<5);
    	delay(2500000);
    }

    void dash()
    {
    	GPIOD->PTOR |= (1<<5);
    	delay(7500000);				//DASH
    	GPIOD->PTOR &= ~(1<<5);
    	delay(2500000);
    }

int main(void) {

  	/* Init board hardware. */
    BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitBootPeripherals();
  	/* Init FSL debug console. */
    BOARD_InitDebugConsole();

    SIM->SCGC5 |= 1<<12;

    PORTD->PCR[5] &= ~0x700;

    PORTD->PCR[5] |= 0x700 & (1 << 8);

    GPIOD->PDDR |= (1 << 5);

    			//TEST PHRASE
        	    char * message ="ABC";
        	    int this = 9;
        	    //TEST ATTEMPT
        	    displayMorse(message, this);

    /* Force the counter to be placed into memory. */
    volatile static int i = 0 ;
    /* Enter an infinite loop, just incrementing a counter. */
    while(1) {
        i++ ;
        /* 'Dummy' NOP to allow source level single stepping of
            tight while() loop */
        __asm volatile ("nop");
    }
    return 0 ;
}
