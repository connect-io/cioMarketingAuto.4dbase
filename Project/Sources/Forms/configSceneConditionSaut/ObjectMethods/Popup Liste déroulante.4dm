var $uuid_t : Text
var $ajout_b : Boolean
var $pointeur_p : Pointer
var $conditionSaut_o : Object
var $collection_c : Collection

If (Form:C1466.sceneDetail.conditionSaut.elements=Null:C1517)  // Il n'y a pas eu de conditions de saut ajouter pour cette scène
	$ajout_b:=True:C214
Else 
	$collection_c:=Form:C1466.sceneDetail.conditionSaut.elements.query("titre = :1"; conditionSautList_at{conditionSautList_at})
	
	$ajout_b:=($collection_c.length=0)
End if 

If ($ajout_b=True:C214)
	$uuid_t:=Generate UUID:C1066
	
	// On charge la condition de saut sélectionnée par l'utilisateur depuis le fichier de config
	$conditionSaut_o:=OB Copy:C1225(Storage:C1525.automation.sceneConditionSaut.elements.query("titre = :1"; conditionSautList_at{conditionSautList_at})[0])
	
	// S'il n'y a pas déjà eu d'ajout de condition de saut on initialise la collection
	If (Form:C1466.sceneDetail.conditionSaut.elements=Null:C1517)
		Form:C1466.sceneDetail.conditionSaut.elements:=New collection:C1472
	End if 
	
	// Initialisation des données
	Form:C1466.sceneDetail.conditionSaut.elements.push(New object:C1471("titre"; conditionSautList_at{conditionSautList_at}; \
		"value"; ""; \
		"formule"; $conditionSaut_o.formule; \
		"type"; $conditionSaut_o.type; \
		"id"; $uuid_t))
	
	If ($conditionSaut_o.paramExtra#Null:C1517)
		Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].paramExtra:=$conditionSaut_o.paramExtra
	Else 
		Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].paramExtra:=New collection:C1472
	End if 
	
	
	Case of 
		: ($conditionSaut_o.type="boolean")  // S'il s'agit d'une condition de saut "Booléen", on initialise certaines propriétés propre à ces conditions de saut
			
			If (Num:C11($conditionSaut_o.nombreEtat)=3)  // Vrai ou Faux ou Indifférent
				Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].value:=2
			Else   // Seulement Vrai ou Faux
				Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].value:=0
			End if 
			
			Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].nombreEtat:=$conditionSaut_o.nombreEtat
	End case 
	
	// On va regarder le nombre de condition de saut identique au type qu'on vient de rajouter
	$collection_c:=Form:C1466.sceneDetail.conditionSaut.elements.query("type = :1"; $conditionSaut_o.type)
	
	Case of 
		: ($conditionSaut_o.type="boolean")
			// On sauvegarde le nom de la variable pour la restituer ensuite au chargement la prochaine fois
			Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].varName:=New collection:C1472("texteBooleen"+String:C10($collection_c.length); \
				"imageBooleen"+String:C10($collection_c.length); \
				"deleteItemBooleen"+String:C10($collection_c.length))
	End case 
	
	If ($conditionSaut_o.paramExtra#Null:C1517)
		Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].varParamExtra:=New collection:C1472
		
		Case of 
			: ($conditionSaut_o.type="boolean")
				
				For each ($paramExtra_o; $conditionSaut_o.paramExtra)
					Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].varParamExtra.push("texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
						cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionSaut_o.paramExtra.indexOf($paramExtra_o)+1))
					
					If ($paramExtra_o.format="input") | ($paramExtra_o.format="inputDelai")
						Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].varParamExtra.push("texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
							cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionSaut_o.paramExtra.indexOf($paramExtra_o)+1)+Choose:C955($paramExtra_o.format="input"; "Input"; "InputDelai"))
						
						If ($paramExtra_o.format="inputDelai")
							Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].varParamExtra.push("texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
								cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionSaut_o.paramExtra.indexOf($paramExtra_o)+1)+"InputDelaiUp"; "texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
								cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionSaut_o.paramExtra.indexOf($paramExtra_o)+1)+"InputDelaiDown"; "texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
								cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionSaut_o.paramExtra.indexOf($paramExtra_o)+1)+"InputDelaiEchelle"; "texteBooleen"+String:C10($collection_c.length)+"ParamExtra"+\
								cmaToolMajuscFirstChar($paramExtra_o.type)+String:C10($conditionSaut_o.paramExtra.indexOf($paramExtra_o)+1)+"InputDelaiEchelleChange")
						End if 
						
					End if 
					
				End for each 
				
		End case 
		
	End if 
	
	conditionSautList_at:=0
	Form:C1466.sceneClass.loadConditionSautDisplay(Form:C1466.sceneDetail)
	
	OBJECT SET ENABLED:C1123(sceneSaut_at; True:C214)
Else 
	ALERT:C41("Impossible de rajouter cette condition de saut car elle existe déjà")
End if 