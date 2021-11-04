Case of 
	: (Form event code:C388=Sur clic:K2:4)
		Form:C1466.sceneClass.manageConditionSautDisplay(0; OBJECT Get name:C1087(Objet courant:K67:2); OBJECT Get pointer:C1124(Objet courant:K67:2); Form:C1466.sceneDetail)
		
		// S'il n'y a pas plus de condition de saut, on désactive la possibilité de sélectionné une scène
		
		If (Form:C1466.sceneDetail.conditionSaut.elements=Null:C1517)
			OB REMOVE:C1226(Form:C1466.sceneDetail.conditionSaut; "sceneSautID")
			
			sceneSaut_at:=0
			sceneSaut_at{0}:="Sélection d'une scène"
		End if 
		
		OBJECT SET ENABLED:C1123(sceneSaut_at; Not:C34(Form:C1466.sceneDetail.conditionSaut.elements=Null:C1517))
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 