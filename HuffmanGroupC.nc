configuration HuffmanGroupC{
  provides interface HuffmanGroup;
}
implementation{
  components HuffmanGroupP;
  HuffmanGroup = HuffmanGroupP;
}
