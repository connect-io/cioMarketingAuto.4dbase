//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaTimestamp

Retrouver le timestamp depuis le 01/01/1970 (en fonction de l'heure de votre machine)

Historique
08/11/10 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
var $1 : Date  // Date [optionnel]
var $2 : Time  // Heure [optionnel]
var $0 : Integer  // Timestamp

var $date_d : Date
var $heure_el; $nbJourSec_el : Integer


If (Count parameters:C259=2)
	ASSERT:C1129($1#!00-00-00!; "Le type de $1 n'est pas une date")
	//ASSERT($2#?00:00:00?; "Le type de $2 n'est pas une heure")
	
	$date_d:=$1
	$heure_el:=$2+0
Else 
	$date_d:=Current date:C33
	$heure_el:=Current time:C178+0
End if 

$nbJourSec_el:=Int:C8(($date_d-!1970-01-01!)*86400)

$0:=$nbJourSec_el+$heure_el-cmaToolJetLag