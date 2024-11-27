var $table_o : Object

If (Form event code:C388=On Clicked:K2:4) & (Form:C1466.ScenarioPersonneCurrentElement#Null:C1517)
	$table_o:=Form:C1466.ScenarioPersonneCurrentElement  // Gestion du scènario de la personne sélectionné
	
	Form:C1466.scene:=$table_o.OneCaScenario.AllCaScene.orderBy("numOrdre asc")  // Gestion des scènes du scénario de la personne sélectionné
	Form:C1466.prochainCheck:="Prochain passage le "+cs:C1710.MATimeStamp.me.read("date"; $table_o.tsProchainCheck)+" à "+cs:C1710.MATimeStamp.me.read("hour"; $table_o.tsProchainCheck)
	
	OBJECT SET ENABLED:C1123(*; "personneDetailListeScene"; True:C214)
Else 
	Form:C1466.prochainCheck:=Null:C1517
	
	If (Form:C1466.scene#Null:C1517)
		Form:C1466.scene:=Null:C1517
	End if 
	
	OBJECT SET ENABLED:C1123(*; "personneDetailListeScene"; False:C215)
End if 

Form:C1466.scenarioEvent:=Null:C1517  // Dans tous les cas je dois réinitialiser mon entitySelection des logs des scènes