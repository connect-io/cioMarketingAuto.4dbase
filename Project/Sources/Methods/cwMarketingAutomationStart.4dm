//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwMarketingAutomationStart

Permet de faire l'éxécution de la partie marketingAutomation du composant cioWeb

Historique
16/02/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $0 : Object
var $1 : Boolean

var $MASms_cs : cs:C1710.MASms
var $MACourrier_cs : cs:C1710.MACourrier

// Instanciation de la class
$0:=cmaToolGetClass("MarketingAutomation").new($1)

If (Storage:C1525.sms=Null:C1517)
	$MASms_cs:=cs:C1710.MASms.new(True:C214; {})
End if 

If (Storage:C1525.courrier=Null:C1517)
	$MACourrier_cs:=cs:C1710.MACourrier.new(True:C214; {})
End if 

If (Application type:C494#4D Remote mode:K5:5)
	$0.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte
	
	If ($1=True:C214)
		
		If (Application type:C494=4D Local mode:K5:1) | (Application type:C494=4D Volume desktop:K5:2)
			
			$reponse_t:=Request:C163("Voulez-vous démarrer le composant marketing auto ?"+Char:C90(Carriage return:K15:38)+" Si oui merci d'écrire 'Cronos'")
			
			If (ok=0)
				return 
			End if 
			
			If ($reponse_t#"Cronos")
				return 
			End if 
			
			$0.loadCronos()
			
		Else 
			$0.loadCronos()
		End if 
		
	End if 
	
End if 