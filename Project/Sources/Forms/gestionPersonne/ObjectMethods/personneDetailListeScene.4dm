var $table_o; $autreTable_o : Object

If (Form event code:C388=On Clicked:K2:4) & (Form:C1466.SceneCurrentElement#Null:C1517)
	$table_o:=Form:C1466.SceneCurrentElement  // Gestion de la scène sélectionnée
	
	Form:C1466.scenarioEvent:=$table_o.AllCaScenarioEvent.query("personneScenarioID = :1"; Form:C1466.ScenarioPersonneCurrentElement.ID)
	OBJECT SET ENABLED:C1123(*; "personneDetailScene@"; True:C214)
Else 
	
	If (Form:C1466.scenarioEvent#Null:C1517)
		Form:C1466.scenarioEvent:=Null:C1517
	End if 
	
	OBJECT SET ENABLED:C1123(*; "personneDetailScene@"; False:C215)
End if 