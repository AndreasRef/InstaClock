PImage[] imgs;

int nFiles = 0;

void setup() {
  size(400, 100);
  
  imgs = new PImage[100];
  //loadFiles();
}

void draw() {
  background(200);
  for (int i = 0; i< nFiles; i++) {
   image(imgs[i], i*100, 0, 100, 100); 
  }
  
  if (frameCount%100 == 0) {
   checkForNewFiles(); 
  }
}


void checkForNewFiles () {
    String path = sketchPath();
    String[] filenames = listFileNames(path+"/data/", txtFilter);
    printArray(filenames);
    
    println();
    println(filenames.length + " frameCount: " + frameCount);
    
    if (nFiles != filenames.length) {
      loadFiles();
    }
    nFiles = filenames.length;
    
}

void loadFiles() {
  String path = sketchPath();
  String[] filenames = listFileNames(path+"/data/", txtFilter);
  
  for (int i = 0; i < filenames.length; i++) {
    imgs[i] = loadImage(filenames[i]);
  }
  printArray(imgs);
  
}


// let's set a filter (which returns true if file's extension is .jpg or .png)
java.io.FilenameFilter txtFilter = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    //return name.toLowerCase().endsWith(".jpg");
    return name.matches("(?i).*\\.(jpg|png)$");
  }
};


String[] listFileNames(String dir, java.io.FilenameFilter extension) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list(extension);
    return names;
  } else {
    return null;
  }
}
