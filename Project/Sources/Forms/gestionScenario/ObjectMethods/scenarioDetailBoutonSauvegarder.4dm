var $retour_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.ScenarioCurrentElement#Null:C1517)
			$retour_o:=Form:C1466.scenarioDetail.save()
			
			If ($retour_o.success=False:C215)
				ALERT:C41("Le scénario n'a pas pu être sauvegardé, veuillez recommencer.")
			End if 
			
			Form:C1466.loadAllScenario()
			LISTBOX SELECT ROW:C912(*; "scenarioListe"; Form:C1466.ScenarioCurrentPosition)
		Else 
			ALERT:C41("Impossible de sauvegarder, aucun scénario de sélectionner !")
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 