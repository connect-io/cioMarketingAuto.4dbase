//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolDuplicateObjInForm

Duplique une élément dans un formulaire

Historique
18/05/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Text  // Nom de la propriété unique
var $2 : Variant  // Valeur de l'objet dupliqué
var $3 : Text  // Nom de l'objet qu'on duplique
var $4 : Variant  // Type de l'objet dupliqué
var $5 : Boolean  // Repositionnement souhaité
var $6 : Integer  // Coordonnée gauche de l'objet dupliqué
var $7 : Integer  // Coordonnée haut de l'objet dupliqué

var $pointeur_p : Pointer

$pointeur_p:=OBJECT Get pointer:C1124(Object named:K67:5; cmaToolMinuscFirstChar($1))

Case of 
	: (Is nil pointer:C315($pointeur_p)=True:C214)  // On vérifie que l'objet n'a pas été créé avant
		// On applique une valeur à l'objet Form    
		OBJECT DUPLICATE:C1111(*; $3; cmaToolMinuscFirstChar($1))
		
		Case of 
			: ($4=Is string var:K8:2)
				OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($1); $2)
			: ($4=Is text:K8:3)
				OBJECT SET TITLE:C194(*; cmaToolMinuscFirstChar($1); $2)
		End case 
		
		If ($5=True:C214)  // On demande de le repositionner
			OBJECT SET COORDINATES:C1248(*; cmaToolMinuscFirstChar($1); $6; $7)
			
			OBJECT SET VISIBLE:C603(*; cmaToolMinuscFirstChar($1); True:C214)
			OBJECT SET ENABLED:C1123(*; cmaToolMinuscFirstChar($1); True:C214)
		End if 
		
	: ($5=True:C214)  // On demande de le repositionner
		OBJECT SET COORDINATES:C1248(*; cmaToolMinuscFirstChar($1); $6; $7)
End case 