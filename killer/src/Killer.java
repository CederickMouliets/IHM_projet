/* Killer.java
// Auteurs : Bruno Merlin / Philippe Truillet
// Date : 04 fevrier 2005 revu le 10 mai 2006 et le 20 septembre 2014
*/

import fr.dgac.ivy.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Killer extends JFrame 
{
	Ivy bus;
	JButton b_kill=new JButton("Kill");
	
	Killer (String adresse) // Constructeur
	{
		super(".: Killer :.");
		getContentPane().add(b_kill);
		b_kill.addActionListener(new ActionListener() // quand on clique sur le bouton ...
		{
			public void actionPerformed(ActionEvent e) // ... il se passe ...
			{
				try
				{
					bus.sendMsg("Killer Action=Kill"); // on envoie un message via Ivy
				} 
				catch (IvyException ie)
				{
					System.out.println("can't send my message !");
				}	
			}
		});

		// Creation du bus
		bus=new Ivy("Killer","",null);
		try
		{
			bus.start(adresse); // lancement de l'agent sur le bus (met un certain temps)
		}
		catch(IvyException e){System.out.println("Erreur "+e);}

		pack();
		setVisible(true);
	}



	public static void main(String[] arg)
	{
		new Killer(arg[0]); // Il faut passer l'adresse en parametre de l'objet
	}
}
