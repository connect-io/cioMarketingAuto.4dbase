var $collection_c : Collection

Case of 
	: (Form event code:C388=On Load:K2:1)
		var toggle_i; toggleOn_i; toggleOff_i : Picture
		
		ARRAY TEXT:C222(conditionActionList_at; 0)
		
		If (Storage:C1525.automation.sceneConditionAction#Null:C1517)
			$collection_c:=Storage:C1525.automation.sceneConditionAction.elements.orderBy("titre asc")
			
			If ($collection_c.length>0)
				COLLECTION TO ARRAY:C1562($collection_c; conditionActionList_at; "titre")
			End if 
			
		End if 
		
		conditionActionList_at{0}:="Sélection d'une condition d'action"
		
		toggle_i:=Storage:C1525.automation.image["toggle"]
		
		toggleOn_i:=Storage:C1525.automation.image["toggle-on"]
		toggleOff_i:=Storage:C1525.automation.image["toggle-off"]
		
		Form:C1466.sceneClass:=cmaToolGetClass("MAScene").new()
		Form:C1466.sceneClass.loadConditionActionDisplay(Form:C1466.sceneDetail)
		
		// On désactive les éléments qui servent à générer visuellement les conditions d'action
		OBJECT SET ENABLED:C1123(*; "imageBooleen"; False:C215)
		OBJECT SET ENABLED:C1123(*; "deleteItem"; False:C215)
		OBJECT SET ENABLED:C1123(*; "inputNum"; False:C215)
		
		OBJECT SET ENABLED:C1123(*; "deleteConditionAction"; False:C215)
End case 