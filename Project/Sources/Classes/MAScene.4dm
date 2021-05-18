/* -----------------------------------------------------------------------------
Class : cs.MAScene

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAScene.constructor
	
Instanciation de la class MAScene
	
Historique
15/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	This:C1470.scene:=Null:C1517
	
Function loadByPrimaryKey($sceneID_i : Integer)->$isOk_b : Boolean
/* -----------------------------------------------------------------------------
Fonction : MAScene.loadByPrimaryKey
	
Retrouve une scène via sa clé primaire.
	
Historique
15/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	This:C1470.scene:=ds:C1482.CaScene.get($sceneID_i)
	
	$isOk_b:=(This:C1470.scene#Null:C1517)
	
Function loadConditionActionDisplay
/* -----------------------------------------------------------------------------
Fonction : MAScene.loadConditionActionDisplay
	
Permet de faire le chargement visuel des différentes conditions d'action d'une scène
	
Historique
18/05/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $pos_el; $gauche_el; $haut_el; $droite_el; $bas_el; $hauteur_el : Integer
	
	ASSERT:C1129(This:C1470.scene#Null:C1517; "Impossible d'utiliser la fonction loadConditionActionDisplay sans une scène de définie.")
	
	If (This:C1470.scene.conditionAction.elements#Null:C1517)
		
		For each ($conditionAction_o; This:C1470.scene.conditionAction.elements)
			// On duplique l'objet standard "texte" et on le repositionne ensuite correctement
			$pos_el:=$conditionAction_o.varName.indexOf("texteBooleen@")
			
			cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; $conditionAction_o.titre; "Texte"; Est un texte:K8:3; True:C214; 10; $bas_el+10)
			
			Case of 
				: ($conditionAction_o.type="boolean")
					$pos_el:=$conditionAction_o.varName.indexOf("imageBooleen@")
					
					// On duplique l'objet standard "booleen" et on le repositionne ensuite correctement
					If (Num:C11($conditionAction_o.nombreEtat)=3)
						
						Case of 
							: ($conditionAction_o.value=0)
								cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; ->toggleOff_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; $bas_el+40)
							: ($conditionAction_o.value=1)
								cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; ->toggleOn_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; $bas_el+40)
							: ($conditionAction_o.value=2)
								cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; ->toggle_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; $bas_el+40)
						End case 
						
					Else 
						//toDo
					End if 
					
					OBJECT GET COORDINATES:C663(*; $conditionAction_o.varName[$pos_el]; $gauche_el; $haut_el; $droite_el; $bas_el)
					$hauteur_el:=$bas_el-$haut_el
					
					$pos_el:=$conditionAction_o.varName.indexOf("deleteItemBooleen@")
					
					If ($hauteur_el>24)
						cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; Null:C1517; "deleteItem"; Est un pointeur:K8:14; True:C214; 430; $haut_el-Round:C94(((24-$hauteur_el)/2); 0))
					Else 
						cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; Null:C1517; "deleteItem"; Est un pointeur:K8:14; True:C214; 430; $haut_el+Round:C94(((24-$hauteur_el)/2); 0))
					End if 
					
			End case 
			
		End for each 
		
	End if 
	
Function manageConditionAction($nomObjet_t : Text; $pointeur_p : Pointer)
/* -----------------------------------------------------------------------------
Fonction : MAScene.manageConditionAction
	
Permet de faire la gestion des différentes conditions d'action d'une scène
	
Historique
17/05/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $pos_el : Integer
	
	ASSERT:C1129(This:C1470.scene#Null:C1517; "Impossible d'utiliser la fonction manageConditionAction sans une scène de définie.")
	
	// On commence par faire un reload
	This:C1470.scene.reload()
	
	If (This:C1470.scene.conditionAction.elements#Null:C1517)
		
		For each ($conditionAction_o; This:C1470.scene.conditionAction.elements)
			$pos_el:=$conditionAction_o.varName.indexOf($nomObjet_t)
			
			If ($pos_el#-1)
				
				Case of 
					: ($conditionAction_o.type="boolean")
						
						If (Num:C11($conditionAction_o.nombreEtat)=3)
							
							Case of 
								: (Picture size:C356($pointeur_p->)=Picture size:C356(Storage:C1525.automation.image["toggle"]))
									OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggleOn_i)
									
									$conditionAction_o.value:=1
								: (Picture size:C356($pointeur_p->)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
									OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggleOff_i)
									
									$conditionAction_o.value:=0
								Else 
									OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggle_i)
									
									$conditionAction_o.value:=2
							End case 
							
							This:C1470.scene.save()
						End if 
						
				End case 
				
			End if 
			
		End for each 
		
	End if 
	
Function manageNumOrdre($numOrdre_el : Integer; $entree_el : Integer)->$return_t : Text
/* -----------------------------------------------------------------------------
Fonction : MAScene.manageNumOrdre
	
Permet de contrôler si le numéro d'ordre renseigné est admissible ou pas
	
Historique
01/05/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $table_o; $enregistrement_o; $return_o : Object
	
	ASSERT:C1129(This:C1470.scene#Null:C1517; "Impossible d'utiliser la fonction manageNumOrdre sans une scène de définie.")
	
	$return_o:=New object:C1471("etat"; True:C214; "erreurDetail"; "")
	
	$table_o:=This:C1470.scene.OneCaScenario.AllCaScene.query("ID # :1 AND numOrdre is :2"; This:C1470.scene.ID; $numOrdre_el)
	
	Case of 
		: ($table_o.length=1)  // Il y a déjà une scène avec un numéro d'ordre identique
			$return_o.etat:=False:C215
			$return_o.erreurDetail:="conflitNumeroOrdre"
		: ($numOrdre_el>Num:C11(This:C1470.scene.OneCaScenario.AllCaScene.length))  // Attribution d'un numéro plus haut que le nombre de scène
			$return_o.etat:=False:C215
			$return_o.erreurDetail:="Le numéro d'ordre attribué est supérieur au nombre de scènes, impossible de lui attribué celui-ci"
		Else   // Tout va bien
			
			If (Count parameters:C259=2)
				
				Case of 
					: ($entree_el=1)  // Lors de la suppression d'une scène, on doit ré-attribuer les autres numéros d'ordre des autres scènes
						
						If ($numOrdre_el>1)
							$table_o:=This:C1470.scene.OneCaScenario.AllCaScene.query("ID # :1 AND numOrdre is :2"; This:C1470.scene.ID; $numOrdre_el-1)
							
							If ($table_o.length=0)  // Problème le numéro d'ordre juste avant n'existe pas, on attribue donc celui-ci à celui sur lequel je suis en train de boucler
								This:C1470.scene.numOrdre:=$numOrdre_el-1
								
								// Il faut également changer le numéro de la scène suivante dans la scène précédente, car la scène suivante a été supprimé... il faut vraiment penser à tout grrrr !
								$table_o:=This:C1470.scene.OneCaScenario.AllCaScene.query("ID # :1 AND numOrdre is :2"; This:C1470.scene.ID; $numOrdre_el-2)
								
								If ($table_o.length=1)
									$enregistrement_o:=$table_o.first()
									
									$enregistrement_o.sceneSuivanteID:=This:C1470.scene.ID
									$enregistrement_o.save()
								End if 
								
								This:C1470.scene.save()
							End if 
							
						End if 
						
				End case 
				
			End if 
			
	End case 
	
	$return_t:=JSON Stringify:C1217($return_o)
	
Function reArrangeNumOrdre($scenarioID_t : Text)
/* -----------------------------------------------------------------------------
Fonction : MAScene.reArrangeNumOrdre
	
Permet de re-arranger les numéros d'ordre des différentes scènes d'un scénario
	
Historique
17/05/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $table_o; $enregistrement_o; $scene_o; $copy_o; $return_o : Object
	
	If (This:C1470.scene#Null:C1517)
		$copy_o:=This:C1470.scene
	End if 
	
	$enregistrement_o:=ds:C1482.CaScenario.get($scenarioID_t)
	
	If ($enregistrement_o#Null:C1517)
		$table_o:=$enregistrement_o.AllCaScene
		
		For each ($scene_o; $table_o)
			This:C1470.scene:=$scene_o
			
			$return_o:=JSON Parse:C1218(This:C1470.manageNumOrdre($scene_o.numOrdre; 1))
			
			If ($return_o.etat=False:C215)  // Il y aura toujours une erreur sur le dernier enregistrement car si ce n'est pas celui-ci qui a été supprimé, son numéro d'ordre sera supérieur aux nombres de scènes
				$scene_o.numOrdre:=$table_o.length
				
				$scene_o.save()
			End if 
			
		End for each 
		
	End if 
	
	If ($copy_o#Null:C1517)
		This:C1470.scene:=$copy_o
	End if 
	
Function updateStringActiveModel($type_t : Text)->$modeleActif_t : Text
/* -----------------------------------------------------------------------------
Fonction : MAScene.updateStringActiveModel
	
Permet de charger les éléments quand on change un modèle actif
	
Historique
15/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $collection_c : Collection
	
	ASSERT:C1129(This:C1470.scene#Null:C1517; "Impossible d'utiliser la fonction changeModeleActif sans une scène de définie.")
	
	// On le raffraichi car il y a pu avoir des modifications sur l'entité depuis son appel
	This:C1470.scene.reload()
	
	$collection_c:=This:C1470.scene.paramAction.modele[$type_t].version.query("actif = :1"; True:C214)
	
	If ($collection_c.length=1)
		$modeleActif_t:="• Titre du modèle actif : "+$collection_c[0].titre+Char:C90(Retour à la ligne:K15:40)
		$modeleActif_t:=$modeleActif_t+"• Dernière modification fait le "+cmaTimestampLire("date"; $collection_c[0].modifierLe)+" par "+$collection_c[0].modifierPar
	Else 
		$modeleActif_t:="• Aucun modèle actif de défini"
	End if 