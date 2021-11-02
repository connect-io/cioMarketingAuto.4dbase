Case of 
	: (Form event code:C388=Sur clic:K2:4)
		OB REMOVE:C1226(Form:C1466.sceneDetail.conditionSaut; "sceneSautID")
		
		sceneSaut_at:=0
		sceneSaut_at{0}:="Sélection d'une scène"
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 