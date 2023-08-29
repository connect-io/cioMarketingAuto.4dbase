var $statut_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.scenarioDetail#Null:C1517)
			
			If (Form:C1466.newScene()=False:C215)
				ALERT:C41("La scène n'a pas pu être créée, veuillez recommencer.")
			End if 
			
			$statut_o:=Form:C1466.scenarioDetail.reload()
			
			Form:C1466.scene:=Form:C1466.scenarioDetail.AllCaScene.orderBy("numOrdre asc")
			OBJECT SET ENABLED:C1123(*; "scenarioScene@"; True:C214)
			
			LISTBOX SELECT ROW:C912(*; "sceneListe"; 1)
		Else 
			ALERT:C41("Veuillez sélectionner un scénario avant de créer une scène.")
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 