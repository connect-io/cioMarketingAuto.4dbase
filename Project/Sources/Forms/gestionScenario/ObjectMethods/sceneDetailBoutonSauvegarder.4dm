If (Form:C1466.SceneCurrentElement#Null:C1517) & (Form:C1466.ScenarioCurrentElement#Null:C1517)
	var $pos_el : Integer
	var $continue_b : Boolean
	var $retour_o : Object
	
	$continue_b:=True:C214
	
	Case of 
		: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="minute(s)")
			Form:C1466.sceneDetail.tsAttente:=Num:C11(Form:C1466.sceneSuivanteDelai)*60*1
		: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="jour(s)")
			Form:C1466.sceneDetail.tsAttente:=Num:C11(Form:C1466.sceneSuivanteDelai)*86400*1
		: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="semaine(s)")
			Form:C1466.sceneDetail.tsAttente:=Num:C11(Form:C1466.sceneSuivanteDelai)*86400*7
		: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="mois(s)")
			Form:C1466.sceneDetail.tsAttente:=Num:C11(Form:C1466.sceneSuivanteDelai)*86400*30
		: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="année(s)")
			Form:C1466.sceneDetail.tsAttente:=Num:C11(Form:C1466.sceneSuivanteDelai)*86400*365
	End case 
	
	If (sceneSuivante_at>0)
		Form:C1466.sceneDetail.sceneSuivanteID:=sceneSuivante_ai{sceneSuivante_at}
	Else 
		Form:C1466.sceneSuivanteDelai:="0"
		
		Form:C1466.sceneDetail.tsAttente:=0
	End if 
	
	If (sceneAction_at>0)
		Form:C1466.sceneDetail.action:=sceneAction_at{sceneAction_at}
	End if 
	
	If (Form:C1466.sceneDetail.action="Changement de scénario")  // Si l'action de la scène est un changement de scénario
		
		If (scenarioSuivantNom_at>0)
			Form:C1466.sceneDetail.scenarioSuivantID:=scenarioSuivantID_at{scenarioSuivantNom_at}
		Else   // Aucun scénario suivant n'a été indiqué...
			$continue_b:=False:C215
		End if 
		
	End if 
	
	If ($continue_b=True:C214)
		
		If (Form:C1466.sceneDetail.conditionSaut.elements#Null:C1517) & (Num:C11(Form:C1466.sceneDetail.conditionSaut.sceneSautID)=0)
			ALERT:C41("Aucune scène n'a été sélectionnée dans les conditions de saut, merci de sélectionner une scène OU supprimer toutes les conditions de saut !")
		Else 
			$retour_o:=Form:C1466.sceneDetail.save()
			
			If ($retour_o.success=True:C214)
				ALERT:C41("La scène a bien été sauvegardée")
			End if 
			
			// On rafraîchi les entités
			Form:C1466.sceneDetail.reload()
			Form:C1466.scenarioDetail.reload()
			
			Form:C1466.scene:=Form:C1466.scenarioDetail.AllCaScene.orderBy("numOrdre asc")
			
			LISTBOX SELECT ROW:C912(*; "sceneListe"; Form:C1466.SceneCurrentPosition)
		End if 
		
	Else 
		ALERT:C41("Impossible de sauvegarder la scène, un scénario suivant est obligatoire !")
	End if 
	
Else 
	ALERT:C41("Impossible de sauvegarder, aucune scène de sélectionner !")
End if 