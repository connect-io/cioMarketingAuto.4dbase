var $email_t; $mime_t : Text
var $fiche_o; $document_o; $mime_o; $signature_o; $statut_o : Object
var $fichier_o : 4D:C1709.File

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
		
		If (Form:C1466.PersonneCurrentElement=Null:C1517)
			ALERT:C41("Pour les besoins du test, veuillez sélectionner une personne dans la liste « Destinataire » afin de prendre ses informations pour les variables du mailing.")
			return 
		End if 
		
		$email_t:=Request:C163("Adresse email de destinataire ?"; "test@gmail.com"; "Envoi"; "Annuler")
		
		If ($email_t="")
			ALERT:C41("Envoi de l'email de test annulé.")
			return 
		End if 
		
		If (cmaToolRegexValidate(1; $email_t)=False:C215)
			ALERT:C41("L'adresse email indiqué n'est pas au bon format, veuillez recommencer.")
			return 
		End if 
		
		Form:C1466.EMail.subject:=Form:C1466.subject
		Form:C1466.EMail.to:=$email_t
		
		$fiche_o:=cmaToolGetClass("MAPersonne").new()
		$fiche_o.loadByPrimaryKey(Form:C1466.PersonneCurrentElement.UID)
		
		Formula from string:C1601("_cmaInit4WPVar(this)").call($fiche_o.personne)
		$document_o:=WP New:C1317(WParea)
		
		$corps_t:=WP Get text:C1575($document_o; wk expressions as value:K81:255)
		
		If ($corps_t="")
			ALERT:C41("Aucun contenu dans l'email, merci de saisir du texte dans la zone 4DWrite Pro.")
			return 
		End if 
		
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
		
		If ($statut_o.success=False:C215)
			ALERT:C41($statut_o.statusText)
			return 
		End if 
		
		ALERT:C41("L'email a bien été envoyé.")
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 