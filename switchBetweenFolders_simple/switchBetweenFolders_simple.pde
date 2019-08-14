import java.util.Date;

PImage[][] imgs;

void setup() {
  size(400,200);
  imgs = new PImage[2][10];
  
  // Using just the path of this sketch to demonstrate,
  // but you can list any directory you like.
  String path = sketchPath() + "/data";

  println("Listing all filenames in a directory: ");
  String[] filenames = listFileNames(path);
  printArray(filenames);
  
  //Messy way to try to avoid .DS_Store. This should be filtered out instead
  int nSubfolders = 0;

  println("\nListing info about all files in a directory: ");
  File[] files = listFiles(path);
  for (int i = 0; i < files.length; i++) {
    File f = files[i];    
    println("Name: " + f.getName());
    println("Is directory: " + f.isDirectory());
    
    
    if (f.isDirectory()) {
      println("here we load stuff!");
      String[] subDirectoryFiles = listFileNamesWithFilter(path+"/"+f.getName(), imageFilter);
      println(path+"/"+f.getName());
      printArray(subDirectoryFiles);
      
      for (int j = 0; j < subDirectoryFiles.length; j++) {
        imgs[nSubfolders][j] = loadImage(f.getName() +"/" + subDirectoryFiles[j]);
        println(f.getName() +"/" + subDirectoryFiles[j]);
        //File imgFile = subDirectoryFiles[j];    
        //println("Name: " + imgFile.getName());
      }
      
      nSubfolders++;
    }
    println("----------------------- \n");
    
    
  }

  /*
  println("\nListing info about all files in a directory and all subdirectories: ");
  ArrayList<File> allFiles = listFilesRecursive(path);

  for (File f : allFiles) {
    println("Name: " + f.getName());
    println("Full path: " + f.getAbsolutePath());
    println("Is directory: " + f.isDirectory());
    println("Size: " + f.length());
    String lastModified = new Date(f.lastModified()).toString();
    println("Last Modified: " + lastModified);
    println("-----------------------");
  }
  */
  
  //imgs[0][0] = loadImage("set_moviescreen_countdown/8.jpg");
  printArray(imgs[0][1]);

  noLoop();
}

// Nothing is drawn in this program and the draw() doesn't loop because
// of the noLoop() in setup()
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


/*
// Function to get a list of all files in a directory and all subdirectories
ArrayList<File> listFilesRecursive(String dir) {
  ArrayList<File> fileList = new ArrayList<File>(); 
  recurseDir(fileList, dir);
  return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList<File> a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a, subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}
*/
