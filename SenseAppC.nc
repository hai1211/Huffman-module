#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration SenseAppC
{
}
implementation {

  components MainC, LedsC, new TimerMilliC(), new SensirionSht11C() as Sensor;
  components PrintfC;
  components SenseC;
  components SerialStartC;
  components HuffmanTreeC;

  SenseC.Boot -> MainC;
  SenseC.Leds -> LedsC;
  SenseC.Timer -> TimerMilliC;
  SenseC.Read -> Sensor.Temperature;
  SenseC.HuffmanTree -> HuffmanTreeC.HuffmanTree;
}
