String fileName = "data_a2.csv";
Table table;

String keyName = "Name", valueName = "Price";

//float topMargin = 0.05, bottomMargin = 0.9, leftMargin = 0.05, rightMargin = 0.95;
//float heighestHeight = 0.8, topBarMargin = 0.1;

enum GraphStatus {
  Line,
  LineToBar,
  Bar,
  BarToLine
}

float highestNumber = -1, numberRows = 0;
boolean textShown = false, animationClicked = false;

GraphStatus graphStatus = GraphStatus.Line;

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
  float topMargin = 0.05 * height, bottomMargin = 0.9 * height, leftMargin = 0.1 * width, rightMargin = 0.90 * width;
  int sizeOfText = (width + height) / 100;
  drawGraph(graphStatus);
  drawAxis();
  
  String buttonText = "";
  if(graphStatus == GraphStatus.Line) {
    buttonText = "Bar";
  }
   else if(graphStatus == GraphStatus.Bar) {
    buttonText = "Line";
  }
  drawButton(buttonText, rightMargin, topMargin - sizeOfText, (width - sizeOfText) * 1.0, topMargin + sizeOfText, #C9E2F2);
}

void drawButton(String text, float x1, float y1, float x2, float y2, color c) {
  int sizeOfText = (width + height) / 100;
  fill(c);
  rect(x1, y1, x2 - x1, y2 - y1, sizeOfText / 2);
  
  if(mouseX >= x1 && mouseX <= x2 &&
    mouseY >= y1 && mouseY <= y2) {
    animationClicked = true;  
  }
  
  textSize(sizeOfText);
  textAlign(CENTER);
  fill(0);
  text(text, (x2 + x1) / 2, (y2 + y1) / 2 + sizeOfText / 2.0);
}

void drawAxis() {
  float topMargin = 0.05 * height, bottomMargin = 0.9 * height, leftMargin = 0.1 * width, rightMargin = 0.90 * width;
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

void drawGraph(GraphStatus status) {
  float topMargin = 0.05 * height, bottomMargin = 0.9 * height, leftMargin = 0.1 * width, rightMargin = 0.90 * width;
  float highestHeight = 0.8 * height, topGraphMargin = 0.1 * height;
  
  float ratio = highestHeight / highestNumber;
  float interval = (rightMargin - leftMargin) / (2 * numberRows + 1);
  
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
  
  // Bars/lines and labels
  boolean firstTime = true;
  float prevX = -1, prevY = -1;
  
  float xPos = leftMargin + interval;
  stroke(255);
  fill(#2D31DE);
  for(TableRow row : table.rows()) {
    // Draw bar or line
    String name = row.getString(keyName);
    int price = row.getInt(valueName);
    stroke(45, 49, 222);
    fill(45, 49, 222);
    if(status == GraphStatus.Bar) {
      drawBar(xPos, price * ratio, interval, name, price);
    }
    else if(status == GraphStatus.Line) {
      float centerX = xPos + interval / 2, centerY = topGraphMargin + highestHeight - price * ratio, diameter = interval / 2;
      drawDot(centerX, centerY, diameter, name, price);
      if(firstTime == false) {
        stroke(45, 49, 222);
        fill(45, 49, 222);
        line(prevX, prevY, centerX, centerY);
      }
      firstTime = false;
      prevX = centerX;
      prevY = centerY;
    }
    
    // Name labels (rotated)
    textAlign(LEFT);
    translate(xPos - interval / 2, bottomMargin + sizeOfText / 2);
    rotate(PI / 5.0);
    stroke(255);
    fill(0);
    text(name, sizeOfText, 0);
    rotate(-PI / 5.0);
    translate(-(xPos - interval / 2), -(bottomMargin + sizeOfText / 2));
    
    xPos += 2 * interval;
  }
  stroke(255);
}

void drawDot(float centerX, float centerY, float diameter, String name, int price) {
  float topMargin = 0.05 * height, bottomMargin = 0.9 * height, leftMargin = 0.1 * width, rightMargin = 0.90 * width;
  float highestHeight = 0.8 * height, topDotMargin = 0.1 * height;
  int sizeOfText = (width + height) / 100;
  stroke(45, 49, 222);
  fill(45, 49, 222);
  ellipse(centerX, centerY, diameter, diameter);
  
  // Mouse hover
  if(mouseX >= centerX - diameter && mouseX <= centerX + diameter &&
    mouseY >= centerY - diameter && mouseY <= centerY + diameter){

    // Highligh dot
    stroke(163, 167, 234);
    fill(163, 167, 234);
    ellipse(centerX, centerY, diameter + 2, diameter + 2);
    stroke(255);
    fill(255);
    
    // Show text
    textSize(sizeOfText * 3 / 2);
    fill(0);

    //textAlign(LEFT);
    //text(name + ": " + str(price), mouseX, mouseY);
    textAlign(CENTER);
    text(name + ": " + str(price), width / 2, topDotMargin - sizeOfText);
    fill(255);
    textSize(sizeOfText);
    textShown = true;
  }
}

void drawBar(float xPos, float barHeight, float interval, String name, int price) {
  int sizeOfText = (width + height) / 100;
  float topMargin = 0.05 * height, bottomMargin = 0.9 * height, leftMargin = 0.1 * width, rightMargin = 0.90 * width;
  float highestHeight = 0.8 * height, topBarMargin = 0.1 * height;
  rect(xPos, topBarMargin + highestHeight - barHeight, interval, barHeight); 
  
  // mouse hover
  if(mouseX >= xPos && mouseX <= xPos + interval &&
    mouseY >= topBarMargin + highestHeight - barHeight && mouseY <= topBarMargin + highestHeight){

    // Highligh bar
    stroke(163, 167, 234);
    fill(163, 167, 234);
    rect(xPos - 1, topBarMargin + highestHeight - barHeight, interval + 2, barHeight); 
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
}

void mouseMoved() {
  if(textShown) {
    background(255, 0);
    draw();
    textShown = false;
  }
}

void mouseClicked() {
  if(animationClicked) {
    println("animation");
    animationClicked = false;
    if(graphStatus == GraphStatus.Line) {
      graphStatus = GraphStatus.Bar;
      background(255, 0);
      println("now bar");
    }
    else if(graphStatus == GraphStatus.Bar) {
      graphStatus = GraphStatus.Line;
      background(255, 0);
      println("now line");
    }
  }
}