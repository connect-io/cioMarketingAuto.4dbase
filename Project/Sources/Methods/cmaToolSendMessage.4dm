//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolSendMessage

Renvoie une class vers la base hôte.

Historique
05/03/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Object

var $MASMS_cs; $MAEMail_cs; $contact_o : Object
var $contact_c : Collection

$contact_c:=Storage:C1525.automation.config.contact.query("role[] = :1"; $1.role)

If ($contact_c.length>0)
	
	Case of 
		: ($1.type="sms")
			$MASMS_cs:=cmaToolGetClass("MASms").new(False:C215; New object:C1471("nom"; $1.prestataire))
		: ($1.type="mail")
			$MAEMail_cs:=cmaToolGetClass("MAEMail").new($1.expediteur)
	End case 
	
	For each ($contact_o; $contact_c)
		
		Case of 
			: ($1.type="sms")
				$MASMS_cs.SMSBOXSendMessage(True:C214; $1.message; $contact_o.telMobile; Current date:C33; Current time:C178; "Reponse"; "2")
			: ($1.type="mail")
				$MAEMail_cs.to:=$contact_o.eMail
				
				$MAEMail_cs.subject:=$1.subject
				$MAEMail_cs.textBody:=$1.message
				$MAEMail_cs.send()
		End case 
		
	End for each 
	
End if 