var $data_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.notif.pieceJointe=Null:C1517)
			Form:C1466.notif.pieceJointe:=New object:C1471("contenu4WP"; WP New:C1317)
		End if 
		
		$data_o:=New object:C1471("pieceJointe"; Form:C1466.notif.pieceJointe)
		cwToolWindowsForm("gestionDocument"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); New object:C1471("entree"; 4; "donnee"; $data_o))
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 