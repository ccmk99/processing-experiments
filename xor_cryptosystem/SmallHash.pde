
static class SmallHash
{
  // most likely extremely insecure and
  // has hella collisions but that's okay
  // because this will only be used to 
  // make some mad xor encryption keys
  
  static byte[] digest(String data)
  {
    return digest(data.getBytes());
  }
  
  static byte[] digest(byte[] data)
  {
    BigInteger n = new BigInteger(data.length==0?new byte[]{0}:data);
    final BigInteger one = BigInteger.ONE;
    final BigInteger mask = one.shiftLeft(512).subtract(one);
    for(int i=0;i<1923;i++) {
      n = n.add(n.shiftLeft(1).add(one));
      if(i%1024==0) {
        n = n.and(mask); // to not use up so much memory
      }
    }
    return n.and(mask).toByteArray();
  }
  
}