If (sceneAction_at{sceneAction_at}="Changement de scénario")
	OBJECT SET ENABLED:C1123(*; "sceneDetailScenarioSuivant"; True:C214)
	OBJECT SET ENABLED:C1123(*; "sceneDetailDeleteScenarioSuivant"; True:C214)
Else 
	OBJECT SET ENABLED:C1123(*; "sceneDetailScenarioSuivant"; False:C215)
	OBJECT SET ENABLED:C1123(*; "sceneDetailDeleteScenarioSuivant"; False:C215)
	
	If (Form:C1466.sceneDetail.scenarioSuivantID#"")  // On reset ce champ là si besoin
		Form:C1466.sceneDetail.scenarioSuivantID:=""
		
		scenarioSuivantNom_at:=0
		scenarioSuivantNom_at{0}:="Sélection du scénario suivant"
	End if 
	
End if 