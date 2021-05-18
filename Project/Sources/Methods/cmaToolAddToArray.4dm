//%attributes = {}
// ----------------------------------------------------
// Nom utilisateur (OS) : Rémy Scanu
// Date et heure : 17/05/21, 15:21:17
// ----------------------------------------------------
// Méthode : cmaToolAddToArray
// Description
// 
//
// Paramètres
// ----------------------------------------------------
var $1 : Pointer
var ${2} : Variant

var $i_el : Integer

For ($i_el; 2; Count parameters:C259)
	APPEND TO ARRAY:C911($1->; ${$i_el})
End for 