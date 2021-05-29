//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : _demo

Lance une démo qui consiste à afficher une liste des personnes de la base hôte

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $marketingAutomation_o; $class_o : Object

// Instanciation de la class
$marketingAutomation_o:=cmaToolGetClass("MarketingAutomation").new(True:C214)

$class_o:=cmaToolGetClass("MAPersonneSelection").new()
$class_o.loadPersonListForm()  // Affichage de la liste des [Personne] de la base hôte