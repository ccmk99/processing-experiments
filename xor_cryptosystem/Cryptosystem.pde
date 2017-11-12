
static class Cryptosystem
{
  static Console console;
  static int files_encrypted = 0;
  static int files_processed = 0;
  
  static void resetStats()
  {
    files_encrypted = 0;
    files_processed = 0;
  }
  
  static void useConsole(Console console)
  {
    Cryptosystem.console = console;
  }
  
  static void process(File file, byte[] key)
  {
    if(file.isDirectory()) {
      for(File child : file.listFiles()) {
        process(child,key);
      }
      renameFile(file);
    } else {
      processFile(file,key);
    }
  }
  
  static void processFile(File file, byte[] key)
  {
    files_processed++;
    console.append(" \nprocessing file \""+file.getName()+"\"");
    byte[] bin = FileIO.read(file.getAbsolutePath());
    if(bin==null) {
      console.append("read failed.");
      return;
    }
    bin = process(bin,key);
    if(FileIO.write(file.getAbsolutePath(),bin)) {
      renameFile(file);
      files_encrypted++;
    } else {
      console.append("write failed.");
      return;
    }
    console.append("...done.");
  }
  
  static void renameFile(File file)
  {
    String new_name = file.getName();
    int last = new_name.length()-1;
    if(new_name.substring(last).equals("=")) {
      new_name = new String(Base64.getDecoder().decode(new_name.substring(0,last)));
    } else {
      new_name = new String(Base64.getEncoder().encode(new_name.getBytes()))+"=";
    }
    String path = file.getAbsolutePath();
    file.renameTo(new File(path.substring(0,path.length()-file.getName().length())+new_name));
    //console.append("renamed to \""+new_name+"\"");
  }
  
  static byte[] process(byte[] data, byte[] key)
  {
    for(int i=0;i<data.length;i++) {
      data[i] ^= key[i%key.length];
    }
    return data;
  }
  
}