configuration HuffmanNodeC{
  provides interface HuffmanNode;
}
implementation{
  components HuffmanNodeP as Node;
  HuffmanNode = Node;

  components HuffmanGroupC as Group;
  Node.HuffmanGroup -> Group.HuffmanGroup;
}
