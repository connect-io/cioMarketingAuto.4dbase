//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cmaProgressBar

Gestion d'une barre de progression

Historique
10/03/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Real
var $2 : Text
var $3 : Boolean

Case of 
	: ($2="Initialisation")
		C_LONGINT:C283(progressBar_el)
		
		progressBar_el:=Progress New  // on crée une nouvelle barre
		
		Progress SET BUTTON ENABLED(progressBar_el; $3)
		Progress SET ICON(progressBar_el; Storage:C1525.image["progress-bar"]; True:C214)
	: ($2="arrêt") | (Progress Stopped(progressBar_el)=True:C214)
		
		If (progressBar_el>0)  // Si la barre de progression n'a pas été arrêté
			Progress QUIT(progressBar_el)
			
			If (Progress Stopped(progressBar_el)=True:C214)  // Si l'utilisateur a cliqué sur le bouton stop on stop tout
				CLEAR VARIABLE:C89(progressBar_el)
			End if 
			
		End if 
		
	Else 
		Progress SET PROGRESS(progressBar_el; $1; $2; True:C214)
		
		If (Round:C94($1; 0)%5=0)
			DELAY PROCESS:C323(Current process:C322; 10)
		End if 
		
End case 