//%attributes = {}
// ----------------------------------------------------
// Nom utilisateur (OS) : Dev
// Date et heure : 13/04/21, 15:51:56
// ----------------------------------------------------
// Méthode : cmaToolCleanVariable
// Description
// 
//
// Paramètres
// ----------------------------------------------------
C_POINTER:C301(${1})

C_LONGINT:C283($i_el)

For ($i_el; 1; Count parameters:C259)
	CLEAR VARIABLE:C89(${$i_el}->)
End for 