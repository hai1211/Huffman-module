interface HuffmanTree{
  command TreeNode * createEmptyTree();
  command uint8_t * encode(int8_t *data, uint8_t length, TreeNode *root);
  command int8_t * decode(uint8_t *code, TreeNode *root);
}
