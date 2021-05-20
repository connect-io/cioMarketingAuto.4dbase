If (Form:C1466.ScenarioEnCoursSelectedElement#Null:C1517)
	var $nom_t : Text
	var $statut_o : Object
	
	$nom_t:=Form:C1466.ScenarioEnCoursSelectedElement[0].OneCaScenario.nom
	
	CONFIRM:C162("Souhaitez-vous vraiment enlever "+Form:C1466.nom+" "+Form:C1466.prenom+" du scénario "+$nom_t+" ?"; "Oui"; "Non")
	
	If (OK=1)
		$statut_o:=Form:C1466.ScenarioEnCoursSelectedElement[0].drop()
		
		If ($statut_o.success=True:C214)
			ALERT:C41("Le scénario "+$nom_t+" a bien été supprimé")
		Else 
			ALERT:C41("Problème lors de la suppression du scénario "+$nom_t+", merci de ré-essayer")
		End if 
		
		Form:C1466.scenarioEnCours:=Form:C1466.personne.AllCaPersonneScenario
		
		If (Form:C1466.scenarioSelected#Null:C1517)
			Form:C1466.scenarioSelected:=Null:C1517  // Scénario sélectionné
			
			Form:C1466.scenarioPersonneEnCours:=Null:C1517  // Chaine qui indique le nombre de personne auquel le scénario est appliqué
		End if 
		
		OBJECT SET ENABLED:C1123(*; "detailPersonneScenario@"; False:C215)
	End if 
	
Else 
	ALERT:C41("Merci de sélectionner un scénario")
End if 