/* -----------------------------------------------------------------------------
Class : cs.MATimeStamp

-----------------------------------------------------------------------------*/

singleton Class constructor()
	
Function jetLag : Integer
/*-----------------------------------------------------------------------------
Fonction : MATimeStamp.jetLag
	
Renvoit le décalage horaire de la machine
	
Historique
20/11/24 - Rémy Scanu <remy@connect-io.fr> - Création entête
------------------------------------------------------------------------------*/
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
	
	return $ts_el-$tsUTC_el
	
Function get($date_d : Date; $heure_t : Time) : Integer
/*-----------------------------------------------------------------------------
Fonction : MATimeStamp.get
	
Retourne le timeStamp pour une date et une heure donnée
Si omis renvoi timeStamp de la date et heure courante
	
Historique
20/11/24 - Rémy Scanu <remy@connect-io.fr> - Création entête
------------------------------------------------------------------------------*/
	var $heure_el; $nbJourSec_el : Integer
	
	If (Count parameters:C259=2)
		ASSERT:C1129($date_d#!00-00-00!; "Le type de $1 n'est pas une date")
		$heure_el:=$heure_t+0
	Else 
		$date_d:=Current date:C33
		$heure_el:=Current time:C178+0
	End if 
	
	$nbJourSec_el:=Int:C8(($date_d-!1970-01-01!)*86400)
	return $nbJourSec_el+$heure_el-This:C1470.jetLag()
	
Function read($lib_t : Text; $ts_i : Integer) : Text
/*-----------------------------------------------------------------------------
Fonction : MATimeStamp.get
	
Retourne en fonction du paramètre $lib_t, soit la date, soit l'heure d'un
timeStamp $ts_i
	
Historique
20/11/24 - Rémy Scanu <remy@connect-io.fr> - Création entête
------------------------------------------------------------------------------*/
	var $tsAvecDecallage_el : Integer
	
	ASSERT:C1129(Count parameters:C259=2; "Il manque un paramêtre à cette méthode.")
	ASSERT:C1129(Type:C295($ts_i)=Is longint:K8:6; "Le param $1 doit être de type 'entier'.")
	ASSERT:C1129(($lib_t="date") | ($lib_t="hour"); "La valeur de $1 est incorrect.")
	
	$tsAvecDecallage_el:=$ts_i+This:C1470.jetLag()
	
	If ($lib_t="date")
		return String:C10(Int:C8($tsAvecDecallage_el/86400)+!1970-01-01!; Internal date short:K1:7)
	Else 
		return String:C10(Time:C179(Mod:C98($tsAvecDecallage_el; 86400)); HH MM SS:K7:1)
	End if 