import java.util.Date;

PImage[][][] imgs;
int nSubfolders;

int activeSubfolder = 0;

void setup() {
  size(400,400);
  imgs = new PImage[10][10][10];
  
  nSubfolders = 0; //Quick way to try to avoid .DS_Store and other annoying irrelevant files. This could be filtered out in a more clever way instead.
  
  String path = sketchPath() + "/data";

  println("Listing all filenames in a directory: ");
  String[] filenames = listFileNames(path);
  filenames = sort(filenames); //Sort alphabetically
  printArray(filenames);

  println("\nLets check if a file is a directory: ");
  File[] files = listFiles(path);
  for (int i = 0; i < files.length; i++) {
    File f = files[i];    
    println("Name: " + f.getName());
    println("Is directory: " + f.isDirectory());
    
    if (f.isDirectory()) {
      println("path to directory: " + path+"/"+f.getName());
      
      File[] newFiles = listFiles(path+"/"+f.getName());
      
      
      for (int j = 0; j < newFiles.length; j++) {
        File fNew = newFiles[j];
        println("Name: " + fNew.getName());
        println("Is directory: " + fNew.isDirectory());
        
        if (fNew.isDirectory()) {
          println("What files are inside this directory (filtered to only look for png+jpg):");
          String[] subDirectoryFiles = listFileNamesWithFilter(path+"/" + f.getName()+ "/" +fNew.getName(), imageFilter);
          subDirectoryFiles = sort(subDirectoryFiles); //Sort alphabetically
          printArray(subDirectoryFiles);
          
          println("loading images into array: ");
      for (int k = 0; k < subDirectoryFiles.length; k++) {
        imgs[nSubfolders][j][k] = loadImage(f.getName() +"/" + "/" +fNew.getName() + subDirectoryFiles[k]);
        print("[" + nSubfolders + "]" + "[" + j + "]" + "[" + k + "]  "); 
      }
          
        }
        
        
        
        
        
        
        
          
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
    for (int j = 0; j<nSubfolders; j++) {
      //image(imgs[j][i], i*width/10, j*height/nSubfolders, width/10, height/nSubfolders);
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

// Image filter returns true if file's extension is .jpg or .png
java.io.FilenameFilter imageFilter = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    //return name.toLowerCase().endsWith(".jpg");
    return name.matches("(?i).*\\.(jpg|png)$");
  }
};

// This function returns all the name of imagefiles in a directory as an array of Strings 
String[] listFileNamesWithFilter(String dir, java.io.FilenameFilter extension) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list(extension);
    return names;
  } else {
    return null;
  }
}
