//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cmaProgressBarGetModulo

Permet d'avoir le modulo nécessaire pour la gestion de la barre de progression

Historique
26/07/23 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $0 : Integer
var $1 : Integer

Case of 
	: ($1>1000)
		$0:=Round:C94($1/100; 0)
	: ($1>=50) & ($1<=100)
		$0:=Round:C94($1/10; 0)
	: ($1>=10) & ($1<50)
		$0:=Round:C94($1/5; 0)
	Else 
		$0:=Round:C94($1/2; 0)
End case 

If ($0=0)
	$0:=1
End if 