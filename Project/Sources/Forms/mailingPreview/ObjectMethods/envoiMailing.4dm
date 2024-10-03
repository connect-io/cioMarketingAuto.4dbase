var $canalEnvoi_t : Text
var $length_el; $moduloProgress_el; $i_el : Integer
var $statut_b; $continue_b : Boolean
var $destinataire_o; $statut_o; $compteur_o; $document_o; $config_o; $retour_o : Object

var $person_cs : cs:C1710.MAPersonne

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$canalEnvoi_t:=OBJECT Get pointer:C1124(Object named:K67:5; "canalEnvoi")->currentValue
		
		Case of 
			: ($canalEnvoi_t="EMail")
				
				If (OBJECT Get pointer:C1124(Object named:K67:5; "transporteur")->index=-1)
					ALERT:C41("Merci de sélectionner un expéditeur.")
					return 
				End if 
				
				If (String:C10(Form:C1466.subject)="")
					ALERT:C41("Veuillez renseigner un objet d'email.")
					return 
				End if 
				
			: ($canalEnvoi_t="SMS")
				
				If (OBJECT Get pointer:C1124(Object named:K67:5; "prestataireSMS")->index=-1)
					ALERT:C41("Merci de sélectionner un prestataire.")
					return 
				End if 
				
			: ($canalEnvoi_t="Courrier")
				
				If (OBJECT Get pointer:C1124(Object named:K67:5; "prestataireCourrier")->index=-1) & ((Form:C1466.Courrier=Null:C1517) || (Form:C1466.Courrier.prestataire.nom#"Imprimante courante"))
					ALERT:C41("Merci de sélectionner un prestataire.")
					return 
				End if 
				
		End case 
		
		$document_o:=WP New:C1317(WParea)
		$corps_t:=WP Get text:C1575($document_o; wk expressions as value:K81:255)
		
		If ($corps_t="")
			ALERT:C41("Aucun contenu dans l"+(($canalEnvoi_t="EMail") ? "'" : "e ")+Lowercase:C14($canalEnvoi_t)+", merci de saisir du texte dans la zone 4DWrite Pro.")
			return 
		End if 
		
		$length_el:=Form:C1466.PersonneSelectedElement.length
		$moduloProgress_el:=Round:C94($length_el/5; 0)
		
		$compteur_o:=New object:C1471("success"; 0; "fail"; 0)
		Form:C1466.failed_c:=New collection:C1472()
		
		If ($canalEnvoi_t="Courrier")
			
			If (Form:C1466.Courrier.prestataire.nom="Imprimante courante")
				PRINT SETTINGS:C106
				
				If (OK=0)
					ALERT:C41("Envoi annulé")
					return 
				End if 
				
				OPEN PRINTING JOB:C995
			End if 
			
		End if 
		
		cmaProgressBar(0; "Initialisation"; True:C214)
		
		For each ($destinataire_o; Form:C1466.MAPersonneSelection.personneCollection)
			
			If ($i_el%$moduloProgress_el=0)
				cmaProgressBar(($i_el/$length_el); "Envoi du mailing en cours..."; True:C214)
			End if 
			
			Case of 
				: ($canalEnvoi_t="EMail")
					$continue_b:=cmaToolRegexValidate(1; $destinataire_o.eMail)
				: ($canalEnvoi_t="SMS")
					$continue_b:=($destinataire_o.telMobile#"")
				: ($canalEnvoi_t="Courrier")
					$continue_b:=($destinataire_o.adresse#"") & ($destinataire_o.codePostal#"") & ($destinataire_o.ville#"")
			End case 
			
			If ($continue_b=True:C214)
				$person_cs:=cmaToolGetClass("MAPersonne").new()
				$person_cs.loadByPrimaryKey($destinataire_o.UID)
				
				If ($person_cs.personne#Null:C1517)
					Formula from string:C1601("_cmaInit4WPVar(this)").call($person_cs.personne)
					$document_o:=WP New:C1317(WParea)
					
					$corps_t:=WP Get text:C1575($document_o; wk expressions as value:K81:255)
					
					Case of 
						: ($canalEnvoi_t="EMail")
							Form:C1466.EMail.subject:=Form:C1466.subject
							Form:C1466.EMail.to:=$destinataire_o.eMail
							
							$config_o:=New object:C1471("success"; True:C214; "type"; "Email"; "eMailConfig"; Form:C1466.EMail; "contenu4WP"; $document_o; "expediteur"; OBJECT Get pointer:C1124(Object named:K67:5; "transporteur")->currentValue)
						: ($canalEnvoi_t="SMS")
							Form:C1466.Sms.date:=Form:C1466.date
							Form:C1466.Sms.time:=Form:C1466.time
							
							$config_o:=New object:C1471("success"; True:C214; "type"; "SMS"; "SMSConfig"; Form:C1466.Sms; "contenu4WP"; $document_o; "smsMarketing"; True:C214)
						: ($canalEnvoi_t="Courrier")
							$config_o:=New object:C1471("success"; True:C214; "type"; "Courrier"; "CourrierConfig"; Form:C1466.Courrier; "contenu4WP"; $document_o; "displayPrintSetting"; False:C215)
							
							If (Form:C1466.contextValue#Null:C1517)
								$config_o.externalReference:=New object:C1471("table"; "Parameter"; "field"; "wording"; "value"; OBJECT Get pointer:C1124(Object named:K67:5; "modele")->currentValue)
								$config_o.contextValue:=Form:C1466.contextValue
							End if 
							
					End case 
					
					$retour_o:=$person_cs.sendMailing($config_o)
					$statut_b:=Bool:C1537($retour_o.success)
				End if 
				
			End if 
			
			If ($statut_b=True:C214)  // Statut de l'envoi du mail
				$compteur_o.success:=$compteur_o.success+1
			Else 
				$compteur_o.fail:=$compteur_o.fail+1
				
				Case of 
					: ($canalEnvoi_t="EMail")
						Form:C1466.failed_c.push(New object:C1471("email"; $destinataire_o.eMail; "status"; $statut_o.statusText))
					: ($canalEnvoi_t="SMS")
						Form:C1466.failed_c.push(New object:C1471("telMobile"; $destinataire_o.telMobile; "status"; ""))
					: ($canalEnvoi_t="Courrier")
						
				End case 
				
			End if 
			
			$i_el+=1
			CLEAR VARIABLE:C89($statut_b)
		End for each 
		
		cmaProgressBar(1; "arrêt")
		
		If ($canalEnvoi_t="Courrier")
			
			If (Form:C1466.Courrier.prestataire.nom="Imprimante courante")
				CLOSE PRINTING JOB:C996
			End if 
			
		End if 
		
		If ($compteur_o.success>0)
			ALERT:C41("Le mailing a bien été envoyé à "+String:C10($compteur_o.success)+" personne(s)")
		End if 
		
		If ($compteur_o.fail>0)
			ALERT:C41("Le mailing n'a pas pu être envoyé à "+String:C10($compteur_o.fail)+" personne(s)")
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 