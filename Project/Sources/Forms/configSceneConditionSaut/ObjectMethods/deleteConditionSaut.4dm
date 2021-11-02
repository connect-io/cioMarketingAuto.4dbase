Case of 
	: (Form event code:C388=Sur clic:K2:4)
		Form:C1466.sceneDetail.conditionSaut:=New object:C1471
		
		// Il n'y a pas plus de condition de saut, on supprimer éventuellement la scène de saut précédemment sélectionnée et on désactive la possibilité de sélectionné une scène
		OB REMOVE:C1226(Form:C1466.sceneDetail.conditionSaut; "sceneSautID")
		
		sceneSaut_at:=0
		sceneSaut_at{0}:="Sélection d'une scène"
		
		OBJECT SET ENABLED:C1123(sceneSaut_at; Not:C34(Form:C1466.sceneDetail.conditionSaut.elements=Null:C1517))
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 