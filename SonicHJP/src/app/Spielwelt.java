package app;

import java.util.ArrayList;

import Entities.Gegner;
import Entities.Fisch;
import Entities.Biene;
import Entities.Affe;
import Entities.Sonic;
import Objects.Objekt;
import Objects.Projektil;
import Objects.Ring;
import Objects.SS_SBahn;
import Objects.SpezialStrecke;
import javafx.scene.image.Image;
import javafx.scene.paint.Color;

public class Spielwelt {
	// ATTRIBUTE //
	private Image dasLevelImage;
	
	private Kamera dieKamera;
	private Sonic derSpieler;
	private SpezialStrecke[] dieSpezialStrecken;
	private ArrayList<Objekt> dieObjekte;
	private ArrayList<Ring> dieRinge;
	private ArrayList<Gegner> dieGegner;
	private ArrayList<Projektil> dieProjektile;
	
	
	// KONSTRUKTOR //
	public Spielwelt(Image pLevelImage, float pSpielerX, float pSpielerY, SpezialStrecke[] pSpezialStrecken, ArrayList<Objekt> pDieObjekte, ArrayList<Ring> pDieRinge, ArrayList<Gegner> pDieGegner, ArrayList<Projektil> pDieProjektile) {
		dasLevelImage = pLevelImage;
		dieKamera = new Kamera(pSpielerX, pSpielerY, 48);
		derSpieler = new Sonic(pSpielerX, pSpielerY, dieKamera);
		dieGegner = new ArrayList<Gegner>();
		
		dieGegner.add(new Fisch(10,10));
		dieGegner.add(new Biene(10,10));
		dieGegner.add(new Affe(10,10));
		
		dieSpezialStrecken = new SpezialStrecke[1];
		dieSpezialStrecken[0] = new SS_SBahn(-1 - 4 * 3 * 2, -1 - 2.5f, 2);
		dieObjekte = pDieObjekte;
		dieRinge = pDieRinge;
		dieGegner = pDieGegner;
		dieProjektile = pDieProjektile;
		
		debugCreateMap();
	}
	
	
	// METHODEN //
	public void start() {
		debugStart();
	}
	
	
	public void update(float delta) {
		debugUpdate();
		debugDraw(delta);
		
		derSpieler.update(delta);
	}
	
	
	public void fixedUpdate(float delta) {
		derSpieler.fixedUpdate(delta);
		
		// Try entering spezial track
		if (!derSpieler.isPhysicsLocked() && derSpieler.getGrounded() && Math.abs(derSpieler.getSpeedX()) > 10) {
			for(int i = 0; i < dieSpezialStrecken.length; i++) {
				boolean Abfrage = dieSpezialStrecken[i].isPointInRange(derSpieler.getX(), derSpieler.getY());
				if (Abfrage == true) {
					if (CMath.distance(dieSpezialStrecken[i].getX(), 0, derSpieler.getX(), 0) <= 1) {
						// Enter from left
						if (derSpieler.getSpeedX() < 0) continue;
						
						derSpieler.setSpezialProzent(0);
						derSpieler.setSpezialZiel(1);
					} else {
						// Enter from right
						if (derSpieler.getSpeedX() > 0) continue;
						
						derSpieler.setSpezialProzent(1);
						derSpieler.setSpezialZiel(0);
					}
					
	
					derSpieler.lockPhysics();
					derSpieler.setSpezialStrecke(dieSpezialStrecken[i]);
				}
			}
		}
	}
	
	
	public void draw() {
		if (dieSpezialStrecken != null) {
			for (int i = 0; i < dieSpezialStrecken.length; i++) {
				dieSpezialStrecken[i].draw(dieKamera);
			}
		}
		
		derSpieler.draw();
		
		if (dieSpezialStrecken != null) {
			for (int i = 0; i < dieSpezialStrecken.length; i++) {
				dieSpezialStrecken[i].lateDraw(dieKamera);
			}
		}
	}
	
	
	public Sonic getSpieler() {
		return derSpieler;
	}
	
	
	
	// DEBUG
	private void debugStart() {
		
	}
	
	private void debugDraw(float delta) {
		// grid
		int ph = (int)Math.floor(dieKamera.getX() - (dieKamera.getWidth() / 2));
		for (int x = ph; x <= (ph + (int)Math.ceil(dieKamera.getWidth())); x++) {
			if (x == 0) {
				dieKamera.setFarbe(Color.RED);
				dieKamera.setLineWidth(0.03f);
			} else {
				dieKamera.setFarbe(Color.BLACK);
				dieKamera.setLineWidth(0.01f);
			}
			
			dieKamera.drawLine(x, dieKamera.getY() - (dieKamera.getHeight() / 2), x, dieKamera.getY() + (dieKamera.getHeight() / 2));
		}
		
		ph = (int)Math.floor(dieKamera.getY() - (dieKamera.getHeight() / 2));
		for (int y = ph; y <= (ph + (int)Math.ceil(dieKamera.getHeight())); y++) {
			if (y == 0) {
				dieKamera.setFarbe(Color.RED);
				dieKamera.setLineWidth(0.03f);
			} else {
				dieKamera.setFarbe(Color.BLACK);
				dieKamera.setLineWidth(0.01f);
			}
			
			dieKamera.drawLine(dieKamera.getX() - (dieKamera.getWidth() / 2), y, dieKamera.getX() + (dieKamera.getWidth() / 2), y);
		}
		
		
		for (int xx = 0; xx < 15; xx++) {
			int clr = xx % 2;
			for (int yy = 0; yy < 5; yy++) {
				clr = (clr + yy) % 2;
				
				if (clr == 0) dieKamera.setFarbe(new Color(1, 0, 0, 0.4f));
				else dieKamera.setFarbe(new Color(1, 1, 0, 0.4f));
				
				dieKamera.drawRect(xx * 10, yy * 10, 10, 10);
			}
		}
		
		
		dieKamera.setLineWidth(0.02f);
		
		
		Kollision.drawDebug(dieKamera);
		
		
		// kollision test
		dieKamera.setFarbe(Color.DARKRED);
		float phfps = (float)Math.floor((1f / delta) * 10) / 10;
		dieKamera.drawText(phfps + " FPS", dieKamera.getX() - (dieKamera.getWidth() / 2) + 0.15f, dieKamera.getY() + (dieKamera.getHeight() / 2) - 0.5f);
		float phx = (float)Math.floor(dieKamera.pixelZuEinheitX(Eingabe.mouseX) * 10) / 10;
		float phy = (float)Math.floor(dieKamera.pixelZuEinheitY(Eingabe.mouseY) * 10) / 10;
		dieKamera.drawText("cursor: " + phx + " | " + phy, dieKamera.getX() - (dieKamera.getWidth() / 2) + 0.15f, dieKamera.getY() + (dieKamera.getHeight() / 2) - 1f);
		
		
		//dieKamera.drawLine(dieKamera.getX(), dieKamera.getY(), phx, phy);
		/*dieKamera.drawLine(phx, phy, phx, phy - 1);
		RaycastHit hit = Kollision.raycast(phx, phy, 0, -1, true);
		
		if (hit != null) {
			dieKamera.drawOval(hit.hitX - 0.2f, hit.hitY - 0.2f, 0.4f, 0.4f);
			dieKamera.drawLine(hit.hitX, hit.hitY, hit.hitX + hit.normalX, hit.hitY + hit.normalY);
		}*/
	}
	
	private void debugUpdate() {
		/*if (Eingabe.isKeyDown("A")) {
			dieKamera.setX(dieKamera.getX() - 0.1f);
		} else if (Eingabe.isKeyDown("D")) {
			dieKamera.setX(dieKamera.getX() + 0.1f);
		}
		if (Eingabe.isKeyDown("S")) {
			dieKamera.setY(dieKamera.getY() - 0.1f);
		} else if (Eingabe.isKeyDown("W")) {
			dieKamera.setY(dieKamera.getY() + 0.1f);
		}*/
	}
	
	private void debugCreateMap() {
		/*new Kollision(-1, -1, 7, -3, false);
		new Kollision(7, -3, 10, -4, false);
		new Kollision(10, -4, 15, -3.5f, false);
		new Kollision(15, -3.5f, 21, -3.75f, false);
		new Kollision(21, -3.75f, 27, -4.5f, false);
		new Kollision(27, -4.5f, 30, -4f, false);
		new Kollision(30, -4, 31, -3, false);
		new Kollision(31, -3, 32, -1.5f, false);
		new Kollision(35, -1, 48, 1, false);
		new Kollision(32, -1.5f, 32.1f, 0.5f, false);
		new Kollision(32.1f, 0.5f, 31.9f, 2f, false);
		new Kollision(31.9f, 2f, 31f, 3.1f, false);
		new Kollision(28f, 4.8f, 31, 3.1f, false);
		new Kollision(16, 0, 19, 0, true);
		new Kollision(-25f, -1f, -40, -1f, false);*/
	}
}
