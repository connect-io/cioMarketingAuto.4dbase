Case of 
	: (Form event code:C388=Sur clic:K2:4)
		
		If (Form:C1466.ScenarioCurrentElement#Null:C1517)
			CONFIRM:C162("Voulez-vous vraiment faire un export du scénario "+Form:C1466.scenarioDetail.nom; "Oui"; "Non")
			
			If (OK=1)
				Form:C1466.scenarioDetail.exportScenario()
			End if 
			
		Else 
			ALERT:C41("Merci de sélectionner un scénario dans la liste ci-dessus afin de pouvoir l'exporter")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 