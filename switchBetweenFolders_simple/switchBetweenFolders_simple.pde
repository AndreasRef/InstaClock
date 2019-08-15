import java.util.Date;

PImage[][] imgs;

void setup() {
  size(400,200);
  imgs = new PImage[2][10];
  
  String path = sketchPath() + "/data";

  println("Listing all filenames in a directory: ");
  String[] filenames = listFileNames(path);
  printArray(filenames);
  
  int nSubfolders = 0; //Quick way to try to avoid .DS_Store and other annoying irrelevant files. This could be filtered out in a more clever way instead.

  println("\nLets check if a file is a directory: ");
  File[] files = listFiles(path);
  for (int i = 0; i < files.length; i++) {
    File f = files[i];    
    println("Name: " + f.getName());
    println("Is directory: " + f.isDirectory());
    
    if (f.isDirectory()) {
      println("path to directory: " + path+"/"+f.getName());
      println("What files are inside this directory (filtered to only look for png+jpg):");
      String[] subDirectoryFiles = listFileNamesWithFilter(path+"/"+f.getName(), imageFilter);
      printArray(subDirectoryFiles);
      
      println("loading images into array: ");
      for (int j = 0; j < subDirectoryFiles.length; j++) {
        imgs[nSubfolders][j] = loadImage(f.getName() +"/" + subDirectoryFiles[j]);
        print("[" + nSubfolders + "]" + "[" + j + "]  "); 
      }
      println("\n\nLets make sure that images are loaded correctly");
      printArray(imgs[nSubfolders]);
      nSubfolders++;
    }
    println("\n----------------------- \n");   
  }
  noLoop();
}

void draw() {
  for (int i = 0; i<10; i++) {
    for (int j = 0; j<2; j++) {
      image(imgs[j][i], i*width/10, j*height/2, width/10, height/2);
    }
  }
}

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// let's set a filter (which returns true if file's extension is .jpg or .png)
java.io.FilenameFilter imageFilter = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    //return name.toLowerCase().endsWith(".jpg");
    return name.matches("(?i).*\\.(jpg|png)$");
  }
};

String[] listFileNamesWithFilter(String dir, java.io.FilenameFilter extension) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list(extension);
    return names;
  } else {
    return null;
  }
}
