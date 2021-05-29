//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolWrProImpr

Permet d'effectuer des impressions papier depuis le composant cioMarketingAuto

Historique
21/05/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Boolean  // Paramètre impression
var $2 : Text  // Type d'impression demandé
var $3 : Text  // Si $2 -> FlydocSilent, $3 contient la tagLine
var $4 : Object  // Objet 4WP
var $5 : Object  // EntitySelection table [Personne] de la base hôte [optionnel]

var $enregistrement_o : Object
var $continue_b : Boolean

If ($1=True:C214)
	PRINT SETTINGS:C106(Dialogue impression:K47:17)
	
	If (OK=1)
		$continue_b:=True:C214
	End if 
	
Else 
	$continue_b:=True:C214
End if 

If ($continue_b=True:C214)
	OPEN PRINTING JOB:C995
	
	Case of 
		: ($2="flydocSilent")
			WP SET TEXT:C1574($4; $3; wk prepend:K81:178)  //On insere notre tagLine dans notre lettre en début de lettre
			
			For each ($enregistrement_o; $5)
				
				If ($enregistrement_o.indexOf($5)>0)
					WP SET TEXT:C1574($4; $3; wk append:K81:179)  //On insere notre tagLine dans notre lettre en début de lettre
				End if 
				
				WP PRINT:C1343($4; wk 4D Write Pro layout:K81:176)
			End for each 
			
		: ($2="simple")
			WP PRINT:C1343($4; wk 4D Write Pro layout:K81:176)
		Else 
			
			For each ($enregistrement_o; $5)
				WP PRINT:C1343($4; wk 4D Write Pro layout:K81:176)
			End for each 
			
	End case 
	
	CLOSE PRINTING JOB:C996
End if 