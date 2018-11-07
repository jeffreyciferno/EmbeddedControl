// MARSStateMachine
// 10-24-2018
// Jeffrey Ciferno
// Status: Operation of state machine based off of switch input
// Objective: 
// =========
// Provide Starting Template for Simple State Machine
// Functional Description:
// ======================
// 1. Read Switch input, State machine logic:
// 2. Display State @ OLED
// 3. MARS Machine logic:
// Inputs:
// ------
//    SW1: Launch
//    SW2: Disengage Rocket
//    SW3: Ion Thrust Ignition
//    SW4: Landing Jet Ignition
// Outputs:
// -------
//    LD1: State Indicator (bit 0) (for visual feedback / troubleshooting)
//    LD2: State Indicator (bit 1) (for visual feedback / troubleshooting)
//    LD5: Launch Indicator
//    LD6: Disengage Rocket Indicator
//    LD7: Ion Thrust Ignition Indicator
//    LD8: Landing Jet Ignition Indicator
//=============================================================================
// Tasks:
// 1. Construct State Diagram
// 2. Design / draw Control Flow Chart based on State Diagram
// 3. Read & verify this Starter Template is working 
// 4. Add logic
// 5. Verify code
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
}// end setup()

void loop() {

// 1. Display State @ OLED:
// -------------------------------------
	IOShieldOled.updateDisplay(); 
	//clear the display and reset the cursor to zero
	IOShieldOled.clearBuffer();
	IOShieldOled.setCursor(0,0);
        IOShieldOled.putString("MARSStateMachine");
        IOShieldOled.setCursor(0,1);
        IOShieldOled.putString("==================");     
	IOShieldOled.setCursor(0,2);
	//create a string to display the temperature on the OLED screen
	displayString="STATE ";
	displayString += state;
	//convert the string to an array of characters
	displayString.toCharArray(displayCharArray,50);
        //Display it @OLED:
        IOShieldOled.putString(displayCharArray);
        // Display Date & Initial:
	IOShieldOled.setCursor(0,3);
	displayString="10-24/Ciferno";
	//convert the string to an array of characters
	displayString.toCharArray(displayCharArray,50);
    	//Display it @ OLED:
	IOShieldOled.putString(displayCharArray);
	IOShieldOled.updateDisplay(); 
// Echo switches to LED Indicators:
  SW1_state = digitalRead(SW1);
  if (SW1_state == HIGH) {digitalWrite(LD1, HIGH);  }
  SW2_state = digitalRead(SW2);
  if (SW2_state == HIGH) {digitalWrite(LD2, HIGH);  }  
  SW3_state = digitalRead(SW3);
  if (SW3_state == HIGH) {digitalWrite(LD3, HIGH);  }
  SW4_state = digitalRead(SW4);
  if (SW4_state == HIGH) {digitalWrite(LD4, HIGH);  }
  SW1_state = digitalRead(SW1);
  if (SW1_state == LOW) {digitalWrite(LD1, LOW);  }
  SW2_state = digitalRead(SW2);
  if (SW2_state == LOW) {digitalWrite(LD2, LOW);  }
  SW3_state = digitalRead(SW3);
  if (SW3_state == LOW) {digitalWrite(LD3, LOW);  }
  SW4_state = digitalRead(SW4);
  if (SW4_state == LOW) {digitalWrite(LD4, LOW);  } 
  
// State Machine Logics:
//----------------------
	switch (state)
{
case 0:
	// Outputs:
     		digitalWrite(LD5, LOW);   //Launch = 0
     		digitalWrite(LD6, LOW);   //Disengage Rocket = 0
     		digitalWrite(LD7, LOW);   //Ion Thrust Ignition = 0
     		digitalWrite(LD8, LOW);   //Landing Jet Ignition = 0
		// state indicators (for visual feedback & troubleshooting):   
	// Transitions:
		 if (SW1_state == HIGH){state = 1;}
                 if (SW4_state == HIGH){state = 0;}
	break;  // end case 0

case 1:
	// Outputs:
     		digitalWrite(LD5, HIGH);  //Launch = 1
     		digitalWrite(LD6, LOW);   //Disengage Rocket= 0
     		digitalWrite(LD7, LOW);   //Ion Thrust Ignition = 0
     		digitalWrite(LD8, LOW);   //Landing Jet Ignition = 0
		// state indicators (for visual feedback & troubleshooting):
	// Transitions:
		if (SW2_state == LOW){state = 2;}
	break; // end case 1

case 2:

        // Outputs:
     		digitalWrite(LD5, LOW);   //Launch = 0
     		digitalWrite(LD6, HIGH);  //Disengage Rocket = 1
     		digitalWrite(LD7, HIGH);  //Ion Thrust Ignition = 1
     		digitalWrite(LD8, LOW);   //Landing Jet Ignition = 0
		// state indicators (for visual feedback & troubleshooting):
	// Transitions:
		if (SW3_state == HIGH){state = 3;}
	break; // end case 2

case 3:

// Outputs:
     		digitalWrite(LD5, LOW);   //Launch = 0
     		digitalWrite(LD6, LOW);   //Disengage Rocket = 0
     		digitalWrite(LD7, LOW);   //Ion Thrust Ignition = 0
     		digitalWrite(LD8, HIGH);  //Landing Jet Ignition = 1
		// state indicators (for visual feedback & troubleshooting):
	// Transitions:
		if (SW4_state == HIGH){state = 0;}
	break; // end case 3
} // end switch (state)
 //----------------------------------------
} // end void loop()

