/*To do

- Perhaps only load the files from folders that have a changed number of files
- Flexible array size instead of the hardcoded 100

 */

PImage[][] imgs; 

int firstDigitIndex = 0;
int previousFirstDigit = 0;

int secondDigitIndex = 0;
int previousSecondDigit = 0;

int nFiles = 0;

String path;

void setup() {
  size(800, 400);
  noCursor();
  //path = sketchPath();
  path = "/Users/andreasrefsgaard/Dropbox/instaClockTest";

  imgs = new PImage[10][100];
  noStroke();
  loadFilesInFolders();
}

void draw() {
  int secondDigit = second()%10;
  int firstDigit = floor(second()/10);

  if (previousSecondDigit != secondDigit) {
    secondDigitIndex = floor(random(imgs[secondDigit].length));
  }
  if (previousFirstDigit != firstDigit) {
    firstDigitIndex = floor(random(imgs[firstDigit].length));
  }
  
  if (imgs[firstDigit].length > 0) {
    image(imgs[firstDigit][firstDigitIndex], 0, 0, width/2, height);
  } else {
    fill(0);
    rect(0, 0, width/2, height);
    fill(255, 0 , 0);
    text("No images for " + firstDigit, 100, 100);
  }
  
  if (imgs[secondDigit].length > 0) {
    image(imgs[secondDigit][secondDigitIndex], width/2, 0, width/2, height); //Nullpointer here
  } else {
    fill(0);
    rect(width/2, 0, width/2, height);
    fill(255, 0 , 0);
    text("No images for " + secondDigit, width/2 + 100, 100);
  }


  previousSecondDigit = secondDigit;
  previousFirstDigit = firstDigit;

  //fill(0, 255, 0);
  //text(firstDigit + " " + secondDigit, 10, 10); //Debug text
  if (frameCount % 100 == 0) checkForNewFiles(); 
}


void checkForNewFiles () {
  
    //String path = sketchPath();  
    int howManyFiles = 0;
    
    for (int numbers = 0; numbers < 10; numbers++) {
      String[] filenames = listFileNames(path+"/data/" + numbers, txtFilter);
      //printArray(filenames);
      howManyFiles += filenames.length;
    }
    
    //println("howManyFiles: " + " " + howManyFiles);
    
    if (nFiles != howManyFiles) {
      println("New number of files... Gonna load em!");
      loadFilesInFolders();
    }
    nFiles = howManyFiles;
}




void loadFilesInFolders () {
  
  background(0);
   text("loading new files", 10, 10);
  
  //String path = sketchPath();
  for (int numbers = 0; numbers < 10; numbers++) {
    String[] filenames = listFileNames(path+"/data/" + numbers, txtFilter);
    printArray(filenames);

    PImage[] incImgs = new PImage[filenames.length];
    for (int i = 0; i < incImgs.length; i++) {
      incImgs[i] = loadImage(path+"/data/" + numbers + "/" + filenames[i]);
    }
    imgs[numbers] = incImgs;
  }
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
