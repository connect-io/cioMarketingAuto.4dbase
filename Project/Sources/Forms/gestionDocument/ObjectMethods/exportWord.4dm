Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $path_t : Text
		
		CONFIRM:C162("Voulez-vous exporter le document vers le format 4d word (.docx) ?"; "Oui"; "Non")
		
		If (OK=1)
			$path_t:=System folder:C487(Bureau:K41:16)
			$path_t:=Select document:C905($path_t; ".docx"; " title"; Saisie nom de fichier:K24:17)
			
			If ($path_t#"")
				WP EXPORT DOCUMENT:C1337(WParea; document; wk docx:K81:277)
			Else 
				ALERT:C41("Une erreur est survenue, impossible d'exporter le document")
			End if 
			
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 