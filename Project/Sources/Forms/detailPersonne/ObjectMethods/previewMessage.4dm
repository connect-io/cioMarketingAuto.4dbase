var $colonne_i; $ligne_i : Integer

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		LISTBOX GET CELL POSITION:C971(*; "List Box2"; $colonne_i; $ligne_i)
		
		If ($ligne_i>0)
			
			If (Form:C1466.envoiMailEnCours[$ligne_i-1].eventDetail.contenu4WP#Null:C1517)
				cwToolWindowsForm("apercuDocument"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); New object:C1471("entree"; 3; "donnee"; Form:C1466.envoiMailEnCours[$ligne_i-1].eventDetail))
			Else 
				ALERT:C41("Impossible de prévisualiser le document, le contenu du mailing n'a pas été sauvegardé")
			End if 
			
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 