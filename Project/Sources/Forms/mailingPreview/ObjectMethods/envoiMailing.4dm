var $canalEnvoi_t : Text
var $length_el; $moduloProgress_el; $i_el : Integer
var $destinataire_o; $fiche_o; $statut_o; $compteur_o; $document_o : Object

Case of 
	: (Form event code:C388=Sur clic:K2:4)
		
		If (OBJECT Get pointer:C1124(Objet nommé:K67:5; "transporteur")->index=-1)
			ALERT:C41("Merci de sélectionner un expéditeur.")
			return 
		End if 
		
		If (String:C10(Form:C1466.subject)="")
			ALERT:C41("Veuillez renseigner un objet d'email.")
			return 
		End if 
		
		$canalEnvoi_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "canalEnvoi")->currentValue
		
		$document_o:=WP New:C1317(WParea)
		$corps_t:=WP Get text:C1575($document_o; wk expressions as value:K81:255)
		
		If ($corps_t="")
			ALERT:C41("Aucun contenu dans l'email, merci de saisir du texte dans la zone 4DWrite Pro.")
			return 
		End if 
		
		$length_el:=Form:C1466.PersonneSelectedElement.length
		$moduloProgress_el:=Round:C94($length_el/5; 0)
		
		$compteur_o:=New object:C1471("success"; 0; "fail"; 0)
		
		cmaProgressBar(0; "Initialisation"; True:C214)
		
		For each ($destinataire_o; Form:C1466.MAPersonneSelection.personneCollection)
			
			If ($i_el%$moduloProgress_el=0)
				cmaProgressBar(($i_el/$length_el); "Envoi du mailing en cours..."; True:C214)
			End if 
			
			If (cmaToolRegexValidate(1; $destinataire_o.eMail)=True:C214)
				Form:C1466.EMail.subject:=Form:C1466.subject
				Form:C1466.EMail.to:=$destinataire_o.eMail
				
				$fiche_o:=cmaToolGetClass("MAPersonne").new()
				$fiche_o.loadByPrimaryKey($destinataire_o.UID)
				
				If ($fiche_o.personne#Null:C1517)
					Formula from string:C1601("_cmaInit4WPVar(this)").call($fiche_o.personne)
					$document_o:=WP New:C1317(WParea)
					
					$corps_t:=WP Get text:C1575($document_o; wk expressions as value:K81:255)
					
					If ($corps_t#"@<p@")
						$fichier_o:=File:C1566(Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioMarketingAutomation"+Séparateur dossier:K24:12+"scene"+Séparateur dossier:K24:12+"signatureEmail.4wp"; fk chemin plateforme:K87:2)
						
						If ($fichier_o.exists=True:C214)
							WP INSERT BREAK:C1413($document_o; wk paragraph break:K81:259; wk append:K81:179)
							
							$signature_o:=WP Import document:C1318($fichier_o.platformPath)
							WP INSERT DOCUMENT:C1411($document_o; $signature_o; wk append:K81:179)
						End if 
						
						WP EXPORT VARIABLE:C1319($document_o; $mime_t; wk mime html:K81:1)  // Mime export of Write Pro document
						$mime_o:=MAIL Convert from MIME:C1681($mime_t)
						
						For each ($propriete_t; $mime_o)
							Form:C1466.EMail[$propriete_t]:=$mime_o[$propriete_t]
						End for each 
						
					Else 
						Form:C1466.EMail.htmlBody:=$corps_t
					End if 
					
					$statut_o:=Form:C1466.EMail.send()
					$statut_b:=Bool:C1537($statut_o.success)
				End if 
				
			End if 
			
			If ($statut_b=True:C214)  // Statut de l'envoie du mail
				$compteur_o.success:=$compteur_o.success+1
			Else 
				$compteur_o.fail:=$compteur_o.fail+1
			End if 
			
			// S'il s'agit d'un Courrier ou SMS ou un mail qui possède un corps non vide, on rajoute l'historique de l'envoi
			If ($canalEnvoi_t#"Email") | (($canalEnvoi_t="Email") & ($corps_t#""))
				WP FREEZE FORMULAS:C1708($document_o; wk recompute expressions:K81:311)
				$fiche_o.updateCaMarketingStatistic(3; New object:C1471("type"; $canalEnvoi_t; "contenu4WP"; $document_o; "statut"; $statut_b))
			End if 
			
			$i_el+=1
			CLEAR VARIABLE:C89($statut_b)
		End for each 
		
		cmaProgressBar(1; "arrêt")
		
		If ($compteur_o.success>0)
			ALERT:C41("Le mailing a bien été envoyé à "+String:C10($compteur_o.success)+" personne(s)")
		End if 
		
		If ($compteur_o.fail>0)
			ALERT:C41("Le mailing n'a pas pu être envoyé à "+String:C10($compteur_o.fail)+" personne(s)")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 