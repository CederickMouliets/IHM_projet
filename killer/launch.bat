set path=C:\Program Files\Java\jdk1.8.0_121\bin;%path%

REM compilation
javac -d ./bin -cp .;./lib/ivy-java-1.2.14.jar ./src/*.java

REM ATTENTION : 3 fenetres vont s'ouvrir : il faut les deplacer sur l'ecran !!!
REM lancement du killer
REM start /MIN java -cp .;./bin;./lib/ivy-java-1.2.18.jar Killer 127.255.255.255:2010

REM lancement de la cible (1)
REM start /MIN java -cp .;./bin;./lib/ivy-java-1.2.18.jar Target 127.255.255.255:2010

REM lancement de la cible (2)
start /MIN java -cp .;./bin;./lib/ivy-java-1.2.18.jar Target 127.255.255.255:2010


