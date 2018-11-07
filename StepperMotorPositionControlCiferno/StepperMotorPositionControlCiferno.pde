// StepperMotorPositionControl
// 10-18-2018
// Jeffrey Ciferno
// Objective: 
//   ============================================================================
// Program for Stepper Motor Position Control using A/D Input (POT)
// Functional Description:
// ======================
// 1. Read POT input, scale to stepper motor command position:
//      command_position = sensorValue / 10;
// 2. Stepper Motor Position Control logic moves the stepper motor to the command position
// 3. Speed Control:
// 3.1. Reflect Speed Control(SW4) to LD4
// 3.2. Timing Control (SW4) input:
// 3.2.1 When in Development mode (SW4 == 0): motorTime = 250 (ms)
// 3.2.2 When in Real mode (SW4 == 1): motorTime = 20 (ms)
// 4. Display Command & Actual Motor Positions @ OLED
//   ============================================================================
//   Basic Stepper Motor Control Logic:
//   ============================================================================
//	Stepper Motor Driver keep track of indexM pointing to stepper Motor Drive Table:
//			IndexM	D3 D2 D1 D0  Hex Value
//			=====	== == == ==  =========
//			 0       0  0  0  1      1
//			 1       0  1  0  0      4
//	   	 	 2       0  0  1  0      2
//			 3	 1  0  0  0      8
//  * Wraps around logic is provided by : indexM = indexM & 3
//  * To move clockwise, indexM = indexM + 1
//  * To move counter clockwise, indexM = indexM - 1
//   ----------------------------------------
//   I/O Assignments:
//   ==========================================================================
//   SW4: Timing Control (SW4 = 0: Development, SW4=1: Real)
//   LD4: SW4 Indicator
//   Simulation:
//   LD5: Motor Coil D0
//   LD6: Motor Coil D1
//   LD7: Motor Coil D2
//   LD8: Motor Coil D3
//   Physical Motor Drive:
//   MotorCoil_0 : pin0
//   MotorCoil_1 : pin1
//   MotorCoil_2 : pin2
//   MotorCoil_3 : pin3
//   ============================================================================
// Tasks:
// 1. Review Stepper Motor Position Control Flow Chart
// 2. Create code based on Control Flow Chart 
// 3. Verify your code works as prescribed
// 4. Verify at System Bench Test with Laser pointer Assembly
//   =============================================================================
#include <IOShieldOled.h>
// set pin numbers:
const int BTN1 = 4;     // the number of the pushbutton pin
const int BTN2 = 78;    //***** Note: label on the board is for Uno32, this is MAX32, see MAX32 Reference Manual
const int ledPin =  13;      // System Operational LED
const int LD1 =  70;     //***** Note: label on the board is for Uno32, this is MAX32, see MAX32 Reference Manual
const int LD2 =  71;     // ******** LD pins are corrected here.
const int LD3 =  72;
const int LD4 =  73;
const int LD5 =  74;
const int LD6 =  75;
const int LD7 =  76;
const int LD8 =  77;
const int SW1 = 2;
const int SW2 = 7;
const int SW3 = 8;
const int SW4 = 79;     //***** Note: label on the I/O board is 35 for uno32 only
// variables:
int BTN1_state = 0;         // variable for reading the pushbutton status
int SW1_state = 0; 
int SW2_state = 0; 
int SW3_state = 0; 
int SW4_state = 0; 
int motorTime = 20;   // unit in ms
// Initial Stepper Motor Coil pattern
int indexM =0;
int step_max = 102;
int motor_step = 0;
int sensorPin = A0;    // select the input pin for the potentiometer
int command_position = 0;
int sensorValue = 0;  // variable to store the value coming from the sensor
int display_refresh=0;
String displayString;
char displayCharArray[50];
// Note: for 10-bit A/D, the range of sensorValue = 0 to 1023

void setup() {
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);  
  pinMode(LD1, OUTPUT);  
  pinMode(LD2, OUTPUT);    
  pinMode(LD3, OUTPUT);  
  pinMode(LD4, OUTPUT);     
  pinMode(LD5, OUTPUT);  
  pinMode(LD6, OUTPUT);    
  pinMode(LD7, OUTPUT);  
  pinMode(LD8, OUTPUT);     
  // initialize the pushbutton pin as an input:
  pinMode(BTN1, INPUT);  
  // initialize switches as inputs:
  pinMode(SW1, INPUT);  
  pinMode(SW2, INPUT);
  pinMode(SW3, INPUT);
  pinMode(SW4, INPUT); 
  // Turn OFF all LEDs
  digitalWrite(LD1, LOW); 
  digitalWrite(LD2, LOW); 
  digitalWrite(LD3, LOW); 
  digitalWrite(LD4, LOW);  
  	// Initial Stepper Motor Coil pattern
  digitalWrite(LD5, LOW); 
  digitalWrite(LD6, LOW); 
  digitalWrite(LD7, LOW); 
  digitalWrite(LD8, LOW); 
	// Initialize OLED:
	IOShieldOled.begin();
	IOShieldOled.displayOn();
}  // end setup()

void loop() {
  
  IOShieldOled.updateDisplay(); 
  // System Operation LED ON:
     digitalWrite(ledPin, HIGH); 
  //----------------------------------------------  
  // read switches inputs:
  SW4_state = digitalRead(SW4); 
  // Echo switches to LED Indicators:
  if (SW4_state == HIGH) {digitalWrite(LD4, HIGH);  }
  if (SW4_state == LOW) {digitalWrite(LD4, LOW);  }  
	// read the value from the POT sensor:
	sensorValue = analogRead(sensorPin);
        // Scale command_position:
        command_position = sensorValue/10;
//============ Stepper Motor Position Control Logic: =======
  if (command_position > motor_step)
  {
   motor_step = motor_step + 1;
   indexM = indexM + 1;  
  }
  
  if (command_position < motor_step)
  {
   motor_step = motor_step - 1;
   indexM = indexM - 1; 
  }
//=========== Basic Stepper Motor Driver ========
indexM = indexM & 3;  // wrap-around logic
switch (indexM)
{
case 0:

 digitalWrite(LD5, HIGH); 
 digitalWrite(LD6, LOW); 
 digitalWrite(LD7, LOW); 
 digitalWrite(LD8, LOW); 
	break;

case 1:

 digitalWrite(LD5, LOW); 
 digitalWrite(LD6, LOW); 
 digitalWrite(LD7, HIGH); 
 digitalWrite(LD8, LOW); 
	break;
case 2:
 digitalWrite(LD5, LOW); 
 digitalWrite(LD6, HIGH); 
 digitalWrite(LD7, LOW); 
 digitalWrite(LD8, LOW); 
	break;

case 3:
 digitalWrite(LD5, LOW); 
 digitalWrite(LD6, LOW); 
 digitalWrite(LD7, LOW); 
 digitalWrite(LD8, HIGH); 
 	break;
} // End Switch (indexM)
  //============== OLED Display: =======================
	//clear the display and reset the cursor to zero
	IOShieldOled.clearBuffer();
	IOShieldOled.setCursor(0,0);
        IOShieldOled.putString("PostitionControl");
        IOShieldOled.setCursor(0,1);
        IOShieldOled.putString("==============");
	IOShieldOled.setCursor(0,2);
	//create a string to display the command on the OLED screen
	displayString="Command: ";
	displayString += command_position;
	//convert the string to an array of characters
	displayString.toCharArray(displayCharArray,50);
        //Display it @OLED:
        IOShieldOled.putString(displayCharArray);
        // Display actual motor_step:
	IOShieldOled.setCursor(0,3);
	displayString="Actual : ";
	displayString += motor_step; 
	//convert the string to an array of characters
	displayString.toCharArray(displayCharArray,50);
    	//Display it @ OLED:
	IOShieldOled.putString(displayCharArray);
	IOShieldOled.updateDisplay(); 
  //=====================================================
        // System Operation LED Indicator:
        digitalWrite(ledPin, LOW); 
 // Speed select processing:
if (SW4_state == LOW)   // Development (slow)
  {
  motorTime = 250;   // unit in ms
  } 
if (SW4_state == HIGH)   // Real (fast)
  {
  motorTime = 20;   
  }  
     delay(motorTime);           // wait for motorTime ms  
} // end void loop()
