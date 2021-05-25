Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		var $collection_c : Collection
		
		var toggle_i; toggleOn_i; toggleOff_i : Picture
		
		ARRAY TEXT:C222(conditionSautList_at; 0)
		
		If (Storage:C1525.automation.sceneConditionSaut#Null:C1517)
			$collection_c:=Storage:C1525.automation.sceneConditionSaut.elements.orderBy("titre asc")
			
			If ($collection_c.length>0)
				COLLECTION TO ARRAY:C1562($collection_c; conditionSautList_at; "titre")
			End if 
			
		End if 
		
		conditionSautList_at{0}:="Sélection d'une condition de saut"
		
		toggle_i:=Storage:C1525.automation.image["toggle"]
		
		toggleOn_i:=Storage:C1525.automation.image["toggle-on"]
		toggleOff_i:=Storage:C1525.automation.image["toggle-off"]
		
		Form:C1466.sceneClass:=cmaToolGetClass("MAScene").new()
		Form:C1466.sceneClass.loadConditionSautDisplay(Form:C1466.sceneDetail)
		
		// On désactive les éléments qui servent à générer visuellement les conditions de saut
		OBJECT SET ENABLED:C1123(*; "imageBooleen"; False:C215)
		OBJECT SET ENABLED:C1123(*; "deleteItem"; False:C215)
		
		OBJECT SET ENABLED:C1123(*; "deleteConditionSaut"; False:C215)
End case 