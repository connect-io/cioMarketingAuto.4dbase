//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwGestionErreur

Méthode qui permet d'intercepter une erreur qui se produit dans le composant

Historique
08/04/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
// Déclarations
var $erreur : Object

ARRAY LONGINT:C221($code; 0)
ARRAY TEXT:C222($composantInterne; 0)
ARRAY TEXT:C222($lib; 0)

GET LAST ERROR STACK:C1015($code; $composantInterne; $lib)

$erreur:=New object:C1471(\
"libelle"; $lib{1}; \
"methode"; Error Method; \
"ligne"; Error Line; \
"code"; Error)

If (visiteur#Null:C1517)
	$erreur.visiteur:=visiteur
End if 

cwLogErreurAjout("Serveur Web"; $erreur)

If (Get assert enabled:C1130)
	WEB SEND TEXT:C677(JSON Stringify:C1217($erreur))
End if 