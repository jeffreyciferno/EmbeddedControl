// BeerControl
// 11/1/2018
// Jeffrey Ciferno
//-----------
// REVD Note:
// ----------
// Fall 2018 / Beer Control State Machine
// Objectives:
//------------
// 1. Design a State Machine using Max32 Microcontroller
// Tasks:
//-------
// 0. (For Lab Only) Form a team of 2 or 3 (team of 1 MUST join team of 1 or 2)
// 1. Review System Block Diagram & State Diagram in Test#2 Handout
// 2. write your C codes based on State Diagram & System Block Diagram
// 3. Test & Troubleshoot your codes with your Max32 + Basic I/O board.
// 4. After you are happy with your code at board level, upload it to System Bench Max32 to test with PC Beer Model
// 5. One-Shot Demo: call coach when you are ready for Demo. 
//	(Lab Grading method: 1-shot / works 100% : 10 points, more than 1 shot: 8 points)
//-----------------------------------------------------------------------------------
#include <IOShieldOled.h>
// set pin numbers:
const int ledPin =  13;      // System Operational LED
const int LD1 =  70;     
const int LD2 =  71;     
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
int flash = 0;
int SW1_state = 0; 
int SW2_state = 0;
int SW3_state = 0;
int SW4_state = 0;
int state = 0;
//=========================================================

void setup() {
  //================== Sign On Message ==============
  IOShieldOled.begin();  
  //Clear the virtual buffer
  IOShieldOled.clearBuffer();
  //Choosing Fill pattern 0
  IOShieldOled.setFillPattern(IOShieldOled.getStdPattern(0));
  //Turn automatic updating off
  IOShieldOled.setCharUpdate(0);  
  int irow;
  int ib; 
  // Display Sign On Message
  IOShieldOled.clearBuffer();
//-------------------------------------------------------------------------------------------   
    IOShieldOled.setCursor(0, 0);
    IOShieldOled.putString("member #1");    //*** Replace with First Name (team member #1)
    IOShieldOled.setCursor(0, 1);
    IOShieldOled.putString("member #2");     //*** Replace with First Name (team member #2)
    IOShieldOled.setCursor(0, 2);
    IOShieldOled.putString("member #3");  
//-------------------------------------------------------------------------------------------  
    IOShieldOled.setCursor(0, 3);
    IOShieldOled.putString("Beer Control");
    IOShieldOled.updateDisplay();  
  //======== End / Sign On Message ==================  
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
 // initialize switches as inputs:
   pinMode(SW1, INPUT);  
   pinMode(SW2, INPUT);
   pinMode(SW3, INPUT);
   pinMode(SW4, INPUT); 
  // initialize Outputs: 
       digitalWrite(LD1, LOW);
       digitalWrite(LD2, LOW);   
       digitalWrite(LD3, LOW);  
       digitalWrite(LD4, LOW); 
       digitalWrite(LD5, LOW);
       digitalWrite(LD6, LOW);   
       digitalWrite(LD7, LOW);  
       digitalWrite(LD8, LOW);  
}

//================================================

void loop(){

  // Flashing "Test#2" Message at OLED:
    IOShieldOled.setCursor(0, 3);
    flash = flash ^1;    // exclusive OR "^1" toggles flash
    if (flash==0){IOShieldOled.putString("*** Test#2 ***"); }
    if (flash==1){IOShieldOled.putString("              "); }     
    IOShieldOled.updateDisplay();   
  // System Operation LED ON:
     digitalWrite(ledPin, HIGH); 
     delay(10);                  // wait for 10 ms

  //----------------------------------------------  
   // read switches:
  SW1_state = digitalRead(SW1);
  SW2_state = digitalRead(SW2);
  SW3_state = digitalRead(SW3);
  SW4_state = digitalRead(SW4);
  // Echo SW to LEDs :  
  if (SW1_state == 1) {digitalWrite(LD1, HIGH);  }
  if (SW1_state == 0) {digitalWrite(LD1, LOW);  }
  if (SW2_state == 1){digitalWrite(LD2, HIGH); }
  if (SW2_state == 0) {digitalWrite(LD2, LOW);  }
  if (SW3_state == 1){digitalWrite(LD3, HIGH);}
  if (SW3_state == 0){digitalWrite(LD3, LOW);}
  if (SW4_state == 1){digitalWrite(LD4, HIGH);}
  if (SW4_state == 0){digitalWrite(LD4, LOW);}
 //=== State Machine starts here ====
 switch (state)
 {
  case 0:     // state 0: Idle: Turn everything OFF (Pump, InletValve, Heater, Chiller), waiting for START signal
   // State Outputs:

       digitalWrite(LD5, LOW);    // Pump = 0
       digitalWrite(LD6, LOW);    // Inlet Valve = 0
       digitalWrite(LD7, LOW);    // Heater = 0
       digitalWrite(LD8, LOW);    // Chiller = 0
       
   // state transition: when SW1(START) == 1
        if (SW1_state == 1){  state = 1;}  

      break;
      
  case 1:    // state 1: Filling tank, transition to state 2 when level sensor==1
    // State Outputs:

       digitalWrite(LD5, LOW);    // Pump = 0
       digitalWrite(LD6, HIGH);   // Inlet Valve = 1
       digitalWrite(LD7, LOW);    // Heater = 0
       digitalWrite(LD8, LOW);    // Chiller = 0
       
   // state transition: when Level Sensor ==1
        if (SW4_state == 1){  state = 2;}         

      break;     

  case 2:    // state 2: Heating, transition to state 3 when Temp sensor==1
    // State Outputs:

       digitalWrite(LD5, LOW);    // Pump = 0
       digitalWrite(LD6, LOW);  // Inlet Valve = 0
       digitalWrite(LD7, HIGH);    // Heater = 1
       digitalWrite(LD8, LOW);    // Chiller = 0
       
   // state transition: when Temp Sensor == 1
        if (SW3_state== 1){  state = 3;}         

      break;
           
  case 3:    // state 3: Soaking, transition to state 3 when Temp sensor==1
    // State Outputs:

       digitalWrite(LD5, LOW);    // Pump = 0
       digitalWrite(LD6, LOW);  // Inlet Valve = 0
       digitalWrite(LD7, LOW);    // Heater = 0
       digitalWrite(LD8, LOW);    // Chiller = 0
       
   // state transition: when delay is over
        delay(7000);
        state = 4;}         

      break;
  
  case 4:    // state 4: Chilling, transition to state 5 when Temp sensor==0
    // State Outputs:

       digitalWrite(LD5, LOW);    // Pump = 0
       digitalWrite(LD6, LOW);  // Inlet Valve = 0
       digitalWrite(LD7, LOW);    // Heater = 0
       digitalWrite(LD8, HIGH);    // Chiller = 1
       
   // state transition: when Temp Sensor == 0
        if (SW3_state == 0){  state = 5;}         

      break;
      
   case 5:    // state 2: Chilling, transition to state 5 when Level sensor==0
    // State Outputs:

       digitalWrite(LD5, HIGH);    // Pump = 1
       digitalWrite(LD6, LOW);  // Inlet Valve = 0
       digitalWrite(LD7, LOW);    // Heater = 0
       digitalWrite(LD8, LOW);  // Chiller = 0
       
   // state transition: when Level Sensor == 0
        if (SW4_state == 0){  state = 1;}         

      break;
 } // end switch (state)

 

  //------------------------------------

   // System Operation LED OFF:

     digitalWrite(ledPin, LOW); 

     delay(10);                  // wait for 10 ms 

  

} // end loop

