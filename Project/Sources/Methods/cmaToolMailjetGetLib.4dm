//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cmaToolMailjetGetLib

Méthode qui permet d'obtenir le libellé suivant le code statut de mailjet

Historique
01/07/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $0 : Text
var $1 : Text

Case of 
	: ($1="1")
		$0:="en attente"
	: ($1="2")
		$0:="envoyé"
	: ($1="3")
		$0:="ouvert"
	: ($1="4")
		$0:="cliqué"
	: ($1="5")
		$0:="bounce"
	: ($1="6")
		$0:="spam"
	: ($1="7")
		$0:="désabonnement"
	: ($1="8")
		$0:="bloqué"
	: ($1="9")
		$0:="softBounce"
	: ($1="10")
		$0:="hardBounce"
	: ($1="10")
		$0:="en différé"
End case 