
module HuffmanGroupP {
  provides interface HuffmanGroup;
}
implementation {
  const uint8_t GROUP0[1] = {0};
  const uint8_t GROUP1[1] = {1};
  const uint8_t GROUP2[2] = {2,3};
  const uint8_t GROUP3[4] = {4,5,6,7};
  const uint8_t GROUP4[8] = {8,9,10,11,12,13,14,15};
  const uint8_t GROUP5[16] = {16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31};
  const uint8_t GROUP6[32] = {32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,
                              48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63};
  const uint8_t GROUP7[64] =  {64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,
                                80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,
                                95,96,97,98,99,100,101,102,103,104,105,106,107,
                                108,109,110,111,112,113,114,115,116,117,118,
                                119,120,121,122,123,124,125,126,127};

  const uint8_t SIZE[] = {1, 1, 2, 4, 8, 16, 32};

  const uint8_t *GROUPS[] = {GROUP0, GROUP1, GROUP2, GROUP3, GROUP4, GROUP5, GROUP6, GROUP7};

  bool check(uint8_t diff, const uint8_t group[], uint8_t size){
    uint8_t i;
    for(i = 0; i < size; i++){
      if(diff == group[i]) return TRUE;
    }
    return FALSE;
  }

  uint8_t absFloat(int8_t diff){
    if(diff >= 0)
    return diff;
    else
    return -diff;
  }

  command Group* HuffmanGroup.fromDiffToGroup(int8_t diff) {
    Group * g = malloc(sizeof(Group));
    uint8_t Diff = absFloat(diff);
    uint8_t i;

    for (i =0; i < GROUP_COUNT; i++){
      if(check(Diff, GROUPS[i], SIZE[i]) == TRUE){
        g->number = i;
        g->size = SIZE[i];
        break;
      }
    }

    return g;
  }

  const uint8_t *getGroupByNumber(uint8_t number){
    return GROUPS[number];
  }

  command uint8_t HuffmanGroup.getDataByIndex(uint8_t index, Group *g){
    const uint8_t *group = getGroupByNumber(g->number);

    if(index < g->size){
      return -group[index];
    }
    else{
      return group[index - g->size];
    }
  }

  command uint8_t HuffmanGroup.getIndexByData(Group * g, int8_t diff){
    const uint8_t *group = getGroupByNumber(g->number);
    uint8_t i;
    uint8_t data = absFloat(diff);

    for (i = 0; i < g->size; i++) {
      if (data == group[i]) {
        return i;
      }
    }

    return -1;
  }

  command uint8_t HuffmanGroup.getGroupBinaryLength(Group * g){
    uint8_t i, length = 1, size = g->size;

    for (i = 0; i < 8; i++){
      if(size & 0x01){
        return ++length;
      }
      size >>= 1;
      length++;
    }

    return 0;
  }
}
