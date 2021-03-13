Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $docFichier_t : Text
		var $selectList_el : Integer
		var $continue_b : Boolean
		var $config_o : Object
		
		If (selectList_at>0)
			$selectList_el:=selectList_at
			
			cwToolWindowsForm("configSceneModele"; "center"; Form:C1466)
			
			CLEAR VARIABLE:C89(selectList_at)
			
			APPEND TO ARRAY:C911(selectList_at; "Email")
			APPEND TO ARRAY:C911(selectList_at; "SMS")
			APPEND TO ARRAY:C911(selectList_at; "Courrier")
			
			selectList_at{0}:="Selection du canal d'envoi"
			selectList_at:=$selectList_el
			
			Form:C1466.modeleActif:=Form:C1466.sceneClass.updateStringActiveModel(Lowercase:C14(Form:C1466.sceneTypeSelected))
		Else 
			ALERT:C41("Merci de sélectionner un canal d'envoi")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 