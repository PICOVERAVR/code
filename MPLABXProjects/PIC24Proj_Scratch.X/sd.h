typedef struct sd_command { //basic SD command structure
    uint8_t command; //command with the form of 0b01xxxxxx
    uint8_t args[4]; //four arguments, all required
    uint8_t crc; //crc, usually not checked unless a CMD0 is issued
} sd_command;

typedef struct sd_resp { //40-bit response for some commands
    uint8_t resp[5];
} sd_resp;

//this has to have a valid crc
sd_command CMD0 = {.command = 0b01000000, .args[0] = 0, 0, 0, 0, .crc = 0b10010101};
//below commands shouldn't need a valid crc
sd_command CMD1 = {.command = 0b01000001, .args[0] = 0, 0, .args[2] = 0, .args[3] = 0, .crc = 0};
sd_command CMD8 = {.command = 0b01001000, .args[0] = 0, 0, 1, 0b10101010, .crc = 0b10000111};
sd_command CMD55 = {.command = 0b01110111, .args[0] = 0, 0, 0, 0, .crc = 0};
sd_command ACMD41 = {.command = 0b01101001, .args[0] = 0x40, 0, 0, 0, .crc = 0};
sd_command CMD58 = {.command = 0b01111010, .args[0] = 0, 0, 0, 0, .crc = 0};

sd_command CMD17 = {.command = 0b01010001, .args[0] = 0, 0, 0, 0, .crc = 0}; //read a single block

typedef struct sd_block { //block size is almost universally 512 bytes
    uint8_t data[512];
} sd_block;

uint8_t sd_writeCommand(sd_command *c) {
    SS_SetLow();
    //set upper two bits of com to 0x40 later, or check for this
    SPI2_Exchange8bit((*c).command);
    
    for (int i = 0; i < 4; i++) {
        SPI2_Exchange8bit((*c).args[i]);
    }
    
    SPI2_Exchange8bit((*c).crc); //CRC of CMD0
    
    uint8_t result = 0xFF;
    do {
        result = SPI2_Exchange8bit(0xFF); //have to keep the MOSI line high, cycle dummy writes 
        //until we get a response or the request times out
    } while (result > 0x80);
    
    SS_SetHigh();
    return result; //return the result code
}

sd_resp sd_writeCommandLong(sd_command *c) {
    sd_resp s;
    SS_SetLow();
    //set upper two bits of com to 0x40 later, or check for this
    SPI2_Exchange8bit((*c).command);
    
    for (int i = 0; i < 4; i++) {
        SPI2_Exchange8bit((*c).args[i]);
    }
    
    SPI2_Exchange8bit((*c).crc);
    
    uint8_t result = 0xFF;
    while (result >= 0x80) {
        result = SPI2_Exchange8bit(0xFF);
    }
    
    s.resp[0] = result;
    for (int i = 1; i < 5; i++) {
        s.resp[i] = SPI2_Exchange8bit(0xFF);
    }
    
    SS_SetHigh();
    return s;
}

//read a block from the SD card
//this is hard-coded because there are only two commands to do this
void sd_readBlock(uint64_t block_addr, sd_block *rd_block) {
    SS_SetLow();
    SPI2_Exchange8bit(CMD17.command);
    for (int i = 4; i > 0; i--) {
        SPI2_Exchange8bit((block_addr >> (i * 8)) & 0xFF);
    }
    SPI2_Exchange8bit(CMD17.crc);
    
    uint8_t result = 0xFF;
    while (result >= 0x80) {
        result = SPI2_Exchange8bit(0xFF);
    }
    
    uint8_t token = 0;
    while (token != 0xFE) { //token for start of data transmission
        token = SPI2_Exchange8bit(0xFF);
    }
    
    for (int i = 0; i < 512; i++) {
        (*rd_block).data[i] = SPI2_Exchange8bit(0xFF);
    }
    
    SS_SetHigh();
}

//note: a recent SD card is assumed.  Old cards will not work.
//add error checking here!!
uint8_t sd_init() {
    SPI2CON1bits.PPRE = 0b00; //set clock speed to ~125kHz
    for (int i = 0; i < 10; i++) {
        SPI2_Exchange8bit(0xFF);
    }
    
    printf("\nCMD0 - %d\n", sd_writeCommand(&CMD0));
    
    delay_poll(MS_100);
    sd_resp r = sd_writeCommandLong(&CMD8);
    printf("CMD8 - %d %d %d %d %d\n", r.resp[0], r.resp[1], r.resp[2], r.resp[3], r.resp[4]);
    
    printf("CMD55, ACMD41\n");
    uint8_t result = 0xFF;
    do {
        sd_writeCommand(&CMD55);
        result = sd_writeCommand(&ACMD41);
    } while (result != 0);
    
    r = sd_writeCommandLong(&CMD58);
    printf("CMD58 - %d %d %d %d %d\n", r.resp[0], r.resp[1], r.resp[2], r.resp[3], r.resp[4]);
    
    SPI2CON1bits.PPRE = 0b11; //return clock speed to ~8MHz
    
    return 0;
}