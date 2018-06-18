#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#pragma once

#define ADC1_ISR_FUNCTION_HEADER    void __attribute__((interrupt, no_auto_psv)) _AD1Interrupt

typedef enum 
{
    ADC1_CHANNEL_AN0 =  0x0,
    ADC1_CHANNEL_AN1 =  0x1,
    ADC1_CHANNEL_CTMU_TEMP =  0x1E,
    ADC1_CHANNEL_CTMU =  0x1F,
    ADC1_MAX_CHANNEL_COUNT = 4
} ADC1_CHANNEL;

typedef enum 
{
    ADC1_POS_123_CHANNEL_0 = 0x0,
    ADC1_POS_123_CHANNEL_1 = 0x1
} ADC1_POS_123_CHANNEL;

typedef enum 
{
   ADC1_NEG_123_CHANNEL_0 = 0x0,
   ADC1_NEG_123_CHANNEL_1 = 0x2,
   ADC1_NEG_123_CHANNEL_2 = 0x3
} ADC1_NEG_123_CHANNEL;

typedef enum 
{
    ADC1_FORM_UNSIGNED_INT   = 0, /* Unsigned Integer */
    ADC1_FORM_SIGNED_INT     = 1, /* Signed Integer */
    ADC1_FORM_UNSIGNED_FRACT = 2, /* Unsigned Fraction */
    ADC1_FORM_SIGNED_FRACT   = 3  /* Signed Integer */
} ADC1_FORM_TYPE;

typedef enum 
{
    ADC1_RESOLUTION_10_BIT   = 0, /* 10-bit, 4-channel ADC operation */
    ADC1_RESOLUTION_12_BIT   = 1  /* 12-bit, 1-channel ADC operation */
} ADC1_RESOLUTION_TYPE;

typedef enum 
{
    ADC1_SAMPLING_SOURCE_MANUAL  =  0x0,
    ADC1_SAMPLING_SOURCE_TMR3  =  0x2,
    ADC1_SAMPLING_SOURCE_AUTO  =  0x7,
    ADC1_SAMPLING_SOURCE_CTMU  =  0x6,
    ADC1_SAMPLING_SOURCE_TMR5  =  0x4,
    ADC1_SAMPLING_SOURCE_PTGO13  =  0x4,
    ADC1_SAMPLING_SOURCE_PTGO14  =  0x5,
    ADC1_SAMPLING_SOURCE_PTGO15  =  0x6,
    ADC1_SAMPLING_SOURCE_PTGO12  =  0x3,
    ADC1_SAMPLING_SOURCE_INT0  =  0x1,
} ADC1_SAMPLING_SOURCE;

typedef enum 
{
    ADC1_CONVERSION_CHANNELS_CH0    = 0, /* Converts only CH0 */
    ADC1_CONVERSION_CHANNELS_CH01   = 1, /* Converts CH0 and CH1 */
    ADC1_CONVERSION_CHANNELS_CH0123 = 2  /* Converts CH0, CH1, CH2 and CH3 */
} ADC1_CONVERSION_CHANNELS_TYPE;

void ADC1_Initialize (void);

inline static void ADC1_InterruptFlagClear(void) {
   IFS0bits.AD1IF = 0;
}

inline static void ADC1_InterruptEnable(void) {  
   IEC0bits.AD1IE = 1;
}

inline static void ADC1_InterruptDisable(void) {
   IEC0bits.AD1IE = 0;
}

inline static void ADC1_SamplingStart(void) {
   AD1CON1bits.SAMP = 1;
}

inline static void ADC1_SamplingStop(void) {
   AD1CON1bits.SAMP = 0;
}

uint16_t ADC1_ConversionResultBufferGet(uint16_t *buffer);

inline static uint16_t ADC1_Channel0ConversionResultGet(void) {
    return ADC1BUF0;
}

inline static uint16_t ADC1_Channel1ConversionResultGet(void) {
    return ADC1BUF1;
}

inline static uint16_t ADC1_Channel2ConversionResultGet(void) {
    return ADC1BUF2;
}

inline static uint16_t ADC1_Channel3ConversionResultGet(void) {
    return ADC1BUF3;
}

inline static bool ADC1_IsConversionComplete( void ) {
    return AD1CON1bits.DONE; //Wait for conversion to complete   
}

inline static void ADC1_ChannelSelectSet( ADC1_CHANNEL channel ) {
    AD1CHS0bits.CH0SA = channel;
}

inline static uint16_t ADC1_ChannelSelectGet( void ) {
    return AD1CHS0bits.CH0SA ;
}

inline static void ADC1_FormatDataSet( ADC1_FORM_TYPE form ) {
    AD1CON1bits.FORM = form;
}

inline static void ADC1_ResolutionModeSet( ADC1_RESOLUTION_TYPE resolution ) {
    AD1CON1bits.AD12B = resolution;
}

inline static void ADC1_SimultaneousSamplingEnable(void) {
    AD1CON1bits.SIMSAM = 1;
}

inline static void ADC1_SimultaneousSamplingDisble(void) {
    AD1CON1bits.SIMSAM = 0;
}

inline static void ADC1_AutomaticSamplingEnable(void) {
    AD1CON1bits.ASAM = 1;
}

inline static void ADC1_AutomaticSamplingDisable(void) {
    AD1CON1bits.ASAM = 0;
}
/**
  @Summary
    Allows conversion clock prescaler value to be set

  @Description
    This routine is used to allow conversion clock prescaler value to be set manually
  
  @Preconditions
    ADC1_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    None

  @Param
    Pass in required prescaler integer value
  
  @Example
    Refer to ADC1_Initializer(); for an example
 
*/

inline static void ADC1_ConversionClockPrescalerSet(uint8_t prescaler)
{
    AD1CON3bits.ADCS = prescaler - 1;
}
/**
  @Summary
    Allows module to be enabled manually

  @Description
    This routine is used to enable the ADC1 module manually
  
  @Preconditions
    ADC1_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    None

  @Param
    None
  
  @Example
*/

inline static void ADC1_Enable(void)
{
    AD1CON1bits.ADON = 1;
}
/**
  @Summary
    Allows module to be disabled manually

  @Description
    This routine is used to disable the ADC1 module manually
  
  @Preconditions
    ADC1_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    None

  @Param
    None
  
  @Example
*/

inline static void ADC1_Disable(void)
{
    AD1CON1bits.ADON = 0;
}

/**
  @Summary
    Allows selection of a positive 123 channel for conversion

  @Description
    This routine is used to select desired positive 123 channel for conversion.
  
  @Preconditions
    ADC1_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    None

  @Param
    Pass in required channel from the ADC1_POS_123_CHANNEL list
  
  @Example
    Refer to ADC1_Initializer(); for an example
 
*/

inline static void ADC1_Positive123ChannelSelect( ADC1_POS_123_CHANNEL channel )
{
    AD1CHS123 = (AD1CHS123 & 0xFF06) | channel;
}
/**
  @Summary
    Allows selection of a negative 123 channel for conversion

  @Description
    This routine is used to select desired negative 123 channel for conversion.
  
  @Preconditions
    ADC1_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    None

  @Param
    Pass in required channel from the ADC1_NEG_123_CHANNEL list
  
  @Example
    Refer to ADC1_Initializer(); for an example
 
*/

inline static void ADC1_Negative123ChannelSelect( ADC1_NEG_123_CHANNEL channel )
{
    AD1CHS123bits.CH123NA = channel;
}
/**
  @Summary
    Allows selection of conversion channels

  @Description
    This routine is used to select conversion channel for conversion.
  
  @Preconditions
    ADC1_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    None

  @Param
    Pass in required channel from the ADC1_CONVERSION_CHANNELS_TYPE list
  
  @Example
    Refer to ADC1_Initializer(); for an example
 
*/

inline static void ADC1_ConversionChannelsSet( ADC1_CONVERSION_CHANNELS_TYPE channel )
{
    AD1CON2bits.CHPS = channel;
}
/**
  @Summary
    Allows selection of a priority for interrupt

  @Description
    This routine is used to select desired priority for interrupt.
  
  @Preconditions
    ADC1_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    None

  @Param
    Pass in required integer priority value
  
  @Example
    Refer to ADC1_Initializer(); for an example
 
*/

inline static void ADC1_InterruptPrioritySet( uint16_t priorityValue )
{
    _AD1IP = 0x7 & priorityValue;
}
/**
  @Summary
    Polled implementation

  @Description
    This routine is used to implement the tasks for polled implementations.
  
  @Preconditions
    ADC1_Initializer() function should have been 
    called before calling this function.
 
  @Returns 
    None
 
  @Param
    None
 
  @Example
    Refer to ADC1_Initializer(); for an example
    
*/
void ADC1_Tasks(void);