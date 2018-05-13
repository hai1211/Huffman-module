interface HuffmanGroup{
  command Group* fromDiffToGroup(int8_t diff);
  command uint8_t getDataByIndex(uint8_t index, Group *g);
  command uint8_t getGroupBinaryLength(Group * g);
  command uint8_t getIndexByData(Group * g, int8_t diff);
}
