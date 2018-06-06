typedef struct sd_command { //basic SD command structure
    uint8_t command;
    uint8_t args[5];
    uint8_t crc;
} sd_command;

typedef struct sd_resp { //40-bit response for some commands, like CMD58
    uint8_t resp[5];
} sd_resp;

sd_command CMD0 = {.command = 0b01000000, .args[0] = 0, 0, 0, 0, .crc = 0b10010101}; //this has to have a valid crc
//below commands shouldn't need a valid crc
sd_command CMD1 = {.command = 0b01000001, .args[0] = 0, 0, .args[2] = 0, .args[3] = 0, .crc = 0b00000000};
sd_command CMD8 = {.command = 0b01001000, .args[0] = 0, 0, 1, 0b10101010, .crc = 0b10011011};
sd_command CMD58 = {.command = 0b01111010, .args[0] = 0, 0, 0, 0, .crc = 0b0111010};

//could we use vargs for this?
//Note: find out how the heck to calculate a CRC!
uint8_t sd_writeCommand(sd_command c) {
    SS_SetLow();
    //set upper two bits of com to 0x40 later, or check for this
    SPI2_Exchange8bit(c.command);
    
    SPI2_Exchange8bit(c.args[0]);
    SPI2_Exchange8bit(c.args[1]);
    SPI2_Exchange8bit(c.args[2]);
    SPI2_Exchange8bit(c.args[3]);
    
    SPI2_Exchange8bit(c.crc); //CRC of CMD0
    
    uint8_t result = 0xFF;
    do {
        result = SPI2_Exchange8bit(0xFF); //have to keep the MOSI line high, cycle dummy writes 
        //until we get a response or the request times out
    } while (result > 0x80);
    
    SS_SetHigh();
    return result; //return the result code
}

sd_resp sd_writeCommandLong(sd_command c) {
    sd_resp s;
    SS_SetLow();
    //set upper two bits of com to 0x40 later, or check for this
    SPI2_Exchange8bit(c.command);
    
    SPI2_Exchange8bit(c.args[0]);
    SPI2_Exchange8bit(c.args[1]);
    SPI2_Exchange8bit(c.args[2]);
    SPI2_Exchange8bit(c.args[3]);
    
    SPI2_Exchange8bit(c.crc); //CRC of CMD0
    
    uint8_t result = 0xFF;
    while (result > 0x80) {
        result = SPI2_Exchange8bit(0xFF);
    }
    s.resp[0] = result;
    s.resp[1] = SPI2_Exchange8bit(0xFF);
    s.resp[2] = SPI2_Exchange8bit(0xFF);
    s.resp[3] = SPI2_Exchange8bit(0xFF);
    s.resp[4] = SPI2_Exchange8bit(0xFF);
    
    SS_SetHigh();
    return s;
}

uint8_t sd_init() {
    SPI2CON1bits.PPRE = 0b00; //set clock speed to ~125kHz
    for (int i = 0; i < 10; i++) {
        SPI2_Exchange8bit(0xFF);
    }
    int result = 0;
    
    result = sd_writeCommand(CMD0); //should get a 1 back
    if (result != 1) {
        printf("ERROR: CMD0 FAILED\n");
        return 1;
    }
    result = sd_writeCommand(CMD1); //may take ~500ms
    delay_poll(MS_100);
    result = sd_writeCommand(CMD8);
    sd_resp r = sd_writeCommandLong(CMD58);
    if (r.resp[0] != 1) {
        printf("WARNING: CMD58 RETURNED UNKNOWN VALUE\n");
    }
    
    SPI2CON1bits.PPRE = 0b11; //return clock speed to ~8MHz
    return 0;
}