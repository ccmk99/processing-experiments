
static class FileIO
{
  
  static byte[] read(String name)
  {
    try {
      FileInputStream in = new FileInputStream(new File(name));
      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      byte[] buffer = new byte[8192];
      int bytesRead;
      while((bytesRead=in.read(buffer))!=-1) {
        baos.write(buffer,0,bytesRead);
      }
      in.close();
      byte[] bin = baos.toByteArray();
      baos.close();
      return bin;
    } catch(Exception e) {}
    return null;
  }
  
  static boolean write(String name, byte[] data)
  {
    try {
      FileOutputStream out = new FileOutputStream(new File(name));
      out.write(data);
      out.close();
      return true;
    } catch(Exception e) {}
    return false;
  }
  
  static File getUserChosenFile(PApplet applet, File start)
  {
    final JFileChooser fc = new JFileChooser(start);
    fc.setDialogTitle("Select a File or Directory");
    fc.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
    int value = fc.showOpenDialog(applet.frame);
    if(value==JFileChooser.APPROVE_OPTION) {
      return fc.getSelectedFile();
    }
    return null;
  }

}