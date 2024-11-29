//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : outilsCatchErrorSendMail

Méthode qui permet d'intercepter une erreur qui se produit dans le composant
lors de l'envoi d'un email (adresse email avec un problème)

Historique
08/04/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
// Déclarations
var $error_o : Object
var $eMail_o : cs:C1710.MAEMail

ARRAY LONGINT:C221($code_ai; 0)
ARRAY TEXT:C222($composantInterne_at; 0)
ARRAY TEXT:C222($lib_at; 0)

GET LAST ERROR STACK:C1015($code_ai; $composantInterne_at; $lib_at)

$error_o:=New object:C1471(\
"libelle"; $lib_at{1}; \
"methode"; Error Method; \
"ligne"; Error Line; \
"code"; Error)

$eMail_o:=cs:C1710.MAEMail.new("Support")

$eMail_o.subject:="CioMarketingAutomation - Erreur envoi email"

$eMail_o.to:=Storage:C1525.automation.config.support.eMail
$eMail_o.textBody:="Détail de l'erreur : "+$error_o.libelle

$eMail_o.send()