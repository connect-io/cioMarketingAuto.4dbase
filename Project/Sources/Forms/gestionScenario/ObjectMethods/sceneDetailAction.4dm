If (sceneAction_at{sceneAction_at}="Changement de scénario")
	OBJECT SET ENABLED:C1123(*; "sceneDetailScenarioSuivant"; True:C214)
	OBJECT SET ENABLED:C1123(*; "sceneDetailDeleteScenarioSuivant"; True:C214)
	
	If (Form:C1466.sceneDetail.sceneSuivanteID#0)  // On reset le champ [CaScene]sceneSuivanteID
		Form:C1466.sceneDetail.sceneSuivanteID:=0
		
		sceneSuivante_at:=0
		sceneSuivante_at{0}:="Sélection de la scène suivante"
	End if 
	
	// Et on rend innaccessible visuellement les éléments en rapport avec ce champ là
	Form:C1466.sceneSuivanteDelai:="0"  // Chaine qui indique le délai avec la scène suivante du scénario sélectionné
	
	OBJECT SET ENABLED:C1123(*; "sceneDetailSceneSuivanteID"; False:C215)
	OBJECT SET ENABLED:C1123(*; "sceneDetailDeleteSceneSuivante"; False:C215)
	
	OBJECT SET ENABLED:C1123(*; "sceneDetailDelai@"; False:C215)
Else 
	OBJECT SET ENABLED:C1123(*; "sceneDetailScenarioSuivant"; False:C215)
	OBJECT SET ENABLED:C1123(*; "sceneDetailDeleteScenarioSuivant"; False:C215)
	
	If (Form:C1466.sceneDetail.scenarioSuivantID#"00000000000000000000000000000000")  // On reset le champ [CaScene]scenarioSuivantID
		Form:C1466.sceneDetail.scenarioSuivantID:="00000000000000000000000000000000"
		
		scenarioSuivantNom_at:=0
		scenarioSuivantNom_at{0}:="Sélection du scénario suivant"
	End if 
	
	// Si l'action n'est pas "Changement de scénario" on rend accessible tout le temps les élément sen rapport avec le champ [CaScene]sceneSuivanteID
	OBJECT SET ENABLED:C1123(*; "sceneDetailSceneSuivanteID"; True:C214)
	OBJECT SET ENABLED:C1123(*; "sceneDetailDeleteSceneSuivante"; True:C214)
	
	OBJECT SET ENABLED:C1123(*; "sceneDetailDelai@"; True:C214)
End if 