//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolMinuscFirstChar

Permet de remplacer le premier caractère d'une chaine en minuscule tout en gardant le reste de la chaine identique qu'à l'entrée

Historique
27/03/20 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $0 : Text  // Chaine de caractère transformé avec le premier caractère $1 en Minuscule
var $1 : Text  // Chaine de caractère à transformer

$1:=Lowercase:C14(Substring:C12($1; 1; 1))+Substring:C12($1; 2)

$0:=$1