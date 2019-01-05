/*
  Arduino EEPROM flasher
    -currently is in development for the GLS29EE010 128Kx8 EEPROM
    for my 68000 project
    -Note: all arduino serial methods time out at (by default) 1sec
    -not designed to be interactive, although everything but 
    the actual data sent is ASCII-encoded.
    -this could be re-written in actual C++...
    
    TODO:
      figure out what state the EEPROM resets into (depends on default state of arduino pins on reset)
      read datasheet and actually write stuff
      test it all
      
*/

/*
  Pinout:
  52 - 35: address pins (16) - address(0)
  34 - 32: L control
  31 - 29: H control
  28 - 21: data(7) - data(0)
*/

/*
  DQ6 will toggle between states until write is complete, in which case the pin will settle.
*/

#include <stdint.h>

// include support for JEDEC software data protection
#define JD_WP 1

enum command_codes {
  E_ERASE,
  E_WRITE, // only supported for blocks at a time
  E_READ,  // only supported for bytes at a time on chip
  E_SDP_ON,
  E_SDP_OFF,
  E_NOP,   // not sure why this would be used, but included
};

enum chip_control_pins {
  H_CS = 29,
  H_OE,
  H_WE,
  L_CS,
  L_OE,
  L_WE,
};

enum input_directions {
  IN,
  OUT,
};

void set_data_pin_mode(bool dir) {
  if (dir) { // out
    for (int i = 28; i > 20; i++) {
      pinMode(i, OUTPUT);
    }
  } else { // in
    for (int i = 28; i > 20; i++) {
      pinMode(i, INPUT);
    }
  }
}

// grab existing data off bus
uint8_t get_data_bus() {
  int data = 0;
  for (int i = 21; i <= 28; i++) {
    // set bits using arduino methods pls
  }
}

// put a byte on the data bus
void set_data_bus(uint8_t data) {
  //stuff
}

// blocks until the pending write is complete
// sets data bus to inputs
void check_write_complete() {
  set_data_pin_mode(IN);

  int past;
  do {
    past = digitalRead(27);
    delayMicroseconds(1); // TODO: change this
  } while (past != digitalRead(27));
  return false;
}

void eeprom_write(long addr, uint16_t data) {
  /*
  SDP_ENABLE
  OE -> High
  WE -> Low
  wait 100 us?
  (do stuff)
  write another byte
  (do more stuff)
  wait >200 us to complete page write
  */
}

uint16_t eeprom_read(long addr) {
  uint16_t temp;
  set_data_pin_mode(IN);
  digitalWrite(H_CS, LOW);
  digitalWrite(H_OE, LOW);
  
  digitalWrite(H_CS, HIGH);
  digitalWrite(H_OE, HIGH);
  digitalWrite(L_CS, LOW);
  digitalWrite(L_OE, LOW);

  digitalWrite(L_CS, HIGH);
  digitalWrite(L_OE, HIGH);
  
}

void setup() {
  // set data lines to inputs just in case
//  set_data_pin_mode(IN);
  
  Serial.begin(9600);

  // 17 addr lines + 3 cntl H + 3 cntl L
//  for (int i = 53; i >= 30; i--) {
//    pinMode(i, OUTPUT);
//  }

  // set control pins to make bus hi-z
//  for (int i = H_CS; i < L_WE; i++) {
//    digitalWrite(i, HIGH);
//  }
  
  Serial.println("Ready.");
}

// RD: <hexaddr>;
// WR: <hexaddr>: <value>;
// ER:;
// VE:;
// PR: <hexaddr>;
// PW: <hexaddr>: <values>;
// NP:;
// <op>: <arg>: <arg>: <arg>;

char buf[8];
int count;

void loop() {
  if (Serial.available() > 0) {
    buf[count++] = Serial.read();
    
    if (buf[count - 1] == '\n') {
      buf[count - 1] = '\0';
    }
  }
}
