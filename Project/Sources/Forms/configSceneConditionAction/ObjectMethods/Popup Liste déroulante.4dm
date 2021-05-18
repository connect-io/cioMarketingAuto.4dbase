var $uuid_t : Text
var $ajout_b : Boolean
var $pointeur_p : Pointer
var $conditionAction_o : Object
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
	$conditionAction_o:=Storage:C1525.automation.sceneConditionAction.elements.query("titre = :1"; conditionActionList_at{conditionActionList_at})[0]
	
	// S'il n'y a pas déjà eu d'ajout de condition d'action on initialise la collection
	If (Form:C1466.sceneDetail.conditionAction.elements=Null:C1517)
		Form:C1466.sceneDetail.conditionAction.elements:=New collection:C1472
	End if 
	
	// Initialisation des données
	Form:C1466.sceneDetail.conditionAction.elements.push(New object:C1471("titre"; conditionActionList_at{conditionActionList_at}; \
		"value"; ""; \
		"formule"; $conditionAction_o.formule; \
		"type"; $conditionAction_o.type; "id"; $uuid_t))
	
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
			// On duplique l'objet standard "texte" et on le repositionne ensuite correctement
			cmaToolDuplicateObjInForm("texteBooleen"+String:C10($collection_c.length); $conditionAction_o.label; "Texte"; Est un texte:K8:3; True:C214; 10; 10)
			
			// On duplique l'objet standard "booleen" et on le repositionne ensuite correctement
			If (Num:C11($conditionAction_o.nombreEtat)=3)
				cmaToolDuplicateObjInForm("imageBooleen"+String:C10($collection_c.length); ->toggle_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; 40)
			Else 
				cmaToolDuplicateObjInForm("imageBooleen"+String:C10($collection_c.length); ->toggleOff_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; 40)
			End if 
			
			cmaToolDuplicateObjInForm("deleteItemBooleen"+String:C10($collection_c.length); Null:C1517; "deleteItem"; Est un pointeur:K8:14; True:C214; 430; 44)
			
			// On sauvegarde le nom de la variable pour la restituer ensuite au chargement la prochaine fois
			Form:C1466.sceneDetail.conditionAction.elements[Form:C1466.sceneDetail.conditionAction.elements.length-1].varName:=New collection:C1472("texteBooleen"+String:C10($collection_c.length); \
				"imageBooleen"+String:C10($collection_c.length); \
				"deleteItemBooleen"+String:C10($collection_c.length))
	End case 
	
	Form:C1466.sceneDetail.save()
Else 
	ALERT:C41("Impossible de rajouter cette condition d'action car elle existe déjà")
End if 