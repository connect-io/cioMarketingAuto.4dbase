Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		var $collection_c : Collection
		
		var toggle_i; toggleOn_i; toggleOff_i : Picture
		
		ARRAY TEXT:C222(conditionActionList_at; 0)
		
		If (Storage:C1525.automation.sceneConditionAction#Null:C1517)
			$collection_c:=Storage:C1525.automation.sceneConditionAction.elements.orderBy("titre asc")
			
			COLLECTION TO ARRAY:C1562($collection_c; conditionActionList_at; "titre")
		End if 
		
		conditionActionList_at{0}:="Sélection d'une condition d'action"
		
		toggle_i:=Storage:C1525.automation.image["toggle"]
		
		toggleOn_i:=Storage:C1525.automation.image["toggle-on"]
		toggleOff_i:=Storage:C1525.automation.image["toggle-off"]
		
		Form:C1466.sceneClass:=cmaToolGetClass("MAScene").new()
		Form:C1466.sceneClass.loadByPrimaryKey(Form:C1466.sceneDetail.ID)
		
		Form:C1466.sceneClass.loadConditionActionDisplay()
		
		// On désactive les éléments qui servent à générer visuellement les conditions d'action
		OBJECT SET ENABLED:C1123(*; "imageBooleen"; False:C215)
		OBJECT SET ENABLED:C1123(*; "deleteItem"; False:C215)
End case 