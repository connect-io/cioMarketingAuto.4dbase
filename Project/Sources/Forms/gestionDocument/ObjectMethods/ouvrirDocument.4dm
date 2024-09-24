var $refDoc_h : Time
var $parameter_es : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		CONFIRM:C162("Voulez-vous ouvrir un modèle stocké dans le logiciel ?"; "Oui"; "Non")
		
		If (OK=1)
			$parameter_es:=ds:C1482["Parameter"].query("type = :1"; "courrier")
			cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; $parameter_es.toCollection(); "property"; "wording"; "selectSubTitle"; "Merci de sélectionner un document"; "title"; "Choix du document :"))
			
			If (selectValue_t#"")
				$parameter_es:=$parameter_es.query("wording = :1"; selectValue_t)
				WParea:=WP New:C1317($parameter_es.first().value_b)
				
				Form:C1466.externalReference:=New object:C1471("table"; "Parameter"; "field"; "wording"; "value"; selectValue_t; "ID"; $parameter_es.first().getKey())
				
				OBJECT SET VISIBLE:C603(*; "externalReference"; True:C214)
				OBJECT SET VISIBLE:C603(*; "sceneDetailVersionDeleteExternalReference"; True:C214)
				
				OBJECT SET VALUE:C1742("externalReference"; "Le document 4D write Pro pointe  actuellement sur la table « "+String:C10(Form:C1466.externalReference.table)+" » et dont le nom est « "+String:C10(Form:C1466.externalReference.value)+" »")
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