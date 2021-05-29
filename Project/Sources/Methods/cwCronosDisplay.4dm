//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cwCronosDisplay

Permet d'afficher l'interface de Cronos

Historique
08/07/20 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Object  // Class MarketingAutomation

var $refFen_el : Integer

$refFen_el:=Open form window:C675("cronos"; Form fenêtre standard:K39:10; À gauche:K39:2; En haut:K39:5)

DIALOG:C40("cronos"; $1)
CLOSE WINDOW:C154($refFen_el)