import java.util.Date;
import processing.io.*;

PImage[][][] imgs;
int nSubfolders;

int firstDigitIndex = 0;
int previousFirstDigit = 0;

int secondDigitIndex = 0;
int previousSecondDigit = 0;

int activeSubfolder = 0;

int nFiles = 0;

String path;

void setup() {
  size(800, 400);
  background(0);
  path = sketchPath() + "/data/";
  //path = "/Users/andreasrefsgaard/Dropbox/instaClockTest/sets/";
  imgs = new PImage[10][10][10];

  loadFilesInFolders();
  GPIO.pinMode(26, GPIO.INPUT_PULLUP);
}

void draw() {

  int secondDigit = second()%10;
  int firstDigit = floor(second()/10);

  if (previousSecondDigit != secondDigit) {
    secondDigitIndex = floor(random(imgs[activeSubfolder][secondDigit].length));
    while (imgs[activeSubfolder][secondDigit][secondDigitIndex] == null) {
      secondDigitIndex = floor(random(imgs[activeSubfolder][secondDigit].length));
    }
  }
  if (previousFirstDigit != firstDigit) {
    firstDigitIndex = floor(random(imgs[activeSubfolder][firstDigit].length));
    while (imgs[activeSubfolder][firstDigit][firstDigitIndex] == null) {
      firstDigitIndex = floor(random(imgs[activeSubfolder][firstDigit].length));
    }
  }

  if (imgs[activeSubfolder][firstDigit][firstDigitIndex] != null) {
    //image(imgs[activeSubfolder][firstDigit][firstDigitIndex], 0, 0, width/2, height);
    image(imgs[activeSubfolder][firstDigit][0], 0, 0, width/2, height);
  } else {
    fill(0);
    rect(0, 0, width/2, height);
    fill(255, 0, 0);
    text("No images for " + firstDigit, 100, 100);
  }

  if (imgs[activeSubfolder][secondDigit][secondDigitIndex] != null) {
    //image(imgs[activeSubfolder][secondDigit][secondDigitIndex], width/2, 0, width/2, height); //Nullpointer here
    image(imgs[activeSubfolder][secondDigit][secondDigitIndex], width/2, 0, width/2, height);
  } else {
    fill(0);
    rect(width/2, 0, width/2, height);
    fill(255, 0, 0);
    text("No images for " + secondDigit + "...", width/2 + 100, 100);
  }

  previousSecondDigit = secondDigit;
  previousFirstDigit = firstDigit;


  if (frameCount % 300 == 0) checkForNewFiles(); 

  if (GPIO.digitalRead(26) == GPIO.LOW) {
    activeSubfolder++;
    if (activeSubfolder >= nSubfolders) {
      activeSubfolder = 0;
    }
  }
}

void keyPressed() {
  activeSubfolder++;
  if (activeSubfolder >= nSubfolders) {
    activeSubfolder = 0;
  }
  println(activeSubfolder);
}

void mouseClicked() {
  checkForNewFiles();
}

void checkForNewFiles () {

  println("CHECKING FOR NEW FILES");

  int howManyFiles = 0;

  //nSubfolders = 0; //Quick way to try to avoid .DS_Store and other annoying irrelevant files. This could be filtered out in a more clever way instead.

  println("Listing all filenames in the top directory: ");
  String[] filenames = listFileNames(path);
  filenames = sort(filenames); //Sort alphabetically
  //printArray(filenames);

  println("\nLets check if each file is a directory: ");
  File[] files = listFiles(path);
  for (int i = 0; i < files.length; i++) {
    File f = files[i];    
    //println("Name: " + f.getName());
    //println("Is directory: " + f.isDirectory());

    if (f.isDirectory()) {
      //println("path to directory: " + path + f.getName());

      for (int j = 0; j < 10; j++) {
        String[] subFolderFileNames = listFileNamesWithFilter(path + f.getName() + "/" + j, imageFilter);
        howManyFiles += subFolderFileNames.length;
      }
    }
    //nSubfolders++;
  }
  if (nFiles != howManyFiles) {
    println("New number of files: " + howManyFiles + " ... Gonna load em!");
    loadFilesInFolders();
  } else {
    println("Same number of files... : " + howManyFiles + " Not loading!");
  }
  nFiles = howManyFiles;
}

void loadFilesInFolders() {
  nSubfolders = 0; //Quick way to try to avoid .DS_Store and other annoying irrelevant files. This could be filtered out in a more clever way instead.

  nFiles = 0;

  println("Listing all filenames in the top directory: ");
  String[] filenames = listFileNames(path);
  filenames = sort(filenames); //Sort alphabetically
  printArray(filenames);

  println("\nLets check if each file is a directory: ");
  File[] files = listFiles(path);
  for (int i = 0; i < files.length; i++) {
    File f = files[i];    
    println("Name: " + f.getName());
    println("Is directory: " + f.isDirectory());

    if (f.isDirectory()) {
      println("path to directory: " + path + f.getName());

      for (int j = 0; j < 10; j++) {
        println("What images are inside this directory (filtered to only look for png+jpg):");
        String[] subDirectoryFiles = listFileNamesWithFilter(path + f.getName()+ "/" + j + "/", imageFilter);
        subDirectoryFiles = sort(subDirectoryFiles); //Sort alphabetically
        printArray(subDirectoryFiles);

        nFiles += subDirectoryFiles.length;


        print("loading images into array: ");
        for (int k = 0; k < subDirectoryFiles.length; k++) {
          print("[" + nSubfolders + "]" + "[" + j + "]" + "[" + k + "]  ");
          imgs[nSubfolders][j][k] = loadImage(path + f.getName() +"/" + j + "/" + subDirectoryFiles[k]);
        }

        println("\n\nLets print out the [nSubfolders][j] arrays to see what images are loaded");
        printArray(imgs[nSubfolders][j]);

        println("\n----------------------- \n");
      }

      nSubfolders++;
    }
    println("\n----------------------- \n");
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
