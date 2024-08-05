//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolDateIsPublicHoliday

Permet de savoir si une date tombe sur un jour férié dans le pays souhaité

Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $0 : Boolean
var $1 : Text
var $2 : Date

var $jour_el; $mois_el : Integer

$jour_el:=Day of:C23($2)
$mois_el:=Month of:C24($2)

Case of 
	: ($1="fr")
		
		If (($jour_el=1) & ($mois_el=1)) | (($jour_el=1) & ($mois_el=4)) | (($jour_el=1) & ($mois_el=5)) | (($jour_el=8) & ($mois_el=5)) | (($jour_el=9) & ($mois_el=5)) | \
			(($jour_el=14) & ($mois_el=7)) | (($jour_el=15) & ($mois_el=8)) | (($jour_el=1) & ($mois_el=11)) | (($jour_el=11) & ($mois_el=11)) | (($jour_el=25) & ($mois_el=12))
			$0:=True:C214
		End if 
		
End case 