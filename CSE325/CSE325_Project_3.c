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
 * @file    CSE_325_Project_3.c
 * @brief   Application entry point.
 * @authors Alex Karsay, Eric Branson, Jeffery Ciferno
 * @team  	21
 */

#include <stdio.h>
#include "board.h"
#include "peripherals.h"
#include "pin_mux.h"
#include "clock_config.h"
#include "MKL46Z4.h"
#include "fsl_debug_console.h"

  unsigned int mod = 40000;		//clk @ 2Mhz / 40,000 = 50Hz
  //values for servo
  int center = 3040;
  int right = 4100;
  int left = 1900;
  //values for encoder
  volatile unsigned int distanceTotal = 0;		//distance is number of ticks, 1 tick ~ 9.4247 mm
  volatile unsigned int distanceTimed = 0;		//distance is number of ticks, 1 tick ~ 9.4247 mm
  volatile unsigned int timeNow = 0;			//measured in milliseconds
  volatile unsigned int velocityCurrent = 0;	//measured in mm/s
  volatile unsigned int velocitySet = 0;		//measured in mm/s

//used to count milliseconds
  void TPM0_IRQHandler(void)
  {
	  TPM0->SC |= (1 << 7); // Reset Timer Interrupt Flag
	  timeNow++;
  }

  void PORTC_PORTD_IRQHandler(void)
  {
	  PORTD->PCR[2] |= 1 << 24; //clear interrupt flag
	  GPIOD->PTOR |= (1 << 5);	//toggles green led used for debugging
	  distanceTotal++;
	  distanceTimed++;
  }

  // Setup SW1
  void setup_SW1()
  {
  	SIM->SCGC5 |= (1<<11);  // Enable Port C Clock
  	PORTC->PCR[3] &= 0xF0703; // Clear First
  	PORTC->PCR[3] |= 0xF0703 & ((1 << 8) | 0x3 ); // Set MUX bits, enable pullups
  	GPIOC->PDDR &= ~(1 << 3); // Setup Pin 3 Port C as input
  }

  //code is taken from sonar.c example and tweaked slightly
  void setup_timer()
  {
  	SIM->SCGC6 |= (1 << 24); // Clock enable TPM0
  	SIM->SOPT2 |= (0x2 << 24); // TPM Clock Source OSCERCLK
  	TPM0->MOD = 7999; // Reload every millisecond
  	TPM0->CONF |= 1 << 6 | 1 << 7;		//configure for debug
  	NVIC_EnableIRQ(17);
  	// Reset TOF, Enable Interrupt, Prescaler = 0, Start Timer
  	TPM0->SC = (1 << 7) | (1 << 6) | (1 << 3);
  }

  void setup_encoder_interrupt()
  {
	  SIM->SCGC5 |= 1 << 12;				//turn on clock for encoder input
	  PORTD->PCR[2] &= ~0xF0703;			//mask bits
	  PORTD->PCR[2] |= 0xF0703 & ((0xB << 16) | (1 << 8)); //sets MUX bits, interrupt on both edges
	  GPIOD->PDDR &= ~(1 << 2);				//set as input

	  NVIC_EnableIRQ(31);					//PORTC PORTD interrupt
  }

  //used when we were debugging
  void setup_LED1()
  {
	  SIM->SCGC5 |= 1 << 12;
	  PORTD->PCR[5] &= ~(0x700);
	  PORTD->PCR[5] |= 0x700 & (1 <<8);
	  GPIOD->PDDR |= (1 << 5);
  }

  void setup_motors()
  {
	  //enable PORTB and PORTD
	  SIM->SCGC5 |= 1 << 10 | 1 << 12;
	  //enable TMP2
	  SIM->SCGC6 |= 1 << 26;
	  //set src for TMP
	  SIM->SOPT2 |= 0x2<<24;
	  //alt 3 select TMP2
	  PORTB->PCR[2] &= ~(0x700);
	  PORTB->PCR[2] |= 0x300;
	  PORTB->PCR[3] &= ~(0x700);
	  PORTB->PCR[3] |= 0x300;

	  PORTD->PCR[3] &= ~(0x700);
	  PORTD->PCR[3] |= 0x100;

	  GPIOD->PDDR |= 1 << 3;
	  //sets motor direction
	  GPIOD->PDOR &= ~(1 << 3);

	  TPM2->CONTROLS[0].CnSC |= 2<<2 | 2<<4;  //mode edge PWM
	  TPM2->CONTROLS[1].CnSC |= 2<<2 | 2<<4;  //mode edge PWM
	  TPM2->SC |= 0x02;   //prescalar set to 4
	  TPM2->MOD = mod;  //mod found using equation, resets the timer
	  TPM2->CONTROLS[0].CnV = center ;   //duty cycle servo
	  TPM2->CONTROLS[1].CnV = 0 ;   //duty cycle motor
	  TPM2->CONF |= 1 << 6 | 1 << 7; 	//configure for debug mode
	  TPM2->SC |= 1 <<3; //starts the clock
  }

int main(void) {

  	/* Init board hardware. */
    BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitBootPeripherals();
  	/* Init FSL debug console. */
    BOARD_InitDebugConsole();

    setup_motors();
    setup_LED1();
    setup_encoder_interrupt();
    setup_timer();
    setup_SW1();

    //wait for button press
    while(GPIOC->PDIR & (1<<3))
    {
    	//used during debugging
//    	if(timeNow % 100 == 0)
//    	{
//    		velocityCurrent = (distanceTimed * 9.4247) * 20;		//velocity in mm/s
//    		printf("%u, %u, %u\n",velocityCurrent, distanceTotal, distanceTimed);
//    		distanceTimed = 0;
//    	}
    }
    int notStopFlag = 1;			//bool flag for stopping
    int distanceGO = 1070;			//aprox 10 meters
    int period = 80;				//number of milliseconds to wait for precision
    //variables used for PI controller
    int level = 0;
    int motorValue = 0;
    int error = 0;
    int accumError = 0;
    float Kp = 1.75;
    float Ki = 1.2;
    velocitySet = 1250;			//in mm/s ~= 1.25 m/s
    while(1)
    {
    	while(distanceTotal < distanceGO - 72)			//72 is variable to allow for rolling
    	{
        	if(timeNow % period == 0)
        	{
        		velocityCurrent = ((float)distanceTimed * 9.4247) / ((float)period / 1000);		//velocity = distance(mm) / time (s)
        		distanceTimed = 0; // reset distance interval to allow for new counts
        		error = velocitySet - velocityCurrent;
        		accumError += error;
        		level = Kp * error + Ki * accumError;
        		motorValue += level;
        		if(motorValue <= 0)				//cannot write negative values to CnV
        			TPM2->CONTROLS[1].CnV = 0;
        		else if(motorValue > mod * 0.2)		//cannot go above 20%
        			TPM2->CONTROLS[1].CnV = mod * 0.2;
        		else
        			TPM2->CONTROLS[1].CnV = motorValue;

        		printf("%u %i\n",velocityCurrent, error);
        	}
    	}
    	if(notStopFlag)
    	{
    		  //flip direction
    		  GPIOD->PDOR |= 1 << 3;
    		  TPM2->CONTROLS[1].CnV = mod;
    		  unsigned int timeGet = timeNow;
    		  //wait 60 milliseconds
    		  while(timeNow < timeGet + 60);
    		  //make sure the motor is turned off
    		  for(int i = 0; i < 50; i++)
    			  TPM2->CONTROLS[1].CnV = 0;
    		  //change states
    		  notStopFlag = 0;
    	}

    }
    return 0 ;
}
