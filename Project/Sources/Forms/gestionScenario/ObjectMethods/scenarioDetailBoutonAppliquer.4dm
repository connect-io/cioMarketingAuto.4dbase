var $dataContext_t : Text
var $nbPersonne_el : Integer

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$nbPersonne_el:=Form:C1466.scenarioSelectionPossiblePersonne.length
		CONFIRM:C162("Le scénario va être appliqué à "+String:C10($nbPersonne_el)+" personne(s), voulez-vous vraiment continuer ?"; "Oui"; "Non")
		
		If (OK=1)
			$dataContext_t:=String:C10(Form:C1466.scenarioDetail.configuration.dataContext)
			
			If ($dataContext_t="")
				CONFIRM:C162("Aucune valeur de data context n'est renseignée dans la configuration du scénario."+Char:C90(Carriage return:K15:38)+\
					"Souhaitez-vous ajouter en ajouter une ?"; "Oui"; "Non")
				
				If (OK=1)
					ALERT:C41("Veuillez cliquer sur le bouton \"Définir la configuration\"")
					return 
				End if 
				
			End if 
			
			Form:C1466.applyScenarioToPerson($dataContext_t)
			
			ALERT:C41("Le scénario a bien été appliqué à "+String:C10($nbPersonne_el)+" personne(s)")
			OBJECT SET ENABLED:C1123(*; "scenarioDetailBoutonAppliquer"; False:C215)
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 