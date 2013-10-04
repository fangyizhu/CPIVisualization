import de.bezier.data.*;
import java.util.Scanner;

float[] tabLeft = new float[9];
float[] tabRight = new float[9]; 
float[] yearTabLeft = new float[11];
float[] yearTabRight = new float[11]; 
float rectX1 = 35;
float rectY1 = 55;
float rectX2 = 1110;
float rectY2 = 450;
float tabTop, tabBottom;
float tabPad = 14;
float yearTabTop, yearTabBottom;
float yearTabPad = 10;
PFont label;
PFont f;
int currentColumn;
int mode; // 0 is single, 1 is multiple
int year1;
int year2;
boolean[] display = {
  true, false, false, false, false, false, false, false, false
};


DataSet[] datas = {
  new DataSet("AllItem.xls"), 
  new DataSet("Apparel.xls"), 
  new DataSet("Education.xls"), 
  new DataSet("Food.xls"), 
  new DataSet("Housing.xls"), 
  new DataSet("Medical.xls"), 
  new DataSet("MedicalService.xls"), 
  new DataSet("Recreation.xls"), 
  new DataSet("Transportation.xls")
  }; 

  void drawTitleTabs( ) {
    rectMode(CORNERS);
    noStroke( );
    textSize(11);
    textAlign(LEFT);
    float runningX = rectX1;
    tabTop = rectX1 - textAscent( );
    tabBottom = rectX1+20;
    for (int col = 0; col < 9; col++) {
      String title = datas[col].title;
      tabLeft[col] = runningX;
      float titleWidth = textWidth(title);
      tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;

      // If the current tab, set its background white; otherwise use pale gray.
      if ((mode == 0 && col == currentColumn) || (mode == 1 && display[col])) {
        fill(255);
      }
      else {
        fill(224);
      }
      rect(tabLeft[col], tabTop, tabRight[col], tabBottom, 9, 9, 0, 0);
      // If the current tab, use black for the text; otherwise use dark gray.
      if ((mode == 0 && col == currentColumn) || (mode == 1 && display[col])) {
        fill(0);
      }
      else {
        fill(64);
      }
      text(title, runningX + tabPad, rectY1 - 10);
      runningX = tabRight[col];
    }
  }

void drawYearTabs( ) {
  rectMode(CORNERS);
  noStroke( );
  textSize(11);
  textAlign(LEFT);
  float runningX = rectX1;
  yearTabTop = rectX1 - textAscent( );
  yearTabBottom = rectX1+20;
  for (int col = 0; col < 11; col++) {
    String year = Integer.toString(col+2003);
    yearTabLeft[col] = runningX;
    float titleWidth = textWidth(year);
    yearTabRight[col] = yearTabLeft[col] + yearTabPad + titleWidth + yearTabPad;

    // If the current tab, set its background white; otherwise use pale gray.
    if (col == year1 || col == year2) {
      fill(255);
    }
    else {
      fill(224);
    }

    rect(yearTabLeft[col], yearTabTop, yearTabRight[col], yearTabBottom, 9, 9, 0, 0);
    // If the current tab, use black for the text; otherwise use dark gray.
    if (col == year1 || col == year2) {
      fill(0);
    }
    else {
      fill(64);
    }
    text(year, runningX + yearTabPad, rectY1 - 10);
    runningX = yearTabRight[col];
  }
}

void drawModeTabs( ) {
  noStroke();
  textSize(11);
  textAlign(LEFT);
  fill(mode == 0? 255 : 224);
  rect(rectX1, rectY2 + 50, rectX1+70, rectY2 + 80, 3, 3, 3, 3);
  fill(0);
  text("single", rectX1+5, rectY2 + 70);

  fill(mode == 1? 255 : 224);
  rect(rectX1, rectY2 + 90, rectX1+70, rectY2 + 120, 3, 3, 3, 3);
  fill(0);
  text("multiple", rectX1+5, rectY2 + 110);

  fill(mode == 2? 255 : 224);
  rect(rectX1+90, rectY2 + 50, rectX1+170, rectY2 + 80, 3, 3, 3, 3);
  fill(0);
  text("time period", rectX1+95, rectY2 + 70);
}

void loadDataSet(DataSet set) {
  XlsReader reader = new XlsReader(this, set.fileName);
  set.title = reader.getString(6, 1);
  set.wholeMin = 1000000;
  set.wholeMax = 0;

  while (reader.getRowNum () != 11) {
    reader.nextRow();
  }
  for (int i = 0; i <= 10; i++) {
    reader.firstCell() ;
    reader.nextCell();
    for (int j = 0; j <= 11; j++) {
      float current = reader.getFloat();
      if (i == 10 && j >= 3) {
        break;
      } 
      else {
        set.monthCPI[i][j] = current;
        if (current < set.wholeMin) {
          set.wholeMin = current;
        }
        if (current > set.wholeMax) {
          set.wholeMax = current;
        }
        reader.nextCell();
      }
    }
    set.yearCPI[i] = reader.getFloat();
    reader.nextCell();
    set.halfYearCPI[i][0] = reader.getFloat();
    reader.nextCell();
    set.halfYearCPI[i][1] = reader.getFloat();    
    reader.nextRow();
  }
}

void drawYearLabels() {
  stroke(128);
  strokeWeight(1);
  fill(0);
  textAlign(CENTER, TOP);
  for (int i = 2003; i <= 2013; i++) {
    float x = map(i, 2003, 2013.25, rectX1, rectX2);
    textFont(label, 10);
    text(i, x, rectY2+10);
    stroke(224);
    line(x, rectY1, x, rectY2);
  }
}

void drawBlockGraph() {
  for (int i = 0; i < 9; i++) {
    stroke(128);
    strokeWeight(1);
    float x = map(i, 0, 9, rectX1+(rectX2-rectX1)/10, rectX2);
    float variation = (datas[i].getYearAverage(myMax(year1,year2)) - datas[i].getYearAverage(myMin(year1,year2))) / datas[i].getYearAverage(myMin(year1,year2));
    float y = map(variation, -0.5, 0.6, rectY2, rectY1);
    textFont(label, 9);
    fill(0);
    textAlign(CENTER);
    text(datas[i].title, x, rectY2+10);
    noStroke();
    if (i == 0) {
      fill(#5679C1);
    } 
    else if (i == 1) {
      fill(#FF00FF);
    }
    else if (i == 2) {
      fill(#567921);
    }
    else if (i == 3) {
      fill(#A680C1);
    }
    else if (i == 4) {
      fill(#00FF08);
    }
    else if (i == 5) {
      fill(#E01B1B);
    }
    else if (i == 6) {
      fill(#FF7700);
    }
    else if (i == 7) {
      fill(#BB00FF);
    }
    else if (i == 8) {
      fill(#FFD000);
    }
    if(variation < 0) {
      fill(0);
      text(variation + "%", x, y + 15);
    }
    else {
  text(variation + "%", x, y - 15);
    }
    rect(x-10,y,x+10,(rectY2-rectY1)/11*6 + rectY1);
  }
}

void drawPercentLabels() {
  stroke(128);
  strokeWeight(1);
  fill(0);
  textAlign(CENTER, TOP);
  for (int i = -10; i <= 60; i += 10) {
    float y = map(i, -10, 60, rectY2, rectY1);
    textFont(label, 10);
    text(i + "%", rectX1-20, y);
  }
}

void drawBigPercentLabels() {
  strokeWeight(1);
  fill(0);
  textAlign(CENTER, TOP);
  stroke(220);
  for (int i = -50; i <= 60; i += 10) {
    float y = map(i, -50, 60, rectY2, rectY1);
    text(i + "%", rectX1-20, y);
    line(rectX1, y , rectX2, y);
  }
}

void setup ()
{
  noStroke();
  smooth();
  size(1250, 600);

  for (DataSet set:datas) {
    loadDataSet(set);
  }
  f = createFont("Arial", 16, true);
  label = createFont("Arial", 16, true);

  mode = 0;
  year1 = 0;
  year2 = 10;
}

void draw() {
  fill( 250);
  background(150);
  noStroke();
  rect(rectX1, rectY1, rectX2, rectY2, 0, 0, 0, 0);
  if (mode == 1) {
    textFont(f, 36);
    fill(255);
    text("Multiple Items", 690, 530);
    drawModeTabs( );
    drawYearLabels();
    drawPercentLabels();
    drawTitleTabs( );
    for (int i = 0; i < 9; i++) {
      if (display[i]) {
        datas[i].drawPercent();
      }
    }
  } 
  else if (mode == 2) {
    textFont(f, 36);
    fill(255);
    if (year1 == -1 || year2 == -1) {
      text("Please select two years.", 690, 530);}
      else{
    text("CPI By Time: From " + Integer.toString(myMin(year1, year2)+2003) + " To " + Integer.toString(myMax(year1, year2)+2003), 690, 530);
    }
    drawModeTabs( );
    drawYearTabs();
    drawBigPercentLabels();
    if(year1 != -1 && year2 != -1) {
    drawBlockGraph();
    }
  } 
  else
  {
    textFont(f, 36);
    fill(255);
    drawModeTabs( );
    drawYearLabels();
    drawTitleTabs( );
    datas[currentColumn].drawTimeSeries();
    datas[currentColumn].drawYearAverage();
    datas[currentColumn].drawValueLabels();
  }
}

int myMax(int int1, int int2) {
  if (int1 > int2) {
    return int1;
  }
  else {
    return int2;
  }
}

int myMin(int int1, int int2) {
  if (int1 < int2) {
    return int1;
  }
  else {
    return int2;
  }
}

void mousePressed( ) {
  if (mode != 2) {
    if (mouseY > tabTop && mouseY < tabBottom) {
      for (int col = 0; col < 9; col++) {
        if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
          if (mode == 0 && col != currentColumn) {
            currentColumn = col;
            redraw();
          }
          if (mode == 1) {
            display[col] = !display[col];
            redraw();
          }
        }
      }
    }
  }
  else {
    if (mouseY > yearTabTop && mouseY < yearTabBottom) {
      for (int col = 0; col < 11; col++) {
        if (mouseX > yearTabLeft[col] && mouseX < yearTabRight[col]) {
          if (col == year1) {
            year1 = -1;
            redraw();
          }
          else if (col == year2) {
            year2 = -1;
            redraw();
          }
          else if (year1 == -1) {
            year1 = col;
            redraw();
          }
          else if (year2 == -1) {
            year2 = col;
            redraw();
          }
        }
      }
    }
  }
  if (rectX1 <= mouseX && mouseX <= rectX1+70 && rectY2 + 50 <= mouseY && mouseY <= rectY2 + 80) {
    if (mode != 0) {
      mode = 0;
      redraw();
    }
  }
  if (rectX1 <= mouseX && mouseX <= rectX1+70 && rectY2 + 90 <= mouseY && mouseY <= rectY2 + 120) {
    if (mode != 1) {
      mode = 1;
      redraw();
    }
  }
  if (rectX1+90 <= mouseX && mouseX <= rectX1+160 && rectY2 + 50 <= mouseY && mouseY <= rectY2 + 80) {
    if (mode != 2) {
      mode = 2;
      redraw();
    }
  }
}

