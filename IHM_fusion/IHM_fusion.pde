/*
 *  vocal_ivy -> Demonstration with ivy middleware
 * v. 1.2
 * 
 * (c) Ph. Truillet, October 2018-2019
 * Last Revision: 22/09/2020
 * Gestion de dialogue oral
 */
 
import fr.dgac.ivy.*;
import java.awt.Point;

// data

Ivy bus;
PFont f;
String message= "";
ArrayList<Forme> formes = new ArrayList();
String cmd=""; //commande recu par ivy
String tau=""; //taux reco
String formeDessine=""; //forme reconnu par icar

int state; //etat machine a etat
public static final int INIT = 0;
public static final int AttCmd = 1;
public static final int DrawR = 2;
public static final int DrawC = 3;
public static final int DrawT = 4;
public static final int DrawCa = 5;
public static final int Pos = 6;
public static final int Coul = 7;


Boolean conditionFormeClicked = false;
Forme formeClicked= null;
Point pointPosition = null;
String[] cmdSplit = null;
Fusion motMut = null;

int StartTCmd;
int StartTAtt;

int totalTime = 10000;
int passedTime;

void init_param(){//en début d'intéractions, les paramètres sont null ou faux ou vide
   conditionFormeClicked = false;
   formeClicked= null;
   pointPosition = null;
   cmdSplit = null;
   motMut = null;
   cmd="";
   tau="";
   formeDessine="";
   message= "";
   verifForme=true;
}

void mousePressed() {
  Point p = new Point(mouseX,mouseY);
  // pour toute les formes faire isclicked enregistre la forme clickée (change bool conditionForme)
  //  si c'est pas une forme enregistre les coords
  
  if(!conditionFormeClicked){
    for (int i=0;i<formes.size();i++) { // we're trying every object in the list
    // println((formes.get(i)).isClicked(p));
      if ((formes.get(i)).isClicked(p)) {
          formeClicked = formes.get(i);
          conditionFormeClicked = true;
      }
    }
    if(!conditionFormeClicked) { pointPosition = p;}//si il n'y a aucune forme
  }
  else{// on recupère la coord 
      pointPosition = p;
    }
  }


void setup()
{
  size(800,800);
  fill(0,255,0);
  f = loadFont("TwCenMT-Regular-24.vlw");
  state = INIT;

  textFont(f,18);
  try
  {
    bus = new Ivy("sra_tts_bridge", " sra_tts_bridge is ready", null);
    bus.start("127.255.255.255:2010");
    
    bus.bindMsg("^ICAR Gesture=(.*)", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Vous avez fait le geste : " + args[0];
        formeDessine = args[0]; //string
      }        
    });
    
    bus.bindMsg("^sra5 Text=(.*) Confidence=(.*)", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Vous avez prononcé : " + args[0] + " avec un taux de confiance de " + args[1];
        cmd = args[0]; //string de la commande prononcée; ex : met rectangle ici
        tau = args[1]; //string de la confiance
      }        
    });
    
    bus.bindMsg("^sra5 Event=Speech_Rejected", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Malheureusement, je ne vous ai pas compris"; 
      }        
    });    
  }
  catch (IvyException ie)
  {
  }
}

void lectureSplit(String[] list){
  String geste = "" ;String ce = ""; String couleur = ""; String position = "";
  for(int i = 1; i<list.length;i++){
    switch(list[i]){
      case "ca":
       geste = list[i];
       break;
      case "ce":
        ce = list[i];
        break;
      case "Rectangle":
        geste = list[i];
        break;
      case "Cercle":
        geste = list[i];
        break;
      case "Triangle":
        geste = list[i];
        break;
      case "Rouge":
        couleur = list[i];
        break;
      case "Bleu":
        couleur = list[i];
        break;
      case "Vert":
        couleur = list[i];
        break;
      case "ici":
        position = list[i];
        break;
      case "la":
        position = list[i];
        break;
    }
  }
  motMut = new Fusion(list[0],ce,geste,couleur,position); //on crée l'objet possédant les attribut de la commande
}



// fonction d'affichage des formes m
void afficherGrille() {
  background(255);
  /* afficher tous les objets */
  for (int i=0;i<formes.size();i++) // on affiche les objets de la liste
    (formes.get(i)).update();
}

Forme creerNouvelleForme(Forme formeClicked){
  Forme f;
    if(formeClicked instanceof Triangle)
       f= new Triangle(formeClicked.origin);
    else if(formeClicked instanceof Rectangle)
       f= new Rectangle(formeClicked.origin);
    else
       f= new Cercle(formeClicked.origin);
    return f;

}

Forme creerDessin(String formeDessine, Point originDessin, color colorDessin){
  Forme f;
  if (formeDessine.equals("Triangle")) {     //triangle
      f = new Triangle(originDessin);
    f.c=colorDessin;
  }
    else if(formeDessine.equals("Rectangle")){  //rectangle
      f = new Rectangle(originDessin);
    f.c=colorDessin;
  }
    else                         {          //cercle
      f = new Cercle(originDessin);
    f.c=colorDessin;
  }
  return f;
}

void dessiner_forme_command(){
  if(motMut.ce.equals("ce") && formeClicked==null && !motMut.verbe.equals("Creer")){
          println("vous désignez une forme non désignée");
          verifForme=false;
          return;
   }
   if(motMut.formeString.equals("ca") && formeClicked==null &&!motMut.verbe.equals("Creer")){
          println("vous désignez une forme non désignée");
          verifForme=false;
          return;
   }
   if(motMut.ce.equals("ce") && motMut.verbe.equals("Creer") && !formeDessine.equals(motMut.formeString)){
     println("vous dessinez une forme en contradiction avec celle spécifié");
          verifForme=false;
          return;
   }

   
  Point originDessin;
  color colorDessin;
  Forme formeDessin;
  
  //choisir couleur pour le dessin
  if (motMut.couleur.equals("Bleu"))
    colorDessin = motMut.blue;
  else if(motMut.couleur.equals("Rouge"))
    colorDessin = motMut.red;
  else if(motMut.couleur.equals("Vert"))
    colorDessin = motMut.green;
  else
    colorDessin = motMut.bl;
    
  //Choisir position pour le dessin
  if (pointPosition==null)
    originDessin = new Point(400,400);
  else
    originDessin = pointPosition;
    
    
  //Choisir forme pour le dessin
  if (motMut.formeString.equals("ca") && motMut.verbe.equals("Deplacer")){//pointage
    println("deplace ca");
    formeDessin = formeClicked; //la forme a dessiner deviens celle cliquée
    formeDessin.origin=originDessin;
  }
  else if (motMut.ce.equals("ce") && motMut.verbe.equals("Deplacer")){//pointage
    println("deplace ce");
    formeDessin = formeClicked; //la forme a dessiner deviens celle cliquée
    formeDessin.origin=originDessin;
  }
  else if(motMut.formeString.equals("ca") && motMut.verbe.equals("Copier")){//geste
    motMut.formeString=formeDessine;//la forme a dessiner deviens celle dessinée
     //changement couleur de la forme
      formeDessin = creerNouvelleForme(formeClicked); //la forme a dessiner deviens celle cliquée
    formeDessin.c= formeClicked.c;
    if (pointPosition!=null)
      formeDessin.origin = pointPosition;
  }
  //le geste ne marche pas encore !!!
  else if(motMut.formeString.equals("ca") && motMut.verbe.equals("Creer")){//geste
      motMut.formeString=formeDessine;//la forme a dessiner deviens celle dessinée
     //changement couleur de la forme
      formeDessin=creerDessin(formeDessine,originDessin, colorDessin);
      //formeDessin.origin=originDessin;
  }
  //le geste ne marche pas encore !!!
  else if(motMut.ce.equals("ce") && motMut.verbe.equals("Creer")){//geste
    motMut.formeString=formeDessine;//la forme a dessiner deviens celle dessinée
     //changement couleur de la forme
      formeDessin=creerDessin(formeDessine,originDessin, colorDessin);
      //formeDessin.origin=originDessin;
  }
  else if (motMut.ce.equals("ce") && motMut.verbe.equals("Copier")){//pointage
    println("copier ce");
       formeDessin = creerNouvelleForme(formeClicked); //la forme a dessiner deviens celle cliquée
    formeDessin.c= formeClicked.c;
    if (pointPosition!=null)
      formeDessin.origin = pointPosition;
  }
  else if (motMut.formeString.equals("Triangle")) {     //triangle
      formeDessin = new Triangle(originDessin);
    formeDessin.c=colorDessin;
  }
    else if(motMut.formeString.equals("Rectangle")){  //rectangle
      formeDessin = new Rectangle(originDessin);
    formeDessin.c=colorDessin;
  }
    else                         {          //cercle
      formeDessin = new Cercle(originDessin);
    formeDessin.c=colorDessin;
  }
  
  
    

  //ajout de la forme dans la grille
  formes.add(formeDessin);
  
}

boolean verifForme=true;
float letau=0.0;
void draw()
{
  afficherGrille();
  
  switch(state) {
    case INIT:

      //message = "Bonjour, veuillez parler s'il vous plaît";
      try {
          bus.sendMsg("ppilot5 Say=" + message);
      }
      catch (IvyException e) {}
      letau = float(tau.replace(',','.'));
      //println(letau>0.70);
      if(cmd != "" && letau>0.70){
        state = AttCmd;
        StartTCmd = millis();
      }
      break;
      
    case AttCmd:
      passedTime = millis();
      if(passedTime - StartTCmd > totalTime){
        print("TIME OUT, on a pas pu passer a l'état de dessin");
        state = INIT;
        // REMETTRE LES PARAMETRES A ZERO (EXAMPLE : conditionFormeClicked)  ------------ A FAIRE ---------------------
        init_param();
      }
      cmdSplit = cmd.split(" ");
      lectureSplit(cmdSplit);
      String aux = motMut.formeString;
      switch(aux){
        case "ca":
          if(formeClicked!= null || formeDessine!=""){//on a désigné une forme existante ou dessiné une
            state = DrawT; //drawCa
            StartTAtt=millis();
          }
          else{// affichage erreur ou attente click ------------ A FAIRE ---------------------
            print("Vous voulez désigner une forme et Vous n'avez pas désigné de forme\nDessinez ou cliquez une forme svp");
          }
          break;
        case "Triangle":
          state = DrawT; 
          StartTAtt=millis();
          break;
        case "Rectangle":
          state = DrawT; //drawR
          StartTAtt=millis();
          break;
        case "Cercle":
          state = DrawT; //drawC
          StartTAtt=millis();
          break;
     }
     case DrawT:

      passedTime = millis();
      if(formeClicked!=null && !motMut.formeString.equals("ca")){
        if(formeClicked.getClass() == Cercle.class && !motMut.formeString.equals("Cercle")){
          println("vous cliquez une forme différente du Cercle");
          verifForme=false;
        }
        if(formeClicked.getClass() == Triangle.class && !motMut.formeString.equals("Triangle")){
          println("vous cliquez une forme différente du Triangle");
          verifForme=false;
        }
        if(formeClicked.getClass() == Rectangle.class && !motMut.formeString.equals("Rectangle")){
          println("vous cliquez une forme différente du rectangle");
          verifForme=false;
        }
      }
      if (motMut.position!="" && pointPosition==null && verifForme) {//si on a précisé une position et qu'on a pas cliqué, on demande de cliquer
        if(passedTime - StartTAtt > totalTime){
          print("TIME OUT pour attribut, on dessine a l'endroit par default");
          // Lancer le dessin par default
          dessiner_forme_command();
          state = INIT;
          // REMETTRE LES PARAMETRES A ZERO (EXAMPLE : conditionFormeClicked)  
          init_param();
          }
        else{// affichage erreur ou attente click
            print("Vous voulez désigner une position et Vous n'avez pas désigné de position\nCliquez sur l'écran svp");
         }
      }
      else if(motMut.verbe.equals("Creer") && (motMut.ce.equals("ce") || motMut.formeString.equals("ca")) && formeDessine.equals("") && verifForme){ //si veut dessiner et qu'on a pas dessiné
          if(passedTime - StartTAtt > totalTime){
          print("TIME OUT pour attribut, on ne peut pas dessine");
          // Lancer le dessin par default 
          state = INIT;
          // REMETTRE LES PARAMETRES A ZERO (EXAMPLE : conditionFormeClicked) 
          init_param();
          }
        else{// affichage erreur ou attente click 
            print("Vous voulez désigner une position et Vous n'avez pas désigné de position\nCliquez sur l'écran svp");
         }
      }
      else if(verifForme){
          // Lancer le dessin comme demandé 
          dessiner_forme_command();
          state = INIT;
          // REMETTRE LES PARAMETRES A ZERO (EXAMPLE : conditionFormeClicked) 
          init_param();
      }
      else{
        println("une erreur est survenue dans la commande");
        state = INIT;
        init_param();
      }

      break;
  }
  
  text("** ETAT COURANT **", 20,20);
  text(state, 20, 50);
}
