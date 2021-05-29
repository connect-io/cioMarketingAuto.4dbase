//%attributes = {"shared":true,"lang":"en"}
/* -----------------------------------------------------------------------------
Méthode : _demo4

Lance une démo qui consiste à montrer comment on gère les scénarios et scènes

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $marketingAutomation_o; $scenario_o : Object

// Instanciation de la class
$marketingAutomation_o:=cmaToolGetClass("MarketingAutomation").new(True:C214)
$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte

// Instanciation de la class
$scenario_o:=cmaToolGetClass("MAScenario").new()
$scenario_o.loadScenarioDisplay()