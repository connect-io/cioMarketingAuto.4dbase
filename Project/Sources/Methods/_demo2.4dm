//%attributes = {"shared":true,"lang":"en"}
/* -----------------------------------------------------------------------------
Méthode : _demo2

Lance une démo qui consiste à mettre à jour les informations d'une personne concernant les envoies de mail passés.

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $1 : Variant

var $update_b : Boolean
var $marketingAutomation_o; $personne_o; $caPersonneMarketing_o; $retour_o : Object

// Instanciation de la class
$marketingAutomation_o:=cmaToolGetClass("MarketingAutomation").new(True:C214)

// Instanciation de la class
$personne_o:=cmaToolGetClass("MAPersonne").new()
$personne_o.loadByPrimaryKey($1)  // Recherche et chargement de l'entité de la personne

// On pensera à mettre à jour les informations marketing.
$personne_o.updateCaMarketingStatistic(1)