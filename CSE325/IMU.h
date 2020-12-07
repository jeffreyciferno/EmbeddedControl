/*
 * IMU.h
 *
 *  Created on: Mar 27, 2020
 *      Authors: Team 21 	Alex Karsay,	Eric Branson,	Jeffery Ciferno
 */

#ifndef IMU_H_
#define IMU_H_
//initializes the I2C interface for the board
void initI2C(void);
//clears all the I2C status flags
void clearStatusFlags(void);
//waits for the TCF flag I2C module
void TCFWait(void);
//waits for the IICIF flag I2C
void IICIFWait(void);
//Send a start bit message over I2C
void SendStart(void);
//Repeat a start message used if first fails over I2C
void RepeatStart(void);
//Send a stop bit message over I2C
void SendStop(void);
//clear the IICIF flag I2C
void clearIICIF(void);
//return if there was an acknowledge sent I2C
_Bool RxAK(void);
//Used to write one byte to slave address
//returns if successful or not
_Bool writeByte(char address, char data);
//Used to read blocks of bytes from IMU since address is incremented
//returns if successful read or not
_Bool readBlock(char address, char* data, int length);
//delay function using TPM0
void delay_ms(unsigned short delay_t);
//used to initialize the IMU
void initIMU(void);
//enables SW1 interrupts that are used to print the calibration values
//to stdout and save them in global variable calibration
void enableSW1Interrupt(void);
//runs through the calibration routine
//returns when calibration is complete
void calibrateIMU(void);
//print the calibration values
void printCalibration(void);
//returns the calibration data array
//used to save calibration values for later use
char* getCalibration(void);
//used to write to the calibration registers provided a
//calibration array of size 22, after being written too
//IMU will need to polish of the calibration so calibration routine is
//run again, however much less time is needed to finish routine
_Bool writeCalibration(char* calibrationCurrent);
//prints the heading, roll and pitch to stdout
void printEulerVectors(void);

#endif /* IMU_H_ */
