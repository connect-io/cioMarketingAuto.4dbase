//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolRegexValidate

Permet de faire des vérification suivant le regex passant en paramètre

Historique
07/03/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $0 : Boolean
var $1 : Integer
var $2 : Variant

var $pattern_t : Text
var $position_el; $longueur_el : Integer

Case of 
	: ($1=1)  // Adresse email
		$pattern_t:="\\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}\\b"
End case 

$0:=Match regex:C1019($pattern_t; $2; 1; $position_el; $longueur_el)