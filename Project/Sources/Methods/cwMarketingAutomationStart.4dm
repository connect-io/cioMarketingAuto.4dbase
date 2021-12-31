//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwMarketingAutomationStart

Permet de faire l'éxécution de la partie marketingAutomation du composant cioWeb

Historique
16/02/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $0 : Object
var $1 : Boolean
var $2 : Boolean

var $startCronos_b : Boolean

If (Count parameters:C259=2)
	$startCronos_b:=$2
End if 

// Instanciation de la class
$0:=cmaToolGetClass("MarketingAutomation").new($1)

If (Application type:C494#4D mode distant:K5:5)
	$0.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte
	
	If ($startCronos_b=True:C214)
		
		If (Application type:C494=4D mode local:K5:1) | (Application type:C494=4D Volume Desktop:K5:2)
			CONFIRM:C162("Voulez-vous démarrer cronos (cioMarketingAutomation) ?"; "Oui"; "Non")
			
			If (OK=1)
				$0.loadCronos()
			End if 
			
		Else 
			$0.loadCronos()
		End if 
		
	End if 
	
End if 