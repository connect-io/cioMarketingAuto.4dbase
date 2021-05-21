If (Form event code:C388=Sur chargement:K2:1)
	SET TIMER:C645(60)
End if 

If (Form event code:C388=Sur minuteur:K2:25)
	var $tsFrom_el; $tsTo_el : Integer
	var $lastRequest_o : Object
	
	Case of 
		: (Form:C1466.cronosMessage="Récupération des données de mailjet en cours...")
			
			If (Form:C1466.cronosVerifMailjet=0)  // Première fois qu'on passe dans la boucle
				Form:C1466.cronosMailjetClass.getHistoryRequestFile()
			End if 
			
			Form:C1466.cronosMailjetClass.getHistoryRequestContent()
			
			$tsFrom_el:=Form:C1466.cronosMailjetClass.historyRequestContent.lastRequest
			$tsTo_el:=cmaTimestamp(Current date:C33; Current time:C178)
			
			Form:C1466.cronosUpdateCaMarketing($tsFrom_el; $tsTo_el; "3"; "4"; "7"; "8"; "10")
			
			$lastRequest_o:=New object:C1471("lastRequest"; cmaTimestamp(Current date:C33; Current time:C178))
			Form:C1466.cronosMailjetClass.setHistoryRequestContent(JSON Stringify:C1217($lastRequest_o; *))
			
			Form:C1466.cronosMessage:=""
			Form:C1466.cronosVerifMailjet:=cmaTimestamp(Current date:C33; Current time:C178)+3600  // On incrémente d'1 heure
		: (Form:C1466.cronosMessage="Gestion des scénarios...")
			Form:C1466.cronosManageScenario()
			
			Form:C1466.cronosMessage:=""
			Form:C1466.cronosVerifScenario:=cmaTimestamp(Current date:C33; Current time:C178)+3600  // On incrémente d'1 heure
		Else 
			Form:C1466.cronosMessageDisplay()
	End case 
	
	If (Form:C1466.cronosStop=True:C214)
		ACCEPT:C269
	End if 
	
End if 