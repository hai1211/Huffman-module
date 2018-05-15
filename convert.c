#include <stdio.h>
#include <stdlib.h>

uint16_t convertHexToDemi(nx_uint16_t temperature){
  int count;
  float realnum;
  //double d = 0, remain = 0, result = 0;
  printf("%u \n", temperature);
  realnum = -39.6 + 0.01 * temperature;
  printf("%u", realnum);
    return -39.6 + 0.01 * temperature;
}

void printfFloat(float toBePrinted) {
     uint32_t fi, f0, f1, f2;
     char c;
     float f = toBePrinted;

     if (f<0){
       c = '-'; f = -f;
     } else {
       c = ' ';
     }

     // integer portion.
     fi = (uint32_t) f;

     // decimal portion...get index for up to 3 decimal places.
     f = f - ((float) fi);
     f0 = f*10;   f0 %= 10;
     f1 = f*100;  f1 %= 10;
     f2 = f*1000; f2 %= 10;
     printf("%c%ld.%d%d%d ", c, fi, (uint8_t) f0, (uint8_t) f1,  (uint8_t) f2);
}
