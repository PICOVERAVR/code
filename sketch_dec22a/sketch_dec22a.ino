/*
  Arduino EEPROM flasher
    currently is in development for the GLS29EE010 128Kx8 EEPROM
    for my 68000 project
*/

/*
  Read:
  CE -> Low
  OE -> Low
  read a byte
  (wait a us, then read more bytes)
  Write:
  SDP_ENABLE
  OE -> High
  WE -> Low
  wait 100 us?
  (do stuff)
  write another byte
  (do more stuff)
  wait >200 us to complete page write

  DQ6 will toggle between states until write is complete, in which case the pin will settle.
*/

enum command_codes {
  E_ERASE,
  E_WRITE, // only supported for blocks at a time
  E_READ,  // only supported for bytes at a time on chip
  E_SDP_ON,
  E_SDP_OFF,
};

void setup() {
  // set up chip

}

void loop() {
  // read a command, parse it, execute on chip
  // eventually have a terminal program write to this and tell it what to do

}
