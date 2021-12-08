C_OBJECT:C1216($config_o)

$config_o:=New object:C1471("entree"; 1; "donnee"; Form:C1466)

cwToolWindowsForm("gestionPersonne"; "center"; $config_o)

OBJECT SET ENABLED:C1123(*; "scenarioDetailBoutonAppliquer"; False:C215)

If (OK=1)
	Form:C1466.scenarioSelectionPossiblePersonne:=entitySelection_o
	
	If (Form:C1466.scenarioSelectionPossiblePersonne.length>0)
		OBJECT SET ENABLED:C1123(*; "scenarioDetailBoutonAppliquer"; True:C214)
	End if 
	
	Form:C1466.updateStringScenarioForm(1)
End if 