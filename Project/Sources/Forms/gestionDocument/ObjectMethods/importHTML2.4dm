var $texte_t : Text
var $refDoc_h : Time
var $fichier_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		CONFIRM:C162("Voulez-vous insérer le contenue par défaut d'une page HTML5 ?"; "Oui"; "Non")
		
		If (OK=1)
			$fichier_o:=File:C1566(Get 4D folder:C485(Current resources folder:K5:16; *)+"cioMarketingAutomation"+Folder separator:K24:12+"html"+Folder separator:K24:12+"structure.html"; fk platform path:K87:2)
			
			If ($fichier_o.exists=True:C214)
				$texte_t:=$fichier_o.getText("UTF-8"; Document with native format:K24:19)
			Else 
				ALERT:C41("Impossible de récupérer le fichier de structure HTML")
			End if 
			
		Else 
			$refDoc_h:=Open document:C264(""; "HTML")
			
			If (OK=1)
				$texte_t:=Document to text:C1236(Document; "UTF-8"; Document with native format:K24:19)
				
				CLOSE DOCUMENT:C267($refDoc_h)
			End if 
			
		End if 
		
		If ($texte_t#"")
			WP SET TEXT:C1574(WParea; $texte_t; wk append:K81:179)
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 