// POTVendingMachine
// 10/11/18
// Jeffrey Ciferno
// Status: Operations verified
// Objective: 
// ======================
// Provide a functional vending machine based on temperature from POT control 
// Functional Description:
// ======================
// 1. Read POT input, scale to temperature in Fahrenheit:
//      degree_F = sensorValue / 10;
// 2. Display Temperature @ OLED
// 3. Vending Machine logics:
// Inputs:
// ------
//    A0: Temperature Sensor
// Outputs:
// --------
//    LD1: State Indicator (bit 0) (for visual feedback / troubleshooting)
//    LD2: State Indicator (bit 1) (for visual feedback / troubleshooting)
//    LD3: Serve Vodka
//    LD4: Serve Coffee
//    LD5: Serve Beer
//    LD6: serve Water
//    LD7: spare / not used
//    LD8: System Run Indicator
// State Assignments:
// ------------------
//        state = 0 (Cold) :Temperature range: 0 - 32 F	
//        state = 1 (Cool) :Temperature range: 33 - 60 F	
//        state = 2 (Warm) :Temperature range: 61 - 90 F	
//        state = 3 (Hot)  :Temperature range: > 90 F   	
//
// State Machine Functional Descriptions:
// -------------------------------------
//        state = 0 (Cold) :Temperature range: 0 - 32 F	
//		Outputs: Vodka =1, Coffee = 0, Beer = 0, Water = 0
//			state indicators: LD1 =0, LD2 = 0
//		Transitions: when temp >32, state = 1
//
//        state = 1 (Cool) :Temperature range: 33 - 60 F	
//		Outputs: Vodka =0, Coffee = 1, Beer = 0, Water = 0
//			state indicators: LD1 =1, LD2 = 0
//		Transitions: 
//			* when temp <32, state = 0
//			* when temp >60, state = 2
//
//        state = 2 (Warm) :Temperature range: 61 - 90 F	
//		Outputs: Vodka =0, Coffee = 0, Beer = 1, Water = 0
//			state indicators: LD1 =0, LD2 = 1
//		Transitions: 
//			* when temp <61, state = 1
//			* when temp >90, state = 3
//
//        state = 3 (Hot) :Temperature range: > 90 F	
//		Outputs: Vodka =0, Coffee = 0, Beer = 0, Water = 1
//			state indicators: LD1 =1, LD2 = 1
//		Transitions: 
//			* when temp <90, state = 2
//=============================================================================
// Tasks:
// 1. Construct State Diagram
// 2. Design / draw Control Flow Chart based on State Diagram
// 3. Read & verify fucntional requirements 
// 4. Add state logic
// 5. Verify your code works as prescribed
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
 
// 1. (Given) Read POT input, scale to temperature in Fahrenheit:
// -------------------------------------------------------------
	// read the value from the POT sensor:
	sensorValue = analogRead(sensorPin);

        // Scale temperature in Fahrenheit:
        degreeF = sensorValue/10;

// 2. (Given) Display Temperature @ OLED:
// -------------------------------------
	IOShieldOled.updateDisplay(); 
	//clear the display and reset the cursor to zero
	IOShieldOled.clearBuffer();
	IOShieldOled.setCursor(0,0);
        IOShieldOled.putString("POTVendingMachine");
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
	displayString="10-11-18/Jeffrey";
	//convert the string to an array of characters
	displayString.toCharArray(displayCharArray,50);
    	//Display it @ OLED:
	IOShieldOled.putString(displayCharArray);
	IOShieldOled.updateDisplay(); 
// State Machine Logics:
//----------------------
	switch (state)
{
case 0:
	// Outputs:
     		digitalWrite(LD3, HIGH);   //Vodka = 1
     		digitalWrite(LD4, LOW);   //Coffee = 0
     		digitalWrite(LD5, LOW);   //Beer = 0
     		digitalWrite(LD6, LOW);   //Water = 0

		// state indicators (for visual feedback & troubleshooting):
     		digitalWrite(LD1, LOW);   //state bit 0 = 0
     		digitalWrite(LD2, LOW);   //state bit 1 = 0

	// Transitions:
		if (degreeF >32) {state = 1;}
	break;  // end case 0

case 1:
	// Outputs:
     		digitalWrite(LD3, LOW);   //Vodka = 0
     		digitalWrite(LD4, HIGH);   //Coffee = 1
     		digitalWrite(LD5, LOW);   //Beer = 0
     		digitalWrite(LD6, LOW);   //Water = 0

		// state indicators (for visual feedback & troubleshooting):
     		digitalWrite(LD1, HIGH);   //state bit 0 = 1 
     		digitalWrite(LD2, LOW);   //state bit 1  = 0

	// Transitions:
		if (degreeF >60) {state = 2;}
		if (degreeF <33) {state = 0;}
	break; // end case 1

case 2:

// Outputs:
     		digitalWrite(LD3, LOW);   //Vodka = 0
     		digitalWrite(LD4, LOW);   //Coffee = 0
     		digitalWrite(LD5, HIGH);   //Beer = 1
     		digitalWrite(LD6, LOW);   //Water = 0

		// state indicators (for visual feedback & troubleshooting):
     		digitalWrite(LD1, LOW);   //state bit 0 = 0 
     		digitalWrite(LD2, HIGH);   //state bit 1  = 1

	// Transitions:
		if (degreeF >90) {state = 3;}
		if (degreeF <61) {state = 1;}

	break; // end case 2

case 3:

// Outputs:
     		digitalWrite(LD3, LOW);   //Vodka = 0
     		digitalWrite(LD4, LOW);   //Coffee = 0
     		digitalWrite(LD5, LOW);   //Beer = 0
     		digitalWrite(LD6, HIGH);   //Water = 1

		// state indicators (for visual feedback & troubleshooting):
     		digitalWrite(LD1, HIGH);   //state bit 0 = 1 
     		digitalWrite(LD2, HIGH);   //state bit 1  = 1

	// Transitions:
		if (degreeF <91) {state = 2;}
		
	break; // end case 3


} // end switch (state)
 //----------------------------------------
   // System Operation LED Indicator:
     digitalWrite(LD8, LOW);  
     delay(250);           // wait for 250 ms  
     
} // end void loop()

