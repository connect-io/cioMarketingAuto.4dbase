Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		Case of 
			: (Picture size:C356(Form:C1466.imageSauvegardeWritePro)=Picture size:C356(Storage:C1525.automation.image["toggle-off"]))
				Form:C1466.sceneDetail.paramAction.sauvegardeWritePro:=True:C214
				Form:C1466.imageSauvegardeWritePro:=Storage:C1525.automation.image["toggle-on"]
			: (Picture size:C356(Form:C1466.imageSauvegardeWritePro)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
				Form:C1466.sceneDetail.paramAction.sauvegardeWritePro:=False:C215
				Form:C1466.imageSauvegardeWritePro:=Storage:C1525.automation.image["toggle-off"]
		End case 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 