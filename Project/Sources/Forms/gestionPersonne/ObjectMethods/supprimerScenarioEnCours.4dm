var $suppr_b; $supprAll_b : Boolean
var $personne_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
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
								$suppr_b:=Form:C1466.donnee.deleteScenarioToPerson($personne_o.getKey(); Form:C1466.donnee.scenarioDetail.getKey())
							End for each 
							
						: (Form:C1466.PersonneCurrentElement#Null:C1517)
							
							For each ($personne_o; Form:C1466.PersonneSelectedElement)
								$suppr_b:=Form:C1466.donnee.deleteScenarioToPerson($personne_o.getKey(); Form:C1466.donnee.scenarioDetail.getKey())
							End for each 
							
					End case 
					
			End case 
			
			If (Form:C1466.PersonneCurrentElement#Null:C1517) | ($supprAll_b=True:C214)
				
				If (Form:C1466.entree=2)
					Form:C1466.donnee.scenarioPersonneEnCoursEntity:=Form:C1466.donnee.scenarioDetail.AllCaPersonneScenario.OnePersonne
				End if 
				
				Form:C1466.MAPersonneDisplay.viewPersonList(Form:C1466)
				Form:C1466.scenarioPersonne:=Null:C1517  // Je réinitialise mon tableau des scénarios de personne
				
				Form:C1466.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageSort("sortNom"; True:C214)
			End if 
			
		End if 
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 