//%attributes = {}
// ======================================================================
// Methode projet : cmaToolMinuscFirstChar
//
// Permet de remplacer le premier caractère d'une chaine en minuscule tout en gardant le reste de la chaine identique qu'à l'entrée
// ----------------------------------------------------------------------

If (False:C215)  // Historique
	// 27/03/20 remy@connect-io.fr - Création
End if 

If (True:C214)  // Déclarations
	C_TEXT:C284($1)  // Chaine de caractère à transformer
	C_TEXT:C284($0)  // Chaine de caractère transformé avec le premier caractère $1 en Majuscule
End if 

$1:=Lowercase:C14(Substring:C12($1; 1; 1))+Substring:C12($1; 2)

$0:=$1