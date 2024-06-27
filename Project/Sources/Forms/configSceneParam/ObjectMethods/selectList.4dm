If (Form event code:C388=On Data Change:K2:15)
	
	Form:C1466.sceneTypeSelected:=selectList_at{selectList_at}
	Form:C1466.modeleActif:=Form:C1466.sceneClass.updateStringActiveModel(Lowercase:C14(Form:C1466.sceneTypeSelected); Form:C1466.sceneDetail)
End if 