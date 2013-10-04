import de.bezier.data.*;
class DataSet {
  String fileName;
  String title;
  float[][] monthCPI = new float[11][12];
  float[] yearCPI = new float[11];
  float[][] halfYearCPI = new float[11][2];
  float wholeMax;
  float wholeMin;
  XlsReader reader;

  DataSet(String file) {
    fileName = file;
  }

  float getYearAverage(int year) {
    return yearCPI[year];
  }
  
  void drawValueLabels() {
    stroke(128);
    strokeWeight(1);
    fill(0);
    textAlign(CENTER, BOTTOM);
    int cut = ((int)wholeMax - (int)wholeMin) / 5;
    for (int i = (int)wholeMin; i <= (int)wholeMax; i += cut) {
      float y = map(i, wholeMin, wholeMax, rectY2, rectY1);
      textFont(label, 10);
      text(i, 20, y);
    }
  }

  void drawYearAverage() {
    smooth();
    fill(0);
    strokeWeight(4);
    stroke(#FF0000);
    textAlign(CENTER, BOTTOM);
    PFont f;
    f = createFont("FreeMono", 16, false);
    textFont(f, 12);
    for (int i = 0; i < 10; i++) {
      float x = map(i, 0, 10, rectX1 + 50, rectX2+25);
      float y = map(yearCPI[i], wholeMin, wholeMax, rectY2, rectY1);
      point(x, y);
      text(yearCPI[i], x, y+20);
    }
  }
  
   void drawBlocks() {
    smooth();
    fill(0);
    strokeWeight(4);
    stroke(#FF0000);
    textAlign(CENTER, BOTTOM);
    PFont f;
    f = createFont("FreeMono", 16, false);
    textFont(f, 12);
    for (int i = 0; i < 10; i++) {
      float x = map(i, 0, 10, rectX1 + 50, rectX2+25);
      float y = map(yearCPI[i], wholeMin, wholeMax, rectY2, rectY1);
      point(x, y);
      text(yearCPI[i], x, y+20);
    }
  }

  void drawTimeSeries() {
    if (mode == 0) {
      textFont(f, 36);
      fill(255);
      text("CPI of " + title, 690, 530);
    }
    stroke(#5679C1);
    label = createFont("Arial", 16, true);
    textFont(label, 10);
    smooth();
    beginShape( );
    noFill();
    for (int i = 0; i <= 10; i++) {
      for (int j = 0; j <= 11; j++) {
        if (i == 10 && j > 2) {
          break;
        } 
        float x = map(i*12 + j, 0, 123, rectX1, rectX2);
        float y = map(monthCPI[i][j], wholeMin, wholeMax, rectY2, rectY1);

        vertex(x, y);
      }
    }
    endShape();
    drawDataHighlight() ;
  }

  void drawPercent() {
    strokeWeight(1);
    if (fileName == "AllItem.xls") {
      stroke(#5679C1);
    } 
    else if (fileName == "Apparel.xls") {
      stroke(#FF00FF);
    }
    else if (fileName == "Education.xls") {
      stroke(#567921);
    }
    else if (fileName == "Food.xls") {
      stroke(#A680C1);
    }
    else if (fileName == "Housing.xls") {
      stroke(#00FF08);
    }
    else if (fileName == "Medical.xls") {
      stroke(#E01B1B);
    }
    else if (fileName == "MedicalService.xls") {
      stroke(#FF7700);
    }
    else if (fileName == "Recreation.xls") {
      stroke(#BB00FF);
    }
    else if (fileName == "Transportation.xls") {
      stroke(#FFD000);
    }
    smooth();
    beginShape( );
    noFill();
    for (int i = 0; i <= 10; i++) {
      for (int j = 0; j <= 11; j++) {
        if (i == 10 && j > 2) {
          break;
        } 
        float x = map(i*12 + j, 0, 123, rectX1, rectX2);
        float y = map((monthCPI[i][j]-monthCPI[0][0])/monthCPI[0][0], -0.1, 0.6, rectY2, rectY1);
        vertex(x, y);
        if (i == 10 && j == 2) {
          label = createFont("Arial", 16, true);
          textFont(label, 13);
          text(title, x+ 20, y);
        }
      }
    }
    endShape();
    drawPercentDataHighlight() ;
  }

  void drawDataHighlight() {
    for (int i = 0; i <= 10; i++) {
      for (int j = 0; j <= 11; j++) {
        if (i == 10 && j > 2) {
          break;
        } 
        float x = map(i*12 + j, 0, 123, rectX1, rectX2);
        float y = map(monthCPI[i][j], wholeMin, wholeMax, rectY2, rectY1);
        if (dist(mouseX, mouseY, x, y) < 4) {
          strokeWeight(5);
          point(x, y);
          fill(0);
          textSize(10);
          textAlign(CENTER);
          text(  monthCPI[i][j] + " (" + (i + 2003) + "," + (j+1) + ")", x, y-8);
        }
      }
    }
  }

  void drawPercentDataHighlight() {
    for (int i = 0; i <= 10; i++) {
      for (int j = 0; j <= 11; j++) {
        if (i == 10 && j > 2) {
          break;
        } 
        float x = map(i*12 + j, 0, 123, rectX1, rectX2);
        float y = map((monthCPI[i][j]-wholeMin)/wholeMin, -0.1, 0.6, rectY2, rectY1);
        if (dist(mouseX, mouseY, x, y) < 4) {
          strokeWeight(5);
          point(x, y);
          textSize(10);
          text(title + " : " + (monthCPI[i][j]-wholeMin)/wholeMin * 100 + "%" + " (" + (i + 2003) + "," + (j+1) + ")", x, y-8);
        }
      }
    }
  }
}

