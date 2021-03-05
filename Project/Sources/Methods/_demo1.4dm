//%attributes = {"shared":true,"lang":"en"}
// Dans cette demo on veut envoyer un emailing
var $1 : Collection

var $marketingAutomation_o; $class_o : Object

// Instanciation de la class
$marketingAutomation_o:=cmaToolGetClass("MarketingAutomation").new()

$class_o:=cmaToolGetClass("MAPersonneSelection").new()
$class_o.fromListPersonCollection($1)

$class_o.sendMailing()