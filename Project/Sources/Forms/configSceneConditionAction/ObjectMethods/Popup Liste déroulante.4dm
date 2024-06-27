var $uuid_t : Text
var $ajout_b : Boolean
var $conditionAction_o; $paramExtra_o : Object
var $collection_c : Collection

If (Form:C1466.sceneDetail.conditionAction.elements=Null:C1517)  // Il n'y a pas eu de conditions d'action ajouter pour cette scène
	$ajout_b:=True:C214
Else 
	$collection_c:=Form:C1466.sceneDetail.conditionAction.elements.query("titre = :1"; conditionActionList_at{conditionActionList_at})
	
	$ajout_b:=($collection_c.length=0)
End if 

If ($ajout_b=True:C214)
	$uuid_t:=Generate UUID:C1066
	
	// On charge la condition d'action sélectionné par l'utilisateur depuis le fichier de config
	$conditionAction_o:=OB Copy:C1225(Storage:C1525.automation.sceneConditionAction.elements.query("titre = :1"; conditionActionList_at{conditionActionList_at})[0])
	
	// S'il n'y a pas déjà eu d'ajout de condition d'action on initialise la collection
	If (Form:C1466.sceneDetail.conditionAction.elements=Null:C1517)
		Form:C1466.sceneDetail.conditionAction.elements:=New collection:C1472
	End if 
	
	// Initialisation des données
	Form:C1466.sceneDetail.conditionAction.elements.push(New object:C1471("titre"; conditionActionList_at{conditionActionList_at}; \
		"value"; ""; \
		"formule"; $conditionAction_o.formule; \
		"type"; $conditionAction_o.type; \
		"id"; $uuid_t))
	
	If ($conditionAction_o.paramExtra#Null:C1517)
		Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].paramExtra:=$conditionAction_o.paramExtra
	Else 
		Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].paramExtra:=New collection:C1472
	End if 
	
	Case of 
		: ($conditionAction_o.type="boolean")  // S'il s'agit d'une condition d'action "Booléen", on initialise certaines propriétés propre à ces conditions d'action
			
			If (Num:C11($conditionAction_o.nombreEtat)=3)  // Vrai ou Faux ou Indifférent
				Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].value:=2
			Else   // Seulement Vrai ou Faux
				Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].value:=0
			End if 
			
			Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].nombreEtat:=$conditionAction_o.nombreEtat
	End case 
	
	// On va regarder le nombre de condition d'action identique au type qu'on vient de rajouter
	$collection_c:=Form:C1466.sceneDetail.conditionAction.elements.query("type = :1"; $conditionAction_o.type)
	
	Case of 
		: ($conditionAction_o.type="boolean")
			// On sauvegarde le nom de la variable pour la restituer ensuite au chargement la prochaine fois
			Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].varName:=New collection:C1472("texteBooleen"+String:C10($collection_c.length); \
				"imageBooleen"+String:C10($collection_c.length); \
				"deleteItemBooleen"+String:C10($collection_c.length))
	End case 
	
	If ($conditionAction_o.paramExtra#Null:C1517)
		Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].varParamExtra:=New collection:C1472
		
		Case of 
			: ($conditionAction_o.type="boolean")
				
				For each ($paramExtra_o; $conditionAction_o.paramExtra)
					Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].varParamExtra.push("texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
						cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionAction_o.paramExtra.indexOf($paramExtra_o)+1))
					
					If ($paramExtra_o.format="input") | ($paramExtra_o.format="inputDelai")
						Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].varParamExtra.push("texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
							cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionAction_o.paramExtra.indexOf($paramExtra_o)+1)+Choose:C955($paramExtra_o.format="input"; "Input"; "InputDelai"))
						
						If ($paramExtra_o.format="inputDelai")
							Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].varParamExtra.push("texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
								cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionAction_o.paramExtra.indexOf($paramExtra_o)+1)+"InputDelaiUp"; "texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
								cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionAction_o.paramExtra.indexOf($paramExtra_o)+1)+"InputDelaiDown"; "texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
								cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionAction_o.paramExtra.indexOf($paramExtra_o)+1)+"InputDelaiEchelle"; "texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
								cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionAction_o.paramExtra.indexOf($paramExtra_o)+1)+"InputDelaiEchelleChange")
						End if 
						
					End if 
					
				End for each 
				
		End case 
		
	End if 
	
	conditionActionList_at:=0
	
	Form:C1466.sceneClass.loadConditionActionDisplay(Form:C1466.sceneDetail)
Else 
	ALERT:C41("Impossible de rajouter cette condition d'action car elle existe déjà")
End if 