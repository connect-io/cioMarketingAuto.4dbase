var $template_t : Text

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(templateListe_at; 0)
		
		templateListe_at{0}:="Merci de sélectionner un template"
	: (Form event code:C388=On Data Change:K2:15)
		$template_t:=templateListe_at{templateListe_at}
End case 