Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		Case of 
			: (Picture size:C356(Form:C1466.imageExecuterFormule)=Picture size:C356(Storage:C1525.automation.image["toggle-off"]))
				CONFIRM:C162("Souhaitez-vous vraiment indiquer que la/les pièces-jointes sera(ont) générée(s) à partir d'une formule "+Choose:C955(Form:C1466.externalReference#Null:C1517; " (cela supprimera le pointage sur le document "+String:C10(Form:C1466.externalReference.value)+")"; "")+"?"; "Valider"; "Annuler")
				
				If (OK=1)
					Form:C1466.imageExecuterFormule:=Storage:C1525.automation.image["toggle-on"]
					Form:C1466.donnee.pieceJointe.executerFormule:=True:C214
					
					OB REMOVE:C1226(Form:C1466; "externalReference")
					OBJECT SET VALUE:C1742("externalReference"; "")
				Else 
					Form:C1466.imageExecuterFormule:=Storage:C1525.automation.image["toggle-off"]
				End if 
				
			: (Picture size:C356(Form:C1466.imageEmail)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
				Form:C1466.imageExecuterFormule:=Storage:C1525.automation.image["toggle-off"]
				Form:C1466.donnee.pieceJointe.executerFormule:=False:C215
		End case 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 