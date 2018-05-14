#include "Timer.h"
#include "printf.h"
#include "convert.c"
#include "huffman.h"

// sampling frequency in binary milliseconds
#define SAMPLING_FREQUENCY 2000

module SenseC
{
  uses {
    interface Boot;
    interface Leds;
    interface Timer<TMilli>;
    interface Read<uint16_t>;
    interface HuffmanTree;
  }
}
implementation
{
  uint16_t prev_data;
  int16_t sub;
  uint32_t tmp;
  TreeNode *root = NULL;
  TreeNode *root2 = NULL;

  size_t strlen1(const char *s) {
    size_t i;
    printf("%s\n", s);
    for (i = 0; s[i] != '\0'; i++) ;
    return i;
  }

  void toBinary(uint8_t *a)
  {
    uint8_t i, j;

    for(i = 0; i < 4; i++){
      for(j=0x80;j!=0;j>>=1)
        printf("%c",(a[i]&j)?'1':'0');
    }

    printf("\n");
    printfflush();
  }

  event void Boot.booted() {
    call Leds.led2On();
    printf("dsadas\n");
    call Timer.startPeriodic(SAMPLING_FREQUENCY);
  }

  event void Timer.fired()
  {
    int8_t data[5] = {1, 3, 2, 5, 4};
    uint8_t i;
    uint8_t *code;
    int8_t *dataArray;

    if (root == NULL){
      root = call HuffmanTree.createEmptyTree();
    }
    if (root2 == NULL){
      root2 = call HuffmanTree.createEmptyTree();
    }

    code = call HuffmanTree.encode(data, 5, root);

    printf("code %ld\n ", strlen(code));
    toBinary(code);

    dataArray = call HuffmanTree.decode(code, root2);


    for(i = 0; i < 5; i++){
      printf("%d ", dataArray[i]);
    }
    printf("\n");
    printfflush();

    free(code);
    free(dataArray);
  }

  event void Read.readDone(error_t result, uint16_t data)
  {
    sub = data - prev_data;
    if(sub < 0){
      tmp = -sub / 10;
    } else {
      tmp = sub / 10;
    }

    if(tmp < 1){
      printf("nho hon ");
    } else {
      printf("lon hon ");
    }
    //sub = (int32_t)((data - prev_data) * 0.01);

    printf("sub: "); printfFloat(0.01*sub);
    printf("data: "); printfFloat(-39.6 + 0.01*data);
    printf("prev: "); printfFloat(-39.6 + 0.01*prev_data);
    printf("tmp: %ld\n", tmp);

    printfflush();

    if(tmp >= 1)
      prev_data = data;
  }
}
