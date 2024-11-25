var $texte_t : Text
var $version_o; $statut_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		Case of 
			: (Form:C1466.entree=2)  // Edition action scène
				$texte_t:=WP Get text:C1575(WParea; wk expressions as source:K81:256)
				
				If ($texte_t#"")
					CONFIRM:C162("Voulez-vous sauvegarder le document en cours ?"; "Oui"; "Non")
					
					If (OK=1)
						//Form.donnee.saveFileActionScene(Form.donnee.scenarioDetail.ID; Form.donnee.sceneDetail.ID; WParea; "4wp"; Faux)
						
						//Form.donnee.sceneDetail.paramAction.modelePerso:=Vrai
						//Form.sceneDetail.paramAction.modele4WP:=WParea
						$version_o:=Form:C1466.donnee.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.donnee.sceneTypeSelected)].version.query("titre = :1"; Form:C1466.donnee.sceneVersionSelected)[0]
						$version_o.contenu4WP:=WParea
						
						If (Form:C1466.externalReference#Null:C1517)
							$version_o.externalReference:=OB Copy:C1225(Form:C1466.externalReference)
						End if 
						
						$version_o.modifierLe:=cs:C1710.MATimeStamp.me.get(Current date:C33; Current time:C178)
						$version_o.modifierPar:=Current user:C182
						
						$statut_o:=Form:C1466.donnee.sceneDetail.save()
						OB REMOVE:C1226(Form:C1466; "externalReference")
					End if 
					
				End if 
				
			: (Form:C1466.entree=3)  // Edition document notification email
				$texte_t:=WP Get text:C1575(WParea; wk expressions as source:K81:256)
				
				If ($texte_t#"")
					CONFIRM:C162("Voulez-vous sauvegarder le document en cours ?"; "Oui"; "Non")
					
					If (OK=1)
						Form:C1466.donnee.notif.contenu4WP:=WParea
						
						If (Form:C1466.externalReference#Null:C1517)
							Form:C1466.donnee.notif.externalReference:=OB Copy:C1225(Form:C1466.externalReference)
						End if 
						
					End if 
					
				End if 
				
		End case 
		
		ACCEPT:C269
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 