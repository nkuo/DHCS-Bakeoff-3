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

// ===== NEXT LETTER CODE ===== 
char next_letter_guess;

// ===== NEXT WORD CODE =====
String[] word_guesses = {" ", " ", " "};
float topbuff = sizeOfInputArea/8;
String curr_word;

float xborder=sizeOfInputArea/15+5;
float yborder=sizeOfInputArea/12-10;
int over = 2;

String[] alphabet = {"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m",""};
float[] top = {514.5, 542.2, 569.9, 597.6, 625.3, 653.0, 680.7, 708.4, 736.1, 763.8};
float[] middle = {531.2, 558.9, 586.60004, 614.3, 642.0, 669.7, 697.4, 725.1, 752.80005};
float[] bottom = {545.2, 572.9, 600.60004, 628.3, 656.0, 683.7, 711.4};
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
  watch = loadImage("watchface.png");
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases), new Random()); //randomize the order of the phrases with no seed
  //Collections.shuffle(Arrays.asList(phrases), new Random(100)); //randomize the order of the phrases with seed 100; same order every time, useful for testing
 
  orientation(LANDSCAPE); //can also be PORTRAIT - sets orientation on android device
  size(1280, 720); //Sets the size of the app. You should modify this to your device's native size. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 20)); //set the font to arial 24. Creating fonts is expensive, so make difference sizes once in setup, not draw
  noStroke(); //my code doesn't use any strokes'
  
  //====== AUTOCOMPLETE CODE =====
  wordFreqBase = readWordFreqSource();
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  if (currTrialNum != totalTrialNum) {
    
    background(255); //clear background
    drawWatch(); //draw watch background
    //fill(100);
    //rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea); //input area should be 1" by 1"
  
    if (finishTime!=0)
    {
      fill(128);
      textAlign(CENTER);
      text("Finished", 280, 150);
      return;
    }
    
    if (startTime==0 & mousePressed)
    {
      nextTrial(); //start the trials!
    }
  
    if (startTime!=0)
    {
      /*noStroke();
      rectMode(CENTER);
      fill(255);
      stroke(10);
      rect(textLocation, 90, 600, 150);
      noStroke();
      rectMode(CORNER);*/
      //feel free to change the size and position of the target/entered phrases and next button 
      textAlign(CENTER);
      fill(128);
      text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, textLocation, 50); //draw the trial count
      text("Target:   " + currentPhrase, textLocation, 100); //draw the target string
      text("Entered:  " + currentTyped +"|", textLocation, 140); //draw what the user has entered thus far 
  
      /*//draw very basic next button
      fill(0, 200, 0);
      rect(600, 600, 200, 200); //draw next button
      fill(255);
      text("NEXT > ", 650, 650); //draw next label
      */
      
      if (version % 3 == 0) {
        //rect(width/2 - (1.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, topbuff);
        //rect(width/2 - (0.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, topbuff);
        //rect(width/2 + (0.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, topbuff);
        fill(0, 102, 153);
        text(word_guesses[0], width/2- sizeOfInputArea/3, height/2-sizeOfInputArea/2+sizeOfInputArea/5/2);
        text(word_guesses[1], width/2, height/2-sizeOfInputArea/2+sizeOfInputArea/5/2);
        text(word_guesses[2], width/2 + sizeOfInputArea/3, height/2-sizeOfInputArea/2+sizeOfInputArea/5/2);
 
        /*//Top Row
        fill(255);
        rect(width/2-sizeOfInputArea/10+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(2*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(3*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(4*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(5*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(2*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(3*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(4*sizeOfInputArea)/10+3, height/2-sizeOfInputArea/5+20, sizeOfInputArea/13, sizeOfInputArea/13); 
        
        fill(0, 102, 153);
        text("t",width/2-sizeOfInputArea/10+13, height/2-sizeOfInputArea/5+15+20);
        text("r",width/2-(2*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+20); 
        text("e",width/2-(3*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+20); 
        text("w",width/2-(4*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+20); 
        text("q",width/2-(5*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+20); 
        text("y",width/2+13, height/2-sizeOfInputArea/5+15+20); 
        text("u",width/2+(sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+20); 
        text("i",width/2+(2*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+21); 
        text("o",width/2+(3*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+20); 
        text("p",width/2+(4*sizeOfInputArea)/10+13, height/2-sizeOfInputArea/5+15+20); 
        
        //Middle Row
        fill(255);
        rect(width/2-sizeOfInputArea/10-8, height/2+10, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(2*sizeOfInputArea)/10-8, height/2+10, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(3*sizeOfInputArea)/10-8, height/2+10, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(4*sizeOfInputArea)/10-8, height/2+10, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-8, height/2+10, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(sizeOfInputArea)/10-8, height/2+10, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(2*sizeOfInputArea)/10-8, height/2+10, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(3*sizeOfInputArea)/10-8, height/2+10, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(4*sizeOfInputArea)/10-8, height/2+10, sizeOfInputArea/13, sizeOfInputArea/13); 
        
        fill(0, 102, 153);
        text("f",width/2-sizeOfInputArea/10+2, height/2+27); 
        text("d",width/2-(2*sizeOfInputArea)/10+2, height/2+27); 
        text("s",width/2-(3*sizeOfInputArea)/10+2, height/2+27); 
        text("a",width/2-(4*sizeOfInputArea)/10+2, height/2+27); 
        text("g",width/2+2, height/2+26); 
        text("h",width/2+(sizeOfInputArea)/10+2, height/2+27); 
        text("j",width/2+(2*sizeOfInputArea)/10+2, height/2+26); 
        text("k",width/2+(3*sizeOfInputArea)/10+2, height/2+27); 
        text("l",width/2+(4*sizeOfInputArea)/10+2, height/2+27);  
        
        //Bottom Row
        fill(255);
        rect(width/2-sizeOfInputArea/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(2*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(3*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2-(4*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13);  
        rect(width/2+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13); 
        rect(width/2+(2*sizeOfInputArea)/10+6, height/2+sizeOfInputArea/5, sizeOfInputArea/13, sizeOfInputArea/13);
        fill(200,50,0);
        rect(width/2 - sizeOfInputArea/2+30, height/2+sizeOfInputArea/5+35, sizeOfInputArea-60, sizeOfInputArea/8-10); 
        fill(200);
        rect(width/2 - sizeOfInputArea/2+30, height/2-sizeOfInputArea/5-30, sizeOfInputArea-60, sizeOfInputArea/8-10); 
        fill(0);
        text("backspace",width/2, height/2+sizeOfInputArea/5+55);
        
        fill(0, 102, 153);
        text("v",width/2-sizeOfInputArea/10+16, height/2+sizeOfInputArea/5+16); 
        text("c",width/2-(2*sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16); 
        text("x",width/2-(3*sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16); 
        text("z",width/2-(4*sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16);  
        text("b",width/2+16, height/2+sizeOfInputArea/5+16); 
        text("n",width/2+(sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16); 
        text("m",width/2+(2*sizeOfInputArea)/10+16, height/2+sizeOfInputArea/5+16);
        */
      }
    }
    
    if (version%5 == 0) {
      stroke(10);
      if (bigbut.size() > 3) {
        fill(200);
        rect(bigbut.get(1)-xborder-10,bigbut.get(0)-yborder, sizeOfInputArea/6,sizeOfInputArea/6);
        rect(bigbut.get(3)-xborder+10,bigbut.get(2)-yborder, sizeOfInputArea/6,sizeOfInputArea/6);
        fill(0, 102, 153);
        text(bigbutT.get(0),bigbut.get(1)+12-xborder, bigbut.get(0)+28-yborder); 
        text(bigbutT.get(1),bigbut.get(3)+32-xborder, bigbut.get(2)+28-yborder); 
        
        if (didMouseClick(bigbut.get(1)-xborder-10,bigbut.get(0)-yborder, sizeOfInputArea/6,sizeOfInputArea/6)) {
          fill(250);
        } else {fill(120);}
        rect(width/2-sizeOfInputArea/6,height/2-110,sizeOfInputArea/6,sizeOfInputArea/6);
        if (didMouseClick(bigbut.get(3)-xborder+10,bigbut.get(2)-yborder, sizeOfInputArea/6,sizeOfInputArea/6)) {
          fill(250);
        } else { fill(120); }
        rect(width/2,height/2-110,sizeOfInputArea/6,sizeOfInputArea/6);
        
        fill(0, 102, 153);
        text(bigbutT.get(0),width/2-sizeOfInputArea/6+22,height/2-110+28); 
        text(bigbutT.get(1),width/2+22,height/2-110+28); 
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


void closestButtons() {
  //sizeofInputArea/5 = 55.4
  //sizeOfInputArea/13 = 21.307
  if (mouseY > height/2-sizeOfInputArea/5+8 && mouseY < height/2-2) {
    //System.out.println("Top");
    for(int i = 0; i < 10; i++) {
      if (interval > abs(mouseX-top[i])) {
        bigbut.add(height/2-sizeOfInputArea/5+18);
        bigbut.add(top[i]);
        bigbutT.add(alphabet[i]);
      }
    }
  }
  else if (mouseY >= height/2-2 && mouseY < height/2+43.407) {
    //System.out.println("Middle");
    for(int i = 0; i < 9; i++) {
      if (interval > abs(mouseX-middle[i])) {
        bigbut.add((float)height/2+8);
        bigbut.add(middle[i]);
        bigbutT.add(alphabet[i+10]);
      }
    }
  }
  else if (mouseY >= height/2+43.407 && mouseY < height/2+sizeOfInputArea/5+sizeOfInputArea/13+12) {
    //System.out.println("Bottom");
    for(int i = 0; i < 7; i++) {
      if (interval > abs(mouseX-bottom[i])) {
        bigbut.add(height/2+53.407);
        bigbut.add(bottom[i]);
        bigbutT.add(alphabet[i+19]);
      }
    }
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
      //System.out.println(mouseX);
      if (version%5 == 0) {
        closestButtons();
      }
    }
  }
}

void mouseReleased()
{
  if (startTime > 0) {
    if (version % 5 == 0) {
      if (bigbut.size() == 2) {
        if (didMouseClick(bigbut.get(1)-xborder, bigbut.get(0)-yborder, sizeOfInputArea/6,sizeOfInputArea/6)) {
          currentTyped+=bigbutT.get(0);
          if (bigbutT.get(0)=="" && currentTyped.length()>0) {
            currentTyped = currentTyped.substring(0, currentTyped.length() - 1);
          }
        }
      }
      else if (bigbut.size() ==4){
        if (didMouseClick(bigbut.get(1)-xborder-10,bigbut.get(0)-yborder, sizeOfInputArea/6,sizeOfInputArea/6)) {
          currentTyped+=bigbutT.get(0);
        } else if (didMouseClick(bigbut.get(3)-xborder+10,bigbut.get(2)-yborder, sizeOfInputArea/6,sizeOfInputArea/6)){
          currentTyped+=bigbutT.get(1);
          if (bigbutT.get(1)=="" && currentTyped.length()>0) {
            currentTyped = currentTyped.substring(0, currentTyped.length() - 1);
          }
        }
      }
    }
    if (didMouseClick(width/2 - (1.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, topbuff) && currentTyped.length()>0) {
      currentTyped = currentTyped.substring(0, currentTyped.length() - curr_word.length()-1) + word_guesses[0] + " ";
    } else if (didMouseClick(width/2 - (0.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, topbuff) && currentTyped.length()>0) {
      currentTyped = currentTyped.substring(0, currentTyped.length() - curr_word.length()-1) + word_guesses[1] + " ";
    } else if (didMouseClick(width/2 + (0.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, topbuff) && currentTyped.length()>0) {
      currentTyped = currentTyped.substring(0, currentTyped.length() - curr_word.length()-1) + word_guesses[2] + " ";
    } else if (didMouseClick(width/2 - sizeOfInputArea/2+30, height/2+sizeOfInputArea/5+35, sizeOfInputArea-60, sizeOfInputArea/8-10) && currentTyped.length()>0) {
      currentTyped = currentTyped.substring(0, currentTyped.length() - 1);
    } else if (didMouseClick(width/2 - sizeOfInputArea/2+30, height/2-sizeOfInputArea/5-30, sizeOfInputArea-60, sizeOfInputArea/8-10)){
      currentTyped += " ";
    }
    
    // GUESS THE NEXT LETTER
    if (currentTyped.length() >= 1 && currentTyped.charAt(0) != (char) 32) { // weird edgecase
      String[] words = currentTyped.split(" ");
      curr_word = words[words.length - 1];
      if (currentTyped.charAt(currentTyped.length() - 1) == (char) 32) // space ascii 
        curr_word = "";
    }
    else {
      curr_word = "";
    }
    next_letter_guess = letterGuess(curr_word);
    println(curr_word);
    // NEXT WORD GUESS
    List<WordFreq> words = autoComplete(curr_word);
    if (words.size() >= 1)
      word_guesses[0] = words.get(0).word;
    if (words.size() >= 2)
      word_guesses[1] = words.get(1).word;
    if (words.size() >= 3)
      word_guesses[2] = words.get(2).word;
    
    bigbut = new ArrayList<Float>();
    bigbutT = new ArrayList<String>();
  }
}

void drawWatch()
{
  if (currTrialNum != totalTrialNum) {
    float watchscale = DPIofYourDeviceScreen/138.0;
    pushMatrix();
    translate(width/2, height/2);
    scale(watchscale);
    imageMode(CENTER);
    image(watch, 0, 0);
    popMatrix();
  }
  
  else {
    //pushMatrix();
    fill(100);
    rect(0,0,width, height);
    fill(255);
    text("Trials complete!", 650, 50);
    
    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
    
    text("Total time taken: " + (finishTime - startTime), 650, 100); //output
    text("Total letters entered: " + lettersEnteredTotal, 650, 150); //output
    text("Total letters expected: " + lettersExpectedTotal, 650, 200); //output
    text("Total errors entered: " + errorsTotal, 650, 250); //output    
    text("Raw WPM: " + wpm, 650, 300); //output
    text("Freebie errors: " + freebieErrors, 650, 350); //output
    text("Penalty: " + penalty, 650, 400);
    text("WPM w/ penalty: " + (wpm-penalty), 650, 450); //yes, minus, becuase higher WPM is better
    text("==================", 650, 500);
  }
}

  
//========AUTOCOMPLETE CODE===========
/* 
   Usage: autoComplete(String prefix) returns an ArrayList of WordFreq (sorted by frequency)
   where each WordFreq is a tuple of word (String) and freq (Long) 
*/
String wordFreqSourceFile = "count_1w.txt";
List<WordFreq> wordFreqBase;
  
class WordFreq {
  public final String word;
  public final long freq;
  public WordFreq(String word, long freq) {
    this.word = word;
    this.freq = freq;
  }
  
  public String toString() {
    return String.format("(%s, %d)", word, freq);
  }
}

List<WordFreq> readWordFreqSource() {
  List<WordFreq> wordFreq = new ArrayList<WordFreq>();
  String[] lines = loadStrings(wordFreqSourceFile);
  for (int i = 0 ; i < lines.length; i++) {
    String[] pieces = splitTokens(lines[i]); //CHANGED
    wordFreq.add(new WordFreq(pieces[0], Long.parseLong(pieces[1])));
  }
  return wordFreq;  
}


List<WordFreq> autoComplete(String prefix) {
  if (wordFreqBase == null)
    wordFreqBase = readWordFreqSource();
    
  List<WordFreq> res = new ArrayList<WordFreq>();
  for (WordFreq wf : wordFreqBase) {
    if (wf.word.startsWith(prefix))
      res.add(wf);
  }
  return res;
}
//======== AUTOCOMPLETE END ============

// ======= MOST PROBABLE LETTER ====== //
int getMaxInd(long[] numbers){
  long maxValue = numbers[0];
  int maxInd = 0;
  for(int i=1;i < numbers.length;i++){
    if(numbers[i] > maxValue){
    maxValue = numbers[i];
    maxInd = i;
  }
  }
  return maxInd;
}

char letterGuess(String prefix) {
  // get the list of possible words
  List<WordFreq> possibleWords = autoComplete(prefix);
  // store the frequencies
  long[] letter_freqs = new long[27]; // 26 letters in the alphabet plus the space
  
  // length of the prefix (tells me where the next letter is gonna be)
  int len = prefix.length();
    
  // loop through the possible words (given the prefix) and find the most likely character
  for (WordFreq wf : possibleWords) {
    // if the string is at end of the possible word
    if (len == wf.word.length())
      letter_freqs[26] += wf.freq;
      
    else {
      char next_char = wf.word.charAt(len);
      int  ascii = (int) next_char;
      
      // increment the frequency count depending on which char it is
      letter_freqs[ascii - 97] += wf.freq;
    }
  }
  int max = getMaxInd(letter_freqs);
  int ascii_max = max + 97;
  
  if (max == 26)
    return (char) 32;
  
  return (char) ascii_max;
}

// ======= END MOST LIKELY LETTER ======== //

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
