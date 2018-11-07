// SecurityControl
// Status: Complete                               
// Author: Jeffrey Ciferno
// Target Hardware:       Digilent chipKITMax32 board
// Development Platform:  mpide-0023-windows-20120903
// Objectives:
//   1. Experiment with Digital I/O
//------------------------------------------
//   I/O Assignments:
//   =======================================================================
//   SW1: Arm
//   SW2: Entrance
//   SW3: Heat
//   SW4: Restrict
//   ------------------------------------------
//   LD1: Arm Indicator
//   LD2: Entrance Indicator
//   LD3: Heat Indicator
//   LD4: Restrict Indicator
//   LD5: System Armed
//   LD6: Alarm
//   LD7: Sprinkler
//   LD8: Laser (1MW)
//   ------------------------------------------
//   Functional requirements:
//   =======================================================================
//   1. Reflect SW1,SW2,SW3,SW4 to LD1,LD2,LD3,LD4
//   2. When the system is not armed (ARM = 0), disable all outputs
//   3. When the system is armed (Arm = 1), turn on System Armed Indicator
//     3.1 When any of the sensor is activated, turn on ALARM
//     3.2 HEAT activates SPRINKLER
//     3.3 RESTRICT activates LASER 
//   =======================================================================
//   Tasks:
//   1. Read & understand requirements
//   2. Create functional requirements
//   3. Verify your code works as prescribed
//   =======================================================================
// set pin numbers:
const int BTN1 = 4;     // the number of the pushbutton pin
const int BTN2 = 78;    //***** Note: label on the board is for Uno32, this is MAX32, see MAX32 Reference Manual
const int ledPin =  13;      // System Operational LED
const int LD1 =  70;     //***** Note: label on the board is for Uno32, this is MAX32, see MAX32 Reference Manual
const int LD2 =  71;     //******** Wow! Digilent was falling asleep, Reference manual is wrong! 
// ******** LD pins are corrected here.
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
// variables will change:
int BTN1_state = 0;         // variable for reading the pushbutton status
int SW1_state = 0; 
int SW2_state = 0; 
int SW3_state = 0; 
int SW4_state = 0; 

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
} // end setup()

void loop(){
  // System Operation LED ON:
     digitalWrite(ledPin, HIGH); 
     delay(50);                  // wait for 50 ms
  //----------------------------------------------  
  // read switches inputs:
  BTN1_state = digitalRead(BTN1);
  SW1_state = digitalRead(SW1);
  SW2_state = digitalRead(SW2); 
  SW3_state = digitalRead(SW3);
  SW4_state = digitalRead(SW4); 
  // Echo switches to LED Indicators:
  if (SW1_state == HIGH) {
  if (SW1_state == HIGH) {digitalWrite(LD1, HIGH);  }
  if (SW1_state == LOW) {digitalWrite(LD1, LOW);  }

  if (SW2_state == HIGH) {digitalWrite(LD2, HIGH);  }
  if (SW2_state == LOW) {digitalWrite(LD2, LOW);  }

  if (SW3_state == HIGH) {digitalWrite(LD3, HIGH);  }
  if (SW3_state == LOW) {digitalWrite(LD3, LOW);  }

  if (SW4_state == HIGH) {digitalWrite(LD4, HIGH);  }
  if (SW4_state == LOW) {digitalWrite(LD4, LOW);  }
  
  if (SW1_state == LOW){
  digitalWrite(LD1, LOW); 
  digitalWrite(LD2, LOW); 
  digitalWrite(LD3, LOW); 
  digitalWrite(LD4, LOW);   
  digitalWrite(LD5, LOW); 
  digitalWrite(LD6, LOW); 
  digitalWrite(LD7, LOW); 
  digitalWrite(LD8, LOW); 
  }
}
  // Arm Logic: 
if (SW1_state == LOW) {
  // process unarmed:
   digitalWrite(LD1, LOW);
   digitalWrite(LD2, LOW); 
   digitalWrite(LD3, LOW); 
   digitalWrite(LD4, LOW);  
   digitalWrite(LD5, LOW); 
   digitalWrite(LD6, LOW); 
   digitalWrite(LD7, LOW); 
   digitalWrite(LD8, LOW); 
} // end if (SW1_State == LOW)
  //============================================================
 
if (SW1_state == HIGH) {     // system is armed
  // System Armed Logic: 
   digitalWrite(LD5, HIGH);  // Turn ON system arm indicator
  
  // Entrance logic:
if (SW2_state == HIGH) {     // system is triggered 
   delay(3000);
   SW2_state = digitalRead(SW2);
   if (SW2_state == HIGH){
   digitalWrite(LD6, HIGH);
   }
}
  // Heat logic:
if (SW3_state == HIGH) {     // system is triggered
   digitalWrite(LD6, HIGH);
   digitalWrite(LD7, HIGH);
}
  // Restrict logic:
  if (SW4_state == HIGH) {   // system is triggered
   delay(3000);
   SW4_state = digitalRead(SW4);
   if (SW4_state == HIGH){
   digitalWrite(LD6, HIGH);
   digitalWrite(LD8, HIGH);
   }
}
} // end if (SW1_state == HIGH)
  //------------------------------------
  // System Operation LED OFF:
     digitalWrite(ledPin, LOW); 
     delay(50);              // wait for 50 ms 
} // end loop
//=============================



