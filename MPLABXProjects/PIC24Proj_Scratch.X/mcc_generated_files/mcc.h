#include <xc.h>
#include "pin_manager.h"
#include <stdint.h>
#include <stdbool.h>
#include "adc1.h"
#include "interrupt_manager.h"
#include "traps.h"
#include "tmr2.h"
#include "spi2.h"
#include "uart1.h"

#pragma once

#define _XTAL_FREQ  32013437UL

/**
  Section: Type defines
 */ 
    
/** 
 * CORCON initialization type enumerator. Supported types:
 * CORCON_MODE_PORVALUES
 * CORCON_MODE_ENABLEALLSATNORMAL_ROUNDBIASED
 * CORCON_MODE_ENABLEALLSATNORMAL_ROUNDUNBIASED
 * CORCON_MODE_DISABLEALLSAT_ROUNDBIASED
 * CORCON_MODE_DISABLEALLSAT_ROUNDUNBIASED
 * CORCON_MODE_ENABLEALLSATSUPER_ROUNDBIASED
 * CORCON_MODE_ENABLEALLSATSUPER_ROUNDUNBIASED
 */
typedef enum tagCORCON_MODE_TYPE
{ 
    CORCON_MODE_PORVALUES   = 0x0020,                       /** Use POR values of CORCON */
    CORCON_MODE_ENABLEALLSATNORMAL_ROUNDBIASED = 0x00E2,    /** Enable saturation for ACCA, ACCB
                                                             *  and Dataspace write, enable normal
                                                             *  ACCA/ACCB saturation mode and set
                                                             *  rounding to Biased (conventional)
                                                             *  mode. Rest of CORCON settings are
                                                             *  set to the default POR values.
                                                             *  */
    CORCON_MODE_ENABLEALLSATNORMAL_ROUNDUNBIASED = 0x00E0,  /** Enable saturation for ACCA, ACCB
                                                             *  and Dataspace write, enable normal
                                                             *  ACCA/ACCB saturation mode and set
                                                             *  rounding to Unbiased (convergent)
                                                             *  mode. Rest of CORCON settings are
                                                             *  set to the default POR values.
                                                             *  */
    CORCON_MODE_DISABLEALLSAT_ROUNDBIASED = 0x0022,         /** Disable saturation for ACCA, ACCB
                                                             *  and Dataspace write and set
                                                             *  rounding to Biased (conventional)
                                                             *  mode. Rest of CORCON settings are
                                                             *  set to the default POR values.
                                                             *  */
    CORCON_MODE_DISABLEALLSAT_ROUNDUNBIASED = 0x0020,       /** Disable saturation for ACCA, ACCB
                                                             *  and Dataspace write and set
                                                             *  rounding to Unbiased (convergent)
                                                             *  mode. Rest of CORCON settings are
                                                             *  set to the default POR values.
                                                             *  */
    CORCON_MODE_ENABLEALLSATSUPER_ROUNDBIASED = 0x00F2,    /** Enable saturation for ACCA, ACCB
                                                             *  and Dataspace write, enable super
                                                             *  ACCA/ACCB saturation mode and set
                                                             *  rounding to Biased (conventional)
                                                             *  mode. Rest of CORCON settings are
                                                             *  set to the default POR values.
                                                             *  */
    CORCON_MODE_ENABLEALLSATSUPER_ROUNDUNBIASED = 0x00F0,  /** Enable saturation for ACCA, ACCB
                                                             *  and Dataspace write, enable super
                                                             *  ACCA/ACCB saturation mode and set
                                                             *  rounding to Unbiased (convergent)
                                                             *  mode. Rest of CORCON settings are
                                                             *  set to the default POR values.
                                                             *  */
} SYSTEM_CORCON_MODES;

/** 
 * RCON error type enumerator. Supported types:
 * ERR_RCON_TRAPR
 * ERR_RCON_IOPUWR
 * ERR_RCON_CM 
 * ERR_RCON_WDTO_ISR
 */
typedef enum tagERROR_TYPE
{
    ERR_RCON_TRAPR      = 1, /** A Trap Conflict Reset has occurred **/
    ERR_RCON_IOPUWR     = 2, /** An illegal opcode detection, an illegal address mode or Uninitialized W register used as an
                             *   Address Pointer caused a Reset **/
    ERR_RCON_CM         = 3, /** A Configuration Mismatch Reset has occurred **/
    ERR_RCON_WDTO_ISR   = 4  /** WDT time-out has occurred **/
}SYSTEM_RESET_TYPES;

/** 
 * RESET CAUSE Masks. Supported masks:
 * RESET_MASK_WDTO
 * RESET_MASK_SWR
 * REST_MASK_EXTR
 * RESET_MASK_CM
 * RESET_MASK_IOPUWR
 * RESET_MASK_TRAPR
 */
typedef enum tagRESET_MASKS
{ 
  RESET_MASK_WDTO = 0x0010,
  RESET_MASK_SWR = 0x0040,
  RESET_MASK_EXTR = 0x0080, 
  RESET_MASK_CM = 0x0200, 
  RESET_MASK_IOPUWR = 0x4000, 
  RESET_MASK_TRAPR = 0x8000, 
} RESET_MASKS;

void SYSTEM_Initialize(void);

void OSCILLATOR_Initialize(void);

uint16_t SYSTEM_GetResetCause(void);

inline static void WDT_WatchdogtimerSoftwareEnable(void) {
    RCONbits.SWDTEN = 1;
}

inline static void WDT_WatchdogtimerSoftwareDisable(void) {
    RCONbits.SWDTEN = 0;
}

inline static void WDT_WatchdogTimerClear(void) {
    ClrWdt();
}

inline static uint32_t DEVICE_DeviceIdRegisterAddressGet(void) {
    return __DEVID_BASE;
}

inline static void CORCON_Initialize() {
    CORCON = (CORCON & 0x00F2) | CORCON_MODE_PORVALUES;    // POR value
}

inline static void CORCON_ModeOperatingSet(SYSTEM_CORCON_MODES modeValue) {
    CORCON = (CORCON & 0x00F2) | modeValue;
}

inline static void CORCON_RegisterValueSet(uint16_t value) {
    CORCON = value;
}

inline static uint16_t CORCON_RegisterValueGet(void) {    
    return CORCON;
}

void __attribute__ ((weak)) SYSTEM_ResetCauseHandler(void);
void SYSTEM_ResetCauseClearAll();