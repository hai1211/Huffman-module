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
  uint16_t prev_data = 0;

  TreeNode *root = NULL;
  TreeNode *root2 = NULL;

  size_t strlen1(const char *s) {
    size_t i = 0;
    printf("%s\n", s);
    for (i = 0; s[i] != '\0'; i++) ;
    if(i == 0) return 1;
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
    call Timer.startPeriodic(SAMPLING_FREQUENCY);
  }

  event void Timer.fired()
  {
    if (root == NULL){
      root = call HuffmanTree.createEmptyTree();
    } else {
      printf("root | group: %d weight: %d\n", root->r_child->group->number, root->r_child->weight);
    }
    if (root2 == NULL){
      root2 = call HuffmanTree.createEmptyTree();
    } else {
      printf("root2 | group: %d weight: %d\n", root2->r_child->group->number, root2->r_child->weight);
    }

    call Read.read();
  }

  event void Read.readDone(error_t result, uint16_t data)
  {
    uint8_t *code, i;
    int8_t *dataArray;
    int16_t sub = 0;
    int32_t tmp;
    int8_t tempArray[1];

    if (prev_data == 0){
      sub = 0;
      tmp = 0;
      prev_data = data;
    } else {
      sub = data - prev_data;
      tmp = sub / 10;
    }

    printf("sub: "); printfFloat(0.01*sub);
    printf("data: "); printfFloat(-39.6 + 0.01*data);
    printf("prev: "); printfFloat(-39.6 + 0.01*prev_data);
    printf("tmp: %d\n", (int8_t)tmp);

    tempArray[0] = (int8_t)tmp;

    code = call HuffmanTree.encode(tempArray, 1, root);

    printf("code length: %ld\n ", strlen(code));
    toBinary(code);

    dataArray = call HuffmanTree.decode(code, root2);


    for(i = 0; i < 1; i++){
      printf("%d ", dataArray[0]);
    }
    printf("\n\n");
    free(code);
    free(dataArray);

    printfflush();

    if(tmp >= 1)
      prev_data = data;
  }
}
