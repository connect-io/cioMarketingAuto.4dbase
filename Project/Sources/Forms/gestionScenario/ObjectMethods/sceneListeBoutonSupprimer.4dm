If (Form:C1466.scenarioDetail#Null:C1517) & (Form:C1466.SceneCurrentElement#Null:C1517)
	var $scenarioID_t : Text
	var $retour_o; $class_o : Object
	
	$scenarioID_t:=Form:C1466.sceneDetail.scenarioID
	$retour_o:=Form:C1466.sceneDetail.drop()
	
	If ($retour_o.success=False:C215)
		// Avertir l'utilisateur
	Else 
		$class_o:=cmaToolGetClass("MAScene").new()
		$class_o.reArrangeNumOrdre($scenarioID_t)
		
		Form:C1466.SceneSelectedElement:=Null:C1517
	End if 
	
	$retour_o:=Form:C1466.scenarioDetail.reload()
	
	Form:C1466.scene:=Form:C1466.scenarioDetail.AllCaScene.orderBy("numOrdre asc")
	Form:C1466.sceneDetail:=Null:C1517
End if 