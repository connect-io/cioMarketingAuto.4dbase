var $tsFrom_el; $tsTo_el; $prochaineVerif_el : Integer
var $lastRequest_o : Object

Case of 
	: (Form event code:C388=On Load:K2:1)
		SET TIMER:C645(60)
	: (Form event code:C388=On Timer:K2:25)
		
		Case of 
			: (Form:C1466.cronosMessage="Récupération des données de mailjet en cours...")
				
				If (Form:C1466.cronosVerifMailjet=0)  // Première fois qu'on passe dans la boucle
					Form:C1466.cronosMailjetClass.getHistoryRequestFile()
				End if 
				
				Form:C1466.cronosMailjetClass.getHistoryRequestContent()
				
				$tsFrom_el:=Form:C1466.cronosMailjetClass.historyRequestContent.lastRequest
				$tsTo_el:=cmaTimestamp(Current date:C33; ?23:59:59?)-cwToolHourSummerWinter(Current date:C33)
				
				$prochaineVerif_el:=3600
				
				If (Form:C1466.cronosMailjetClass.historyRequestContent.prochaineVerif#Null:C1517)
					$prochaineVerif_el:=Form:C1466.cronosMailjetClass.historyRequestContent.prochaineVerif
				End if 
				
				Form:C1466.cronosUpdateCaMarketing($tsFrom_el; $tsTo_el; "3"; "4"; "7"; "8"; "10")
				
				$lastRequest_o:=New object:C1471("lastRequest"; cmaTimestamp(Current date:C33; Current time:C178)-cwToolHourSummerWinter(Current date:C33))
				
				If (Form:C1466.cronosMailjetClass.historyRequestContent.prochaineVerif#Null:C1517)
					$lastRequest_o.prochaineVerif:=$prochaineVerif_el
				End if 
				
				Form:C1466.cronosMailjetClass.setHistoryRequestContent(JSON Stringify:C1217($lastRequest_o; *))
				
				Form:C1466.cronosMessage:=""
				Form:C1466.cronosVerifMailjet:=cmaTimestamp(Current date:C33; Current time:C178)+$prochaineVerif_el  // On incrémente d'1 heure par défaut sinon le temps défini par l'utilisateur
			: (Form:C1466.cronosMessage="Gestion des scénarios...")
				Form:C1466.cronosManageScenario()
				
				Form:C1466.cronosMessage:=""
				Form:C1466.cronosVerifScenario:=cmaTimestamp(Current date:C33; Current time:C178)+120  // On incrémente de 2 min
			: (Form:C1466.cronosMessage="Gestion des process automatiques personnalisés journalier...")
				Formula from string:C1601("_cmaGestionCronos(1)").call()
				
				Form:C1466.cronosMessage:=""
				Form:C1466.cronosVerifProcessAuto:=cmaTimestamp(Current date:C33+1; ?00:00:00?)  // On incrémente de 24h
			Else 
				Form:C1466.cronosMessageDisplay()
		End case 
		
		If (Form:C1466.cronosStop=True:C214)
			ACCEPT:C269
		End if 
		
End case 