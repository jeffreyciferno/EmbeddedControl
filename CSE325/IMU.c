/*
 * IMU.c
 *
 *  Created on: Mar 24, 2020
 *      Authors: Team 21 	Alex Karsay,	Eric Branson,	Jeffery Ciferno
 */


#include "IMU.h"
#include "board.h"
#include "peripherals.h"
#include "pin_mux.h"
#include "clock_config.h"
#include "MKL46Z4.h"
#include "fsl_debug_console.h"

unsigned int dummy = 0;
int i = 0;
char calibration[22] = {};


void initI2C()
{
// Enable Clock Gating for I2C module and Port
	SIM->SCGC4 |= 1 << 7;
	SIM->SCGC5 |= 1 << 11;
// Setup Pin Mode for I2C
	PORTC->PCR[1] &= ~(0x700);		//SCL
	PORTC->PCR[1] |= 0x200;

	PORTC->PCR[2] &= ~(0x700);		//SDA
	PORTC->PCR[2] |= 0x200;
// Write 0 to all I2C registers
	I2C1->A1 &= 0;
	I2C1->F &= 0;
	I2C1->C1 &= 0;
	I2C1->S &= 0;
	I2C1->D &= 0;
	I2C1->C2 &= 0;
	I2C1->RA &= 0;


// Write 0x50 to FLT register (clears all bits)
	I2C1->FLT |= 0x50;

// Clear status flags
	clearStatusFlags();

// Set I2C Divider Register (Choose a clock frequency less than 100 KHz)
	I2C1->F = 0x2E;

// Set bit to enable I2C Module
	I2C1->C1 |= 1 << 7;
}
void clearStatusFlags()
{
// Clear STOPF and Undocumented STARTF bit 4 in Filter Register
	I2C1->FLT = (1 << 6) | (1 << 4);
// Clear ARBL and IICIF bits in Status Register
	I2C1->S = (1 << 4) | (1 << 1);
}
void TCFWait()
{
// Wait for TCF bit to Set in Status Register
	while(!(I2C1->S & (1 << 7)))	dummy++;
}
void IICIFWait()
{
// Wait for IICIF bit to Set in Status Register
	while(!(I2C1->S & (1 << 1)))	dummy++;
}
void SendStart()
{
// Set MST and TX bits in Control 1 Register
	I2C1->C1 |= (1 << 5) | (1 << 4);
}
void RepeatStart()
{
// Set MST, TX and RSTA bits in Control 1 Register
	I2C1->C1 |= (1 << 5) | (1 << 4);
	I2C1->C1 |= (1 << 2);
// Wait 6 cycles ??
	for(int i = 0; i < 5; i++)	dummy++;
}
void SendStop()
{
// Clear MST, TX and TXAK bits in Control 1 Register
	I2C1->C1 &= ~(0x38);		//ones in bits 3, 4, 5
// Wait for BUSY bit to go low in Status Register
	while(I2C1->S & (1 << 5))	dummy++;
}
void clearIICIF()
{
// Clear IICIF bit in Status Register
	I2C1->S |= 1 << 1;
}
_Bool RxAK()
{
// Return 1 if byte has been ACK'd. (See RXAK in Status Register)
	return !(I2C1->S & (1 << 0));
}
_Bool writeByte(char address, char data)
{
	clearStatusFlags();
	TCFWait();
	SendStart();
// TODO: Write Device Address, R/W = 0 to Data Register
	//address is cut and a 0 is shifted in?

	I2C1->D = 0x28 << 1;

	IICIFWait();
	if (!RxAK())
	{
		printf("NO RESPONSE - Address\n");
		SendStop();
		return 0;
	}
	clearIICIF();
// TODO: Write Register address to Data Register

	I2C1->D = address;

	IICIFWait();
	if (!RxAK())
	{
		printf("NO RESPONSE - Register\n");
		SendStop();
		return 0;
	}
	TCFWait();
	clearIICIF();
// Write Data byte to Data Register

	I2C1->D = data;

	IICIFWait();
	if (!RxAK())
	{
		printf("Incorrect ACK - Data\n");
		clearIICIF();
		SendStop();
		return 0;
	}else
	{
		clearIICIF();
		SendStop();
		return 1;
	}
}
_Bool readBlock(char address, char* data, int length)
{

	clearStatusFlags();
	TCFWait();
	SendStart();
	dummy++; // Do something to suppress the warning.
//TODO: Write Device Address, R/W = 0 to Data Register

	I2C1->D = 0x28 << 1;

	IICIFWait();
	if (!RxAK()) {
		printf("NO RESPONSE - Address\n");
		SendStop();
		return 0;
	}
	clearIICIF();
	// Write Register address to Data Register

	I2C1->D = address;

	IICIFWait();
	if (!RxAK()) {
		printf("NO RESPONSE - Register\n");
		SendStop();
		return 0;
	}
	clearIICIF();
	RepeatStart();
	// Write device address again, R/W = 1 to Data Register

	I2C1->D = 0x28 << 1 | 0x1;

	IICIFWait();
	if (!RxAK()) {
		printf("NO RESPONSE - Restart\n");
		SendStop();
		return 0;
	}
	TCFWait();
	clearIICIF();
	// Switch to RX by clearing TX and TXAK bits in Control 1 register

	I2C1->C1 &= ~(0x18);			//bits 3 and 4

	if(length == 1)
	{
		// Set TXAK to NACK in Control 1 - No more data!
		I2C1->C1 |= 1 << 3;
	}
	dummy = I2C1->D; // Dummy Read
	for(int i = 0; i < length; i++)
	{
		IICIFWait();
		clearIICIF();
		if(i == length - 2)
		{
			// Set TXAK to NACK in Control 1 - No more data!
			I2C1->C1 |= 1 << 3;
		}
		if(i == length - 1)
		{
			SendStop();
		}
		// Read Byte from Data Register into Array
		data[i] = I2C1->D;
	}

	clearIICIF();
	return 1;
}

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
void initIMU()
{
	initI2C();
	//Reset IMU
	SIM->SCGC5 |= 1 << 10;
	PORTB->PCR[20] &= ~(0x700);
	PORTB->PCR[20] |= 0x100;
	GPIOB->PDDR |= 1 << 20;
	GPIOB->PDOR &= ~(1 << 20);
	//wait 1 second
	delay_ms(1000);
	GPIOB->PDOR |= 1 << 20;
	//wait 1 second
	delay_ms(1000);
	//Set Config Mode
	if(!writeByte(0x3D, 0x00))
		printf("Failed to Change Mode to CONFIG\n");
	else
		delay_ms(100);
	//Reset Page
	if(!writeByte(0x07, 0x00))
		printf("Failed to Reset Page");

	//Set Normal Power Mode
	if(!writeByte(0x3E, 0x00))
		printf("Failed to Change Power Mode to NORMAL\n");
	else
		delay_ms(100);
	//Set NDOF Mode
	if(!writeByte(0x3D, 0x0C))
		printf("Failed to Change Mode to NDOF\n");
	else
		delay_ms(100);
	//Read Chip ID, 0xA0
	char chipID = 0x00;
	if(!readBlock(0x00, &chipID, 1))
		printf("Failed to read ChipID\n");

	if(chipID == 0xA0)
		printf("ChipID Verified\n");
	else
	{
		printf("ChipID not verified error\n");
		return;
	}

}
void enableSW1Interrupt()
{
	//enable SW1
  	SIM->SCGC5 |= (1<<11);  // Enable Port C Clock
  	PORTC->PCR[3] &= 0xF0703; // Clear First
  	PORTC->PCR[3] |= 0xF0703 & ((1 << 8) | 0x3 | 0xA << 16); // Set MUX bits, enable pullups, enable interrupt on falling edge
  	GPIOC->PDDR &= ~(1 << 3); // Setup Pin 3 Port C as input
	NVIC_EnableIRQ(31);					//PORTC PORTD interrupt
}
void calibrateIMU()
{
	//Read Calibration Status Wait for all to be 3
	printf("Calibration begin...\n");
	char calibStat = 0x00;
	while(calibStat != 0xFF)
	{
		readBlock(0x35, &calibStat, 1);
		printf("Status: %d, Gyro: %d, Acc: %d, Mag: %d\n", (calibStat & 0xC0) >> 6, (calibStat & 0x30) >> 4, (calibStat & 0x0C) >> 2, calibStat & 0x03);
		delay_ms(250);
	}
	//write values into calibration
	if(!writeByte(0x3D, 0x00))
		printf("Failed to Change Mode to CONFIG\n");
	else
		delay_ms(100);

	for(i = 0; i < 22; i++)
	{
		if(!readBlock(0x55 + i, &calibration[i], 1))
			printf("Failed to read calibration data\n");
	}
	//Set NDOF Mode
	if(!writeByte(0x3D, 0x0C))
		printf("Failed to Change Mode to NDOF\n");
	else
		delay_ms(100);

	printf("IMU Calibrated and Ready For Use\n");
}
void PORTC_PORTD_IRQHandler(void)
{
	//Set Config Mode
	if(!writeByte(0x3D, 0x00))
		printf("Failed to Change Mode to CONFIG\n");
	else
		delay_ms(100);

	for(i = 0; i < 22; i++)
	{
		if(!readBlock(0x55 + i, &calibration[i], 1))
			printf("Failed to read calibration data\n");
	}
	//Set NDOF Mode
	if(!writeByte(0x3D, 0x0C))
		printf("Failed to Change Mode to NDOF\n");
	else
		delay_ms(100);

	printCalibration();
	PORTC->PCR[3] |= 1 << 24; //clear interrupt flag
}
void printCalibration()
{
	printf("Accelerometer X Offset: 0x%x%x\nAccelerometer Y Offset: 0x%x%x\nAccelerometer Z Offset: 0x%x%x\n\n"
			,calibration[0], calibration[1], calibration[2], calibration[3], calibration[4], calibration[5]);

	printf("Magnetometer X Offset: 0x%x%x\nMagnetometer Y Offset: 0x%x%x\nMagnetometer Z Offset: 0x%x%x\n\n"
			,calibration[6], calibration[7], calibration[8], calibration[9], calibration[10], calibration[11]);

	printf("Gyroscope X Offset: 0x%x%x\nGyroscope Y Offset: 0x%x%x\nGyroscope Z Offset: 0x%x%x\n\n"
			,calibration[12], calibration[13], calibration[14], calibration[15], calibration[16], calibration[17]);

	printf("Accelerometer Radius: 0x%x%x\nMagnetometer Radius: 0x%x%x\n\n"
			, calibration[18], calibration[19], calibration[20], calibration[21]);
}
char* getCalibration()
{
	return calibration;
}
_Bool writeCalibration(char* calibrationCurrent)
{
	//Set Config Mode
	if(!writeByte(0x3D, 0x00))
		printf("Failed to Change Mode to CONFIG\n");
	else
		delay_ms(100);

	for(i = 0; i < 22; i++)
		if(!writeByte(0x55 + i, calibrationCurrent[i]))
		{
			printf("Failed to Write Calibration\n");
			return 0;
		}

	//Set NDOF Mode
	if(!writeByte(0x3D, 0x0C))
		printf("Failed to Change Mode to NDOF\n");
	else
		delay_ms(100);

	printf("Move around until calibrated...\n");
	char calibStat = 0x00;
	while(calibStat != 0xFF)
	{
		readBlock(0x35, &calibStat, 1);
		printf("Status: %d, Gyro: %d, Acc: %d, Mag: %d\n", (calibStat & 0xC0) >> 6, (calibStat & 0x30) >> 4, (calibStat & 0x0C) >> 2, calibStat & 0x03);
		delay_ms(250);
	}

	printf("Successfully wrote calibration...\n");
	return 1;
}

void printEulerVectors()
{

	//set the unit select to degrees
	writeByte(0x3B, 0x00);

	char euler[6] = {};
	for(i = 0; i < 6; i++)
	{
		if(!readBlock(0x1A + i, &euler[i], 1))
			printf("Failed to read euler values");
	}


	printf("Heading: 0x%x%x\nRoll: 0x%x%x\nPitch: 0x%x%x\n", euler[0], euler[1], euler[2], euler[3], euler[4], euler[5]);

}

