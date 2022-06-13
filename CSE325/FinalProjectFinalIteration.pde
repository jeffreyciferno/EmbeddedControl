//Dual stepper motor driver
//11-20-2018
//Team 2: Eric Branson, Jeffrey Ciferno
//Objective: 
//control 2 stepper motors to move a laser along the x and y axis, using certain inputs to determine
//manual or automatic mode
//
//Functional description:
//1. Read switch 1 input to determine run or stop
//2. Read switch 2 to determine auto or manual
//3. If auto, follow a set of predetermined movements
//4. If manual, move to 4 different coordinates based on a combination of switch 3 and 4
//Inputs:
//  SW1: Run/Stop
//  SW2: Auto/Manual
//  SW3: Manual Position control 1
//  SW4: Manual Position control 2
//  
//Simulation:
//Horizontal
//LD1: Motor coil D0
//LD2: Motor coil D1
//LD3: Motor coil D2
//LD4: Motor coil D3
//Vertical
//LD5: Motor coil D4
//LD6: Motor coil D5
//LD7: Motor coil D6
//LD8: Motor coil D7
//
//Physical Motor Drive:
//Horizontal
//MotorCoil_0 : pin0
//MotorCoil_1 : pin1
//MotorCoil_2 : pin2
//MotorCoil_3 : pin3
//Vertical
//MotorCoil_0 : pin4
//MotorCoil_1 : pin5
//MotorCoil_2 : pin6
//MotorCoil_3 : pin7

#include <IOShieldOled.h>
// set pin numbers:
const int ledPin = 13;
const int LD1 = 70; //***** Note: label on the board is for Uno32, this is MAX32, see MAX32 Reference Manual
const int LD2 = 71; // ******** LD pins are corrected here.
const int LD3 = 72;
const int LD4 = 73;
const int LD5 = 74;
const int LD6 = 75;
const int LD7 = 76;
const int LD8 = 77; 
const int SW1 = 2;
const int SW2 = 7;
const int SW3 = 8;
const int SW4 = 79; //***** Note: label on the I/O board is 35 for uno32 only
// variables:
int SW1_state = 0;
int SW2_state = 0;
int SW3_state = 0;
int SW4_state = 0;
//====================================
int indexM = 0;
int indexN = 0;
int step_max_x = 32;
int step_max_y = 32;
int motor_step_x = 0;
int motor_step_y = 0;
int auto_direction = 0;
int command_position_x = 0;
int command_position_y = 0;
int display_refresh = 0;
String displayString;
char displayCharArray[50];
int auto_hold;
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
} // end setup()
void loop() {
  auto_hold = 0;

  // read switches inputs:
  SW1_state = digitalRead(SW1);
  SW2_state = digitalRead(SW2);
  SW3_state = digitalRead(SW3);
  SW4_state = digitalRead(SW4);
  // Arm Logic:
  if (SW1_state == LOW) {
    // system NOT running:
  } // end if (SW1_State == LOW)
  //==============================

  if (SW1_state == HIGH) { // system is running
    //============ Stepper Motor Position Control Logic: X =======
    //Horizontal

    if (command_position_x > motor_step_x) {
      motor_step_x = motor_step_x + 1;
      indexM = indexM + 1;
    }

    if (command_position_x < motor_step_x) {
      motor_step_x = motor_step_x - 1;
      indexM = indexM - 1;
    }
    //============ Stepper Motor Position Control Logic: Y =======
    //Vertical
    if (command_position_y > motor_step_y) {
      motor_step_y = motor_step_y + 1;
      indexN = indexN + 1;
    }

    if (command_position_y < motor_step_y) {
      motor_step_y = motor_step_y - 1;
      indexN = indexN - 1;
    }

    
    // Display tON @ OLED:
         // -------------------------------------
         IOShieldOled.updateDisplay();
         //clear the display and reset the cursor to zero
         IOShieldOled.clearBuffer();
         IOShieldOled.setCursor(0, 0);
         IOShieldOled.putString("PWM Control");
         // Display Date & Your Name:
         IOShieldOled.setCursor(0, 1);
         displayString = "X:";
         displayString += motor_step_x;
         //convert the string to an array of characters
         displayString.toCharArray(displayCharArray, 50);
         //Display it @ OLED:
         IOShieldOled.putString(displayCharArray);
         IOShieldOled.setCursor(0, 3);
         //create a string to display the temperature on the OLED screen
         displayString = "Y:";
         displayString += motor_step_y;
         //convert the string to an array of characters
         displayString.toCharArray(displayCharArray, 50);
         //Display it @OLED:
         IOShieldOled.putString(displayCharArray);
         IOShieldOled.updateDisplay();

    if (SW2_state == LOW) // manual mode
    {
      // Direction control:
      // 2.1 If Direction ==0, run motor clockwise
      if (SW3_state == LOW && SW4_state == LOW) //home
      {
        command_position_x = 0;
        command_position_y = 0;
      }

      if (SW3_state == HIGH && SW4_state == LOW) //C
      {
        command_position_x = 0;
        command_position_y = 32;
      }

      if (SW3_state == LOW && SW4_state == HIGH) //B
      {
        command_position_x = -32;
        command_position_y = -32;
      }

      if (SW3_state == HIGH && SW4_state == HIGH) //A
      {
        command_position_x = 32;
        command_position_y = -32;
      }

    } // end if (SW3_state == LOW)

    if (SW2_state == HIGH) { //autoscan mode
      switch (auto_direction) {
      case 0: //home
        command_position_x = 0;
        command_position_y = 0;

        if (command_position_x == motor_step_x && command_position_y == motor_step_y) {
          auto_hold = 1;
          auto_direction = 1;
        }

        break;
      case 1: //C
        command_position_x = 0;
        command_position_y = 32;

        if (command_position_x == motor_step_x && command_position_y == motor_step_y) {
          auto_hold = 1;
          auto_direction = 2;
        }

        break;
      case 2: //B
        command_position_x = -32;
        command_position_y = -32;

        if (command_position_x == motor_step_x && command_position_y == motor_step_y) {
          auto_hold = 1;
          auto_direction = 3;
        }

        break;

      case 3: //A
        command_position_x = 32;
        command_position_y = -32;

        if (command_position_x == motor_step_x && command_position_y == motor_step_y) {
          auto_hold = 1;
          auto_direction = 0;
        }

        break;

      }

    }
    //=========== Stepper Motor Driver ========
    indexM = indexM & 3; // wraps-around logic
    switch (indexM) {
    case 0:
      digitalWrite(LD1, HIGH);
      digitalWrite(LD2, LOW);
      digitalWrite(LD3, LOW);
      digitalWrite(LD4, LOW);
      break;
    case 1:
      digitalWrite(LD1, LOW);
      digitalWrite(LD2, LOW);
      digitalWrite(LD3, HIGH);
      digitalWrite(LD4, LOW);

      break;
    case 2:
      digitalWrite(LD1, LOW);
      digitalWrite(LD2, HIGH);
      digitalWrite(LD3, LOW);
      digitalWrite(LD4, LOW);
      break;
    case 3:
      digitalWrite(LD1, LOW);
      digitalWrite(LD2, LOW);
      digitalWrite(LD3, LOW);
      digitalWrite(LD4, HIGH);

      break;
    } // End Switch (indexM)

    indexN = indexN & 3; // wraps-around logic
    switch (indexN) {
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
    } // End Switch (index)
    // end if (SW3_state == HIGH)

  } // end if (SW1_state == HIGH)
  //------------------------------------
  // System Operation LED OFF:
  digitalWrite(ledPin, LOW);
  if (auto_hold) {
    delay(3000);
  }
  delay(10); // wait for motorTime ms

} // end loop
//=============================


