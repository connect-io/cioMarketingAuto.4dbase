var $elementSelected_o : Object
var $prestataire_c : Collection

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (expediteurList_at{expediteurList_at}#"Maileva")
			ALERT:C41("L'expéditeur \""+expediteurList_at{expediteurList_at}+"\" ne nécessite pas de configuration d'envoi")
			return 
		End if 
		
		$elementSelected_o:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; versionList_at{versionList_at})[0]
		
		If ($elementSelected_o.sendingDetail=Null:C1517)
			$prestataire_c:=Storage:C1525.courrier.config.prestataire.query("nom = :1"; expediteurList_at{expediteurList_at})
			
			If ($prestataire_c.length=1)
				$elementSelected_o.sendingDetail:=OB Copy:C1225($prestataire_c[0].sendingDetailDefault)
			Else 
				$elementSelected_o.sendingDetail:=New object:C1471("sendingName"; ""; "sender_address_line_1"; ""; "sender_address_line_2"; ""; \
					"sender_address_line_3"; ""; "sender_address_line_4"; ""; "sender_address_line_5"; ""; "sender_address_line_6"; ""; "sender_country_code"; "FR"; \
					"print_sender_address"; False:C215; "duplex_printing"; False:C215; "color_printing"; True:C214; "treat_undelivered_mail"; False:C215; \
					"recommendedShipping"; False:C215; "acknowledgement_of_receipt"; False:C215; "postage_type"; "ECONOMIC"; "envelope_windows_type"; "SIMPLE"; "notification_email"; "")
			End if 
			
		End if 
		
		cwToolWindowsForm("config"+expediteurList_at{expediteurList_at}+"Sending"; "center"; $elementSelected_o.sendingDetail)
		OB REMOVE:C1226($elementSelected_o.sendingDetail; "delaiCourrier")
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 