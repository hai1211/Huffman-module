configuration HuffmanTreeC{
  provides interface HuffmanTree;
}
implementation{
  components HuffmanTreeP as Tree;
  HuffmanTree = Tree;

  components HuffmanGroupC as Group;
  Tree.HuffmanGroup -> Group.HuffmanGroup;

  components HuffmanNodeC as Node;
  Tree.HuffmanNode -> Node.HuffmanNode;
}
