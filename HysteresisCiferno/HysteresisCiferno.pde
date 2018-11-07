// Hysteresis
// 10-19-2018
//Jeffrey Ciferno
// Status: Hysteresis created for Max32 + Basic I/O board
// Objective: 
// =========
// Demonstrate Temperature Control with Hysteresis
// System I/O
// ==========
// Inputs:
// ------
//    A0: Temperature Sensor
// Outputs:
// --------
//    LD1: AC Control
//    LD2: Heater Control
//    LD8: System Run Indicator
//==================================================================
// Functional Description:
// ======================
// 1. Read POT input, scale to temperature in Fahrenheit:
//      degree_F = sensorValue / 10;
// 2. Display Temperature @ OLED
// 3. Temperature Control Logics:
// 3.1 Heating Logic:
//     * As temperature cools off: < 60 DegF, Turn Heater (LD2) ON
//     * As temperature increases: > 65 DegF, Turn Heater (LD2) OFF
// 3.2 Cooling Logic:
//     * As temperature increases: > 85 DegF, Turn AC (LD1) ON
//     * As temperature decreases: < 80 DegF, Turn AC (LD1) OFF
//==================================================================
// Tasks:
// ======
// 1. Review Concept of Hysteresis
// 2. Read & verify Heating Logic is working (without your additional codes) 
// 3. Add Cooling logics (Requirement 3.2) 
// 4. Verify your codes work as prescribed
// 5. Submit Optical report to Coach
//=============================================================================
#include <IOShieldOled.h>

// set pin numbers:
const int BTN1 = 4;     // the number of the pushbutton pin
const int BTN2 = 78;    //***** Note: label on the board is for Uno32, this is MAX32, see MAX32 Reference Manual
const int ledPin =  13;     
const int LD1 =  70;     //***** Note: label on the board is for Uno32, this is MAX32, see MAX32 Reference Manual
const int LD2 =  71;     // ******** LD pins are corrected here.
const int LD3 =  72;
const int LD4 =  73;
const int LD5 =  74;
const int LD6 =  75;
const int LD7 =  76;
const int LD8 =  77;	 // System Operational LED
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
int sensorPin = A0;    // select the input pin for the potentiometer
int sensorValue = 0;  // variable to store the value coming from the sensor
// Note: for 10-bit A/D, the range of sensorValue = 0 to 1023
int degreeF = 0;
int state = 0;
int display_refresh=0;
String displayString;
char displayCharArray[50];

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
  // initialize state:
	state = 0;    // ***
  // Turn OFF all LEDs
 digitalWrite(LD1, LOW); 
 digitalWrite(LD2, LOW); 
 digitalWrite(LD3, LOW); 
 digitalWrite(LD4, LOW);  
 digitalWrite(LD5, LOW); 
 digitalWrite(LD6, LOW); 
 digitalWrite(LD7, LOW); 
 digitalWrite(LD8, LOW); 
  // Initialize OLED:
	IOShieldOled.begin();
	IOShieldOled.displayOn();
}  // end setup()

void loop() {
  // System Operation LED ON:
     digitalWrite(LD8, HIGH);
     delay(250);           // wait for 250 ms 
  //----------------------------------------------  
  
// 1. Read POT input, scale to temperature in Fahrenheit:
// -------------------------------------------------------------
	// read the value from the POT sensor:
	sensorValue = analogRead(sensorPin);
        // Scale temperature in Fahrenheit:
        degreeF = sensorValue/10;
// 2. Display Temperature @ OLED:
// -------------------------------------
	IOShieldOled.updateDisplay(); 
	//clear the display and reset the cursor to zero
	IOShieldOled.clearBuffer();
	IOShieldOled.setCursor(0,0);
        IOShieldOled.putString("Ciferno-Hysteresis");
        IOShieldOled.setCursor(0,1);
        IOShieldOled.putString("==================");
	IOShieldOled.setCursor(0,2);
	//create a string to display the temperature on the OLED screen
	displayString="Temp(F): ";
	displayString += degreeF;
	//convert the string to an array of characters
	displayString.toCharArray(displayCharArray,50);
        //Display it @OLED:
        IOShieldOled.putString(displayCharArray);
        // Display Date & Initial:
	IOShieldOled.setCursor(0,3);
	displayString="10-19";
	//convert the string to an array of characters
	displayString.toCharArray(displayCharArray,50);
    	//Display it @ OLED:
	IOShieldOled.putString(displayCharArray);
	IOShieldOled.updateDisplay(); 
// Requirement 3.1: Heating Logic
//-------------------------------------------
      if (degreeF < 60) {digitalWrite(LD2, HIGH);}
      if (degreeF > 65) {digitalWrite(LD2, LOW);}
// Requirement 3.2: Cooling Logic
//-------------------------------------------
      if (degreeF > 85) {digitalWrite(LD1, HIGH);}
      if (degreeF < 80) {digitalWrite(LD1, LOW);}
//-------------------------------------------
// System Operation LED Indicator:
     digitalWrite(LD8, LOW);  
     delay(250);           // wait for 250 ms  
} // end void loop()


