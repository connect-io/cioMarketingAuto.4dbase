var $commentaire_t : Text
var $colonne_i; $ligne_i : Integer
var $class_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		LISTBOX GET CELL POSITION:C971(*; "List Box2"; $colonne_i; $ligne_i)
		
		If ($ligne_i>0)
			
			If (Form:C1466.envoiMailEnCours[$ligne_i-1].eventDetail.type#"Email")
				SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217(Form:C1466.envoiMailEnCours[$ligne_i-1]))
				ALERT:C41("Le contenu de l'historique a été fixé dans le presse-papier")
				
				return 
			End if 
			
			$class_o:=cmaToolGetClass("MAMailjet").new()
			
			If (String:C10(Form:C1466.envoiMailEnCours[$ligne_i-1].eventDetail.messageID)#"")
				$commentaire_t:=$class_o.getMessageHistoryDetail(Form:C1466.envoiMailEnCours[$ligne_i-1].eventDetail.messageID)
			Else 
				$commentaire_t:="ID du message inconnu, impossible d'obtenir l'historique"
			End if 
			
			ALERT:C41($commentaire_t)
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 