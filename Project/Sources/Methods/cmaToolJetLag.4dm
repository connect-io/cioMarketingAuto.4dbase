//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolJetLag

Renvoi le decallage horaire depuis lheure local de la machine.
origine du code : http://forums.4d.fr/Post/FR/14701949/1/14928049#14928049

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $0 : Integer

var $ts_t; $tsUTC_t : Text
var $ts_el; $tsUTC_el : Integer
var $day_d : Date
var $hour_h : Time

$day_d:=Current date:C33
$hour_h:=Current time:C178

$tsUTC_t:=String:C10($day_d; ISO date GMT:K1:10; $hour_h)  //<<< encodage UTC
$tsUTC_t:=Substring:C12($tsUTC_t; 1; 19)  //remove trailing"Z"

$ts_t:=String:C10($day_d; ISO date:K1:8; $hour_h)  //<<< encodage heure locale

XML DECODE:C1091($tsUTC_t; $day_d)
XML DECODE:C1091($tsUTC_t; $hour_h)

$tsUTC_el:=(($day_d-!2000-01-01!)*86400)+$hour_h  //86400 sec= 24h

XML DECODE:C1091($ts_t; $day_d)
XML DECODE:C1091($ts_t; $hour_h)

$ts_el:=(($day_d-!2000-01-01!)*86400)+$hour_h

$0:=$ts_el-$tsUTC_el