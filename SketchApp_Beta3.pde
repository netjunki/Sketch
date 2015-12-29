/**==================================================
 This code was written by Light BWK as Processing
 API learning process. 
 Code is licensed CC-BY-SA 4.0 Light BWK 2015 
 ==================================================*/

import codeanticode.tablet.*;
Tablet tablet;

boolean showSave = false, toggleDraw = true, toggleMirror = false, clearCanvas = false, penPressure = false, reDraw = true;
boolean storyBoard = false, gettingThumbnails = false, gettingPortrait = false, gettingThirds = false, mySketch = false;
int draw, erase;
float hue = 105, sat = 65, value = 70;
float thickness = 3, alpha = 5, loopRandomHue = 2, loopDim = 1.6, pressure, lineWeight;
PImage UITEXT, EXTRA;
String timeStamp;

void setup() {
  size(1280, 720);                    //BASE SETUP
  frameRate(60);
  colorMode(HSB, 200, 200, 200);
  background(0, 0, 190);
  UITEXT = loadImage("UITEXT.png");
  EXTRA = loadImage("usr/EG.png");
  tablet = new Tablet(this);
}

void draw() {
  color transparent = color(0, 0, 200, 0);
  
  if (focused) {                                 //Redraw only when window in focus

    if (reDraw) {                                //Redraw UI only when redraw is true and window in focus
      noStroke();
      fill(120, 60, 80);
      rect(0, 0, width, 80);
      image(UITEXT, 0, 0);

      if (showSave) {                            //UI: SAVED INDICATOR
        strokeWeight(3);
        stroke(0, 140, 200);
        line(175, 60, 203, 60);
      }
      if (toggleDraw) {                          //UI: INDICATORS TO SKETCH or ERASE
        strokeWeight(3);
        stroke(0, 140, 200);
        line(245, 65, 290, 65);
        stroke(transparent);
        line(307, 65, 345, 65);
      } else if (!toggleDraw) {
        strokeWeight(3);
        stroke(transparent);
        line(245, 65, 290, 65);
        stroke(0, 140, 200);
        line(307, 65, 345, 65);
      }
      if (toggleMirror) {                       //UI: TOGGLE MIRROR INDICATOR
        stroke(0, 140, 200);
        strokeWeight(3);
        line(363, 65, 407, 65);
      }
      if (toggleDraw) {                         //UI: DRAW BRUSH SIZE
        draw = 100;
        erase = 190;
      } else if (!toggleDraw) {
        draw = 190;
        erase = 100;
      }
      noStroke();
      fill(0, 0, erase);
      ellipse(500, 40, 50, 50);                //BG Circle
      fill(0, 0, draw);
      ellipse(500, 40, thickness, thickness);  //FB Brush Circle

      noStroke();                              //UI: BRUSH COLOR
      fill(hue, sat, value);
      ellipse(648, 40, 50, 50);
      for (int i = 0; i < 40; i++) {           //UI: HUE BAR, 40 steps, 5 px per step
        fill(i*5, 200, 200);
        rect(680 + (i*5), 20, 5, 10);
      }
      stroke(0, 0, 200);
      line(hue + 680, 20, hue + 680, 30);
      noStroke();
      
      for (int i = 0; i < 20; i++) {          //UI: SATURATION BAR, 20 steps, 10 px per step
        noStroke();
        fill(hue, i*10, 200);
        rect(680 + (i*10), 35, 10, 10);
      }
      stroke(hue, 200-sat, 150);
      line(sat+680, 35, sat + 680, 45);
      noStroke();
      
      for (int i = 0; i < 20; i++) {          //UI: VALUE BAR, 20 steps, 10 px per step
        noStroke();
        fill(hue, sat, i*10);
        rect(680 + (i*10), 50, 10, 10);
      }
      stroke(120, 50, 200 - value);
      line(value + 680, 50, value + 680, 60);
      noStroke();
      
      if (clearCanvas) {                     //UI: CLEAR CANVAS
        noStroke();
        fill(0, 0, 190);
        rect(0, 80, width, height - 80);
        storyBoard = false;
        gettingThumbnails = false;
        gettingPortrait = false;
        gettingThirds = false;
        clearCanvas = false;
      }

      if (storyBoard) {                                     //UI: HIDDEN STORYBOARD
        stroke(0, 0, 170);
        strokeWeight(2);
        noFill();
        rect(30, 110, width-60, (height-110)-30);           //big box
        stroke(0, 0, 175);
        strokeWeight(0.1);
        rect(90, 150, width-180, (height-150)-80);          //small box
        line(width-400, 106, width-30, 106);
      }
      if (gettingThumbnails) {                                          //UI: HIDDEN THUMBNAILS DIVIDERS
        stroke(0, 0, 170);
        strokeWeight(1);
        line(10, ((height-80)/2)+80, width-10, ((height-80)/2)+80);     // horizontal
        line(width/2, 90, width/2, height-10);                          //vertical
      }
      if (gettingPortrait) {                                            //UI: HIDDEN PORTRAIT DIVIDERS
        stroke(0, 0, 170);
        strokeWeight(1);
        line(width/3, 90, width/3, height-10);                          //line left
        line((width/3)*2, 90, (width/3)*2, height-10);                  //line right
      }
      if (gettingThirds) {                                                     //UI: HIDDEN THIRDS
        stroke(0, 0, 170);
        strokeWeight(1);
        line(width/3, 90, width/3, height-10);                                 //line vertical left
        line((width/3)*2, 90, (width/3)*2, height-10);                         //line vertical right
        line(10, ((height-80)/3)+80, width-10, ((height-80)/3)+80);            //line horizontal top
        line(10, (((height-80)/3)*2)+80, width-10, (((height-80)/3)*2)+80);    //line horizontal bottom
      }
      if (loopRandomHue < 2) {                                                 //UI: HIDDEN CANVAS HUES
        noStroke();
        fill(random(0, 200), 40, 200, 35);
        rect(0, 80, width, height-80);
        loopRandomHue += 0.1;
        delay(20);
      }
      if (loopDim < 1.6) {                                                     //UI: HIDDEN ONION SKIN
        noStroke();
        fill(0, 0, 190, 25);
        rect(0, 80, width, height-80);
        loopDim += 0.1;
        delay(20);
      }

      if (alpha < 5) {                                  //UI: EE DARK
        noStroke();
        fill(0, 0, 0, alpha);
        rect(0, 80, width, height-80);
        alpha += 0.1;
      }
      if (mySketch) {                                   //UI: EE OOPS
        imageMode(CENTER);
        fill(0, 0, 190);
        rect(0, 80, width, height-80);
        image(EXTRA, width*0.5, (height*0.5)+40);
        imageMode(CORNER);
      }
      redraw = false;                                   //Don't redraw if no input event changing redraw state to true
    }

    //change cursor type when mouse over UI
    if (mouseX > 172 && mouseX < 210 && mouseY > 24 && mouseY < 60) {             //=====on Screen Capture or SAVE IMAGE
      cursor(HAND);
    } else if (mouseX > 224 && mouseX < 296 && mouseY > 29 && mouseY < 65) {      //=====on Sketch Mode
      cursor(HAND);
    } else if (mouseX > 305 && mouseX < 351 && mouseY > 29 && mouseY < 65) {      //=====on Erase Mode
      cursor(HAND);
    } else if (mouseX > 360 && mouseX < 414 && mouseY > 29 && mouseY < 65) {      //=====on Mirror Mode
      cursor(HAND);
    } else if (mouseX > 523 && mouseX < 542 && mouseY > 10 && mouseY < 28) {      //=====on Increase Brush Size
      cursor(HAND);
    } else if (mouseX > 523 && mouseX < 542 && mouseY > 50 && mouseY < 72) {      //=====on Decrease Brush Size
      cursor(HAND);
    } else if (dist(mouseX, mouseY, 500, 40) < 25) {                              //=====on Resize Brush Area
      cursor(HAND);
    } else if (mouseX > 905 && mouseX < 965 && mouseY > 15 && mouseY < 65) {      //=====on Clear Paint Area
      cursor(HAND);
    } else if (mouseX > 680 && mouseX < 880 && mouseY > 20 && mouseY < 30) {      //=====on Hue
      cursor(HAND);
    } else if (mouseX > 680 && mouseX < 880 && mouseY > 35 && mouseY < 45) {      //=====on Saturation
      cursor(HAND);
    } else if (mouseX > 680 && mouseX < 880 && mouseY > 50 && mouseY < 60) {      //=====on Value
      cursor(HAND);
    } else if (mouseY < 80) {                                                     //=====on the other part of UI
      cursor(ARROW);
    } else {
      cursor(CROSS);                                                              //=====on the Canvas
    }

    if (mousePressed) {                                                                   //MOUSE CLICK EVENTS

      showSave = false; 
      reDraw = true;

      if (penPressure) {                                                                  //=====PRESSURE TOGGLE & TEST
        pressure = tablet.getPressure();
        if (pressure == 0) {
          lineWeight = thickness * 0.1;
        } else if (pressure > 0) {
          lineWeight = thickness * pressure;
        }
      } else if (!penPressure) {
        lineWeight = thickness;
      }

      if (mouseButton == LEFT && toggleDraw && !toggleMirror && mouseY > 80) {            //=====NORMAL SKETCH/DRAW
        stroke(hue, sat, value);
        strokeWeight(lineWeight + 0.1);
        line(mouseX, mouseY, pmouseX, pmouseY);
      } else if (mouseButton == LEFT && !toggleDraw && !toggleMirror && mouseY > 80) {    //=====NORMAL ERASE
        stroke(0, 0, 190);
        strokeWeight(thickness + 0.1);
        line(mouseX, mouseY, pmouseX, pmouseY);
      } else if (mouseButton == LEFT && toggleDraw && toggleMirror && mouseY > 80) {      //=====DRAW IN MIRROR MODE
        stroke(hue, sat, value);
        strokeWeight(lineWeight + 0.1);
        line(mouseX, mouseY, pmouseX, pmouseY);
        line(width-mouseX, mouseY, width-pmouseX, pmouseY);
      } else if (mouseButton == LEFT && !toggleDraw && toggleMirror && mouseY > 80) {     //=====ERASE IN MIRROR MODE
        stroke(0, 0, 190);
        strokeWeight(thickness + 0.1);
        line(mouseX, mouseY, pmouseX, pmouseY);
        line(width-mouseX, mouseY, width-pmouseX, pmouseY);
      } else if (mouseX > 172 && mouseX < 210 && mouseY > 24 && mouseY < 60 && mouseButton == LEFT) {      //=====LMB Click Screen Capture or SAVE IMAGE
        timeStamp = year() + "-" + month() + "-" + day() + "_" + hour() + "-" + minute() + "-" + second();
        saveFrame("ScreenShot" + "/" + timeStamp + ".png");
        showSave = true;
        delay(300);
      } else if (mouseX > 224 && mouseX < 296 && mouseY > 29 && mouseY < 65 && mouseButton == LEFT) {      //=====LMB Click Sketch Mode
        toggleDraw = true;
        delay(200);
      } else if (mouseX > 305 && mouseX < 351 && mouseY > 29 && mouseY < 65 && mouseButton == LEFT) {      //=====LMB Click Erase Mode
        toggleDraw = false;
        delay(200);
      } else if (mouseX > 360 && mouseX < 414 && mouseY > 29 && mouseY < 65 && mouseButton == LEFT) {      //=====LMB Click Mirror Mode
        toggleMirror = !toggleMirror;
        delay(200);
      } else if (mouseX > 523 && mouseX < 542 && mouseY > 10 && mouseY < 28 && mouseButton == LEFT) {      //=====LMB Click Increase Brush Size
        if (thickness < 50) {
          thickness ++;
          delay(100);
        }
      } else if (mouseX > 523 && mouseX < 542 && mouseY > 50 && mouseY < 72 && mouseButton == LEFT) {      //=====LMB Click Decrease Brush Size
        if (thickness > 1) {
          thickness --;
          delay(100);
        }
      } else if (dist(mouseX, mouseY, 500, 40) < 25 && mouseButton == LEFT && thickness < 50) {            //=====LMB Click to resize Brush
        thickness = dist(mouseX, mouseY, 500, 40) * 2;
      } else if (mouseX > 905 && mouseX < 965 && mouseY > 15 && mouseY < 65 && mouseButton == LEFT) {      //=====LMB Click Clear Paint Area
        clearCanvas = true;
        delay(200);
      } else if (mouseX > 680 && mouseX < 880 && mouseY > 20 && mouseY < 30 && mouseButton == LEFT) {      //=====LMB Click color to pick hue
        hue = mouseX - 680;
      } else if (mouseX > 680 && mouseX < 880 && mouseY > 35 && mouseY < 45 && mouseButton == LEFT) {      //=====LMB Click color to pick saturation
        sat = mouseX - 680;
      } else if (mouseX > 680 && mouseX < 880 && mouseY > 50 && mouseY < 60 && mouseButton == LEFT) {      //=====LMB Click color to pick value
        value = mouseX - 680;
      } else if (mouseY > 80 && mouseButton == RIGHT) {                                                    //=====RMB CLICK to color pick from canvas
        int picked = get(mouseX, mouseY);
        hue = hue(picked);
        sat = saturation(picked);
        value = brightness(picked);
      }
    }

    if (keyPressed) {                                      //KEY PRESS EVENTS
      reDraw = true;
      if ((key == 'c') || (key == 'C')) {                  //=====CLEAR SCREEN, REMOVE STORYBOARD FRAME, THUMBNAILS SKETCH DIVIDERS & PORTRAIT SKETCH DIVIDERS
        clearCanvas = true;
      } else if ((key ==']') && thickness < 50) {          //=====INCREASE BRUSH SIZE
        thickness ++;
        delay(200);
      } else if ((key =='[') && thickness > 1) {           //=====DECREASE BRUSH SIZE
        thickness --;
        delay(200);
      } else if ((key == 'e') || (key == 'E')) {           //=====TOGGLE TO ERASE
        toggleDraw = false;
        delay(200);
      } else if ((key == 'b') || (key == 'B')) {           //=====TOGGLE TO DRAW
        toggleDraw = true;
        delay(200);
      } else if ((key == 'm') || (key == 'M')) {           //=====TOOGLE MIRROR MODE, TOGGLE ON/OFF
        toggleMirror = !toggleMirror;
        delay(200);
      } else if ((key == 's') || (key == 'S')) {           //=====SAVE IMAGE
        timeStamp = year() + "-" + month() + "-" + day() + "_" + hour() + "-" + minute() + "-" + second();
        saveFrame("ScreenShot" + "/" + timeStamp + ".png");
        showSave = true;
        delay(300);
      } else if (key == '1') {                             //=====HIDDEN FEATURE: STORYBOARD
        storyBoard = true;
        delay(200);
      } else if (key =='2') {                              //=====HIDDEN FEATURE: THUMBNAILS BOXES
        gettingThumbnails = true;
        delay(200);
      } else if (key =='3') {                              //=====HIDDEN FEATURE: PORTRAIT BOXES
        gettingPortrait = true;
        delay(200);
      } else if (key =='4') {                              //=====HIDDEN FEATURE: COMPOSITION THIRDS
        gettingThirds = true;
        delay(200);
      } else if (key == '5') {                             //=====HIDDEN FEATURE: RANDOM LOW SAT HUES
        loopRandomHue = 0;
        delay(200);
      } else if (key =='6') {                              //=====HIDDEN FEATURE: ONION SKIN
        loopDim = 0;
        delay(200);
      } else if (key == '9') {                             //=====EE #2, GETTING DARK
        alpha = 0;
        delay(200);
      } else if (key == '0') {                             //=====EE #1, OOPS, TOGGLE ON/OFF
        mySketch = !mySketch;
        delay(200);
      } else if (key == 'p' || key == 'P') {               //=====(DE)ACTIVATE PEN PRESSURE
        penPressure = !penPressure;
        delay(200);
      }
    }
  }
}