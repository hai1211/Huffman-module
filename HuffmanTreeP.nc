module HuffmanTreeP {
  provides interface HuffmanTree;
  uses{
    interface HuffmanGroup;
    interface HuffmanNode;
  }
}
implementation {
  size_t strlen(uint8_t *s) {
    size_t i = 0;

    while(1){
      if(s[i] == '\0' && s[i+1] == '\0' && s[i+2] == '\0'){
        break;
      }
      i++;
    }

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
  command TreeNode * HuffmanTree.createEmptyTree(){
    TreeNode * root = call HuffmanNode.createNYT_TreeNode();
    root->huffmanCode = 0;
    root->codeLength = 0;

    return root;
  }

  HuffmanCode * createCode(){
    HuffmanCode * code = malloc(sizeof(HuffmanCode));

    code->value = 0;
    code->size = 0;
    code->next = NULL;
    code->last = code;

    return code;
  }

  void freeCode(HuffmanCode * code){
    HuffmanCode *curr = code, *next = code->next;

    while(next != NULL){
      free(curr);
      curr = next;
      next = curr->next;
    }

    free(curr);
  }

  void addToCode(HuffmanCode * root, uint8_t value, uint8_t length){
    HuffmanCode * code = root->last;
    uint8_t i, tmp = 0x80;

    for (i = 0; i < 8 - length; i++){
      tmp >>= 1;
    }

    for (i = 0; i < length; i++){
      if(code->size >= 8){
        code->next = createCode();
        code = code->next;
        root->last = code;
      }

      code->value <<= 1;
      code->size++;
      if(tmp & value){
        code->value++;
      }
      tmp >>= 1;
    }
  }

  uint8_t * convert(HuffmanCode *root){
    HuffmanCode *tmp = root, *last = root->last;
    uint8_t count = 0;
    uint8_t *code;

    last->value <<= 8 - last->size;

    while(tmp != NULL){
      //printf("Huffmancode: %d\n", tmp->value);
      count++;
      tmp = tmp->next;
    }

    code = malloc(count + 3);
    tmp = root;
    count = 0;
    while(tmp != NULL){
      code[count] = tmp->value;
      tmp = tmp->next;
      count++;
    }

    code[count] = '\0';
    code[count+1] = '\0';
    code[count+2] = '\0';
    //printf("strlen: %d\n", strlen(code));
    //freeCode(root);

    return code;
  }

  void shiftLeft(uint8_t *code, uint8_t length){
    //printf("length: %d\n", length);
    uint8_t buf = 0xFF, i, tmp, codeLength = strlen(code);

    buf <<= 8 - length;
    code[0] <<= length;

    for (i = 1; i < codeLength; i++){
      //toBinary(code);
      tmp = code[i] & buf;
      tmp >>= 8 - length;
      code[i-1] += tmp;
      code[i] <<= length;
    }
  }

  TreeNode * search(TreeNode *root, TreeNode *node) {
    TreeNode *left, *right;
    if (root != NULL) {
      if (root->group->number == node->group->number) {
        return root;
      } else {
        left = search(root->l_child, node);
        if (left != NULL)
          return left;
        right = search(root->r_child, node);
        if (right != NULL)
          return right;
      }
    }

    return NULL;
  }

  TreeNode * search_nyt(TreeNode *root) {
    TreeNode *left, *right;
    if (root != NULL) {
      if (root->flag == NYT_NODE) {
        return root;
      } else {
        left = search_nyt(root->l_child);
        if (left != NULL)
          return left;
        right = search_nyt(root->r_child);
        if (right != NULL)
          return right;
      }
    }

    return NULL;
  }

  void buildCode(TreeNode *root) {
    if (root->l_child) {
      root->l_child->huffmanCode = root->huffmanCode << 1;
      root->l_child->codeLength = root->codeLength + 1;
      buildCode(root->l_child);
    }
    if (root->r_child) {
      root->r_child->huffmanCode = root->huffmanCode << 1;
      root->r_child->huffmanCode++;
      root->r_child->codeLength = root->codeLength + 1;
      buildCode(root->r_child);
    }
  }

  uint8_t traverse(TreeNode *root, uint8_t diff, uint8_t *prefixCode) {
    TreeNode *node;

    node = search(root, call HuffmanNode.createNRM_TreeNode(diff));

    if (node == NULL) {
        node = search_nyt(root);
    }

    *prefixCode = node->huffmanCode;
    return node->codeLength;
  }

  int8_t suffixCode(int8_t diff, int8_t *suffixCode) {
      uint16_t index;
      Group *g = call HuffmanGroup.fromDiffToGroup(diff);
      uint16_t codeLength = call HuffmanGroup.getGroupBinaryLength(g);

      index = call HuffmanGroup.getIndexByData(g, diff);

      if (diff <= 0) {
        *suffixCode = g->size - index - 1;
      }
      if (diff > 0) {
        *suffixCode = g->size + index;
      }

      free(g);
      return codeLength;
  }

  uint8_t ConvertToBCD(int8_t diff, int8_t *BCDCode) {
    *BCDCode = diff;
    return 8;
  }

  void addNode(TreeNode *root, int8_t diff) {
      TreeNode* nyt = call HuffmanNode.createNYT_TreeNode();
      TreeNode* nrm = call HuffmanNode.createNRM_TreeNode(diff);
      TreeNode* temp = search_nyt(root);

      temp->l_child = nyt;
      temp->flag = COMP_NODE;
      temp->weight = -1;
      temp->r_child = nrm;
  }

  uint8_t reBalance_Step(TreeNode *root) {
      TreeNode *upper_node = NULL, *lower_node = NULL;
      uint8_t upper_weight, lower_weight;

      if(root->r_child){
          upper_node = root->r_child;
          upper_weight = upper_node->weight;
      }

      if(root->l_child && root->l_child->r_child){
          lower_node = root->l_child->r_child;
          lower_weight = lower_node->weight;
      }

      if(upper_node && lower_node){
          //printf("upper node & lower node\n");
          if(lower_weight > upper_weight){
              root->r_child = lower_node;
              root->l_child->r_child = upper_node;
              reBalance_Step(root->l_child);
              return 1;
          }
      }

      return 0;
  }

  void reBalance(TreeNode *root) {
    uint8_t count;
    count = reBalance_Step(root);
    while (count != 0) {
        count = reBalance_Step(root);
    }
    buildCode(root);
  }

  uint8_t getDataFromCode(Group * group, uint8_t *code, uint8_t length){
    uint8_t data, tmp = code[0];

    tmp >>= 8 - length;
    printf("tmp: %2x\n", tmp);
    data = call HuffmanGroup.getDataByIndex(tmp, group);
    printf("data: %d\n", data);
    printfflush();

    return data;
  }

  command uint8_t * HuffmanTree.encode(int8_t *data, uint8_t length, TreeNode *root) {
    HuffmanCode * code = createCode();
    TreeNode * temp;
    uint8_t preCode, preCodeLength, sufCodeLength, i;
    int8_t sufCode;

    for (i = 0; i < length; i++) {
      temp = call HuffmanNode.createNRM_TreeNode(data[i]);
      temp = search(root, temp);
      if (temp == NULL) {
          preCodeLength = traverse(root, data[i], &preCode);
          sufCodeLength = ConvertToBCD(data[i], &sufCode);

          addNode(root, data[i]);
          reBalance(root);
      } else {
          preCodeLength = traverse(root, data[i], &preCode);
          sufCodeLength = suffixCode(data[i], &sufCode);

          temp->weight += 1;
          reBalance(root);
      }

      addToCode(code, preCode, preCodeLength);
      addToCode(code, sufCode, sufCodeLength);
    }

    return convert(code);
  }

  command int8_t * HuffmanTree.decode(uint8_t *code, TreeNode *root) {
    TreeNode *currentNode;
    int8_t * dataArray = malloc(10), data_count = 0;
    uint8_t count = 0, codeLength = strlen(code) * 8;
    uint8_t sufCodeLength = 0;

    codeLength = (codeLength == 0)? 8 : codeLength;

    while (count < codeLength){
      currentNode = root;

      if(currentNode->flag == NYT_NODE){
        dataArray[data_count++] = code[0];
        addNode(root, code[0]);
        count += 8;
        shiftLeft(code, 8);
      } else if (currentNode->flag == COMP_NODE){
        if (code[0] == 0 && codeLength - count < 8) break;
        while((code[0] & 0x80) == 0 && currentNode->flag != NYT_NODE){
          currentNode = currentNode->l_child;
          count++;
          shiftLeft(code, 1);
        }

        if (currentNode->flag == NYT_NODE){
          dataArray[data_count++] = code[0];

          addNode(root, code[0]);
          reBalance(root);

          count += 8;
          shiftLeft(code, 8);
        } else if (currentNode->flag == COMP_NODE){
          // Doc ki tu 1

          count++;
          shiftLeft(code, 1);
          currentNode = currentNode->r_child;

          sufCodeLength = call HuffmanGroup.getGroupBinaryLength(currentNode->group);
          dataArray[data_count++] = getDataFromCode(currentNode->group, code, sufCodeLength);

          count += sufCodeLength;
          shiftLeft(code, sufCodeLength);
          currentNode->weight++;
          reBalance(root);
        }
      }
    }
    return dataArray;
  }
}
