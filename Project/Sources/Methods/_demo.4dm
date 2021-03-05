//%attributes = {"shared":true}
var $marketingAutomation_o; $class_o : Object

// Instanciation de la class
$marketingAutomation_o:=cmaToolGetClass("MarketingAutomation").new(True:C214)

$class_o:=cmaToolGetClass("MAPersonneSelection").new()
$class_o.loadPersonListForm()  // Affichage de la liste des [Personne] de la base hôte