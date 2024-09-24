If (Form event code:C388=On Load:K2:1)
	ARRAY TEXT:C222(expediteurListForNotif_at; 0)
	
	expediteurListForNotif_at{0}:="Merci de sélectionner un expéditeur"
	expediteurListForNotif_at:=0
	
	If (cwStorage.eMail.transporter.query("type = :1"; "smtp").length>0)
		COLLECTION TO ARRAY:C1562(cwStorage.eMail.transporter.query("type = :1"; "smtp"); expediteurListForNotif_at; "name")
	End if 
	
	If (String:C10(Form:C1466.notif.expediteur)#"")
		$pos_el:=Find in array:C230(expediteurListForNotif_at; String:C10(Form:C1466.notif.expediteur))
		
		If ($pos_el>0)
			expediteurListForNotif_at:=$pos_el
			expediteurListForNotif_at{expediteurListForNotif_at}:=String:C10(Form:C1466.notif.expediteur)
		End if 
		
	End if 
	
End if 