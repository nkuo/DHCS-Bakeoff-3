import java.util.Arrays;
import java.util.Collections;
import java.util.Random;

String[] phrases; //contains all of the phrases
int totalTrialNum = 2; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 277; //200; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
//http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!
PImage watch;

//J9 Variables
int version = 3; 
//2 - Binary
//3 - Cellphone
int first = 0;
int second = 0;
int third = 0;
String buttonText;

String[] set1 = {"a", "b", "c", "d", "e", "f", "<-", ""};
String[] set2 = {"g", "h", "i", "j", "k", "l", "<-", "m"};
String[] set3 = {"n", "o", "p", "q", "r", "s", "<-", ""};
String[] set4 = {"t", "u", "v", "w", "x", "y", "<-", "z"};
String[] curSet;

//9 Button Code
String[] but9 = {" ","abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

//Location Variables
int textLocation = 1280/2;

//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  watch = loadImage("watchhand3smaller.png");
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases), new Random()); //randomize the order of the phrases with no seed
  //Collections.shuffle(Arrays.asList(phrases), new Random(100)); //randomize the order of the phrases with seed 100; same order every time, useful for testing
 
  orientation(LANDSCAPE); //can also be PORTRAIT - sets orientation on android device
  size(1280, 720); //Sets the size of the app. You should modify this to your device's native size. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 24)); //set the font to arial 24. Creating fonts is expensive, so make difference sizes once in setup, not draw
  noStroke(); //my code doesn't use any strokes
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(255); //clear background
  drawWatch(); //draw watch background
  fill(100);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea); //input area should be 1" by 1"

  if (finishTime!=0)
  {
    fill(128);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(128);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    noStroke();
    rectMode(CENTER);
    fill(255);
    stroke(10);
    rect(textLocation, 90, 600, 150);
    noStroke();
    rectMode(CORNER);
    //feel free to change the size and position of the target/entered phrases and next button 
    textAlign(CENTER);
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, textLocation, 50); //draw the trial count
    fill(128);
    text("Target:   " + currentPhrase, textLocation, 100); //draw the target string
    text("Entered:  " + currentTyped +"|", textLocation, 140); //draw what the user has entered thus far 

    //draw very basic next button
    fill(255, 0, 0);
    rect(600, 600, 200, 200); //draw next button
    fill(255);
    text("NEXT > ", 650, 650); //draw next label
    
    //stroke(255);
    /*if (version % 2 == 0) {
      if (first + second >= 4) {
        //Draw 8 Buttons
        fill(255, 255, 0); //red button
        rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/4); //draw left red button
        rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/4, sizeOfInputArea/2, sizeOfInputArea/4); //draw left red button
        rect(width/2-sizeOfInputArea/2, height/2, sizeOfInputArea/2, sizeOfInputArea/4); //draw left red button
        rect(width/2-sizeOfInputArea/2, height/2+sizeOfInputArea/4, sizeOfInputArea/2, sizeOfInputArea/4); //draw left red button
        fill(0, 255, 255); //red button
        rect(width/2, height/2-sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/4); //draw left red button
        rect(width/2, height/2-sizeOfInputArea/4, sizeOfInputArea/2, sizeOfInputArea/4); //draw left red button
        rect(width/2, height/2, sizeOfInputArea/2, sizeOfInputArea/4); //draw left red button
        rect(width/2, height/2+sizeOfInputArea/4, sizeOfInputArea/2, sizeOfInputArea/4); //draw left red button
        
        textAlign(CENTER);
        fill(200);
        setCur();
        text(curSet[0], width/2-sizeOfInputArea/4, height/2-sizeOfInputArea/2+sizeOfInputArea/8); //draw current letter
        text(curSet[2], width/2-sizeOfInputArea/4, height/2-sizeOfInputArea/4+sizeOfInputArea/8);
        text(curSet[4], width/2-sizeOfInputArea/4, height/2+sizeOfInputArea/8);
        text(curSet[6], width/2-sizeOfInputArea/4, height/2+sizeOfInputArea/4+sizeOfInputArea/8);
        text(curSet[1], width/2+sizeOfInputArea/4, height/2-sizeOfInputArea/2+sizeOfInputArea/8);
        text(curSet[3], width/2+sizeOfInputArea/4, height/2-sizeOfInputArea/4+sizeOfInputArea/8);
        text(curSet[5], width/2+sizeOfInputArea/4, height/2+sizeOfInputArea/8);
        text(curSet[7], width/2+sizeOfInputArea/4, height/2+sizeOfInputArea/4+sizeOfInputArea/8);
      } else {
      //my draw code
        fill(255, 0, 0); //red button
        rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw left red button
        fill(0, 255, 0); //green button
        rect(width/2-sizeOfInputArea/2+sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw right green button
        textAlign(CENTER);
        fill(200);
        setCur();
        text(buttonText, width/2, height/2-sizeOfInputArea/4); //draw current letter
      }
    } else */if (version % 3 == 0) {
      //10, 9, 7
      //Top Row
      fill(255);
      rect(width/2-sizeOfInputArea/10+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(2*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(3*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(4*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(5*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(2*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(3*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(4*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      
      fill(0, 102, 153);
      textSize(20);
      text("t",width/2-sizeOfInputArea/10+13, height/2-sizeOfInputArea/5+15);
      text("r",width/2-(2*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("e",width/2-(3*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("w",width/2-(4*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("q",width/2-(5*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("y",width/2+13, height/2-sizeOfInputArea/5+15); 
      text("u",width/2+(sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("i",width/2+(2*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("o",width/2+(3*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("p",width/2+(4*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      
      //Middle Row
      fill(255);
      rect(width/2-sizeOfInputArea/10-8, height/2, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(2*sizeOfInputArea)/10-8, height/2, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(3*sizeOfInputArea)/10-8, height/2, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(4*sizeOfInputArea)/10-8, height/2, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-8, height/2, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(sizeOfInputArea)/10-8, height/2, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(2*sizeOfInputArea)/10-8, height/2, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(3*sizeOfInputArea)/10-8, height/2, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(4*sizeOfInputArea)/10-8, height/2, sizeOfInputArea/13, sizeOfInputArea/13); 
      
      fill(0, 102, 153);
      textSize(20);
      text("t",width/2-sizeOfInputArea/10+13, height/2-sizeOfInputArea/5+15);
      text("r",width/2-(2*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("e",width/2-(3*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("w",width/2-(4*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("q",width/2-(5*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("y",width/2+13, height/2-sizeOfInputArea/5+15); 
      text("u",width/2+(sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("i",width/2+(2*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("o",width/2+(3*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      text("p",width/2+(4*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15); 
      
      //Middle Row
      fill(255);
      rect(width/2-sizeOfInputArea/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(2*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(3*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2-(4*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13);  
      rect(width/2+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(2*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
      rect(width/2+(3*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
    }
    
  }
}

void setCur() {
  if (first == 0) {
    buttonText = "<- A-M N-Z ->";
  } else if (second == 0) {
    if (first == 1) {
      buttonText = " <- A-F G-M ->";
    } else {
      buttonText = " <- N-S T-Z ->";
    }
  } else if (first == 1 && second == 3) {
    curSet = set1;
  } else if (first == 1 && second == 4) {
    curSet = set2;
  } else if (first == 2 && second == 3) {
    curSet = set3;
  } else if (first == 2 && second == 4) {
    curSet = set4;
  }
}

//my terrible implementation you can entirely replace
boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

//my terrible implementation you can entirely replace
void mousePressed()
{
  if (first + second < 4) {
    if (didMouseClick(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in left button
    {
      if (first == 0) {
        first = 1;
      } else if (second == 0) {
        System.out.println("Made it Here");
        second = 3;
      }
    }
  
    if (didMouseClick(width/2-sizeOfInputArea/2+sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in right button
    {
      if (first == 0) {
        first = 2;
      } else if (second == 0) {
        System.out.println("Made it Here");
        second = 4;
      }
    }
    
    if (didMouseClick(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea/2)) //check if click occured in letter area
    {
      currentTyped+=" ";
      first = 0;
      second = 0;
      third = 0;
    }
    
  } else {
    //8 Button Code
    if (didMouseClick(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/4)) {
      currentTyped+=curSet[0];
      first = 0;
      second = 0;
      third = 0;
    }
    if (didMouseClick(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/4, sizeOfInputArea/2, sizeOfInputArea/4)) {
      currentTyped+=curSet[2];
      first = 0;
      second = 0;
      third = 0;
    }
    if (didMouseClick(width/2-sizeOfInputArea/2, height/2, sizeOfInputArea/2, sizeOfInputArea/4)) {
      currentTyped+=curSet[4];
      first = 0;
      second = 0;
      third = 0;
    }
    if (didMouseClick(width/2-sizeOfInputArea/2, height/2+sizeOfInputArea/4, sizeOfInputArea/2, sizeOfInputArea/4)) {
      //currentTyped+=curSet[6];
      first = 0;
      second = 0;
      third = 0;
    }
    if (didMouseClick(width/2, height/2-sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/4)) {
      currentTyped+=curSet[1];
      first = 0;
      second = 0;
      third = 0;
    }
    if (didMouseClick(width/2, height/2-sizeOfInputArea/4, sizeOfInputArea/2, sizeOfInputArea/4)) {
      currentTyped+=curSet[3];
      first = 0;
      second = 0;
      third = 0;
    }
    if (didMouseClick(width/2, height/2, sizeOfInputArea/2, sizeOfInputArea/4)) {
      currentTyped+=curSet[5];
      first = 0;
      second = 0;
      third = 0;
    }
    if (didMouseClick(width/2, height/2+sizeOfInputArea/4, sizeOfInputArea/2, sizeOfInputArea/4)) {
      currentTyped+=curSet[7];
      first = 0;
      second = 0;
      third = 0;      
    }
   
  }

  //You are allowed to have a next button outside the 1" area
  if (didMouseClick(600, 600, 200, 200)) //check if click is in next button
  {
    nextTrial(); //if so, advance to next trial
  }
}


void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

  if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.trim().length();
    lettersEnteredTotal+=currentTyped.trim().length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  //probably shouldn't need to modify any of this output / penalty code.
  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output

    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
    
    System.out.println("Raw WPM: " + wpm); //output
    System.out.println("Freebie errors: " + freebieErrors); //output
    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
    System.out.println("==================");

    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  } 
  else
    currTrialNum++; //increment trial number

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}


void drawWatch()
{
  float watchscale = DPIofYourDeviceScreen/138.0;
  pushMatrix();
  translate(width/2, height/2);
  scale(watchscale);
  imageMode(CENTER);
  image(watch, 0, 0);
  popMatrix();
}





//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}
