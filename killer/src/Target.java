// Target.java
// Auteur : Philippe truillet
// Date : 10 mai 2006, revu le 20 septembre 2015

import fr.dgac.ivy.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Target extends JFrame
{
	Ivy bus;
	JLabel target=new JLabel("Target");
		
	Target(String adresse) // Constructeur
	{
		super("Target");
		getContentPane().add(target);
		bus=new Ivy("Target","",null);
		try
		{
			bus.start(adresse); // lancement du bus
		}
		catch(IvyException e){System.out.println("Erreur "+e);}

		try
		{
			bus.bindMsg("^X .* receiver=(.*) .*", new IvyMessageListener() // abonnement a un type de message
				{
					public void receive(IvyClient client,String[] args)
					{
						if(args[1].compareTo("Y")==0) // si l'argument est egal a "Y" alors on meurt !
						System.exit(0);
					}				
				}
			);
		}
		catch (IvyException ie) // Exception levee
		{
			System.out.println("can't bind my message !");
		}
		pack();
		setVisible(true);
	}



	public static void main(String[] arg)
	{
		new Target(arg[0]); // l'adresse doit etre passee en parametre
	}
}
