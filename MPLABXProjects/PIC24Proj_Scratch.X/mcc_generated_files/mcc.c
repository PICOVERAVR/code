// Configuration bits: selected in the GUI

// FICD
#pragma config ICS = PGD3    // ICD Communication Channel Select bits->Communicate on PGEC3 and PGED3
#pragma config JTAGEN = OFF    // JTAG Enable bit->JTAG is disabled

// FPOR
#pragma config ALTI2C1 = ON    // Alternate I2C1 pins->I2C1 mapped to ASDA1/ASCL1 pins
#pragma config ALTI2C2 = ON    // Alternate I2C2 pins->I2C2 mapped to ASDA2/ASCL2 pins
#pragma config WDTWIN = WIN25    // Watchdog Window Select bits->WDT Window is 25% of WDT period

// FWDT
#pragma config WDTPOST = PS32768    // Watchdog Timer Postscaler bits->1:32768
#pragma config WDTPRE = PR128    // Watchdog Timer Prescaler bit->1:128
#pragma config PLLKEN = ON    // PLL Lock Enable bit->Clock switch to PLL source will wait until the PLL lock signal is valid.
#pragma config WINDIS = OFF    // Watchdog Timer Window Enable bit->Watchdog Timer in Non-Window mode
#pragma config FWDTEN = OFF    // Watchdog Timer Enable bit->Watchdog timer enabled/disabled by user software

// FOSC
#pragma config POSCMD = NONE    // Primary Oscillator Mode Select bits->Primary Oscillator disabled
#pragma config OSCIOFNC = ON    // OSC2 Pin Function bit->OSC2 is general purpose digital I/O pin
#pragma config IOL1WAY = OFF    // Peripheral pin select configuration->Allow multiple reconfigurations
#pragma config FCKSM = CSDCMD    // Clock Switching Mode bits->Both Clock switching and Fail-safe Clock Monitor are disabled

// FOSCSEL
#pragma config FNOSC = FRCPLL    // Oscillator Source Selection->Fast RC Oscillator with divide-by-N with PLL module (FRCPLL)
#pragma config IESO = ON    // Two-speed Oscillator Start-up Enable bit->Start up device with FRC, then switch to user-selected oscillator source

// FGS
#pragma config GWRP = OFF    // General Segment Write-Protect bit->General Segment may be written
#pragma config GCP = OFF    // General Segment Code-Protect bit->General Segment Code protect is Disabled

#include "mcc.h"

bool SYSTEM_ResetCauseFromSoftware(uint16_t resetCause);
bool SYSTEM_ResetCauseFromWatchdogTimer(uint16_t resetCause);
bool SYSTEM_ResetCauseFromConfigurationMismatch(uint16_t resetCause);
bool SYSTEM_ResetCauseFromIllegalOpcode(uint16_t resetCause);
bool SYSTEM_ResetCauseFromExternal(uint16_t resetCause);
bool SYSTEM_ResetCauseFromTrap(uint16_t resetCause);
void SYSTEM_ResetCauseClear(RESET_MASKS resetFlagMask);


void SYSTEM_Initialize(void)
{
    PIN_MANAGER_Initialize();
    OSCILLATOR_Initialize();
    INTERRUPT_Initialize();
    SPI2_Initialize();
    UART1_Initialize();
    ADC1_Initialize();
    TMR2_Initialize();
    CORCON_ModeOperatingSet(CORCON_MODE_PORVALUES);
}

void OSCILLATOR_Initialize(void)
{
    // CF no clock failure; NOSC FRCPLL; CLKLOCK unlocked; OSWEN Switch is Complete; 
    __builtin_write_OSCCONL((uint8_t) (0x0100 & 0x00FF));
    // FRCDIV FRC/1; PLLPRE 4; DOZE 1:8; PLLPOST 1:8; DOZEN disabled; ROI disabled; 
    CLKDIV = 0x30C2;
    // TUN Center frequency; 
    OSCTUN = 0x0000;
    // ROON disabled; ROSEL disabled; RODIV Base clock value; ROSSLP disabled; 
    REFOCON = 0x0000;
    // PLLDIV 137; 
    PLLFBD = 0x0089;
    // RND disabled; SATB disabled; SATA disabled; ACCSAT disabled; 
	CORCONbits.RND = 0;
	CORCONbits.SATB = 0;
	CORCONbits.SATA = 0;
	CORCONbits.ACCSAT = 0;
}

uint16_t SYSTEM_GetResetCause(void)
{
    return RCON;
}

void __attribute__ ((weak)) SYSTEM_ResetCauseHandler(void)
{
    uint16_t resetCause = SYSTEM_GetResetCause();
    if(SYSTEM_ResetCauseFromTrap(resetCause))
    { 
      SYSTEM_ResetCauseClear(RESET_MASK_TRAPR); 
      //Do something 
    }
    if(SYSTEM_ResetCauseFromIllegalOpcode(resetCause))
    { 
      SYSTEM_ResetCauseClear(RESET_MASK_IOPUWR); 
      //Do something 
    }
    if(SYSTEM_ResetCauseFromConfigurationMismatch(resetCause))
    { 
      SYSTEM_ResetCauseClear(RESET_MASK_CM); 
      //Do something 
    }
    if(SYSTEM_ResetCauseFromExternal(resetCause))
    { 
      SYSTEM_ResetCauseClear(RESET_MASK_EXTR); 
      //Do something 
    }
    if(SYSTEM_ResetCauseFromSoftware(resetCause))
    { 
      SYSTEM_ResetCauseClear(RESET_MASK_SWR); 
      //Do something 
    }
    if(SYSTEM_ResetCauseFromWatchdogTimer(resetCause))
    { 
      SYSTEM_ResetCauseClear(RESET_MASK_WDTO); 
      //Do something 
    }
}

bool SYSTEM_ResetCauseFromTrap(uint16_t resetCause)
{
    bool resetStatus = false;
    if(resetCause & RESET_MASK_TRAPR)
    { 
      resetStatus = true; 
    }
    return resetStatus;
}

bool SYSTEM_ResetCauseFromIllegalOpcode(uint16_t resetCause)
{
    bool resetStatus = false;
    if(resetCause & RESET_MASK_IOPUWR)
    { 
      resetStatus = true; 
    }
    return resetStatus;
}

bool SYSTEM_ResetCauseFromConfigurationMismatch(uint16_t resetCause)
{
    bool resetStatus = false;
    if(resetCause & RESET_MASK_CM)
    { 
      resetStatus = true; 
    }
    return resetStatus;
}

bool SYSTEM_ResetCauseFromExternal(uint16_t resetCause)
{
    bool resetStatus = false;
    if(resetCause & RESET_MASK_EXTR)
    { 
      resetStatus = true; 
    }
    return resetStatus;
}

bool SYSTEM_ResetCauseFromSoftware(uint16_t resetCause)
{
    bool resetStatus = false;
    if(resetCause & RESET_MASK_SWR)
    { 
      resetStatus = true; 
    }
    return resetStatus;
}

bool SYSTEM_ResetCauseFromWatchdogTimer(uint16_t resetCause)
{
    bool resetStatus = false;
    if(resetCause & RESET_MASK_WDTO)
    { 
      resetStatus = true;
    }
    return resetStatus;
}

void SYSTEM_ResetCauseClear(RESET_MASKS resetFlagMask)
{ 
     RCON = RCON & (~resetFlagMask); 
} 

void SYSTEM_ResetCauseClearAll()
{ 
    RCON = 0x00; 
}