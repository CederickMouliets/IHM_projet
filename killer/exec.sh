#!/bin/bash
javac -d ./bin -cp .:./lib/ivy-java-1.2.14.jar ./src/*.java

java -cp .:./bin:./lib/ivy-java-1.2.18.jar Killer 127.255.255.255:2010&
java -cp .:./bin:./lib/ivy-java-1.2.18.jar Target 127.255.255.255:2010&
java -cp .:./bin:./lib/ivy-java-1.2.18.jar Target 127.255.255.255:2010&


