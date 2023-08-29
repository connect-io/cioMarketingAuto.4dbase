Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.newScenario()=False:C215)
			ALERT:C41("Le scénario n'a pas pu être créé, veuillez recommencer.")
		End if 
		
		Form:C1466.loadAllScenario()
		
		Form:C1466.scenarioDetail:=Form:C1466.scenario.first()
		Form:C1466.scene:=Null:C1517
		
		OBJECT SET ENABLED:C1123(*; "scenarioDetail@"; True:C214)
		LISTBOX SELECT ROW:C912(*; "scenarioListe"; 1)
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 