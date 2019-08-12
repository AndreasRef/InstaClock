PImage[][] imgs; 

int firstDigitIndex = 0;
int previousFirstDigit = 0;

int secondDigitIndex = 0;
int previousSecondDigit = 0;

int nFiles = 0;

void setup() {
  size(800, 400);

  imgs = new PImage[10][100];

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

  image(imgs[firstDigit][firstDigitIndex], 0, 0, width/2, height);
  image(imgs[secondDigit][secondDigitIndex], width/2, 0, width/2, height);

  previousSecondDigit = secondDigit;
  previousFirstDigit = firstDigit;

  fill(255, 0, 0);
  text(firstDigit + " " + secondDigit, 10, 10);
}


void checkForNewFiles () {
    String path = sketchPath();
    
    int howManyFiles = 0;
    
    for (int numbers = 0; numbers < 10; numbers++) {
      String[] filenames = listFileNames(path+"/data/" + numbers, txtFilter);
      //printArray(filenames);
    
      //println();
      //println(filenames.length + " frameCount: " + frameCount);
      howManyFiles += filenames.length;
    }
    
    println("howManyFiles: " + " " + howManyFiles);
    
    if (nFiles != howManyFiles) {
      println("New number of files... Gonna load em!");
      loadFilesInFolders();
    }
    nFiles = howManyFiles;
}


void mousePressed() {
 checkForNewFiles(); 
}


void loadFilesInFolders () {
  String path = sketchPath();
  for (int numbers = 0; numbers < 10; numbers++) {
    String[] filenames = listFileNames(path+"/data/" + numbers, txtFilter);
    printArray(filenames);

    PImage[] incImgs = new PImage[filenames.length];
    for (int i = 0; i < incImgs.length; i++) {
      incImgs[i] = loadImage(numbers + "/" + filenames[i]);
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
