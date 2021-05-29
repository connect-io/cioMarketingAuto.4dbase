//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolCleanVariable

Remise à zéro des variables mis en paramètre

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var ${1} : Pointer

var $i_el : Integer

For ($i_el; 1; Count parameters:C259)
	CLEAR VARIABLE:C89(${$i_el}->)
End for 