Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $commentaire_t : Text
		var $colonne_i; $ligne_i : Integer
		var $class_o : Object
		
		LISTBOX GET CELL POSITION:C971(*; "List Box2"; $colonne_i; $ligne_i)
		
		If ($ligne_i>0)
			// Instanciation de la class
			$class_o:=cmaToolGetClass("MAMailjet").new()
			
			If (String:C10(Form:C1466.envoiMailEnCours[$ligne_i-1].messageID)#"")
				$commentaire_t:=$class_o.getMessageHistoryDetail(Form:C1466.envoiMailEnCours[$ligne_i-1].messageID)
			Else 
				$commentaire_t:="ID du message inconnu, impossible d'obtenir l'historique"
			End if 
			
			ALERT:C41($commentaire_t)
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 