var $elementSelected_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$elementSelected_o:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; versionList_at{versionList_at})[0]
		
		If ($elementSelected_o.notif=Null:C1517)
			$elementSelected_o.notif:=New object:C1471("subject"; ""; "expediteur"; ""; "contenu4WP"; WP New:C1317)
		End if 
		
		cwToolWindowsForm("configNotificationEmail"; "center"; New object:C1471("notif"; $elementSelected_o.notif))
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 