public class Fusion { 
  // attributes
  // forme ; action ; color (R,G,B) ; position (x,y)
  float xpos = 400;
  float ypos = 400;
  
  color red = color(255,0,0);
  color green = color(0,255,0);
  color blue = color(0,0,255);
  color bl = color(0,0,0);
  
  String verbe;
  String formeString;
  String ce;
  String couleur;
  String position;
  float tauxConfience = 70;
  
  Forme forme;
  
  // constructeur
  Fusion (String action, String desig,String geste ,String col,String pos) {
    verbe = action;
    formeString = geste;
    ce = desig;
    couleur = col;
    position = pos;
  } 
  // fonction (méthodes)
  void StringToForme(String geste){
  } 
}
