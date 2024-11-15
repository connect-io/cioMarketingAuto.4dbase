var $body_o; $mailing_o : Object
var $sendind_c : Collection

var $MACourrier_cs : Object
var $MAPersonne_cs : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$MACourrier_cs:=cmaToolGetClass("MACourrier").new(False:C215; New object:C1471("nom"; "Maileva"; "environnement"; "production"))
		$MACourrier_cs.getTokenAPIMaileva()
		
		If ($MACourrier_cs.token.access_token=Null:C1517)
			ALERT:C41("Le token pour utiliser l'API Maileva n'a pas pu se généré")
			return 
		End if 
		
		$MAPersonne_cs:=cmaToolGetClass("MAPersonne").new()
		$MAPersonne_cs.loadByPrimaryKey(Form:C1466.PersonneCurrentElement[Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "UID")])
		
		If ($MAPersonne_cs.personne=Null:C1517)
			ALERT:C41("Impossible de trouver la personne dans la base de données (ID : "+String:C10(Form:C1466.PersonneCurrentElement[Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "UID")])+")")
			return 
		End if 
		
		$sendind_c:=New collection:C1472
		
		For each ($mailing_o; $MAPersonne_cs.personne.AllCaPersonneMarketing.first().historique.detail)
			
			If ($mailing_o.eventDetail.extraDetail=Null:C1517)
				continue
			End if 
			
			$sendind_c.push(New object:C1471(\
				"id"; $mailing_o.eventDetail.extraDetail.sendingInformation.id; \
				"destinataire"; $mailing_o.eventDetail.extraDetail.recipientInformation.address_line_2; \
				"libelle"; "Courrier envoyé le "+String:C10(Date:C102($mailing_o.eventDetail.extraDetail.sendingInformation.creation_date))+" à "+Time string:C180(Time:C179($mailing_o.eventDetail.extraDetail.sendingInformation.creation_date))+" pour "+$mailing_o.eventDetail.extraDetail.recipientInformation.address_line_2))
		End for each 
		
		cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; $sendind_c; "property"; "libelle"; "selectSubTitle"; "Merci de sélectionner un envoi"; "title"; "Choix de l'envoi :"))
		
		If (selectValue_t="")
			return 
		End if 
		
		$body_o:=New object:C1471
		$body_o.modifyURL:=New object:C1471("sendingPK"; $sendind_c[$sendind_c.indices("libelle = :1"; selectValue_t)[0]].id)
		
		$retour_o:=$MACourrier_cs.request("simple"; "sendingDetail"; $body_o)
		ALERT:C41(JSON Stringify:C1217($retour_o; *))
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 