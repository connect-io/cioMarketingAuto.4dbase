//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cmaToolMailjetGetColor

Méthode qui permet d'affecter une couleur à un statut d'email

Historique
01/07/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $0 : Integer
var $1 : Text

Case of 
	: ($1="1")  // couleur gris
		$0:=0x0095A5A6
	: ($1="2")  // couleur vert clair
		$0:=0x007DCEA0
	: ($1="3")  // couleur vert clair/foncé
		$0:=0x00229954
	: ($1="4")  // couleur vert foncé
		$0:=0x00196F3D
	: ($1="5")  // couleur orange
		$0:=0x00D68910
	: ($1="6")  // couleur rouge foncé
		$0:=0x00CB4335
	: ($1="7")  // couleur bleu clair
		$0:=0x0026A5E5
	: ($1="8")  // couleur noir
		$0:=0x0017202A
	: ($1="9")  // couleur orange clair/foncé
		$0:=0x00CA6F1E
	: ($1="10")  // couleur orange foncé
		$0:=0x00BA4A00
	: ($1="10")
		$0:=0x0000
End case 