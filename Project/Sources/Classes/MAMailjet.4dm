Class constructor
	C_TEXT:C284($1)
	C_OBJECT:C1216($fichierConfig_o)
	
	If (Count parameters:C259=0)
		This:C1470.configChemin:=Get 4D folder:C485(Current resources folder:K5:16; *)+"cioMailjet"+Folder separator:K24:12+"config.json"
	Else 
		This:C1470.configChemin:=$1
	End if 
	
	$fichierConfig_o:=File:C1566(This:C1470.configChemin; fk platform path:K87:2)
	
	If ($fichierConfig_o.exists=True:C214)
		This:C1470.config:=JSON Parse:C1218($fichierConfig_o.getText())
		This:C1470.config.domainRequest:="https://"+This:C1470.config.smtpKeyPublic+":"+This:C1470.config.smtpKeySecret+"@api.mailjet.com/"+This:C1470.config.smtpVersion
	Else 
		ALERT:C41("Impossible d'intialiser le composant cioMailjet")
	End if 
	
Function AnalysisMessageEvent
	var $1 : Object  // Réponse mailjet de la function getMessageEvent
	var $2 : Text  // Statut des emails qu'on souhaite avoir
	var $3 : Integer  // TS début
	var $4 : Integer  // TS fin
	var $5 : Pointer  // Collection à retourner qui contient mail et idContact
	
	var $resultatHttp_t; $tsFrom_t; $tsTo_t; $email_t; $arrivedAt_t : Text
	var $countMessage_el; $nbBoucle_el; $i_el; $j_el; $offset_el; $tsEvent_el : Integer
	var $contactID_r : Real
	var $dateArrivedAt_d : Date
	var $heureArrivedAt_h : Time
	var $mailStatut_o; $statut_o : Object
	
	ARRAY TEXT:C222($email_at; 0)
	ARRAY TEXT:C222($messageID_at; 0)
	
	ARRAY OBJECT:C1221($dataStat_ao; 0)
	
	$5->:=New collection:C1472()
	
	$tsFrom_t:="&FromTS="+String:C10($3)
	$tsTo_t:="&ToTS="+String:C10($4)
	
	If ($1.Count#Null:C1517)
		$countMessage_el:=Num:C11($1.Count)
		$nbBoucle_el:=Int:C8($countMessage_el/1000)+1
		
		For ($i_el; 1; $nbBoucle_el)
			
			If ($i_el>1)  // Il y a plus de 1000 résultats
				$offset_el:=(1000*$i_el)+1
			Else 
				$offset_el:=0
			End if 
			
			// Je demande dans un second temps les 1000 premiers mails de mon laps de temps recherché (entre $3 et $4) -> un jour à la fois normalement
			cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/REST/message?MessageStatus="+$2+"&limit=1000"+$tsFrom_t+$tsTo_t+"&offset="+String:C10($offset_el)+"&ShowContactAlt=true&sort=ArrivedAt+desc"; ""; ->$resultatHttp_t)
			
			If ($resultatHttp_t#"@Error@")
				// Modifié par : Scanu Rémy (25/06/2021)
				// Obligé de rajouter cela pour avoir les ID des messages...
				This:C1470.getMessageID($resultatHttp_t; ->$messageID_at)
				
				$mailStatut_o:=JSON Parse:C1218($resultatHttp_t)
				OB GET ARRAY:C1229($mailStatut_o; "Data"; $dataStat_ao)
				
				If (Size of array:C274($dataStat_ao)>0)
					
					For ($j_el; 1; Size of array:C274($dataStat_ao))
						$statut_o:=$dataStat_ao{$j_el}
						
						$contactID_r:=Num:C11($statut_o.ContactID)  // Contact ID chez mailjet du contact
						$email_t:=$statut_o.ContactAlt  // Email du contact
						
						If (Find in array:C230($email_at; $email_t)=-1)  // Si le contact n'a pas déjà été traité on ne recherche que le statut du mail le plus récent, inutile de boucler sur les plus anciens
							APPEND TO ARRAY:C911($email_at; $email_t)
							
							$arrivedAt_t:=$statut_o.ArrivedAt
							
							$dateArrivedAt_d:=Date:C102($arrivedAt_t)
							$heureArrivedAt_h:=Time:C179($arrivedAt_t)
							
							$tsEvent_el:=cmaTimestamp($dateArrivedAt_d; $heureArrivedAt_h)-cwToolHourSummerWinter($dateArrivedAt_d)
							$5->push(New object:C1471("email"; $email_t; "idContact"; $contactID_r; "tsEvent"; $tsEvent_el; "messageID"; $messageID_at{$j_el}))
						End if 
						
					End for 
					
				End if 
				
			End if 
			
		End for 
		
	End if 
	
Function getLabelSearch
	var $1 : Text  // Numéro du label qu'on souhaite
	
	var $typeSearch_c : Collection
	
	$typeSearch_c:=This:C1470.config.typeSearch.query("number = :1"; $1)
	
	If ($typeSearch_c.length=1)
		This:C1470.numberTypeSearch:=$typeSearch_c[0].number
		This:C1470.labelTypeSearch:=$typeSearch_c[0].label
	Else 
		This:C1470.numberTypeSearch:=""
		This:C1470.labelTypeSearch:=""
	End if 
	
Function getHistoryRequestFile
	var $cheminFichier_t : Text
	var $fichier_o; $config_o : Object
	
	$config_o:=New object:C1471()
	
	$cheminFichier_t:=Get 4D folder:C485(Current resources folder:K5:16; *)+"cioMailjet"+Folder separator:K24:12+"historyRequest.json"
	
	$fichier_o:=File:C1566($cheminFichier_t; fk platform path:K87:2)
	
	If ($fichier_o.exists=False:C215)
		
		If ($fichier_o.create()=True:C214)
			$config_o.lastRequest:=cmaTimestamp(Current date:C33; Current time:C178)-604800  // Par défaut on met que la dernière requête a eu lieu il y a 7 jours
			
			$fichier_o.setText(JSON Stringify:C1217($config_o; *); 2)
		End if 
		
	End if 
	
	This:C1470.historyRequest:=$fichier_o
	
Function getHistoryRequestContent
	
	If (This:C1470.historyRequest#Null:C1517)
		This:C1470.historyRequestContent:=JSON Parse:C1218(This:C1470.historyRequest.getText())
	End if 
	
Function getMessageEvent($statut_t : Text; $tsFrom_el : Integer; $tsTo_el : Integer; $mailjet_p : Pointer; $contactID_r : Real)
	var $resultatHttp_t; $tsFrom_t; $tsTo_t; $contactID_t : Text
	
	$tsFrom_t:="&FromTS="+String:C10($tsFrom_el)
	$tsTo_t:="&ToTS="+String:C10($tsTo_el)
	
	If (Count parameters:C259=5)
		$contactID_t:=String:C10($contactID_r)
	End if 
	
	cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/REST/message?MessageStatus="+$statut_t+"&countOnly=1"+$tsFrom_t+$tsTo_t+Choose:C955($contactID_t#""; "&Contact="+$contactID_t; ""); ""; ->$resultatHttp_t)
	
	If ($resultatHttp_t="{@}")
		$mailjet_p->:=JSON Parse:C1218($resultatHttp_t)
	Else 
		$mailjet_p->:=New object:C1471("errorHttp"; $resultatHttp_t)
	End if 
	
Function getMessageEventDetail($mailjet_o : Object; $messageEvent_t : Text; $tsFrom_el : Integer; $tsTo_el : Integer; $contactID_r : Real; $displayCompteur_b : Boolean)->$retour_o : Object
	var $resultatHttp_t; $tsFrom_t; $tsTo_t; $contactID_t : Text
	var $countMessage_el; $nbBoucle_el; $i_el; $offset_el : Integer
	
	$retour_o:=New object:C1471
	
	$tsFrom_t:="&FromTS="+String:C10($tsFrom_el)
	$tsTo_t:="&ToTS="+String:C10($tsTo_el)
	
	If (Count parameters:C259=5)
		$contactID_t:=String:C10($contactID_r)
	End if 
	
	If ($mailjet_o.Count#Null:C1517)
		$countMessage_el:=Num:C11($mailjet_o.Count)
		$nbBoucle_el:=Int:C8($countMessage_el/1000)+1
		
		If (Count parameters:C259=6)
			
			If ($displayCompteur_b=True:C214)
				cmaProgressBar(0; "Initialisation"; True:C214)
			End if 
			
		End if 
		
		For ($i_el; 1; $nbBoucle_el)
			
			If (Count parameters:C259=6)
				
				If ($displayCompteur_b=True:C214)
					cmaProgressBar(($i_el/$nbBoucle_el); "Récupération des données de mailjet...")
				End if 
				
			End if 
			
			If ($i_el>1)  // Il y a plus de 1000 résultats
				$offset_el:=(1000*$i_el)+1
			Else 
				$offset_el:=0
			End if 
			
			// Je demande dans un second temps les 1000 premiers mails de mon laps de temps recherché (entre $tsFrom_el et $tsTo_el) -> un jour à la fois normalement
			cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/REST/message?MessageStatus="+$messageEvent_t+"&limit=1000"+$tsFrom_t+$tsTo_t+Choose:C955($contactID_t#""; "&Contact="+$contactID_t; "")+"&offset="+String:C10($offset_el)+"&ShowContactAlt=true&Sort=ArrivedAt+desc"; ""; ->$resultatHttp_t)
			$retour_o[String:C10($offset_el)+"to"+String:C10($offset_el+Choose:C955($offset_el=0; 1000; 999))]:=$resultatHttp_t
			
			If (Count parameters:C259=6)
				
				If ($displayCompteur_b=True:C214)
					
					If (progressBar_el=0)
						$i_el:=$nbBoucle_el
					End if 
					
				End if 
				
			End if 
			
		End for 
		
		If (Count parameters:C259=6)
			
			If ($displayCompteur_b=True:C214)
				cmaProgressBar(1; "arrêt")
			End if 
			
		End if 
		
	End if 
	
Function getContactInformation($email_t : Text)->$contact_o : Object
	var $url_t; $resultatHttp_t : Text
	
	//Il faut encoder l'url... ou pas
	$url_t:=This:C1470.config.domainRequest+"/REST/contact/"+$email_t
	
	//$result_b:=PHP Exécuter(""; "urlencode"; $urlEncode_t; $url_t)
	
	//Si ($result_b=Vrai)
	//cwToolWebHttpRequest("GET"; $urlEncode_t; ""; ->$resultatHttp_t)
	
	//$contact_o:=JSON Parse($resultatHttp_t; *)
	//Fin de si 
	cwToolWebHttpRequest("GET"; $url_t; ""; ->$resultatHttp_t)
	
	If ($resultatHttp_t#"Error@")
		$contact_o:=JSON Parse:C1218($resultatHttp_t; *)
	End if 
	
Function getMessageID
	var $1 : Text  // Chaine à analyser
	var $2 : Pointer  // Pointeur [tabeau texte || collection] qui contient les id des messages (Si collection contient également les timeStamp de ces messages là)
	
	var $demonteChaine_t; $chaineObjet_t; $messageID_t : Text
	var $positionCrochet_el; $positionAccolade_el; $positionID_el; $positionVirgule_el : Integer
	var $detail_o : Object
	
	// Petite galère qui fait bien chier, je vais devoir passer en revu ma chaine $resultatHTTP car l'ID du message est supérieur à la valeur autorisée par la commande JSON PARSE ±10.421e±10...
	$demonteChaine_t:=$1
	$positionCrochet_el:=Position:C15("["; $demonteChaine_t)
	
	If ($positionCrochet_el>0)
		$demonteChaine_t:=Delete string:C232($demonteChaine_t; 1; $positionCrochet_el)
		$positionCrochet_el:=Position:C15("]"; $demonteChaine_t)
		
		If ($positionCrochet_el>0)
			$demonteChaine_t:=Substring:C12($demonteChaine_t; 1; $positionCrochet_el-1)
			
			// On devrait se retrouver avec une chaine comme ça : {...},{...},{...}
			$positionAccolade_el:=Position:C15("}"; $demonteChaine_t)
			
			If ($positionAccolade_el>0)
				
				While ($positionAccolade_el>0)
					$chaineObjet_t:=Substring:C12($demonteChaine_t; 1; $positionAccolade_el)
					
					// $chaineObjet_t devrait ressembler à une chaine comme ça : {...}
					If (Value type:C1509($2->)=Is collection:K8:32)
						$detail_o:=JSON Parse:C1218($chaineObjet_t)
						
						$2->push(New object:C1471("arrivedAt"; cmaTimestamp(Date:C102($detail_o.ArrivedAt); Time:C179($detail_o.ArrivedAt)); "messageID"; ""))
					End if 
					
					$positionID_el:=Position:C15("\"ID\" :"; $chaineObjet_t)
					
					If ($positionID_el>0)
						$chaineObjet_t:=Substring:C12($chaineObjet_t; $positionID_el+7)
						$positionVirgule_el:=Position:C15(","; $chaineObjet_t)
						
						If ($positionVirgule_el>0)
							$messageID_t:=Substring:C12($chaineObjet_t; 1; $positionVirgule_el-1)
							
							// Enfin on est arrivé au bout !
							If (Value type:C1509($2->)=Is collection:K8:32)
								$2->[$2->length-1].messageID:=$messageID_t
							Else 
								APPEND TO ARRAY:C911($2->; $messageID_t)
							End if 
							
						End if 
						
					End if 
					
					$demonteChaine_t:=Delete string:C232($demonteChaine_t; 1; $positionAccolade_el+1)
					$positionAccolade_el:=Position:C15("}"; $demonteChaine_t)
				End while 
				
			End if 
			
		End if 
		
	End if 
	
Function getMessageDetail($messageID_t : Text)->$messageDetail_o : Object
	var $resultatHttp_t : Text
	
	// Je demande dans un second temps les 1000 premiers mails de mon laps de temps recherché (entre $3 et $4) -> un jour à la fois normalement
	cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/REST/message/"+$messageID_t+"?ShowContactAlt=true&ShowSubject=true"; ""; ->$resultatHttp_t)
	
	If ($resultatHttp_t#"") & ($resultatHttp_t#"Error@")
		$messageDetail_o:=JSON Parse:C1218($resultatHttp_t)
	End if 
	
Function getMessageHistoryDetail($messageID_t : Text)->$messageHistoryDetail_t : Text
	var $resultatHttp_t : Text
	var $i_el : Integer
	var $detail_o; $messageDetail_o : Object
	
	ARRAY OBJECT:C1221($dataDetail_ao; 0)
	
	cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/REST/messagehistory/"+$messageID_t; ""; ->$resultatHttp_t)
	
	If ($resultatHttp_t#"") & ($resultatHttp_t#"Error@")
		$detail_o:=JSON Parse:C1218($resultatHttp_t)
		
		OB GET ARRAY:C1229($detail_o; "Data"; $dataDetail_ao)
		
		For ($i_el; 1; Size of array:C274($dataDetail_ao))
			$messageDetail_o:=$dataDetail_ao{$i_el}
			
			Case of 
				: (String:C10($messageDetail_o.Comment)#"")  // Il s'agit d'un bounce
					
					Case of 
						: (String:C10($messageDetail_o.Comment)="@5.0.0@")
							$messageHistoryDetail_t:="Adresse e-mail inexistante"
						: (String:C10($messageDetail_o.Comment)="@5.1.0@")
							$messageHistoryDetail_t:="Code d'erreur inconnu"
						: (String:C10($messageDetail_o.Comment)="@5.1.1@")
							$messageHistoryDetail_t:="Adresse e-mail erronée"
						: (String:C10($messageDetail_o.Comment)="@5.1.2@")
							$messageHistoryDetail_t:="Adresse de destination du système invalide"
						: (String:C10($messageDetail_o.Comment)="@5.1.3@")
							$messageHistoryDetail_t:="Syntaxe d'adresse e-mail incorrecte"
						: (String:C10($messageDetail_o.Comment)="@5.1.4@")
							$messageHistoryDetail_t:="Adresse de destination ambiguë"
						: (String:C10($messageDetail_o.Comment)="@5.1.5@")
							$messageHistoryDetail_t:="Adresse de destination invalide"
						: (String:C10($messageDetail_o.Comment)="@5.1.6@")
							$messageHistoryDetail_t:="La boite aux lettres a été déplacée"
						: (String:C10($messageDetail_o.Comment)="@5.1.7@")
							$messageHistoryDetail_t:="Syntaxe de l’adresse e-mail de l’expéditeur erronée"
						: (String:C10($messageDetail_o.Comment)="@5.1.8@")
							$messageHistoryDetail_t:="Adresse système de l’expéditeur erronée"
						: (String:C10($messageDetail_o.Comment)="@5.2.0@")
							$messageHistoryDetail_t:="État de l’adresse e-mail non défini ou autre"
						: (String:C10($messageDetail_o.Comment)="@5.2.1@")
							$messageHistoryDetail_t:="Adresse e-mail désactivée, n’accepte pas les messages"
						: (String:C10($messageDetail_o.Comment)="@5.2.2@")
							$messageHistoryDetail_t:="Boîte de réception saturée"
						: (String:C10($messageDetail_o.Comment)="@5.2.3@")
							$messageHistoryDetail_t:="La longueur du message dépasse la limite définie par l’administrateur"
						: (String:C10($messageDetail_o.Comment)="@5.2.4@")
							$messageHistoryDetail_t:="Problème de résolution de la liste de diffusion"
						: (String:C10($messageDetail_o.Comment)="@5.3.0@")
							$messageHistoryDetail_t:="État du système de messagerie non défini ou autre"
						: (String:C10($messageDetail_o.Comment)="@5.3.1@")
							$messageHistoryDetail_t:="Système de messagerie saturé"
						: (String:C10($messageDetail_o.Comment)="@5.3.2@")
							$messageHistoryDetail_t:="Le système n’accepte pas les messages réseaux"
						: (String:C10($messageDetail_o.Comment)="@5.3.3@")
							$messageHistoryDetail_t:="Le système ne parvient pas à traiter les fonctions ou commandes demandées"
						: (String:C10($messageDetail_o.Comment)="@5.3.4@")
							$messageHistoryDetail_t:="Message trop volumineux pour le système"
						: (String:C10($messageDetail_o.Comment)="@5.4.0@")
							$messageHistoryDetail_t:="État du réseau ou du routage non défini ou autre"
						: (String:C10($messageDetail_o.Comment)="@5.4.1@")
							$messageHistoryDetail_t:="Aucune réponse de l’hôte (Serveur SMTP distant)"
						: (String:C10($messageDetail_o.Comment)="@5.4.2@")
							$messageHistoryDetail_t:="Mauvaise connexion"
						: (String:C10($messageDetail_o.Comment)="@5.4.3@")
							$messageHistoryDetail_t:="Panne du serveur de routage"
						: (String:C10($messageDetail_o.Comment)="@5.4.4@")
							$messageHistoryDetail_t:="Impossible de router le message"
						: (String:C10($messageDetail_o.Comment)="@5.4.5@")
							$messageHistoryDetail_t:="Congestion du réseau"
						: (String:C10($messageDetail_o.Comment)="@5.4.6@")
							$messageHistoryDetail_t:="Boucle de routage détectée"
						: (String:C10($messageDetail_o.Comment)="@5.4.7@")
							$messageHistoryDetail_t:="Expiration du délai de livraison"
						: (String:C10($messageDetail_o.Comment)="@5.5.0@")
							$messageHistoryDetail_t:="État de protocole non défini ou autre"
						: (String:C10($messageDetail_o.Comment)="@5.5.1@")
							$messageHistoryDetail_t:="Commande invalide"
						: (String:C10($messageDetail_o.Comment)="@5.5.2@")
							$messageHistoryDetail_t:="Erreur de syntaxe"
						: (String:C10($messageDetail_o.Comment)="@5.5.3@")
							$messageHistoryDetail_t:="Trop de destinataires"
						: (String:C10($messageDetail_o.Comment)="@5.5.4@")
							$messageHistoryDetail_t:="Arguments de commande invalides"
						: (String:C10($messageDetail_o.Comment)="@5.5.5@")
							$messageHistoryDetail_t:="Version de protocole erronée"
						: (String:C10($messageDetail_o.Comment)="@5.6.0@")
							$messageHistoryDetail_t:="Erreur dans le contenu du mail"
						: (String:C10($messageDetail_o.Comment)="@5.6.1@")
							$messageHistoryDetail_t:="Contenu non pris en charge"
						: (String:C10($messageDetail_o.Comment)="@5.6.2@")
							$messageHistoryDetail_t:="Conversion demandée et interdite"
						: (String:C10($messageDetail_o.Comment)="@5.6.3@")
							$messageHistoryDetail_t:="Conversion demandée non supportée"
						: (String:C10($messageDetail_o.Comment)="@5.6.4@")
							$messageHistoryDetail_t:="Conversion du mail effectuée avec des pertes de données"
						: (String:C10($messageDetail_o.Comment)="@5.6.5@")
							$messageHistoryDetail_t:="Échec de la conversion"
						: (String:C10($messageDetail_o.Comment)="@5.7.0@")
							$messageHistoryDetail_t:="État de sécurité non défini ou autre"
						: (String:C10($messageDetail_o.Comment)="@5.7.1@")
							$messageHistoryDetail_t:="Adresse du destinataire rejetée : Accès refusé"
						: (String:C10($messageDetail_o.Comment)="@5.7.2@")
							$messageHistoryDetail_t:="Résolution de la liste de diffusion interdite"
						: (String:C10($messageDetail_o.Comment)="@5.7.3@")
							$messageHistoryDetail_t:="Conversion de sécurité obligatoire mais impossible"
						: (String:C10($messageDetail_o.Comment)="@5.7.4@")
							$messageHistoryDetail_t:="Fonctionnalités de sécurité non prises en charge"
						: (String:C10($messageDetail_o.Comment)="@5.7.5@")
							$messageHistoryDetail_t:="Échec de chiffrement"
						: (String:C10($messageDetail_o.Comment)="@5.7.6@")
							$messageHistoryDetail_t:="Algorithme de chiffrement non pris en charge"
						: (String:C10($messageDetail_o.Comment)="@5.7.7@")
							$messageHistoryDetail_t:="Échec de l’intégrité de Message"
						Else 
							$messageHistoryDetail_t:="Raison inconnue"
					End case 
					
					$i_el:=Size of array:C274($dataDetail_ao)
				Else 
					$messageHistoryDetail_t:=$messageHistoryDetail_t+"Action : "+$messageDetail_o.EventType+", le "+cmaTimestampLire("date"; $messageDetail_o.EventAt)+" à "+cmaTimestampLire("heure"; $messageDetail_o.EventAt)
					
					If ($i_el<Size of array:C274($dataDetail_ao))
						$messageHistoryDetail_t:=$messageHistoryDetail_t+Char:C90(Line feed:K15:40)
					End if 
					
			End case 
			
		End for 
		
	Else 
		$messageHistoryDetail_t:="Erreur réseau, vérifiez votre connexion internet"
	End if 
	
Function getInformationDetail
	var $0 : Collection
	var $1 : Text
	
	var $mailjet_o : Object
	
	ARRAY TEXT:C222($messageID_at; 0)
	
	$0:=New collection:C1472
	
	$mailjet_o:=JSON Parse:C1218($1)
	$0:=$mailjet_o.Data.extract("ContactID"; "contactID"; "SenderID"; "senderID"; "UUID"; "UUID")
	
	This:C1470.getMessageID($1; ->$messageID_at)
	ARRAY TO COLLECTION:C1563($0; $messageID_at; "messageID")
	
Function getStatistic
	var $0 : Object  // Retour de mailjet
	var $1 : Text  // Email OU Contact ID de la personne dont on souhaite avoir les stats
	
	var $resultatHttp_t : Text
	
	cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/REST/contactstatistics/"+String:C10($1); ""; ->$resultatHttp_t)
	
	If ($resultatHttp_t="{@}")
		$0:=JSON Parse:C1218($resultatHttp_t)
	Else 
		$0:=New object:C1471("errorHttp"; $resultatHttp_t)
	End if 
	
Function setHistoryRequestContent
	var $1 : Text
	
	If (This:C1470.historyRequest#Null:C1517)
		This:C1470.historyRequest.setText($1; "UTF-8")
	End if 