//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolResizeWindows

Effectue le redimensionnement d'une fenêtre

Historique
12/05/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Integer  // Ref fenêtre à redimensionner
var $2 : Integer

var $gauche_el; $haut_el; $droite_el; $bas_el; $hauteurForm_el : Integer

GET WINDOW RECT:C443($gauche_el; $haut_el; $droite_el; $bas_el; $1)
FORM GET PROPERTIES:C674("configSceneModele"; $largeurForm_el; $hauteurForm_el)

$hauteurForm_el:=$hauteurForm_el+($2)

SET WINDOW RECT:C444($gauche_el; ((Screen height:C188(*)/2)-10)-($hauteurForm_el/2); $droite_el; ((Screen height:C188(*)/2)-10)+($hauteurForm_el/2); $1; *)