Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (sceneAction_at{sceneAction_at}="Attente") | (sceneAction_at{sceneAction_at}="Changement de scénario") | (sceneAction_at{sceneAction_at}="Fin du scénario")
			ALERT:C41("L'action \""+sceneAction_at{sceneAction_at}+"\" ne permet pas de paramétrer la scène")
		Else 
			cwToolWindowsForm("configSceneParam"; "center"; Form:C1466)  // Form est la class scénario
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 