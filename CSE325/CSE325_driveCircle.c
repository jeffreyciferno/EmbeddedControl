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
 * @file    CSE_325_driveCircle.c
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

/*
 * @brief   Application entry point.
 */
  unsigned int i = 0;
  unsigned int mod = 40000;		//clk @ 2Mhz / 40,000 = 50Hz
  int center = 3010;
  int right = 4100;
  int left = 1900;

//delay function taken from lecture notes
void delay_ms(unsigned short delay_t) {
    SIM->SCGC6 |= (1 << 24); // Clock Enable TPM0
    SIM->SOPT2 |= (0x2 << 24); // Set TPMSRC to OSCERCLK
    TPM0->CONF |= (0x1 << 17); // Stop on Overflow
    TPM0->SC = (0x1 << 7) | (0x07); // Reset Timer Overflow Flag, Set Prescaler 128
    TPM0->MOD = delay_t * 61 + delay_t/2; //

    TPM0->SC |= 0x01 << 3; // Start the clock!

    while(!(TPM0->SC & 0x80)){} // Wait until Overflow Flag
    return;
}
void circle10()
{
	int timeby10 = 60;
	TPM2->CONTROLS[0].CnV = right;		//turn right
	TPM2->CONTROLS[1].CnV = 4000;		//go %10
	for(int i = 0; i < timeby10; i++)
		delay_ms(100);					//wait for circle
	TPM2->CONTROLS[1].CnV = 0;			//turn off motor
	return;
}
void circle20()
{
	int timeby10 = 32;
	TPM2->CONTROLS[0].CnV = right;		//turn right
	TPM2->CONTROLS[1].CnV = 8000;		//go %20
	for(int i = 0; i < timeby10; i++)
		delay_ms(100);					//wait for circle
	TPM2->CONTROLS[1].CnV = 0;			//turn off motor
	return;
}
void square()
{
	int sideby10 = 10;
	int turnby10 = 12;
	//side 1
	TPM2->CONTROLS[0].CnV = center;			//center wheels
	TPM2->CONTROLS[1].CnV = 8000;			//go 5% motor
	for(int i = 0; i < sideby10; i++)
		delay_ms(100);						//wait for side
	TPM2->CONTROLS[1].CnV = 0;				//turn off motor

	//turn 1
	TPM2->CONTROLS[0].CnV = right;			//turn wheels right
	delay_ms(250);							//wait for turn
	TPM2->CONTROLS[1].CnV = 4000;			//go 2.5% motor
	for(int i = 0; i < turnby10; i++)
		delay_ms(100);						//wait for turn
	TPM2->CONTROLS[1].CnV = 0;				//turn off motor
	delay_ms(50);

	//side 2
	TPM2->CONTROLS[0].CnV = center;			//center wheels
	TPM2->CONTROLS[1].CnV = 8000;			//go 5% motor
	for(int i = 0; i < sideby10; i++)
		delay_ms(100);						//wait for side
	TPM2->CONTROLS[1].CnV = 0;				//turn off motor

	//turn 2
	TPM2->CONTROLS[0].CnV = right;			//turn wheels right
	delay_ms(250);							//wait for turn
	TPM2->CONTROLS[1].CnV = 4000;			//go 2.5% motor
	for(int i = 0; i < turnby10; i++)
			delay_ms(100);					//wait for turn
	TPM2->CONTROLS[1].CnV = 0;				//turn off motor
	delay_ms(50);

	//side 3
	TPM2->CONTROLS[0].CnV = center;			//center wheels
	TPM2->CONTROLS[1].CnV = 8000;			//go 5% motor
	for(int i = 0; i < sideby10; i++)
		delay_ms(100);						//wait for side
	TPM2->CONTROLS[1].CnV = 0;				//turn off motor

	//turn 3
	TPM2->CONTROLS[0].CnV = right;			//turn wheels right
	delay_ms(250);							//wait for turn
	TPM2->CONTROLS[1].CnV = 4000;			//go 2.5% motor
	for(int i = 0; i < turnby10; i++)
			delay_ms(100);					//wait for turn
	TPM2->CONTROLS[1].CnV = 0;				//turn off motor
	delay_ms(50);

	//side 4
	TPM2->CONTROLS[0].CnV = center;			//center wheels
	TPM2->CONTROLS[1].CnV = 8000;			//go 5% motor
	for(int i = 0; i < sideby10; i++)
		delay_ms(100);						//wait for side
	TPM2->CONTROLS[1].CnV = 0;				//turn off motor

	//turn 4
		TPM2->CONTROLS[0].CnV = right;			//turn wheels right
		delay_ms(250);							//wait for turn
		TPM2->CONTROLS[1].CnV = 4000;			//go 2.5% motor
		for(int i = 0; i < turnby10; i++)
				delay_ms(100);					//wait for turn
		TPM2->CONTROLS[1].CnV = 0;				//turn off motor
		delay_ms(50);
	//dont need to turn 4 times
}
int main(void) {

  	/* Init board hardware. */
    BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitBootPeripherals();
  	/* Init FSL debug console. */
    BOARD_InitDebugConsole();

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
    //GPIOD->PDOR |= 1 << 3;
    GPIOD->PDOR &= ~(1 << 3);

    TPM2->CONTROLS[0].CnSC |= 2<<2 | 2<<4;  //mode edge PWM
    TPM2->CONTROLS[1].CnSC |= 2<<2 | 2<<4;  //mode edge PWM
    TPM2->SC |= 0x02;   //prescalar set to 4
    TPM2->MOD = mod;  //mod found using equation, resets the timer
    TPM2->CONTROLS[0].CnV = center ;   //duty cycle servo
    TPM2->CONTROLS[1].CnV = 0 ;   //duty cycle motor
    TPM2->SC |= 1 <<3; //starts the clock
    delay_ms(1000);

    circle10();
    circle20();
    //square();
    while(1)
    {

    }
    return 0 ;
}
