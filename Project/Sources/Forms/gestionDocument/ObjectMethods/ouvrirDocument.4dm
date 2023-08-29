var $refDoc_h : Time
var $parameter_es : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		CONFIRM:C162("Voulez-vous ouvrir un modèle stocké dans le logiciel ?"; "Oui"; "Non")
		
		If (OK=1)
			$parameter_es:=ds:C1482.Parameter.query("type = :1"; "courrier")
			cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; $parameter_es.toCollection(); "property"; "wording"; "selectSubTitle"; "Merci de sélectionner un document"; "title"; "Choix du document :"))
			
			If (selectValue_t#"")
				$parameter_es:=$parameter_es.query("wording = :1"; selectValue_t)
				WParea:=WP New:C1317($parameter_es.first().value_b)
			End if 
			
		Else 
			$refDoc_h:=Open document:C264(""; "4W7;4WP")  // Le fichier est ouvert
			
			If (OK=1)
				WParea:=WP Import document:C1318(Document)
				CLOSE DOCUMENT:C267($refDoc_h)
			End if 
			
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 