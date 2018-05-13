module HuffmanNodeP {
  provides interface HuffmanNode;
  uses{
    interface HuffmanGroup;
  }
}
implementation {
  command TreeNode * HuffmanNode.createNYT_TreeNode(){
    TreeNode * node;

    node = (TreeNode*)malloc(sizeof(TreeNode));
    node->group = (Group*)malloc(sizeof(Group));

    node->huffmanCode = 0;
    node->flag = NYT_NODE;
    node->weight = 0;
    node->l_child = NULL;
    node->r_child = NULL;
    node->group->number = -1;

    return node;
}

  command TreeNode * HuffmanNode.createNRM_TreeNode(int8_t diff){
    TreeNode * node;

    node = malloc(sizeof(TreeNode));

    node->huffmanCode = 0;
    node->flag = NRM_NODE;
    node->weight = 1;
    node->l_child = 0;
    node->r_child = 0;
    node->group = call HuffmanGroup.fromDiffToGroup(diff);

    return node;
  }
}
