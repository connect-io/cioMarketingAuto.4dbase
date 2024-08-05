//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwToolWebHttpRequest

Méthode qui permet de faire des requêtes http

Historique
02/07/20 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $0 : Variant  // Réponse du serveur distant
var $1 : Text  // Type de requête demandé
var $2 : Text  // Url demandée
var $3 : Variant  // Body de la requête peut varié d'une requête à l'autre
var $4 : Pointer  // Pointeur de la réponse attendue de l'url $2
var $5 : Collection  // Collection headerNames [optionnel]
var $6 : Collection  // Collection headerValues [optionnel]

var $reponse_v : Variant
var $etat_el : Integer
var $blobVide_b : Blob

ARRAY TEXT:C222($headerNames_at; 0)
ARRAY TEXT:C222($headerValues_at; 0)

If (Count parameters:C259>4)
	COLLECTION TO ARRAY:C1562($5; $headerNames_at)
	COLLECTION TO ARRAY:C1562($6; $headerValues_at)
End if 

Case of 
	: (Value type:C1509($4->)=Est un texte:K8:3)
		$reponse_v:=""
	: (Value type:C1509($4->)=Est un objet:K8:27)
		$reponse_v:=New object:C1471
	: (Value type:C1509($4->)=Est un BLOB:K8:12)
		$reponse_v:=$blobVide_b
End case 

ON ERR CALL:C155("cwGestionErreur")
$etat_el:=HTTP Request:C1158($1; $2; $3; $reponse_v; $headerNames_at; $headerValues_at)
ON ERR CALL:C155("")

If ($etat_el#200)
	$reponse_v:="Error HTTP "+String:C10($etat_el)
End if 

$4->:=$reponse_v