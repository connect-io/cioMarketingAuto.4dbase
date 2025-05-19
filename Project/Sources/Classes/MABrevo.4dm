Class constructor($path_t : Text)
	var $fichierConfig_o : Object
	
	If (Count parameters:C259=0)
		This:C1470.configChemin:=Get 4D folder:C485(Current resources folder:K5:16; *)+"cioBrevo"+Folder separator:K24:12+"config.json"
	Else 
		This:C1470.configChemin:=$path_t
	End if 
	
	$fichierConfig_o:=File:C1566(This:C1470.configChemin; fk platform path:K87:2)
	ASSERT:C1129($fichierConfig_o.exists=True:C214; "Impossible de charger le fichier de configuration cioBrevo")
	
	If ($fichierConfig_o.exists=True:C214)
		This:C1470.config:=JSON Parse:C1218($fichierConfig_o.getText())
	End if 
	
Function analysisMessageEvent($statistiqueEmail_o : Object; $statut_t : Text; $tsFrom_el : Integer; $tsTo_el : Integer; $statistiqueEmail_p : Pointer)
	var $resultatHttp_t; $tsFrom_t; $tsTo_t : Text
	var $i_el; $offset_el; $tsEvent_el; $total_el : Integer
	var $resultatHttp_o; $mailStatut_o; $statut_o : Object
	
	$statistiqueEmail_p->:=New collection:C1472()
	
	$tsFrom_t:="&startDate="+cs:C1710.MADate.me.JJMMAA("AAAA-MM-JJ"; Date:C102(cs:C1710.MATimeStamp.me.read("date"; $tsFrom_el)))
	$tsTo_t:="&endDate="+cs:C1710.MADate.me.JJMMAA("AAAA-MM-JJ"; Date:C102(cs:C1710.MATimeStamp.me.read("date"; $tsTo_el)))
	
	If ($statistiqueEmail_o.events#Null:C1517)
		$total_el:=$statistiqueEmail_o.events.length
		
		While ($total_el>0)
			
			If ($i_el>=1)  // Il y a plus de 1000 résultats
				$offset_el:=(1000*$i_el)+1
			End if 
			
			// Je demande dans un second temps les 1000 premiers mails de mon laps de temps recherché (entre $tsFrom_el et $tsTo_el) -> un jour à la fois normalement
			This:C1470.getTypeSearch($statut_t)
			cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/smtp/statistics/events?event="+This:C1470.typeSearch.lib+"&limit=1000"+$tsFrom_t+$tsTo_t+"&offset="+String:C10($offset_el)+"&sort=desc"; ""; ->$resultatHttp_t; ["accept"; "api-key"]; ["application/json"; This:C1470.config.apiKey])
			
			CLEAR VARIABLE:C89($total_el)
			
			If ($resultatHttp_t#"@Error@") & ($resultatHttp_t#"{}")
				$resultatHttp_o:=JSON Parse:C1218($resultatHttp_t)
				$total_el:=$resultatHttp_o.events.length
				
				For each ($event_o; $resultatHttp_o.events)
					$tsEvent_el:=cs:C1710.MATimeStamp.me.get(Date:C102($event_o.date); Time:C179($event_o.date))-cwToolHourSummerWinter(Date:C102($event_o.date))
					
					If ($statistiqueEmail_p->query("email = :1"; $event_o.email).length=1)  // On a déjà traité le mail et on a le plus récent pour l'event recherché
						continue
					End if 
					
					$statistiqueEmail_p->push(New object:C1471("email"; $event_o.email; "idContact"; $event_o.email; "tsEvent"; $tsEvent_el; "messageID"; $event_o.messageId))
				End for each 
				
				If ($total_el<1000)  // Moins de 1000 résultat on a fait la dernière boucle
					CLEAR VARIABLE:C89($total_el)
				End if 
				
			End if 
			
			$i_el+=1
		End while 
		
	End if 
	
Function getHistoryRequestFile
	var $path_t : Text
	var $file_f : 4D:C1709.File
	
	$path_t:=Get 4D folder:C485(Current resources folder:K5:16; *)+"cioBrevo"+Folder separator:K24:12+"historyRequest.json"
	$file_f:=File:C1566($path_t; fk platform path:K87:2)
	
	If ($file_f.exists=False:C215)
		
		If ($file_f.create()=True:C214)
			$file_f.setText(JSON Stringify:C1217({lastRequest: cs:C1710.MATimeStamp.me.get(Current date:C33; Current time:C178)-604800}; *); 2)  // Par défaut on met que la dernière requête a eu lieu il y a 7 jours
		End if 
		
	End if 
	
	This:C1470.historyRequest:=$file_f
	
Function getHistoryRequestContent
	
	If (This:C1470.historyRequest#Null:C1517)
		This:C1470.historyRequestContent:=JSON Parse:C1218(This:C1470.historyRequest.getText())
	End if 
	
Function getMessageEvent($statut_t : Text; $tsFrom_el : Integer; $tsTo_el : Integer; $statistiqueEmail_p : Pointer; $email_t : Text)
	var $resultatHttp_t; $tsFrom_t; $tsTo_t; $contactID_t : Text
	
	This:C1470.getTypeSearch($statut_t)
	
	$tsFrom_t:="&startDate="+cs:C1710.MADate.me.JJMMAA("AAAA-MM-JJ"; Date:C102(cs:C1710.MATimeStamp.me.read("date"; $tsFrom_el)))
	$tsTo_t:="&endDate="+cs:C1710.MADate.me.JJMMAA("AAAA-MM-JJ"; Date:C102(cs:C1710.MATimeStamp.me.read("date"; $tsTo_el)))
	
	If (Count parameters:C259=5)
		$contactID_t:=$email_t
	End if 
	
	// Documentation : https://developers.brevo.com/reference/getemaileventreport-1
	cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/smtp/statistics/events?event="+This:C1470.typeSearch.lib+$tsFrom_t+$tsTo_t+Choose:C955($contactID_t#""; "&email="+$contactID_t; ""); ""; ->$resultatHttp_t; ["accept"; "api-key"]; ["application/json"; This:C1470.config.apiKey])
	
	If ($resultatHttp_t="{@}")
		$statistiqueEmail_p->:=JSON Parse:C1218($resultatHttp_t)
	Else 
		$statistiqueEmail_p->:=New object:C1471("errorHttp"; $resultatHttp_t)
	End if 
	
Function getTypeSearch($num_t : Text)
	var $typeSearch_c : Collection
	
	$typeSearch_c:=This:C1470.config.typeSearch.query("number = :1"; $num_t)
	This:C1470.typeSearch:=OB Copy:C1225($typeSearch_c[0])
	
Function setHistoryRequestContent($content_t : Text)
	
	If (This:C1470.historyRequest#Null:C1517)
		This:C1470.historyRequest.setText($content_t; "UTF-8")
	End if 