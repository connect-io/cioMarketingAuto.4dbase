//%attributes = {"shared":true,"lang":"en"}
/* -----------------------------------------------------------------------------
Méthode : _demo1

Lance une démo qui consiste à envoyer un emailing à une sélection de personne

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $1 : Collection

var $marketingAutomation_o; $class_o : Object

// Instanciation de la class
$marketingAutomation_o:=cmaToolGetClass("MarketingAutomation").new(True:C214)

// Instanciation de la class
$class_o:=cmaToolGetClass("MAPersonneSelection").new()
$class_o.fromListPersonCollection($1)

$class_o.sendMailing()