// Progressive_Vending_Machine
// 9-30-2018
// Jeffrey Ciferno
// Objective: Vend Based off of Temperature
// =========
// Progressive Vending Machine
// Functional Description:
// ======================
// 1.  Read POT input, scale to temperature in Fahrenheit:
//      degree_F = sensorValue / 10;
// 2.  Display Temperature @ OLED
// 3.  Progressive Vending Machine logic:
// Inputs:
// ------
//    SW1: Intoxication Sensor
//    SW2: Overstressed Sensor
//    A0: Temperature Sensor
// Outputs:
// --------
//    LD1: Intoxication Indicator
//    LD2: Overstressed Indicator
//    LD3: Serve Vodka
//    LD4: Serve Coffee
//    LD5: Serve Beer
//    LD6: serve Water
//    LD7: Dial 911
//    LD8: System Run Indicator
// System Operation Modes:
// ---------------------- 
//    Overstressed  Intoxicated   Mode
//    ------------  -----------   ----   
//          0            0         0 : normal
//          0            1         1 : Intoxicated
//          1            0         2 : Overstressed
//          1            1         3 : Emergency
//    3.0 Normal Mode(0):
//        Temperature range: 0 - 32 F	: serve Vodka 
//        Temperature range: 33 - 60 F	: Serve Coffee
//        Temperature range: 61 - 90 F	: Serve Beer 
//        Temperature range: >= 91F   	: Serve Water 
//    3.1 Intoxicated Mode(1)
//        Serve Water
//    3.2 Overstressed Mode(2)
//        Serve Beer
//    3.3 Intoxicated & Overstressed Mode(3)
//        Serve Water
//        Dial 911
//=============================================================================
// Tasks:
// 1. Design / draw Control Flow Chart
// 2. Read & verify code is working (without your Progressive Vending Machine logic) 
// 3. Create code based on Control Flow Chart 
// 4. Verify code work as prescribed
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
  delay(10);  // wait for 10 ms 
  // note: @ the end, 10ms OFF
  // loop time = 10 ms + instructions + 10 ms = 20ms +
  //---------------------------------------------- 
  // 1. Read POT input, scale to temperature in Fahrenheit:
  // -------------------------------------------------------------
  // read the value from the POT sensor:
  sensorValue = analogRead(sensorPin);

  // Scale temperature in Fahrenheit:
  degreeF = sensorValue/10;

  // 2. Display Temperature @ OLED:
  // -------------------------------------
  //clear the display and reset the cursor to zero
  IOShieldOled.clearBuffer();
  IOShieldOled.setCursor(0,0);
  IOShieldOled.putString("Vending");
  IOShieldOled.setCursor(0,1);
  IOShieldOled.putString("==============");
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
  displayString="9-30/Ciferno";
  //convert the string to an array of characters
  displayString.toCharArray(displayCharArray,50);
  //Display it @ OLED:
  IOShieldOled.putString(displayCharArray);
  IOShieldOled.updateDisplay(); 
  // 3. Progressive Vending Machine Logic:
  SW1_state = digitalRead(SW1);
  SW2_state = digitalRead(SW2);
  SW3_state = digitalRead(SW3);
  SW4_state = digitalRead(SW4);
  //normal mode
  if (SW1_state == LOW && SW2_state == LOW)
  {  
    if (degreeF <= 32)
    {
      digitalWrite(LD3, HIGH);
      digitalWrite(LD4, LOW);
      digitalWrite(LD5, LOW);
      digitalWrite(LD6, LOW);
      digitalWrite(LD7, LOW);
    }

    if (degreeF >= 33  && degreeF <= 60)
    {
      digitalWrite(LD4, HIGH);
      digitalWrite(LD3, LOW);
      digitalWrite(LD5, LOW);
      digitalWrite(LD6, LOW);
      digitalWrite(LD7, LOW);
    }

    if (degreeF >= 61 && degreeF <= 90)
    {
      digitalWrite(LD5, HIGH);
      digitalWrite(LD3, LOW);
      digitalWrite(LD4, LOW);
      digitalWrite(LD6, LOW);
      digitalWrite(LD7, LOW);
    }

    if (degreeF >= 91)
    {
      digitalWrite(LD6, HIGH);
      digitalWrite(LD3, LOW);
      digitalWrite(LD4, LOW);
      digitalWrite(LD5, LOW);
      digitalWrite(LD7, LOW);
    }
  }
  //Intoxicated Mode
  if (SW1_state == HIGH && SW2_state == LOW)
  {
    digitalWrite(LD6, HIGH);
    digitalWrite(LD3, LOW);
    digitalWrite(LD4, LOW);
    digitalWrite(LD5, LOW);
    digitalWrite(LD7, LOW);
  }
  //Overstressed Mode
  if (SW1_state == LOW && SW2_state == HIGH)
  {
    digitalWrite(LD5, HIGH);
    digitalWrite(LD3, LOW);
    digitalWrite(LD4, LOW);
    digitalWrite(LD6, LOW);
    digitalWrite(LD7, LOW);
  }
  //Intoxicated && Overstressed Mode
  if (SW1_state == HIGH && SW2_state == HIGH)
  {
    digitalWrite(LD6, HIGH);
    digitalWrite(LD7, HIGH);
    digitalWrite(LD3, LOW);
    digitalWrite(LD4, LOW);
    digitalWrite(LD5, LOW);
  }
  //----------------------------------------
  // System Operation LED Indicator:
  digitalWrite(LD8, LOW);  
  delay(10);           // wait for 10 ms  
} // end void loop()

