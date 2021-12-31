var $nbPersonne_el : Integer

$nbPersonne_el:=Form:C1466.scenarioSelectionPossiblePersonne.length

CONFIRM:C162("Le scénario va être appliqué à "+String:C10($nbPersonne_el)+" personne(s), voulez-vous vraiment continuer ?"; "Oui"; "Non")

If (OK=1)
	Form:C1466.applyScenarioToPerson()
	
	ALERT:C41("Le scénario a bien été appliqué à "+String:C10($nbPersonne_el)+" personne(s)")
	OBJECT SET ENABLED:C1123(*; "scenarioDetailBoutonAppliquer"; False:C215)
End if 