public class Level {
  // ATTRIBUTE //
  public Werkzeug dasWerkzeug;
  private int auswahlWerkzeug;
  private int toolboxPosX, toolboxPosY;

  // Platzierte Dinge
  public ArrayList<Objekt> liste_Objekte;
  public ArrayList<Strecke> liste_Strecken;
  public ArrayList<Spezial> liste_Spezial;
  public ArrayList<Gegner> liste_Gegner;

  private PImage hintergrund;
  private boolean zeichneMap;
  
  
  // Level-Config
  public int levelMapID;
  public int levelPixelProEinheit;
  public int sonicSpawnX, sonicSpawnY;
  


  // KONSTRUKTOR //
  public Level() {
    auswahlWerkzeug = 0;
    werkzeugWechseln(0);
    toolboxPosX = width - 300;
    toolboxPosY = height - 200;
    
    
    liste_Objekte = new ArrayList<Objekt>();
    liste_Strecken = new ArrayList<Strecke>();
    liste_Spezial = new ArrayList<Spezial>();
    liste_Gegner = new ArrayList<Gegner>();
    
    
    levelMapID = 0;
    levelPixelProEinheit = 32;
    sonicSpawnX = 10;
    sonicSpawnY = 10;
    
    
    hintergrund = loadImage("images/map_01.png"); // 88x8 chunks; 4x4 tiles per chunk
    zeichneMap = false;
  }


  // METHODEN //
  public void zeichnen() {
    // Hintergrund zeichnen
    if (zeichneMap) {
      tint(200, 200, 200, 155);
      //dieKamera.drawImage(hintergrund, 0, 0, 88 * 4, 8 * 4);
      dieKamera.drawImage(hintergrund, 0, 0, hintergrund.width / levelPixelProEinheit, hintergrund.height / levelPixelProEinheit);
    }


    // Spezial-Liste zeichnen
    stroke(0, 0, 0, 155);
    fill(75, 75, 255, 155);
    for (int i = 0; i < liste_Spezial.size(); i++) {
      liste_Spezial.get(i).zeichnen();
    }

    // Strecken-Liste zeichnen
    stroke(75, 75, 255);
    strokeWeight(6);
    for (int i = 0; i < liste_Strecken.size(); i++) {
      liste_Strecken.get(i).zeichnen();
    }


    // Objekt-Liste zeichnen
    stroke(0, 0, 0, 155);
    fill(75, 75, 255, 155);

    // Objekte zeichnen

    for (int i = 0; i < liste_Objekte.size(); i++) {
      liste_Objekte.get(i).zeichnen();
    }

    // Gegner-Liste zeichnen
    stroke(0, 0, 0, 155);
    fill(75, 75, 255, 155);
    
    for (int i = 0; i < liste_Gegner.size(); i++) {
      liste_Gegner.get(i).zeichnen();
    }
    
    // Sonic
    stroke(0);
    fill(255, 0, 0, 155);
    dieKamera.drawCircle((float)sonicSpawnX, (float)sonicSpawnY, 0.5f);


    // Werkzeug
    dasWerkzeug.zeichnen();
    dasWerkzeug.getToolbox().zeichnen(toolboxPosX, toolboxPosY);
  }


  public void cursorMoved(float deltaX, float deltaY) {
    dasWerkzeug.cursorMoved(deltaX, deltaY);
    
    // Toolbox bewegen
    if (dieEingabe.istMausButtonGedrueckt(0) && mouseX >= toolboxPosX && mouseX <= (toolboxPosX + 300) && mouseY >= toolboxPosY && mouseY <= (toolboxPosY + 200)) {
      toolboxPosX += deltaX * dieKamera.pixelProEinheit;
      toolboxPosY -= deltaY * dieKamera.pixelProEinheit;
      
      if (toolboxPosX > (width - 10)) toolboxPosX = width - 10;
      else if ((toolboxPosX + 300) < 10) toolboxPosX = -290;
      
      if (toolboxPosY > (height - 10)) toolboxPosY = height - 10;
      else if ((toolboxPosY + 200) < 10) toolboxPosY = -190;
    }
  }
  public void cursorPressed(int button) {
    if (mouseX >= toolboxPosX && mouseX <= (toolboxPosX + 300) && mouseY >= toolboxPosY && mouseY <= (toolboxPosY + 200)) return;
    
    // button == 0 -> LINKS; button == 1 -> RECHTS; button == 2 -> MITTE
    dasWerkzeug.cursorPressed(button);
  }
  public void cursorReleased(int button) {
    // button == 0 -> LINKS; button == 1 -> RECHTS; button == 2 -> MITTE
    dasWerkzeug.cursorReleased(button);
  }
  public void cursorClicked(int button) {
    if (mouseX >= toolboxPosX && mouseX <= (toolboxPosX + 300) && mouseY >= toolboxPosY && mouseY <= (toolboxPosY + 200)) return;
    
    // button == 0 -> LINKS; button == 1 -> RECHTS; button == 2 -> MITTE
    dasWerkzeug.cursorClicked(button);
  }

  public void tasteGedrueckt(char k) {
    dasWerkzeug.tasteGedrueckt(k);
    
    
    switch (k) {
      case ('A'):
        werkzeugWechseln(-1);
        break;
      case ('D'):
        werkzeugWechseln(1);
        break;
      case ('M'):
        zeichneMap = !zeichneMap;
        break;
      case ('9'):
        levelSpeichern();
        break;
      case ('0'):
        levelLesen();
        break;
    }
  }
  public void tasteLosgelassen(char k) {
    dasWerkzeug.tasteLosgelassen(k);
  }


  private void werkzeugWechseln(int richtung) {
    auswahlWerkzeug += richtung;
    if (auswahlWerkzeug >= 5)
      auswahlWerkzeug = 0;
    else if (auswahlWerkzeug < 0)
      auswahlWerkzeug = 4;

    println("Werkzeug gewechselt: " + auswahlWerkzeug);


    switch (auswahlWerkzeug) {
      case(0):
        dasWerkzeug = new WZ_Objekte();
        break;
      case(1):
        dasWerkzeug = new WZ_Strecken();
        break;
      case(2):
        dasWerkzeug = new WZ_Gegner();
        break;
      case(3):
        dasWerkzeug = new WZ_Spezial();
        break;
      case(4):
        dasWerkzeug = new WZ_Config();
        break;
    }
  }
  
  
  
  private void levelLesen() {
    liste_Objekte.clear();
    liste_Strecken.clear();
    liste_Spezial.clear();
    liste_Gegner.clear();
    
    
    BufferedReader reader = createReader("level.txt");
    String line;
    
    
    try {
      do {
        line = reader.readLine();
        
        if (line != null) {
          String[] split = splitTokens(line, " ");
          
          if (split[0].equals("OBJ")) { // OBJ X Y ID
            liste_Objekte.add(new Objekt(strToInt(split[3]), strToFloat(split[1]), strToFloat(split[2])));
          } else if (split[0].equals("STK")) { // STK X1 Y1 X2 Y2 TYP
            liste_Strecken.add(new Strecke(strToFloat(split[1]), strToFloat(split[2]), strToFloat(split[3]), strToFloat(split[4]), strToInt(split[5])));
          } else if (split[0].equals("SPC")) { // SPC X Y ID
            liste_Spezial.add(new Spezial(strToInt(split[3]), strToFloat(split[1]), strToFloat(split[2]), strToInt(split[4])));
          } else if (split[0].equals("GEG")) { // GEG X Y ID RICHTUNG
            liste_Gegner.add(new Gegner(strToInt(split[3]), strToFloat(split[1]), strToFloat(split[2]), strToInt(split[4])));
          } else if (split[0].equals("CNF")) { // GEG X Y ID RICHTUNG SONICX SONICY
            levelMapID = strToInt(split[1]);
            levelPixelProEinheit = strToInt(split[2]);
            sonicSpawnX = strToInt(split[3]);
            sonicSpawnY = strToInt(split[4]);
          }
        }
      } while (line != null);
      
      reader.close();
      
      println("Level geladen!");
    } catch (IOException e) {
      println("FEHLER - Konnte Level nicht laden!");
    }
  }

  private void levelSpeichern() {
    PrintWriter writer = createWriter("level.txt");
    
    
    // Speichere Konfiguration
    // CNF MAP-ID PIXEL-PRO-EINHEIT SONICX SONICY
    writer.println("CNF " + levelMapID + " " + levelPixelProEinheit + " " + sonicSpawnX + " " + sonicSpawnY);
    
    // Speichere liste_Objekte
    // OBJ X Y ID
    for (int i = 0; i < liste_Objekte.size(); i++) {
      Objekt p = liste_Objekte.get(i);
      writer.println("OBJ " + p.x + " " + p.y + " " + p.id);
    }
    
    // Speichere liste_Strecken
    // STK X1 Y1 X2 Y2 TYP
    for (int i = 0; i < liste_Strecken.size(); i++) {
      writer.println("STK " + liste_Strecken.get(i).x1 + " " + liste_Strecken.get(i).y1 + " " + liste_Strecken.get(i).x2 + " " + liste_Strecken.get(i).y2 + " " + liste_Strecken.get(i).typ);
    }
    
    // Speichere liste_Spezial
    // SPC X Y ID OPT
    for (int i = 0; i < liste_Spezial.size(); i++) {
      Spezial p = liste_Spezial.get(i);
      writer.println("SPC " + p.x + " " + p.y + " " + p.id + " " + p.opt);
    }
    
    // Speichere liste_Gegner
    // GEG X Y ID RICHTUNG
    for (int i = 0; i < liste_Gegner.size(); i++) {
      Gegner p = liste_Gegner.get(i);
      writer.println("GEG " + p.x + " " + p.y + " " + p.id + " " + p.richtung);
    }
    
    
    writer.flush();
    writer.close();
    
    
    println("Level gespeichert! Projekt-Ordner -> level.txt");
  }
  
  
  private int strToInt(String str) {
    try {
      return Integer.parseInt(str);
    } catch (NumberFormatException e) {
      return -1;
    }
  }
  
  
  private float strToFloat(String str) {
    try {
      return Float.parseFloat(str);
    } catch (NumberFormatException e) {
      return -1;
    }
  }
}
