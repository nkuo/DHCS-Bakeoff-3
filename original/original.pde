import java.util.Arrays;
import java.util.Collections;
import java.util.Random;
import java.util.List;
import java.util.ArrayList;
import java.lang.Long;


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

//Location Variables
int textLocation = 1280/2; //70;

// ===== NEXT LETTER CODE ===== 
char next_letter_guess;

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
  
  //====== AUTOCOMPLETE CODE =====
  wordFreqBase = readWordFreqSource();
  //====== NINEKEYS========
  nineExtensionsSetup();
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  String[] words = currentTyped.split(" ");
  String curr_word = words[words.length - 1];
  next_letter_guess = letterGuess(curr_word);
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
    text("Click to start time!", textLocation, 90); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    rectMode(CENTER);
    fill(255);
    stroke(10);
    rect(textLocation, 90, 600, 150);
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
    
    drawInputUI();
  }
}

void mousePressed()
{
  mousePressedUI();
  //fill(255);
  //rect(0,0,75,100);
  //fill(0);
  //text(String.format("%d, %d", mouseX, mouseY), 50, 50);

  //You are allowed to have a next button outside the 1" area
  if (didMouseClick(600, 600, 200, 200)) //check if click is in next button
  {
    System.out.println(autoComplete(currentTyped));
    nextTrial(); //if so, advance to next trial
  }
}

void mouseClicked() {
  mouseClickedUI();
  //fill(0);
  //text(String.format("%d, %d", mouseX, mouseY), 50, 100);
}
  

void mouseDragged() { // might be useful for 
  //System.out.println(mouseX + " " + mouseY);
}

//my terrible implementation you can entirely replace
boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

void drawInputUI() {
  //scaffoldDrawInputUI();
  nineExtensionUI();
}

void mousePressedUI() {
  //scaffoldInputCheck();
  nineExtensionClicked();
}

void mouseClickedUI() {
  
}

//========NineExtensionCode=======
ArrayList<ArrayList<Character>> nineKeys = new ArrayList<ArrayList<Character>>();
ArrayList<ArrayList<Integer>> ninePos = new ArrayList<ArrayList<Integer>>();
float cornerX;
float cornerY;
float totalX;
float totalY;
int rows;
int cols;

int clicked = -1;

void nineExtensionsSetup() {
  nineKeys.add(new ArrayList<Character>(Arrays.asList('a','b','c')));
  nineKeys.add(new ArrayList<Character>(Arrays.asList('d','e','f')));
  nineKeys.add(new ArrayList<Character>(Arrays.asList('g','h','i')));
  nineKeys.add(new ArrayList<Character>(Arrays.asList('j','k','l')));
  nineKeys.add(new ArrayList<Character>(Arrays.asList('m','n','o')));
  nineKeys.add(new ArrayList<Character>(Arrays.asList('p','q','r')));
  nineKeys.add(new ArrayList<Character>(Arrays.asList('s','t','u')));
  nineKeys.add(new ArrayList<Character>(Arrays.asList('v','w','x')));
  nineKeys.add(new ArrayList<Character>(Arrays.asList('y','z')));
  
  /*
  ninePos.add(new ArrayList<Integer>(Arrays.asList(3,4,1)));
  ninePos.add(new ArrayList<Integer>(Arrays.asList(0,4,2)));
  ninePos.add(new ArrayList<Integer>(Arrays.asList(1,4,5)));
  ninePos.add(new ArrayList<Integer>(Arrays.asList(0,4,6)));
  ninePos.add(new ArrayList<Integer>(Arrays.asList(3,1,5)));
  ninePos.add(new ArrayList<Integer>(Arrays.asList(2,4,8)));
  ninePos.add(new ArrayList<Integer>(Arrays.asList(3,4,7)));
  ninePos.add(new ArrayList<Integer>(Arrays.asList(6,4,8)));
  ninePos.add(new ArrayList<Integer>(Arrays.asList(7,5)));
  */
    
  cornerX = width/2-sizeOfInputArea/2;
  cornerY = height/2-sizeOfInputArea/2+sizeOfInputArea/5;
  totalX = sizeOfInputArea;
  totalY = sizeOfInputArea*4/5;
  rows = 3;
  cols = 3;
  
  for (int i = 0; i < rows; i++) {
    ArrayList<Integer> indices = new ArrayList<Integer>();
    for (int j = 0; j < cols; j++) {
      indices.add(i*rows+j);
    }
    for (int j = 0; j < cols; j++) {
      ninePos.add(new ArrayList<Integer>(indices));
    }
  }
  ninePos.get(8).remove(0);
}
  
void drawNineSquares(String[] text) {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      float x = cornerX+totalX/cols*j;
      float y = cornerY+totalY/rows*i;
      float w = totalX/cols;
      float h = totalY/rows;
      fill(255);
      rect(x, y, w, h);
      int index = i*rows+j;
      fill(0);
      textAlign(CENTER);
      text(text[index], x+w/2, y+h/2);
    }
  }
}

void nineExtensionUI() {
  
  rectMode(CORNER);
  fill(200);
  stroke(10);
  rect(width/2- (1.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, sizeOfInputArea/5);
  rect(width/2 - (0.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, sizeOfInputArea/5);
  rect(width/2 + (0.5 * sizeOfInputArea/3), height/2 -sizeOfInputArea/2, sizeOfInputArea/3, sizeOfInputArea/5);
  fill(0);
  text("SPACE", width/2- sizeOfInputArea/3, height/2-sizeOfInputArea/2+sizeOfInputArea/5/2);
  text("BACK", width/2, height/2-sizeOfInputArea/2+sizeOfInputArea/5/2);
  text(next_letter_guess, width/2 + sizeOfInputArea/3, height/2-sizeOfInputArea/2+sizeOfInputArea/5/2);
  
  
  String[] text = new String[nineKeys.size()];
  for (int i = 0; i < nineKeys.size(); i++) {
    String currText = "";
    for (int j = 0; j < nineKeys.get(i).size(); j++)
      currText += nineKeys.get(i).get(j) + " ";
    currText = currText.substring(0, currText.length()-1);
    text[i] = currText;
  }
  if (clicked != -1) {
    ArrayList<Integer> indices = ninePos.get(clicked);
    for (int i = 0; i < indices.size(); i++) {
      text[indices.get(i)] = nineKeys.get(clicked).get(i).toString();
    }
  }
  
  drawNineSquares(text);
}

int getCurrClicked() {
  int clicked = -1;
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      float x = cornerX+totalX/cols*j;
      float y = cornerY+totalY/rows*i;
      float w = totalX/cols;
      float h = totalY/rows;
      int index = i*rows+j;
      if (didMouseClick(x,y,w,h))
        clicked = index;
    }
  }
  return clicked;
}

void nineExtensionClicked() {
  int currClicked = getCurrClicked();
  if (didMouseClick(width/2-(1.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, sizeOfInputArea/5)) { //space
    currentTyped += " ";
    return;
  }
  if (didMouseClick(width/2 - (0.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, sizeOfInputArea/5) && currentTyped.length() > 0) { //backspace
    currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    return;
  }
  
  if (didMouseClick(width/2 + (0.5 * sizeOfInputArea/3), height/2-sizeOfInputArea/2, sizeOfInputArea/3, sizeOfInputArea/5)) {
    currentTyped += next_letter_guess;
    return;
  }
  
  if (clicked == -1) { //if none clicked currently
    clicked = getCurrClicked();
  }
  else {
    ArrayList<Integer> indices = ninePos.get(clicked);
    for (int i = 0; i < indices.size(); i++) {
      if (currClicked == indices.get(i)) {
        currentTyped += nineKeys.get(clicked).get(i);
      }
    }
    clicked = -1;
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

/* PRINT ERROR CODE
try {
      wordFreq.add(new WordFreq(pieces[0], Long.parseLong(pieces[1])));
    }
    catch(Exception e) {
      background(255);
      fill(0);
      StackTraceElement[] trace = e.getStackTrace();
      for (int j = 0; j < trace.length; j++)
        text(trace[j].toString(), 10, 250 + j*20);
      text(Arrays.toString(pieces), 10, 400);
      //text(pieces[1], 10, 400);
      break;
    }
    */
    
void printError(Exception e) {
  //try {
  //  CODE
  //}
  //catch (Exception e) {
  //  printError(e);
  //  //break
  //}
  
  background(255);
  fill(0);
  StackTraceElement[] trace = e.getStackTrace();
  for (int j = 0; j < trace.length; j++)
    text(trace[j].toString(), 10, 250 + j*20);
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
int getMaxInd(int[] numbers){
  int maxValue = numbers[0];
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
  int[] letter_freqs = new int[27]; // 26 letters in the alphabet plus the space
  
  // length of the prefix (tells me where the next letter is gonna be)
  int len = prefix.length();
    
  // loop through the possible words (given the prefix) and find the most likely character
  for (WordFreq wf : possibleWords) {
    // if the string is at end of the possible word
    if (len == wf.word.length())
      letter_freqs[26] += 1;
      
    else {
      char next_char = wf.word.charAt(len);
      int  ascii = (int) next_char;
      
      // increment the frequency count depending on which char it is
      letter_freqs[ascii - 97] += 1;
    }
  }
  int max = getMaxInd(letter_freqs);
  int ascii_max = max + 97;
  
  return (char) ascii_max;
}

// ======= END MOST LIKELY LETTER ======== //


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

void scaffoldDrawInputUI() {
  
  //my draw code
  fill(255, 0, 0); //red button
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw left red button
  fill(0, 255, 0); //green button
  rect(width/2-sizeOfInputArea/2+sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw right green button
  textAlign(CENTER);
  fill(200);
  text("" + currentLetter, width/2, height/2-sizeOfInputArea/4); //draw current letter
}

void scaffoldInputCheck() {
  if (didMouseClick(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in left button
  {
    currentLetter --;
    if (currentLetter<'_') //wrap around to z
      currentLetter = 'z';
  }

  if (didMouseClick(width/2-sizeOfInputArea/2+sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in right button
  {
    currentLetter ++;
    if (currentLetter>'z') //wrap back to space (aka underscore)
      currentLetter = '_';
  }

  if (didMouseClick(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea/2)) //check if click occured in letter area
  {
    if (currentLetter=='_') //if underscore, consider that a space bar
      currentTyped+=" ";
    else if (currentLetter=='`' & currentTyped.length()>0) //if `, treat that as a delete command
      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    else if (currentLetter!='`') //if not any of the above cases, add the current letter to the typed string
      currentTyped+=currentLetter;
  }
}
