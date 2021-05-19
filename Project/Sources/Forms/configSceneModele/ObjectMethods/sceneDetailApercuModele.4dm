Case of 
	: (Form event code:C388=Sur clic:K2:4)
		
		If (versionList_at>0)
			Form:C1466.sceneDetail.save()
			
			// On rafraîchi l'entité
			Form:C1466.sceneDetail.reload()
			
			cwToolWindowsForm("gestionDocument"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); New object:C1471("entree"; 2; "donnee"; Form:C1466))
		Else 
			ALERT:C41("Merci de sélectionner une version avant de pouvoir l'éditer")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 