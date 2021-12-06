C_BOOLEAN:C305($suppr_b; $supprAll_b)
C_OBJECT:C1216($personne_o)

CONFIRM:C162("Cette action est irréversible, souhaitez-vous continuer ?"; "Oui"; "Non")

If (OK=1)
	
	If (Form:C1466.PersonneCurrentElement=Null:C1517)
		CONFIRM:C162("Cette action supprimera le scénario pour toutes les personnes de la liste, souhaitez-vous vraiment le supprimer pour toutes ces personnes ?"; "Oui"; "Annuler")
		
		$supprAll_b:=(OK=1)
	End if 
	
	Case of 
		: (Form:C1466.entree=2)
			
			Case of 
				: ($supprAll_b=True:C214)
					
					For each ($personne_o; Form:C1466.personneCollection)
						$suppr_b:=Form:C1466.donnee.deleteScenarioToPerson($personne_o.UID; Form:C1466.donnee.scenarioDetail.getKey())
						
						If ($suppr_b=True:C214)
							
							If (Form:C1466.entree=2)
								Form:C1466.donnee.scenarioPersonneEnCoursEntity:=Form:C1466.donnee.scenarioDetail.AllCaPersonneScenario.OnePersonne
							End if 
							
							Form:C1466.MAPersonneDisplay.viewPersonList(Form:C1466)
						End if 
						
					End for each 
					
				: (Form:C1466.PersonneCurrentElement#Null:C1517)
					$suppr_b:=Form:C1466.donnee.deleteScenarioToPerson(Form:C1466.PersonneSelectedElement[0].UID; Form:C1466.donnee.scenarioDetail.getKey())
			End case 
			
	End case 
	
	If (Form:C1466.PersonneCurrentElement#Null:C1517) & ($suppr_b=True:C214)
		
		If (Form:C1466.entree=2)
			Form:C1466.donnee.scenarioPersonneEnCoursEntity:=Form:C1466.donnee.scenarioDetail.AllCaPersonneScenario.OnePersonne
		End if 
		
		Form:C1466.MAPersonneDisplay.viewPersonList(Form:C1466)
		
		Form:C1466.scenarioPersonne:=Null:C1517  // Je réinitialise mon tableau des scénarios de personne
	End if 
	
End if 