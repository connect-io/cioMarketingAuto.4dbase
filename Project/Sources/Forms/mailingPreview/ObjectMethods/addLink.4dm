var $lien_t; $texte_t : Text
var $plageSelect_o : Object
var $lien_c : Collection

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$plageSelect_o:=WP Selection range:C1340(*; "WParea")
		$lien_c:=WP Get links:C1643($plageSelect_o)
		
		If ($lien_c.length>0)  // Il y a un lien
			
			WP RESET ATTRIBUTES:C1344($plageSelect_o; wk link url:K81:202)
		Else 
			$lien_t:=Request:C163("Quel lien voulez-vous insérer ?"; "https://www.google.fr"; "Valider"; "Annuler")
			
			If ($lien_t#"")
				If ($lien_t="http@") | ($lien_t="mailto:@") | ($lien_t="[[UNSUB_LINK_FR]]")
					
					WP SET LINK:C1642($plageSelect_o; New object:C1471("url"; $lien_t))
				Else 
					
					ALERT:C41("Le lien n'est pas au format \"http://nomDuSite.fr\"")
					
				End if 
			End if 
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
		
End case 