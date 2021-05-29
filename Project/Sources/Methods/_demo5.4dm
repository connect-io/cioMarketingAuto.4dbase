//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : _demo5

Lance une démo qui consiste à générer si besoin les enregistrements dans la table [CaMarketing] pour les personnes de la base hôte

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $1 : Collection

var $marketingAutomation_o; $class_o : Object

// Instanciation de la class
$marketingAutomation_o:=cmaToolGetClass("MarketingAutomation").new(True:C214)

$class_o:=cmaToolGetClass("MAPersonneSelection").new()
$class_o.fromListPersonCollection($1)

$class_o.updateCaMarketingStatistic()