If (Form event code:C388=On Load:K2:1)
	ARRAY TEXT:C222(selectList_at; 0)
	
	APPEND TO ARRAY:C911(selectList_at; "Email")
	APPEND TO ARRAY:C911(selectList_at; "SMS")
	APPEND TO ARRAY:C911(selectList_at; "Courrier")
	
	selectList_at{0}:="Selection du canal d'envoi"
	selectList_at:=0
	
	Form:C1466.sceneClass:=cmaToolGetClass("MAScene").new()
	Form:C1466.modeleActif:=""
	
	OBJECT SET ENTERABLE:C238(*; "sceneDetailFormule"; (Form:C1466.sceneDetail.action="Exécuter une formule"))
	OBJECT SET ENABLED:C1123(*; "sceneDetailFormuleContexte"; (Form:C1466.sceneDetail.action="Exécuter une formule"))
End if 