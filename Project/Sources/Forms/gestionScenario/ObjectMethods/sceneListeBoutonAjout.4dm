If (Form:C1466.scenarioDetail#Null:C1517)
	var $statut_o : Object
	
	If (Form:C1466.newScene()=False:C215)
		// Avertir l'utilisateur
	End if 
	
	$statut_o:=Form:C1466.scenarioDetail.reload()
	
	Form:C1466.scene:=Form:C1466.scenarioDetail.AllCaScene.orderBy("numOrdre asc")
	
	OBJECT SET ENABLED:C1123(*; "scenarioScene@"; True:C214)
	
	LISTBOX SELECT ROW:C912(*; "sceneListe"; 1)
Else 
	ALERT:C41("Veuillez sélectionner un scénario avant de créer une scène.")
End if 