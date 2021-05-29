//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolAddToArray

Ajoute à un tableau les éléments mis en paramètre

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $1 : Pointer
var ${2} : Variant

var $i_el : Integer

For ($i_el; 2; Count parameters:C259)
	APPEND TO ARRAY:C911($1->; ${$i_el})
End for 