String fileName = "data_a2.csv";
Table table;

String keyName = "Name", valueName = "Price";

//float topMargin = 0.05, bottomMargin = 0.9, leftMargin = 0.05, rightMargin = 0.95;
//float heighestHeight = 0.8, topBarMargin = 0.1;

float highestNumber = -1, numberRows = 0;
boolean textShown = false;
void setup() {
  background(255);
  size(600, 600);
  surface.setResizable(true);
  table = loadTable(fileName, "header");
  
  // test
  println(table.getRowCount() + " rows.");
  numberRows = table.getRowCount();
  for(TableRow row : table.rows()) {
    int price = row.getInt(valueName);
    println(row.getString(keyName) + ": " + price);
    highestNumber = float(price) > highestNumber ? float(price) : highestNumber;
  }
}

void draw() {
  drawBar();
  drawAxis();
}

void drawAxis() {
  float topMargin = 0.05 * height, bottomMargin = 0.9 * height, leftMargin = 0.1 * width, rightMargin = 0.95 * width;
  int sizeOfText = (width + height) / 100;
  stroke(0);
  // X-axis
  line(leftMargin, bottomMargin, rightMargin, bottomMargin);
  // Y-axis
  line(leftMargin, topMargin, leftMargin, bottomMargin);
  
  // 0 label of x and y
  fill(0);
  textSize(sizeOfText);
  textAlign(RIGHT);
  text("0", leftMargin - sizeOfText / 2, bottomMargin + sizeOfText / 2);

  
  // Name labels
  text(valueName, leftMargin, topMargin - sizeOfText / 2);
  fill(255);
  textAlign(CENTER);
}

void drawBar() {
  float topMargin = 0.05 * height, bottomMargin = 0.9 * height, leftMargin = 0.1 * width, rightMargin = 0.95 * width;
  float highestHeight = 0.8 * height, topBarMargin = 0.1 * height;
  
  float ratio = highestHeight / highestNumber;
  float barInterval = (rightMargin - leftMargin) / (2 * numberRows + 1);
  
  final int ASSIST_LINE_NUM = 8;
  float assistDist = highestHeight / ASSIST_LINE_NUM, assistNumDiff = assistDist / ratio;
  int sizeOfText = (width + height) / 100;
  
  // Draw assist lines
  stroke(#C6C6C6);
  fill(0);
  textSize(sizeOfText);
  textAlign(RIGHT);
  float assistHeight = assistDist, assistNum = assistNumDiff;
  for(int i = 0; i < ASSIST_LINE_NUM; i++) {
    line(leftMargin, bottomMargin - assistHeight, rightMargin, bottomMargin - assistHeight);
    text(int(assistNum), leftMargin - sizeOfText / 2, bottomMargin - assistHeight);
    assistHeight += assistDist;
    assistNum += assistNumDiff;
  }
  stroke(255);
  fill(255);
  textAlign(CENTER);
  
  // Bars and labels
  float barXPos = leftMargin + barInterval;
  stroke(255);
  fill(#2D31DE);
  for(TableRow row : table.rows()) {
    // Draw bar

    String name = row.getString(keyName);
    int price = row.getInt(valueName);
    stroke(45, 49, 222);
    fill(45, 49, 222);
    rect(barXPos, topBarMargin + highestHeight - price * ratio, barInterval, price * ratio); 
   
   
   // Mouse hover
    if(mouseX >= barXPos && mouseX <= barXPos + barInterval &&
      mouseY >= topBarMargin + highestHeight - price * ratio && mouseY <= topBarMargin + highestHeight){
  
      // Highligh bar
      stroke(163, 167, 234);
      fill(163, 167, 234);
      rect(barXPos - 1, topBarMargin + highestHeight - price * ratio, barInterval + 2, price * ratio); 
      fill(255);
      stroke(255);
      
      // Show text
      textSize(sizeOfText * 3 / 2);
      fill(0);

      //textAlign(LEFT);
      //text(name + ": " + str(price), mouseX, mouseY);
      textAlign(CENTER);
      text(name + ": " + str(price), width / 2, topBarMargin - sizeOfText);
      fill(255);
      textSize(sizeOfText);
      textShown = true;
    }
    
    // Name labels (rotated)
    textAlign(LEFT);
    translate(barXPos - barInterval / 2, bottomMargin + sizeOfText / 2);
    rotate(PI / 5.0);
    stroke(255);
    fill(0);
    text(name, sizeOfText, 0);
    rotate(-PI / 5.0);
    translate(-(barXPos - barInterval / 2), -(bottomMargin + sizeOfText / 2));
    
    
    barXPos += 2 * barInterval;
  }
  stroke(255);
}

void mouseMoved() {
  if(textShown) {
    background(255, 0);
    draw();
    textShown = false;
  }
}