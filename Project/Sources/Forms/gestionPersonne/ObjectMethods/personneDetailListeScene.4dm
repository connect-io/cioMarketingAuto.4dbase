If (Form event code:C388=Sur clic:K2:4) & (Form:C1466.SceneCurrentElement#Null:C1517)
	var $idPersonneScenario_t : Text
	var $table_o; $autreTable_o : Object
	
	$table_o:=Form:C1466.SceneCurrentElement  // Gestion de la scène sélectionnée
	
	// Il faut charger tous les évènements de la personne sur lequel l'utilisateur est
	$autreTable_o:=$table_o.AllCaScenarioEvent.OneCaPersonneScenario.query("personneID is :1"; Form:C1466.personneDetail.UID)
	
	If ($autreTable_o.length=1)
		$idPersonneScenario_t:=$autreTable_o[0].ID
	End if 
	
	Form:C1466.scenarioEvent:=$table_o.AllCaScenarioEvent.query("personneScenarioID = :1"; $idPersonneScenario_t)
	
	OBJECT SET ENABLED:C1123(*; "personneDetailScene@"; True:C214)
Else 
	
	If (Form:C1466.scenarioEvent#Null:C1517)
		Form:C1466.scenarioEvent:=Null:C1517
	End if 
	
	OBJECT SET ENABLED:C1123(*; "personneDetailScene@"; False:C215)
End if 