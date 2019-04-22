import java.util.Arrays;
import java.util.Collections;
import java.util.Random;
import java.util.ArrayList;
import java.util.List;

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
float interval = 17;

//J9 Variables
int version = 15; 
//2 - Binary
//3 - Cellphone
int first = 0;
int second = 0;
int third = 0;
String buttonText;

float xborder=sizeOfInputArea/15;
float yborder=sizeOfInputArea/12-10;

String[] alphabet = {"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m",""};
float[] top = {514.5, 542.2, 569.9, 597.6, 625.3, 653.0, 680.7, 708.4, 736.1, 763.8};
float[] middle = {531.2, 558.9, 586.60004, 614.3, 642.0, 669.7, 697.4, 725.1, 752.80005};
float[] bottom = {545.2, 572.9, 600.60004, 628.3, 656.0, 683.7, 711.4, 739.1};
ArrayList<Float> bigbut = new ArrayList<Float>();
ArrayList<String> bigbutT = new ArrayList<String>();

float[] top1 = {width/2-(5*sizeOfInputArea)/10+13, width/2-(4*sizeOfInputArea)/10+13, width/2-(3*sizeOfInputArea)/10+13, width/2-(2*sizeOfInputArea)/10+13, width/2-sizeOfInputArea/10+15,
      width/2+13, width/2+(sizeOfInputArea)/10+13, width/2+(2*sizeOfInputArea)/10+13, width/2+(3*sizeOfInputArea)/10+13, width/2+(4*sizeOfInputArea)/10+13};
float[] middle1 = {width/2-(4*sizeOfInputArea)/10+2,width/2-(3*sizeOfInputArea)/10+2,width/2-(2*sizeOfInputArea)/10+2,width/2-sizeOfInputArea/10+2,width/2+2,width/2+(sizeOfInputArea)/10+2,
      width/2+(2*sizeOfInputArea)/10+2,width/2+(3*sizeOfInputArea)/10+2,width/2+(4*sizeOfInputArea)/10+2};
float[] bottom1 = {width/2-(4*sizeOfInputArea)/10+16, width/2-(3*sizeOfInputArea)/10+16, width/2-(2*sizeOfInputArea)/10+16, width/2-sizeOfInputArea/10+16, 
      width/2+16,width/2+(sizeOfInputArea)/10+16,width/2+(2*sizeOfInputArea)/10+16};
      

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
  textFont(createFont("Arial", 20)); //set the font to arial 24. Creating fonts is expensive, so make difference sizes once in setup, not draw
  noStroke(); //my code doesn't use any strokes'
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  if (currTrialNum != totalTrialNum) {
    
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
      fill(0, 200, 0);
      rect(600, 600, 200, 200); //draw next button
      fill(255);
      text("NEXT > ", 650, 650); //draw next label
      
      if (version % 3 == 0) {
        //Top Row
        fill(255);
        rect(width/2-sizeOfInputArea/10+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(2*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(3*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(4*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(5*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(2*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(3*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(4*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+40, sizeOfInputArea/13, sizeOfInputArea/13); 
        
        fill(0, 102, 153);
        text("t",width/2-sizeOfInputArea/10+13, height/2-sizeOfInputArea/5+15+40);
        text("r",width/2-(2*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+40); 
        text("e",width/2-(3*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+40); 
        text("w",width/2-(4*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+40); 
        text("q",width/2-(5*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+40); 
        text("y",width/2+13, height/2-sizeOfInputArea/5+15+40); 
        text("u",width/2+(sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+40); 
        text("i",width/2+(2*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+41); 
        text("o",width/2+(3*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+40); 
        text("p",width/2+(4*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+40); 
        
        //Middle Row
        fill(255);
        rect(width/2-sizeOfInputArea/10-8, height/2+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(2*sizeOfInputArea)/10-8, height/2+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(3*sizeOfInputArea)/10-8, height/2+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(4*sizeOfInputArea)/10-8, height/2+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-8, height/2+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(sizeOfInputArea)/10-8, height/2+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(2*sizeOfInputArea)/10-8, height/2+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(3*sizeOfInputArea)/10-8, height/2+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(4*sizeOfInputArea)/10-8, height/2+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        
        fill(0, 102, 153);
        text("f",width/2-sizeOfInputArea/10+2, height/2+37); 
        text("d",width/2-(2*sizeOfInputArea)/10+2, height/2+37); 
        text("s",width/2-(3*sizeOfInputArea)/10+2, height/2+37); 
        text("a",width/2-(4*sizeOfInputArea)/10+2, height/2+37); 
        text("g",width/2+2, height/2+36); 
        text("h",width/2+(sizeOfInputArea)/10+2, height/2+37); 
        text("j",width/2+(2*sizeOfInputArea)/10+2, height/2+36); 
        text("k",width/2+(3*sizeOfInputArea)/10+2, height/2+37); 
        text("l",width/2+(4*sizeOfInputArea)/10+2, height/2+37);  
        
        //Bottom Row
        fill(255);
        rect(width/2-sizeOfInputArea/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(2*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(3*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(4*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13);  
        rect(width/2+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(2*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13);
        fill(255, 50, 0);
        rect(width/2+(3*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        
        fill(0, 102, 153);
        text("v",width/2-sizeOfInputArea/10+16, height/2+sizeOfInputArea/5+16); 
        text("c",width/2-(2*sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16); 
        text("x",width/2-(3*sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16); 
        text("z",width/2-(4*sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16);  
        text("b",width/2+16, height/2+sizeOfInputArea/5+16); 
        text("n",width/2+(sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16); 
        text("m",width/2+(2*sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16); 
      }
    }
    
    if (version%5 == 0) {
      for (int i = 0; i < bigbut.size()/2; i++) {
        fill(200);
        rect(bigbut.get(2*i+1)-xborder,bigbut.get(2*i)-yborder, sizeOfInputArea/6,sizeOfInputArea/6);
        fill(0, 102, 153);
        text(bigbutT.get(i),bigbut.get(2*i+1)+15-xborder, bigbut.get(2*i)+25-yborder); 
      }
    }
    
  }
  else {
    drawWatch();
  }
}

//my terrible implementation you can entirely replace
boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

String closestButton() {
  String ret="";
  float cloose;
  int j=0;
  if (mouseY > height/2-sizeOfInputArea/5+30 && mouseY < height/2+10) {
    System.out.println("Top");
    cloose = abs(mouseX-top[0]);
    for(int i = 1; i < 10; i++) {
      if (cloose > abs(mouseX-top[i])) {
        cloose = abs(mouseX-top[i]);
        j=i;
      }
    }
    ret = alphabet[j];
  }
  else if (mouseY > height/2+10 && mouseY < height/2+sizeOfInputArea/5-10) {
    System.out.println("Middle");
    cloose = abs(mouseX-top[0]);
    for(int i = 1; i < 9; i++) {
      if (cloose > abs(mouseX-middle[i])) {
        cloose = abs(mouseX-middle[i]);
        j=i;
      }
    }
    ret = alphabet[10+j];
  }
  else if (mouseY > height/2+sizeOfInputArea/5-10 && mouseY < height/2+sizeOfInputArea/5+sizeOfInputArea/13+10) {
    System.out.println("Bottom");
    cloose = abs(mouseX-top[0]);
    for(int i = 1; i < 8; i++) {
      if (cloose > abs(mouseX-bottom[i])) {
        cloose = abs(mouseX-bottom[i]);
        j=i;
      }
    }
    if (j == 8) {
      currentTyped = currentTyped.substring(0, currentTyped.length() - 1);
      return "";
    }
    ret = alphabet[19+j];
  }
  else {
    ret = " ";
  }
  return ret; 
}

void closestButtons() {
  if (mouseY > height/2-sizeOfInputArea/5+30 && mouseY < height/2+10) {
    System.out.println("Top");
    for(int i = 0; i < 10; i++) {
      if (interval > abs(mouseX-top[i])) {
        bigbut.add(height/2-sizeOfInputArea/5+40);
        bigbut.add(top[i]);
        bigbutT.add(alphabet[i]);
      }
    }
  }
  else if (mouseY > height/2+10 && mouseY < height/2+sizeOfInputArea/5-10) {
    System.out.println("Middle");
    for(int i = 0; i < 9; i++) {
      if (interval > abs(mouseX-middle[i])) {
        bigbut.add((float)height/2+20);
        bigbut.add(middle[i]);
        bigbutT.add(alphabet[i+10]);
      }
    }
  }
  else if (mouseY > height/2+sizeOfInputArea/5-10 && mouseY < height/2+sizeOfInputArea/5+sizeOfInputArea/13+10) {
    System.out.println("Bottom");
    for(int i = 0; i < 8; i++) {
      if (interval > abs(mouseX-bottom[i])) {
        bigbut.add(height/2+sizeOfInputArea/5);
        bigbut.add(bottom[i]);
        bigbutT.add(alphabet[i+19]);
      }
    }
  }
  else {
    currentTyped += " ";
  }
}

//my terrible implementation you can entirely replace
void mousePressed()
{
  if (startTime > 0) {
    //You are allowed to have a next button outside the 1" area
    if (didMouseClick(600, 600, 200, 200)) //check if click is in next button
    {
      nextTrial(); //if so, advance to next trial
    } else {
      System.out.println(mouseX);
      if (version%5 == 0) {
        closestButtons();
      }
      else {
        currentTyped+=closestButton();
      }
    }
  }
}

void mouseReleased()
{
  if (version % 5 == 0) {
    for (int i = 0; i < bigbut.size()/2; i++) {
      if (didMouseClick(bigbut.get(2*i+1)-xborder, bigbut.get(2*i)-yborder, sizeOfInputArea/6,sizeOfInputArea/6)) {
        currentTyped+=bigbutT.get(i);
        if (bigbutT.get(i)==""&&currentTyped.length()>0) {
          currentTyped = currentTyped.substring(0, currentTyped.length() - 1);
        }
      }
    }
  }
  bigbut = new ArrayList<Float>();
  bigbutT = new ArrayList<String>();
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
