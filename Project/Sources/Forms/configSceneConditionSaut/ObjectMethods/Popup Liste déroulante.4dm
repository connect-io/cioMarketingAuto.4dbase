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
	$conditionSaut_o:=Storage:C1525.automation.sceneConditionSaut.elements.query("titre = :1"; conditionSautList_at{conditionSautList_at})[0]
	
	// S'il n'y a pas déjà eu d'ajout de condition de saut on initialise la collection
	If (Form:C1466.sceneDetail.conditionSaut.elements=Null:C1517)
		Form:C1466.sceneDetail.conditionSaut.elements:=New collection:C1472
	End if 
	
	// Initialisation des données
	Form:C1466.sceneDetail.conditionSaut.elements.push(New object:C1471("titre"; conditionSautList_at{conditionSautList_at}; \
		"value"; ""; \
		"formule"; $conditionSaut_o.formule; \
		"type"; $conditionSaut_o.type; "id"; $uuid_t))
	
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
			// On duplique l'objet standard "texte" et on le repositionne ensuite correctement
			cmaToolDuplicateObjInForm("texteBooleen"+String:C10($collection_c.length); $conditionSaut_o.label; "Texte"; Est un texte:K8:3; True:C214; 10; 10)
			
			// On duplique l'objet standard "booleen" et on le repositionne ensuite correctement
			If (Num:C11($conditionSaut_o.nombreEtat)=3)
				cmaToolDuplicateObjInForm("imageBooleen"+String:C10($collection_c.length); ->toggle_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; 40)
			Else 
				cmaToolDuplicateObjInForm("imageBooleen"+String:C10($collection_c.length); ->toggleOff_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; 40)
			End if 
			
			cmaToolDuplicateObjInForm("deleteItemBooleen"+String:C10($collection_c.length); Null:C1517; "deleteItem"; Est un pointeur:K8:14; True:C214; 430; 44)
			
			// On sauvegarde le nom de la variable pour la restituer ensuite au chargement la prochaine fois
			Form:C1466.sceneDetail.conditionSaut.elements[Form:C1466.sceneDetail.conditionSaut.elements.length-1].varName:=New collection:C1472("texteBooleen"+String:C10($collection_c.length); \
				"imageBooleen"+String:C10($collection_c.length); \
				"deleteItemBooleen"+String:C10($collection_c.length))
	End case 
	
Else 
	ALERT:C41("Impossible de rajouter cette condition de saut car elle existe déjà")
End if 