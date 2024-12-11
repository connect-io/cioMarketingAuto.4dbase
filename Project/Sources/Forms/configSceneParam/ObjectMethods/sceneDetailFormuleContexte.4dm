var $index_el : Integer

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT Get pointer:C1124(Object current:K67:2)->:=New object:C1471
		OBJECT Get pointer:C1124(Object current:K67:2)->values:=New collection:C1472("Aucun"; "External référence du champ [CaPersonneScenario]situation.detail")
		
		If (Form:C1466.sceneDetail.paramAction.formule#Null:C1517)
			$index_el:=OBJECT Get pointer:C1124(Object current:K67:2)->values.indexOf(String:C10(Form:C1466.sceneDetail.paramAction.formule.contexte))
		End if 
		
		OBJECT Get pointer:C1124(Object current:K67:2)->index:=$index_el
		OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:=OBJECT Get pointer:C1124(Object current:K67:2)->values[$index_el]
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.sceneDetail.paramAction.formule.contexte:=OBJECT Get pointer:C1124(Object current:K67:2)->currentValue
End case 