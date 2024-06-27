var $enregistrement_o; $statut_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.ScenarioEnCoursSelectedElement#Null:C1517)
			$enregistrement_o:=Form:C1466.ScenarioEnCoursSelectedElement[0]
			
			CONFIRM:C162("Souhaitez-vous vraiment rendre "+Choose:C955($enregistrement_o.actif=True:C214; "inactif"; "actif")+" le scénario "+$enregistrement_o.OneCaScenario.nom+" ?"; "Oui"; "Non")
			
			If (OK=1)
				
				If ($enregistrement_o.actif=True:C214)
					$enregistrement_o.actif:=False:C215
				Else 
					$enregistrement_o.actif:=True:C214
				End if 
				
				$statut_o:=$enregistrement_o.save()
				$enregistrement_o.reload()
				
				Form:C1466.scenarioEnCours:=Form:C1466.personne.AllCaPersonneScenario
			End if 
			
		Else 
			ALERT:C41("Merci de sélectionner un scénario")
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 