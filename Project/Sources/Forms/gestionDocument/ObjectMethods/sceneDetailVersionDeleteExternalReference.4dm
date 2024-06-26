Case of 
	: (Form event code:C388=On Clicked:K2:4)
		CONFIRM:C162("Voulez-vous vraiment supprimer le lien avec le document « "+String:C10(Form:C1466.externalReference.value)+" » ?"; "Oui"; "Non")
		
		If (OK=1)
			OB REMOVE:C1226(Form:C1466; "externalReference")
			OBJECT SET VALUE:C1742("externalReference"; "")
			
			OBJECT SET VISIBLE:C603(*; "externalReference"; False:C215)
			OBJECT SET VISIBLE:C603(*; "sceneDetailVersionDeleteExternalReference"; False:C215)
			WParea:=WP New:C1317
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 