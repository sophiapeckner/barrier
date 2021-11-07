import java.util.HashMap;
//BufferedReader reader;
//String line;
PImage img;

int page = 1;    // Tracks screen

// Learn More Page variables, the index of questions correspond to the ans map
String[] questions = {"Importance of mental health care",
                      "What are the barriers?",
                      "What disparities are present?",
                      "How is the game related?",
                      "What are some policy ideas?",
                      "References"};
HashMap<Integer, String[]> ans = new HashMap<Integer, String[]>();
int currentQuestion;

// Button Declerations
Button playBtn;
Button learnMoreBtn;
Button startBtn;
Button backToLevelsBtn;
Button homeBtn;
Button[] stateLevels = new Button[49];
Button[] questionBtn = new Button[questions.length];
Button backBtn;

// Trouble with createReader function, parse csv file and pasted string and float here 
String[] states = {"New Jersey", "Rhode Island", "Nebraska", "Utah", "New Hampshire", "Virginia", "Ohio", "Georgia", "Pennsylvania", "Nevada", "Iowa", "Texas", "South Carolina", "Arkansas", "Maryland", "Maine", "Massachusetts", "Wisconsin", "Kansas", "Indiana", "Wyoming", "Colorado", "Minnesota", "Oklahoma", "California", "Mississippi", "Louisiana", "Idaho", "Alabama", "Kentucky", "Michigan", "Oregon", "Illinois", "Hawaii", "New York", "Delaware", "North Dakota", "West Virginia", "Alaska", "Florida", "North Carolina", "Connecticut", "Tennessee", "New Mexico", "Washington", "Montana", "South Dakota", "Arizona", "Missouri"};
Float[] unmet = {0.3016, 0.305, 0.4903, 0.5335, 0.5481, 0.5751, 0.6042, 0.609, 0.6156, 0.6462, 0.6477, 0.6478, 0.6498, 0.6564, 0.6569, 0.67, 0.6779, 0.6787, 0.6795, 0.6801, 0.6854, 0.6862, 0.7146, 0.7215, 0.7335, 0.7341, 0.7455, 0.7567, 0.7587, 0.7599, 0.7653, 0.7666, 0.7667, 0.7754, 0.7936, 0.8086, 0.8098, 0.8264, 0.8281, 0.8308, 0.8596, 0.8612, 0.8677, 0.8712, 0.8777, 0.8837, 0.8877, 0.8886, 0.9633};      // 100 - Percent of Need Met 

int[] barriers;                     // Stores the INDEXES of each barrier square
HashMap<Float, Integer> barriersData = new HashMap<Float, Integer>();    // Map {Barrier Index : Row It's In}
HashMap<Integer, String> rowDirection = new HashMap<Integer, String>();  // Map {Row Number : Random Direction, Left/ Right}
boolean gameOn = true;              // Checks whether barriersData needs to be updated
String state;                       // Stores the current state that the user is playing on
int numBarriers;

Square[] mySquare;
int gridLength = 10;
int gridWidth = 10;
int squareSize = (int) 400/gridLength - 10; 

int start = gridLength * (gridWidth - 1);          // Tracks the starting position -> a barrier can NOT be placed here, lower left square
int currentIndex = gridLength * (gridWidth - 1);   // The square that the box (moved by the user) is located
int endIndex = gridLength - 1;                     // Track where the box must always move to, upper right destination square

String outcome;

void setup() {
  size(400, 400); 
  frameRate(30);      // Slow down the game speed
  //reader = createReader("/Users/sophiapeckner/Downloads/percentage1.csv");    // Loads the file. File is downloaded from: https://www.kff.org/other/state-indicator/mental-health-care-health-professional-shortage-areas-hpsas/?currentTimeframe=0&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D
  //getData();
  populateStateLevels();
  playBtn = new Button(190, 220, 130, 35, "Play Game", 2, #EDD382);
  learnMoreBtn = new Button(190, 265, 130, 35, "Learn More", 6, #EDD382);
  startBtn = new Button(150, 360, 100, 35, "Start", 3, #EDD382);
  backToLevelsBtn = new Button(150, 360, 100, 35, "Back To Levels", 3, #EDD382);
  homeBtn = new Button(5, 0, 50, 35, "Home", 1, #EDD382);
  backBtn = new Button(150, 360, 100, 35, "Back", 6, #EDD382);
  img = loadImage("mentalHealth2.png");
}

void draw() { 
  background(#F2F3AE);
  myBackground();
  
  if (page == 1)        page1();
  else if (page == 2)   page2();
  else if (page == 3)   page3();
  else if (page == 4)   page4();
  else if (page == 5)   page5();
  else if (page == 6)   page6();
  else if (page == 7)   page7(currentQuestion);
}

// PAGES //
void page1() {      // Home Page
  image(img, 20, 200, 200, 200);
  blob(200, 200, 1, 1);
  prettyText("BARRIER", 120, 170, "title");
  prettyText("A Mental Health Awareness App", 120, 190, "caption");
  // Shows both buttons
  playBtn.display();
  learnMoreBtn.display();
}

void page2() {      // Instructions Page
  prettyText("ABOUT", 40, 70, "heading");
  // Array holding each sentence in the ABOUT section
  String[] about = {
    "This game will visually demonstrate the barriers",
    "people face when seeking out mental health services.",
    "The number of barriers is based off of a KFF.org dataset",
    "comparing the Percent of Need Met in U.S. states. This",
    "is defined as the number of psychiatrists available",
    "divided by the number of psychiatrists needed to",
    "eliminate the mental health professional shortage."};

  for (int i = 0; i < about.length; i ++) {
    prettyText(about[i], 20, 100 + (20 * i), "text");
  }
  
  prettyText("GAMEPLAY", 40, 260, "heading");
  
  String[] gamePlay = {
    "(1) Use arrow keys to change your current position",
    "(2) Don't hit the MOVING red blocks",
    "(3) Navigate to the end!",
    "(4) Try New Jersey first (has least barriers)"};
  
  for (int i = 0; i < gamePlay.length; i ++) {
    prettyText(gamePlay[i], 20, 290 + (20 * i), "text");
  }
  startBtn.display();
  homeBtn.display();
}

void page3() {          // Levels Page (Menu Of All Possible States)
  // Show 49 buttons, each corresponding to one state
  for (int i = 0; i < stateLevels.length; i++){
    stateLevels[i].display();
  }
  homeBtn.display();
}

void page4() {          // Play Game
  if (gameOn) {      // Checks whether or not barriersData has already been updated
    currentIndex = start;    // Reset boxes position
    barriersData = new HashMap<Float, Integer>();    // Reset barriersData
    populateBarrier(numBarriers);  // Populate barriersData with numBarriers number of random indexes
    splitBarrierIntoRows();        // Getting the barrier indexes row number
    determineRowDirection();       // Use barriersData to determine a random row direction
    gameOn = false;                // This way the barrier indexes aren't constantly changing
  }
  prettyText(state + ", " + numBarriers + "% barriers", 200, 20, "text");
  updateBarrier();
}

void page5() {         // After Lose/ Win Page
  textAlign(CENTER);
  blob(100,330,1.3,1.3);
  String[] actionItems = {
    "- Educate yourself about inequity in mental health care",
    "- Be empathetic towards people going through a",
    "  mental health problem",
    "- Educate yourself on mental health disorders",
    "- Support local mental health advocacy organizations"};
  if (outcome == "W") { // Player won
    prettyText("Congrats", 200, 70, "heading");
  } else {
    prettyText("Game Over", 200, 70, "heading");
  }
  int needMet = 100 - numBarriers; 
  prettyText("In " + state + ", " + needMet + "% of need is met", 200, 95, "text");
  prettyText("The barriers represent the % of need that is NOT met", 200, 120, "text");
  prettyText("For some people, these barriers are their reality.", 200, 145, "text");
  
  textAlign(LEFT);
  prettyText("Some Action Items To Help:", 20, 205, "text");
  for (int i = 0; i < actionItems.length; i ++) {
    prettyText(actionItems[i], 20, 230 + (20 * i), "text");
  }
  
  backToLevelsBtn.display();
  homeBtn.display();
}

void page6() {
  // This is not dynamic, will improve in the next version
  String[] a1 = {
    "Mental health plays a substantial role in an individual’s",
    "wellbeing. Furthermore, it correlates with physical health.",
    "According to the CDC, mental health disorders could",
    "increase the rise of physical problems."};
  
  String[] a2 = {
    "According to a study by the Cohen Veterans Network",
    "and National Council for Behavioral Health,",
    "barriers Americans face include: ",
    "- Unawareness. 29% of respondents indicated that",
    "they didn’t know how to access mental health care",
    "- Insurance. 42% of respondents indicated that high",
    "cost and inadequate insurance was a deterrence.",
    "- Social Stigma. 31% of respondents worried about",
    "how they’d be perceived by others when seeking mental",
    "health care"};
    
  String[] a3 = {
    "Racial disparities are prevalent in mental health care.",
    "According to NCBI, black people are 50% as likely to",
    "receive psychiatric treatment as their white counterparts.",
    "There’s also a disparity between suburban and urban",
    "areas. A study by AAMC gauged the percent of people",
    "who had trouble finding a provider. Among urban",
    "respondents, 45% indicated this was a problem",
    "compared to 27% of suburban respondents.",
    "",
    "",
    "* NCBI: National Center for Biotechnology Information",
    "* AAMC: Association of American Medical Colleges"};
    
  String[] a4 = {
    "KFF.org released a dataset comparing Percent of",
    "Need Met between states in the U.S. Percent of",
    "need met is computed by dividing available ",
    "psychiatrists by psychiatrists needed to eliminate the",
    "Health Professional Shortage Area. This percentage",
    "is used to compute the number of barriers. Players",
    "can see how the number of barriers fluctuate between",
    "different states, and therefore how difficult it is to",
    " navigate to the end. Hopefully this game can be an",
    "incentive to help remove these barriers in the real.",
    "world"};
    
  String[] a5 = {
    "The Institute of Medicine (IOM) wrote policy suggestions",
    "in its Unequal Treatment Report. They include:",
    "1. Improve access to care",
    "2. Foster more diversity in clinicians, which also",
    "   addresses language-barriers",
    "3. Encourage education of mental health diseases"};
  
  String[] a6 = {
    "- KFF.org Dataset: https://bit.ly/3bMEaey",
    "- Mental Health Barriers Study: https://bit.ly/3BRvluL",
    "- https://www.cdc.gov/mentalhealth/learn/index.htm",
    "- https://www.aamc.org/media/9926/download",
    "- https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3928067/"};
    
  ans.put(0, a1);
  ans.put(1, a2);
  ans.put(2, a3);
  ans.put(3, a4);
  ans.put(4, a5);
  ans.put(5, a6);
  
  for (int i = 0; i < questions.length; i++) {
    questionBtn[i] = new Button(20, i*35 + 40, 360, 25, questions[i], 7, #F2F3AE);
    questionBtn[i].myQNum = i;
    questionBtn[i].display();
  }
 
  homeBtn.display();
}

// When click on a question, shows the corresponding ans.
void page7(int index) {
  String[] myAns = ans.get(index);
  prettyText(questions[index], 5, 60, "heading");
  for (int i = 0; i < myAns.length; i++) {
    prettyText(myAns[i], 20, 100 + (20 * i), "text");
  }
  backBtn.display();
}

// BARRIERS //
// Populating an array of random indexes between 0 and total length of the grid (gridLength * gridLength)
void populateBarrier(int myCount) {
  barriers = new int[myCount];
  int i = 0;
  while (i < myCount) {
    int randomPos = (int) (Math.random() * (gridLength*gridLength));
    if (randomPos != gridLength * (gridWidth - 1) && randomPos != endIndex && !inBarrier(randomPos)) {    // Checks whether barrier is already in the array + whether it's on end/ start position
      barriers[i] = randomPos;      // Puts that index into barriers array
      i++;                          // Repeats the cycle -> Gets another index, check whether it meets the criteria, append to array
    }
  }
}

// Determine the row that each index is located in, this way I can move each row in a random direction
void splitBarrierIntoRows() {
  for (int i = 0; i < barriers.length; i++) {
    int rowNum = int(barriers[i]/gridLength);
    barriersData.put(float(barriers[i]), rowNum);      // => {barrierIndex : Corresponding Row} => Ex. {0 : 0}
  }
}

// Each row is assigned a random direction (barriers in the grid move left/ right)
void determineRowDirection() {
  for (int i = 0; i < gridLength; i++) {
    // Equal probability to have a row go left or right
    if (Math.random() < 0.5)      rowDirection.put(i, "left");
    else                          rowDirection.put(i, "right");
  }
}

// Update the barrier's index to the left or right
void updateBarrier() {
  barriers = new int[numBarriers];      // Reset barriers array because new indexes will be added to it
  HashMap<Float, Integer> updatedBarrier = new HashMap<Float, Integer>();
  int i = 0;
  // Loop through every existing barrier and see it's row num and index (aka. position in the grid)
  for (float barrierIndex : barriersData.keySet()) {
    int rowNum = barriersData.get(barrierIndex);
    String direction = rowDirection.get(rowNum);
    float newPos = newBarrierPos(direction, barrierIndex);
    
    if (barrierIndex == gridLength * (gridWidth - 1))  barriers[i] = (gridLength * gridWidth) - 1;    // Ensures that no barriers will be moved to the start index
    // Changes the index of the barrier element depending on its direction
    else if (direction == "left")    barriers[i] = (int) Math.ceil(newPos);
    else if (direction == "right")   barriers[i] = (int) Math.floor(newPos);
    updatedBarrier.put(newPos, rowNum);
    i++;
  }
  barriersData = updatedBarrier;    // Updates barriersData to hold new positions
  updateGrid();
}

public float newBarrierPos(String direction, float currentPos) {
  if (direction == "left") {
    if (Math.ceil(currentPos + 0.5) % gridLength == 0) return currentPos + (gridLength-1);
    else return currentPos - 0.02;    // -0.02 to slow down the barrier's seed
  }
  else {
    if (int(currentPos + 1) % gridLength == 0) return currentPos - (gridLength-1);
    else return currentPos + 0.02;
  }
}

// Check to see if that index is in barriers[]
public boolean inBarrier(int index) {
  for (int i = 0; i < barriers.length; i++)
    if (index == barriers[i]) return true;
  return false;
}

// LEVEL DATA //
// Create instances of the button class that show all of the state levels
void populateStateLevels() {
  int t = 0;
  for (int i = 0; i < 13; i++){    // ~ 12 Row x 4 Columns -> Personal visual preference
    for (int j = 0; j < 4; j++){
      if (t < 49) {
        //int percent = (int) (unmet[t] * 100);
        stateLevels[t] = new Button(j*95+8, i*25 + 40, 95, 25, states[t], 4, #F2F3AE);
        stateLevels[t].stateBarrierPercent = unmet[t];
        t++;
      }
    }
  }
}

// GAME GRID //
// Draws the game board
void updateGrid() {
  int myIndex = 0;
  mySquare = new Square[gridLength*gridLength];
  
  for (int y = 0; y < gridLength; y++){
    for (int x = 0; x < gridWidth; x++){
      String myColor;
      
      // Fill the squares depending on it's 'purpose' (Red => Barrier, Green => Start, Black => End)
      if (myIndex == currentIndex)       myColor = "green";
      else if (myIndex == endIndex)      myColor = "black";
      else if (inBarrier(myIndex))       myColor = "red";
      else                               myColor = "white";
      
      mySquare[myIndex] = new Square(x*squareSize + 35, 
                                     y*squareSize + 35,
                                     myColor);
     myIndex++;
    }
  }
  showGrid();
  // Checks whether reached the end or collided with a barrier
  if ((inBarrier(currentIndex) || currentIndex == endIndex) && currentIndex != start) {
    if (inBarrier(currentIndex))        outcome = "L";
    else if (currentIndex == endIndex)  outcome = "W";
    gameOn = true;
    page = 5;
  }
}

void showGrid() {
  for (int i = 0; i < mySquare.length; i++) mySquare[i].show();
}

// DESIGN //
void prettyText(String word, int x, int y, String type) {
  if (type == "title") {
    textSize(60);
    fill(#FF521B);
    text(word, x, y);
    fill(#FC9E4F);
    text(word, x-2, y-2);
  }
  else if (type == "heading") {
    textSize(26);
    strokeWeight(2);
    fill(#FF521B);
    text(word, x, y);
  }
  else if (type == "text") {
    fill(#020122);
    textSize(15);
    text(word, x, y);
  }
  else if (type == "caption") {
    fill(#ff3d03);
    textSize(15);
    text(word, x, y);
  }
}

void myBackground() {
  strokeWeight(2);
  stroke(#FC9E4F);
  line(0, 30, 400, 30);
  line(0, 370, 400, 370);
  noFill();
  bezier(0, 102, 113, 83, 55, 25, 151, 1);
  bezier(263, 399, 317, 380, 322, 330, 399, 324);
}

void blob(int x, int y, float sx, float sy) {
  pushMatrix();
  pushStyle();
  translate(x, y);
  scale(sx, sy);
  fill(#EDD382);
  strokeWeight(0);
  beginShape();
  curveVertex(53,-92); curveVertex(109,-92); curveVertex(158,-61); curveVertex(139,-19); curveVertex(70,9); curveVertex(30,1); curveVertex(0,-21); curveVertex(-44,-11); curveVertex(-63,-69); curveVertex(-6,-94); curveVertex(53,-92); curveVertex(109,-92); curveVertex(158,-61); /**/
  endShape();
  popStyle();
  popMatrix();
}
  
// USER INTERACTION //
void keyPressed() {
  if (keyCode == RIGHT){
    if ((currentIndex + 1) % gridLength != 0) currentIndex += 1;
  }
  else if (keyCode == LEFT){
    if (currentIndex % gridLength != 0) currentIndex -= 1;
  }
  else if (keyCode == UP){
    if (currentIndex > gridLength - 1) currentIndex -= gridLength;
  }
  else if (keyCode == DOWN){
    if (currentIndex < gridLength * (gridWidth - 1))  currentIndex += gridLength;
  }
  //redraw();
}  

void mousePressed() {
  // Conditionals so that you can only click on buttons when you're on the corresponding page
  if (page == 1) {
    playBtn.clicked(mouseX, mouseY);
    learnMoreBtn.clicked(mouseX, mouseY);
  }
  else if (page == 2)   startBtn.clicked(mouseX, mouseY);
  else if (page == 3) {
    for (int i = 0; i < stateLevels.length; i++){
      stateLevels[i].clicked(mouseX, mouseY);
    }
  }
  else if (page == 5)   backToLevelsBtn.clicked(mouseX, mouseY);
  else if (page == 6) {
    for (int i = 0; i < questionBtn.length; i++)   questionBtn[i].clicked(mouseX, mouseY);
  }
  else if (page == 7) backBtn.clicked(mouseX, mouseY);
  homeBtn.clicked(mouseX, mouseY);
}

class Square {
  float myX, myY;
  String myColor;
  
  Square(float x, float y, String paint){
    myX = x;
    myY = y;
    myColor = paint;
  }
  
  void show(){
    if (myColor == "green") fill(0, 255, 0);
    if (myColor == "black") fill(0);
    if (myColor == "red")   fill(255, 0, 0);
    if (myColor == "white") fill(255);
    
    rect(myX, myY, squareSize, squareSize);
  }
}

// Based off: https://kdoore.gitbook.io/cs1335-java-and-processing/object-oriented-programming/buttons_as_objects/button-class
class Button{
  // Member Variables
  float x,y; //position
  float w,h; //size
  String label;
  float stateBarrierPercent;  // Only set in buttons in Page 3
  int nextPage;
  int myQNum; // Only applicable for Page 6
  color myColor;
  
  // Constructor
  Button(float myX, float myY, float myW, float myH, String myL, int next, color c){
    x = myX;
    y = myY;
    w = myW;
    h = myH;
    label = myL;
    nextPage = next;
    myColor = c;
  }
  
  // Member Functions
  void display(){
    fill(myColor);  //#EDD382
    rect(x, y, w, h, 10);
    fill(0);
    textAlign(CENTER);
    textSize(14);
    text(label, x + w/2, y + (h/2));
    textAlign(LEFT);
  }

  void clicked(int mx, int my){
    if( mx > x && mx < x + w  && my > y && my < y+h){ 
      if (stateBarrierPercent != 0.0) {  // stateBarrierPercent == 0.0 for any button not associated with a state
        numBarriers = (int) (stateBarrierPercent * (gridLength*gridLength));
        state = label;
      }
      
      else if (page == 6) currentQuestion = myQNum;

      page = nextPage;
      
    }
  }
}
