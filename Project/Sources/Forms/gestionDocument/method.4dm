Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		var $image_i : Picture
		var $fichier_o; $version_o : Object
		
		var WParea : Object
		
		WParea:=WP New:C1317()
		
		Form:C1466.voirVariable:=False:C215
		
		Case of 
			: (Form:C1466.entree=1)  // Envoi d'un mailing à la table [Personne]
			: (Form:C1466.entree=2)  // Edition action scène
				$version_o:=Form:C1466.donnee.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.donnee.sceneTypeSelected)].version.query("titre = :1"; Form:C1466.donnee.sceneVersionSelected)[0]
				WParea:=WP New:C1317($version_o.contenu4WP)
		End case 
		
	: (Form event code:C388=Sur case de fermeture:K2:21)
		var $texte_t : Text
		var $version_o : Object
		
		Case of 
			: (Form:C1466.entree=2)  // Edition action scène
				$texte_t:=WP Get text:C1575(WParea; wk expressions as source:K81:256)
				
				If ($texte_t#"")
					CONFIRM:C162("Voulez-vous sauvegarder le document en cours ?"; "Oui"; "Non")
					
					If (OK=1)
						$version_o:=Form:C1466.donnee.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.donnee.sceneTypeSelected)].version.query("titre = :1"; Form:C1466.donnee.sceneVersionSelected)[0]
						
						$version_o.contenu4WP:=WParea
						
						$version_o.modifierLe:=cmaTimestamp
						$version_o.modifierPar:=Current user:C182
						
						Form:C1466.donnee.sceneDetail.save()
						//Form.donnee.saveFileActionScene(Form.donnee.scenarioDetail.ID; Form.donnee.sceneDetail.ID; WParea; "4wp"; Faux)
					End if 
					
				End if 
				
		End case 
		
End case 