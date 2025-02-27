var $posDebut_el; $posFin_el : Integer
var $elementSelected_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (versionList_at>0)
			$elementSelected_o:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; versionList_at{versionList_at})[0]
			cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; New collection:C1472(New object:C1471("action"; "lister"); New object:C1471("action"; "créer"); New object:C1471("action"; "éditer"); New object:C1471("action"; "supprimer")); \
				"property"; "action"; "selectSubTitle"; "Merci de sélectionner une action"; "title"; "Choix de l'action :"))
			
			If (selectValue_t#"")
				
				Case of 
					: (selectValue_t="lister")
					: (selectValue_t="créer")
						GET HIGHLIGHT:C209(*; "modeleObjetEmail"; $posDebut_el; $posFin_el)
					: (selectValue_t="éditer")
					: (selectValue_t="supprimer")
				End case 
				
			End if 
			
		Else 
			ALERT:C41("Merci de sélectionner une version avant de pouvoir l'éditer")
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 