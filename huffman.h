#define GROUP_COUNT 8

#define GROUP_0 0
#define GROUP_1 1
#define GROUP_2 2
#define GROUP_3 3
#define GROUP_4 4
#define GROUP_5 5
#define GROUP_6 6
#define GROUP_7 7

// define node type
#define NYT_NODE 10
#define NRM_NODE 11
#define COMP_NODE 12

typedef struct group {
  uint8_t number;
  uint8_t size;
} Group;

typedef struct TreeNode {
  Group * group;
  uint8_t weight;
  uint8_t flag;
  uint8_t codeLength;
  struct TreeNode *l_child;
  struct TreeNode *r_child;
  uint8_t huffmanCode;
} TreeNode;

typedef struct HuffmanCode {
  uint8_t value;
  uint8_t size;
  struct HuffmanCode *next;
  struct HuffmanCode *last;
} HuffmanCode;
