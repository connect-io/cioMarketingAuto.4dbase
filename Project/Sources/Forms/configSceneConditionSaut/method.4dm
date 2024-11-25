Case of 
	: (Form event code:C388=On Load:K2:1)
		var $pos_el : Integer
		var $table_o : Object
		var $collection_c : Collection
		
		var toggle_i; toggleOn_i; toggleOff_i : Picture
		
		ARRAY TEXT:C222(conditionSautList_at; 0)
		ARRAY TEXT:C222(sceneSaut_at; 0)
		
		ARRAY LONGINT:C221(sceneSaut_ai; 0)
		
		If (Storage:C1525.automation.sceneConditionSaut#Null:C1517)
			$collection_c:=Storage:C1525.automation.sceneConditionSaut.elements.orderBy("titre asc")
			
			If ($collection_c.length>0)
				COLLECTION TO ARRAY:C1562($collection_c; conditionSautList_at; "titre")
			End if 
			
		End if 
		
		conditionSautList_at{0}:="Sélection d'une condition de saut"
		OBJECT SET ENABLED:C1123(sceneSaut_at; False:C215)
		
		$table_o:=Form:C1466.sceneDetail.OneCaScenario.AllCaScene.query("ID # :1"; Form:C1466.sceneDetail.ID)
		
		// On recherche toutes les autres scènes autre que celle qu'on est en train d'éditer
		$collection_c:=$table_o.toCollection("nom,ID").orderBy("nom asc")
		COLLECTION TO ARRAY:C1562($collection_c; sceneSaut_at; "nom"; sceneSaut_ai; "ID")
		
		sceneSaut_at{0}:="Sélection d'une scène"
		
		If (Form:C1466.sceneDetail.conditionSaut.elements#Null:C1517)
			$pos_el:=Find in array:C230(sceneSaut_ai; Num:C11(Form:C1466.sceneDetail.conditionSaut.sceneSautID))
			
			If ($pos_el>0)
				sceneSaut_at:=$pos_el
				sceneSaut_at{0}:=sceneSaut_at{$pos_el}
				
				sceneSaut_ai:=$pos_el
				sceneSaut_ai{0}:=sceneSaut_ai{$pos_el}
			End if 
			
			OBJECT SET ENABLED:C1123(sceneSaut_at; (Form:C1466.sceneDetail.conditionSaut.elements.length>0))
		End if 
		
		toggle_i:=Storage:C1525.automation.image["toggle"]
		
		toggleOn_i:=Storage:C1525.automation.image["toggle-on"]
		toggleOff_i:=Storage:C1525.automation.image["toggle-off"]
		
		Form:C1466.sceneClass:=cmaToolGetClass("MAScene").new()
		Form:C1466.sceneClass.loadConditionSautDisplay(Form:C1466.sceneDetail)
		
		// On désactive les éléments qui servent à générer visuellement les conditions de saut
		OBJECT SET ENABLED:C1123(*; "imageBooleen"; False:C215)
		OBJECT SET ENABLED:C1123(*; "deleteItem"; False:C215)
		
		OBJECT SET ENABLED:C1123(*; "deleteConditionSaut"; False:C215)
		
		OBJECT SET COORDINATES:C1248(*; "selectSceneSaut"; 483; 80)
		OBJECT SET COORDINATES:C1248(*; "deleteSceneSaut"; 743; 80)
End case 