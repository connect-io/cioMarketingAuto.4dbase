var $texte_t : Text
var $version_o; $statut_o : Object

var $parameter_e; $parameter_es : Object

Case of 
	: (Form event code:C388=On Load:K2:1)
		var WParea : Object
		
		WParea:=WP New:C1317()
		
		Form:C1466.voirVariable:=False:C215
		
		Case of 
			: (Form:C1466.entree=1)  // Envoi d'un mailing à la table [Personne]
				Form:C1466.imageSave:=Storage:C1525.automation.image["logout"]
			: (Form:C1466.entree=2)  // Edition action scène
				Form:C1466.imageSave:=Storage:C1525.automation.image["save"]
				
				OBJECT SET COORDINATES:C1248(*; "sauvegarderDocument"; 801; 59; 841; 99)
				
				OBJECT SET TITLE:C194(*; "Texte6"; "Sauvegarder et fermer")
				OBJECT SET COORDINATES:C1248(*; "Texte6"; 749; 101; 894; 116)
				
				OBJECT SET COORDINATES:C1248(*; "Rectangle"; 27; 53; 915; 117)
				
				$version_o:=Form:C1466.donnee.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.donnee.sceneTypeSelected)].version.query("titre = :1"; Form:C1466.donnee.sceneVersionSelected)[0]
				
				If ($version_o.externalReference#Null:C1517)
					$parameter_e:=ds:C1482[$version_o.externalReference.table].get($version_o.externalReference.ID)
					WParea:=WP New:C1317($parameter_e.value_b)
					
					Form:C1466.externalReference:=OB Copy:C1225($version_o.externalReference)
					Form:C1466.externalReference.value:=$parameter_e[Form:C1466.externalReference.field]
					
					OBJECT SET VISIBLE:C603(*; "externalReference"; True:C214)
					OBJECT SET VISIBLE:C603(*; "sceneDetailVersionDeleteExternalReference"; True:C214)
					
					OBJECT SET VALUE:C1742("externalReference"; "Le document 4D write Pro pointe  actuellement sur la table « "+String:C10(Form:C1466.externalReference.table)+" » et dont le nom est « "+String:C10($parameter_e[Form:C1466.externalReference.field])+" »")
				Else 
					WParea:=WP New:C1317($version_o.contenu4WP)
				End if 
				
			: (Form:C1466.entree=3)  // Edition notification Email
				Form:C1466.imageSave:=Storage:C1525.automation.image["save"]
				
				OBJECT SET COORDINATES:C1248(*; "sauvegarderDocument"; 801; 59; 841; 99)
				
				OBJECT SET TITLE:C194(*; "Texte6"; "Sauvegarder et fermer")
				OBJECT SET COORDINATES:C1248(*; "Texte6"; 749; 101; 894; 116)
				
				OBJECT SET COORDINATES:C1248(*; "Rectangle"; 27; 53; 915; 117)
				
				If (Form:C1466.donnee.notif.externalReference#Null:C1517)
					$parameter_e:=ds:C1482[Form:C1466.donnee.notif.externalReference.table].get(Form:C1466.donnee.notif.externalReference.ID)
					WParea:=WP New:C1317($parameter_e.value_b)
					
					Form:C1466.externalReference:=OB Copy:C1225(Form:C1466.donnee.notif.externalReference)
					
					OBJECT SET VISIBLE:C603(*; "externalReference"; True:C214)
					OBJECT SET VISIBLE:C603(*; "sceneDetailVersionDeleteExternalReference"; True:C214)
					
					OBJECT SET VALUE:C1742("externalReference"; "Le document 4D write Pro pointe  actuellement sur la table « "+String:C10(Form:C1466.externalReference.table)+" » et dont le nom est « "+String:C10($parameter_e[Form:C1466.donnee.notif.externalReference.field])+" »")
				Else 
					WParea:=WP New:C1317(Form:C1466.donnee.notif.contenu4WP)
				End if 
				
			: (Form:C1466.entree=4)  // Edition pièce-jointe Email
				Form:C1466.imageSave:=Storage:C1525.automation.image["save"]
				
				OBJECT SET COORDINATES:C1248(*; "sauvegarderDocument"; 801; 59; 841; 99)
				
				OBJECT SET TITLE:C194(*; "Texte6"; "Sauvegarder et fermer")
				OBJECT SET COORDINATES:C1248(*; "Texte6"; 749; 101; 894; 116)
				
				OBJECT SET COORDINATES:C1248(*; "Rectangle"; 27; 53; 915; 117)
				
				If (Form:C1466.donnee.pieceJointe.externalReference#Null:C1517)
					$parameter_e:=ds:C1482[Form:C1466.donnee.pieceJointe.externalReference.table].get(Form:C1466.donnee.pieceJointe.externalReference.ID)
					WParea:=WP New:C1317($parameter_e.value_b)
					
					Form:C1466.externalReference:=OB Copy:C1225(Form:C1466.donnee.pieceJointe.externalReference)
					
					OBJECT SET VISIBLE:C603(*; "externalReference"; True:C214)
					OBJECT SET VISIBLE:C603(*; "sceneDetailVersionDeleteExternalReference"; True:C214)
					
					OBJECT SET VALUE:C1742("externalReference"; "Le document 4D write Pro pointe  actuellement sur la table « "+String:C10(Form:C1466.externalReference.table)+" » et dont le nom est « "+String:C10($parameter_e[Form:C1466.donnee.pieceJointe.externalReference.field])+" »")
				Else 
					WParea:=WP New:C1317(Form:C1466.donnee.pieceJointe.contenu4WP)
				End if 
				
		End case 
		
	: (Form event code:C388=On Close Box:K2:21)
		
		Case of 
			: (Form:C1466.entree=2)  // Edition action scène
				$texte_t:=WP Get text:C1575(WParea; wk expressions as source:K81:256)
				
				If ($texte_t#"")
					CONFIRM:C162("Voulez-vous sauvegarder le document en cours ?"; "Oui"; "Non")
					
					If (OK=1)
						$version_o:=Form:C1466.donnee.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.donnee.sceneTypeSelected)].version.query("titre = :1"; Form:C1466.donnee.sceneVersionSelected)[0]
						$version_o.contenu4WP:=WParea
						
						If (Form:C1466.externalReference#Null:C1517)
							$version_o.externalReference:=OB Copy:C1225(Form:C1466.externalReference)
						End if 
						
						$version_o.modifierLe:=cs:C1710.MATimeStamp.me.get(Current date:C33; Current time:C178)
						$version_o.modifierPar:=Current user:C182
						
						$statut_o:=Form:C1466.donnee.sceneDetail.save()
						OB REMOVE:C1226(Form:C1466; "externalReference")
						//Form.donnee.saveFileActionScene(Form.donnee.scenarioDetail.ID; Form.donnee.sceneDetail.ID; WParea; "4wp"; Faux)
					End if 
					
				End if 
				
			: (Form:C1466.entree=3)  // Edition notification Email
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
				
			: (Form:C1466.entree=4)  // Edition pièce-jointe Email
				$texte_t:=WP Get text:C1575(WParea; wk expressions as source:K81:256)
				
				If ($texte_t#"")
					CONFIRM:C162("Voulez-vous sauvegarder le document en cours ?"; "Oui"; "Non")
					
					If (OK=1)
						Form:C1466.donnee.pieceJointe.contenu4WP:=WParea
						
						If (Form:C1466.externalReference#Null:C1517)
							Form:C1466.donnee.pieceJointe.externalReference:=OB Copy:C1225(Form:C1466.externalReference)
						End if 
						
					End if 
					
				End if 
				
		End case 
		
End case 