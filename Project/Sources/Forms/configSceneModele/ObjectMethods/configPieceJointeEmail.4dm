var $elementSelected_o; $data_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$elementSelected_o:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; versionList_at{versionList_at})[0]
		
		If ($elementSelected_o.pieceJointe=Null:C1517)
			$elementSelected_o.pieceJointe:=New object:C1471("contenu4WP"; WP New:C1317)
		End if 
		
		$data_o:=New object:C1471("pieceJointe"; $elementSelected_o.pieceJointe)
		cwToolWindowsForm("gestionDocument"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); New object:C1471("entree"; 4; "donnee"; $data_o))
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 