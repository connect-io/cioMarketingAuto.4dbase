//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : _test

Méthode de test

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $ts_el:=cs:C1710.MATimeStamp.me.get(Current date:C33; Current time:C178)

var $date_t : Text:=cs:C1710.MATimeStamp.me.read("date"; $ts_el)
var $heure_t : Text:=cs:C1710.MATimeStamp.me.read("hour"; $ts_el)