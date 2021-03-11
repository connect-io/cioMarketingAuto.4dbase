//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwMarketingAutomationStart

Permet de faire l'éxécution de la partie marketingAutomation du composant cioWeb

Historique
16/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

// Déclarations
var $0 : Object

var $initComponent_b : Boolean

If (Application type:C494=4D Server:K5:6) | (Application type:C494=4D mode local:K5:1)
	$initComponent_b:=True:C214
End if 

// Instanciation de la class
$0:=cmaToolGetClass("MarketingAutomation").new($initComponent_b)

If (Application type:C494=4D Server:K5:6) | (Application type:C494=4D mode local:K5:1)
	$0.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte
	
	If (Application type:C494=4D mode local:K5:1)
		CONFIRM:C162("Voulez-vous démarrer cronos (cioMarketingAutomation) ?"; "Oui"; "Non")
		
		If (OK=1)
			$0.loadCronos()
		End if 
		
	Else 
		$0.loadCronos()
	End if 
	
End if 