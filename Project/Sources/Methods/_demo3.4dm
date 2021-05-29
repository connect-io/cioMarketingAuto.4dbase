//%attributes = {"shared":true,"lang":"en"}
/* -----------------------------------------------------------------------------
Méthode : _demo3

Lance une démo qui consiste à créer un cron qui va : 
- interroger mailjet de façon automatique 
- mettre à jour les fiches des personnes de la base hôte
- gérer les scénarios des personnes et faires les actions mises en place dans la config des scènes de ces scénarios

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $marketingAutomation_o : Object

// Instanciation de la class
$marketingAutomation_o:=cmaToolGetClass("MarketingAutomation").new(True:C214)

$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte
$marketingAutomation_o.loadCronos()  // Chargement de cronos