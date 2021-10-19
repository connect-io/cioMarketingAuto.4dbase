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
	
Function addScenarioEvent($action_t : Text; $personneScenarioID_v : Variant)
/* -----------------------------------------------------------------------------
Fonction : MAScene.addScenarioEvent
	
Permet de faire l'ajout d'un log quand un évenement arrive sur une scène d'un scénario d'une personne
	
Historique
19/05/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $caScenarioEvent_o : Object
	
	ASSERT:C1129(This:C1470.scene#Null:C1517; "Impossible d'utiliser la fonction addScenarioEvent sans une scène de définie.")
	
	$caScenarioEvent_o:=ds:C1482.CaScenarioEvent.new()
	
	$caScenarioEvent_o.personneScenarioID:=$personneScenarioID_v
	$caScenarioEvent_o.sceneID:=This:C1470.scene.ID
	$caScenarioEvent_o.tsCreation:=cmaTimestamp(Current date:C33; Current time:C178)
	
	Case of 
		: ($action_t="Attente")
			$caScenarioEvent_o.etat:="En cours"
			
			$caScenarioEvent_o.information:="Attente de la prochaine scène"
		: ($action_t="Envoi email")
			$caScenarioEvent_o.etat:="En cours"
			
			$caScenarioEvent_o.information:="Envoi d'un email"
		: ($action_t="Changement de scénario") | ($action_t="Fin du scénario")
			$caScenarioEvent_o.etat:="Terminé"
			
			$caScenarioEvent_o.information:=$action_t
	End case 
	
	$caScenarioEvent_o.save()
	
Function loadByPrimaryKey($sceneID_i : Integer)->$isOk_b : Boolean
/* -----------------------------------------------------------------------------
Fonction : MAScene.loadByPrimaryKey
	
Retrouve une scène via sa clé primaire.
	
Historique
15/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	This:C1470.scene:=ds:C1482.CaScene.get($sceneID_i)
	
	$isOk_b:=(This:C1470.scene#Null:C1517)
	
Function loadConditionActionDisplay($scene_o : Object)
/* -----------------------------------------------------------------------------
Fonction : MAScene.loadConditionActionDisplay
	
Permet de faire le chargement visuel des différentes conditions d'action d'une scène
	
Historique
18/05/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $pos_el; $gauche_el; $haut_el; $droite_el; $bas_el; $hauteur_el : Integer
	var $conditionAction_o : Object
	
	If ($scene_o.conditionAction.elements#Null:C1517)
		
		For each ($conditionAction_o; $scene_o.conditionAction.elements)
			
			Case of 
				: ($conditionAction_o.type="boolean")
					// On duplique l'objet standard "texte" et on le repositionne ensuite correctement
					$pos_el:=$conditionAction_o.varName.indexOf("texteBooleen@")
					
					cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; $conditionAction_o.titre; "Texte"; Est un texte:K8:3; True:C214; 10; $bas_el+10)
					
					$pos_el:=$conditionAction_o.varName.indexOf("imageBooleen@")
					
					// On duplique l'objet standard "booleen" et on le repositionne ensuite correctement
					Case of 
						: ($conditionAction_o.value=0)
							cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; ->toggleOff_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; $bas_el+40)
						: ($conditionAction_o.value=1)
							cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; ->toggleOn_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; $bas_el+40)
						: ($conditionAction_o.value=2)
							cmaToolDuplicateObjInForm($conditionAction_o.varName[$pos_el]; ->toggle_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; $bas_el+40)
					End case 
					
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
	
Function loadConditionSautDisplay($scene_o : Object)
/* -----------------------------------------------------------------------------
Fonction : MAScene.loadConditionSautDisplay
	
Permet de faire le chargement visuel des différentes conditions de saut d'une scène
	
Historique
25/05/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $pos_el; $gauche_el; $haut_el; $droite_el; $bas_el; $hauteur_el : Integer
	var $conditionSaut_o : Object
	
	If ($scene_o.conditionSaut.elements#Null:C1517)
		
		For each ($conditionSaut_o; $scene_o.conditionSaut.elements)
			
			Case of 
				: ($conditionSaut_o.type="boolean")
					// On duplique l'objet standard "texte" et on le repositionne ensuite correctement
					$pos_el:=$conditionSaut_o.varName.indexOf("texteBooleen@")
					
					cmaToolDuplicateObjInForm($conditionSaut_o.varName[$pos_el]; $conditionSaut_o.titre; "Texte"; Est un texte:K8:3; True:C214; 10; $bas_el+10)
					
					$pos_el:=$conditionSaut_o.varName.indexOf("imageBooleen@")
					
					// On duplique l'objet standard "booleen" et on le repositionne ensuite correctement
					Case of 
						: ($conditionSaut_o.value=0)
							cmaToolDuplicateObjInForm($conditionSaut_o.varName[$pos_el]; ->toggleOff_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; $bas_el+40)
						: ($conditionSaut_o.value=1)
							cmaToolDuplicateObjInForm($conditionSaut_o.varName[$pos_el]; ->toggleOn_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; $bas_el+40)
						: ($conditionSaut_o.value=2)
							cmaToolDuplicateObjInForm($conditionSaut_o.varName[$pos_el]; ->toggle_i; "imageBooleen"; Est une variable chaîne:K8:2; True:C214; 10; $bas_el+40)
					End case 
					
					OBJECT GET COORDINATES:C663(*; $conditionSaut_o.varName[$pos_el]; $gauche_el; $haut_el; $droite_el; $bas_el)
					$hauteur_el:=$bas_el-$haut_el
					
					$pos_el:=$conditionSaut_o.varName.indexOf("deleteItemBooleen@")
					
					If ($hauteur_el>24)
						cmaToolDuplicateObjInForm($conditionSaut_o.varName[$pos_el]; Null:C1517; "deleteItem"; Est un pointeur:K8:14; True:C214; 430; $haut_el-Round:C94(((24-$hauteur_el)/2); 0))
					Else 
						cmaToolDuplicateObjInForm($conditionSaut_o.varName[$pos_el]; Null:C1517; "deleteItem"; Est un pointeur:K8:14; True:C214; 430; $haut_el+Round:C94(((24-$hauteur_el)/2); 0))
					End if 
					
			End case 
			
		End for each 
		
	End if 
	
Function manageConditionAction($conditionAction_o : Object; $caPersonneScenario_o : Object)->$continue_b : Boolean
/* -----------------------------------------------------------------------------
Fonction : MAScene.manageConditionAction
	
Permet de gérer les différents condition d'action possible
	
Historique
19/10/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $table_o; $enregistrement_o; $autreTable_o; $autreEnregistrement_o : Object
	var $collection_c : Collection
	
	ASSERT:C1129(This:C1470.scene#Null:C1517; "Impossible d'utiliser la fonction manageConditionAction sans une scène de définie.")
	
	Case of 
		: ($conditionAction_o.titre="Mail de la scène précédente ouvert")  // On doit chercher si dans une scène précédente, il y en a au moins une qui a l'action Envoi email
			$table_o:=ds:C1482.CaScene.query("scenarioID is :1 AND numOrdre < :2 AND action = :3"; This:C1470.scene.scenarioID; This:C1470.scene.numOrdre; "Envoi email").orderBy("numOrdre desc")
			
			If ($table_o.length>0)  // On a bien trouvé une des scènes précédentes au scénario dont l'action est "Envoi email", on prend la première puisqu'on a trié par numOrdre décroissant
				$enregistrement_o:=$table_o.first()
				
				// On cherche parmi tous les logs de la scène, celles de la personne sur lequel on fait la vérification et dont l'action a été Envoi d'un email et qui est Terminé
				$table_o:=$enregistrement_o.AllCaScenarioEvent.query("information = :1 AND etat = :2 AND personneScenarioID = :3"; "Envoi d'un email"; "Terminé"; $caPersonneScenario_o.ID).orderBy("tsCreation desc")
				
				If ($table_o.length>0)  // On a bien trouvé un log, on prend le premier puisqu'on a trié par tsCreation décroissant
					$enregistrement_o:=$table_o.first()
					
					$autreTable_o:=$caPersonneScenario_o.OnePersonne.AllCaPersonneMarketing
					
					If ($autreTable_o.length=1)
						$autreEnregistrement_o:=$autreTable_o.first()
						$collection_c:=$autreEnregistrement_o.historique.detail.query("eventTs > :1 AND eventTs <= :2"; $enregistrement_o.tsCreation-60; $enregistrement_o.tsCreation)  // Je prends une marge d'1 minute pour être certain de prendre le bon mail
						
						If ($collection_c.length>0)  // C'est une solution du à peu près en attendant que je mette en place une solution plus précise
							
							Case of 
								: ($conditionAction_o.value=1)  // Le mail doit avoir été ouvert
									$continue_b:=($autreEnregistrement_o.lastOpened>$collection_c[0].eventTs) | ($autreEnregistrement_o.lastClicked>$collection_c[0].eventTs)
								: ($conditionAction_o.value=0)  // Le mail ne doit pas avoir été ouvert ou cliqué
									$continue_b:=Not:C34(($autreEnregistrement_o.lastOpened>$collection_c[0].eventTs) | ($autreEnregistrement_o.lastClicked>$collection_c[0].eventTs))
							End case 
							
						End if 
						
					End if 
					
				End if 
				
			End if 
			
	End case 
	
Function manageConditionActionDisplay($entree_el : Integer; $nomObjet_t : Text; $pointeur_p : Pointer; $scene_o : Object)
/* -----------------------------------------------------------------------------
Fonction : MAScene.manageConditionActionDisplay
	
Permet de faire la gestion des différentes conditions d'action d'une scène
	
Historique
17/05/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $element_t : Text
	var $pos_el; $posBis_el : Integer
	var $conditionAction_o : Object
	
	Case of 
		: ($entree_el=0)  // Suppression d'une condition d'action
			
			If ($scene_o.conditionAction.elements#Null:C1517)
				
				For each ($conditionAction_o; $scene_o.conditionAction.elements)
					// On cherche dans quelle condition d'action se trouve le bouton suppr sur lequel l'utilisateur a cliqué
					$pos_el:=$conditionAction_o.varName.indexOf($nomObjet_t)
					
					If ($pos_el#-1)  // Bingo c'est ici
						
						// On va boucler sur chaque elément de la condition d'action et les virer un par un
						For each ($element_t; $conditionAction_o.varName)
							OBJECT SET COORDINATES:C1248(*; $element_t; -9999; -9999; -9999; -9999)
						End for each 
						
						// Une fois cela fait on va virer la condition d'action de la propriété "elements"
						$posBis_el:=$scene_o.conditionAction.elements.indexOf($conditionAction_o)
					End if 
					
				End for each 
				
				If ($posBis_el#-1)
					$scene_o.conditionAction.elements.remove($posBis_el)
					
					If ($scene_o.conditionAction.elements.length=0)
						$scene_o.conditionAction:=New object:C1471
					End if 
					
				End if 
				
			End if 
			
		: ($entree_el=1)  // Modification d'une condition d'action
			
			If ($scene_o.conditionAction.elements#Null:C1517)
				
				For each ($conditionAction_o; $scene_o.conditionAction.elements)
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
									
								Else 
									
									If (Picture size:C356($pointeur_p->)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
										OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggleOff_i)
										
										$conditionAction_o.value:=0
									Else 
										OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggleOn_i)
										
										$conditionAction_o.value:=1
									End if 
									
								End if 
								
						End case 
						
					End if 
					
				End for each 
				
			End if 
			
	End case 
	
Function manageConditionSautDisplay($entree_el : Integer; $nomObjet_t : Text; $pointeur_p : Pointer; $scene_o : Object)
/* -----------------------------------------------------------------------------
Fonction : MAScene.manageConditionSautDisplay
	
Permet de faire la gestion des différentes conditions de saut d'une scène
	
Historique
25/05/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $element_t : Text
	var $pos_el; $posBis_el : Integer
	var $conditionSaut_o : Object
	
	Case of 
		: ($entree_el=0)  // Suppression d'une condition de saut
			
			If ($scene_o.conditionSaut.elements#Null:C1517)
				
				For each ($conditionSaut_o; $scene_o.conditionSaut.elements)
					// On cherche dans quelle condition de saut se trouve le bouton suppr sur lequel l'utilisateur a cliqué
					$pos_el:=$conditionSaut_o.varName.indexOf($nomObjet_t)
					
					If ($pos_el#-1)  // Bingo c'est ici
						
						// On va boucler sur chaque elément de la condition de saut et les virer un par un
						For each ($element_t; $conditionSaut_o.varName)
							OBJECT SET COORDINATES:C1248(*; $element_t; -9999; -9999; -9999; -9999)
						End for each 
						
						// Une fois cela fait on va virer la condition de saut de la propriété "elements"
						$posBis_el:=$scene_o.conditionSaut.elements.indexOf($conditionSaut_o)
					End if 
					
				End for each 
				
				If ($posBis_el#-1)
					$scene_o.conditionSaut.elements.remove($posBis_el)
					
					// S'il n'y a plus de conditions de saut on reset l'objet
					If ($scene_o.conditionSaut.elements.length=0)
						$scene_o.conditionSaut:=New object:C1471
					End if 
					
				End if 
				
			End if 
			
		: ($entree_el=1)  // Modification d'une condition de saut
			
			If ($scene_o.conditionSaut.elements#Null:C1517)
				
				For each ($conditionSaut_o; $scene_o.conditionSaut.elements)
					$pos_el:=$conditionSaut_o.varName.indexOf($nomObjet_t)
					
					If ($pos_el#-1)
						
						Case of 
							: ($conditionSaut_o.type="boolean")
								
								If (Num:C11($conditionSaut_o.nombreEtat)=3)
									
									Case of 
										: (Picture size:C356($pointeur_p->)=Picture size:C356(Storage:C1525.automation.image["toggle"]))
											OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggleOn_i)
											
											$conditionSaut_o.value:=1
										: (Picture size:C356($pointeur_p->)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
											OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggleOff_i)
											
											$conditionSaut_o.value:=0
										Else 
											OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggle_i)
											
											$conditionSaut_o.value:=2
									End case 
									
								Else 
									
									If (Picture size:C356($pointeur_p->)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
										OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggleOff_i)
										
										$conditionSaut_o.value:=0
									Else 
										OBJECT SET DATA SOURCE:C1264(*; cmaToolMinuscFirstChar($nomObjet_t); ->toggleOn_i)
										
										$conditionSaut_o.value:=1
									End if 
									
								End if 
								
						End case 
						
					End if 
					
				End for each 
				
			End if 
			
	End case 
	
Function manageConditionSaut($conditionSaut_o : Object; $caPersonneScenario_o : Object)->$continue_b : Boolean
/* -----------------------------------------------------------------------------
Fonction : MAScene.manageConditionSaut
	
Permet de gérer les différents condition de saut possible
	
Historique
19/10/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $table_o; $enregistrement_o; $autreTable_o; $autreEnregistrement_o : Object
	var $collection_c : Collection
	
	ASSERT:C1129(This:C1470.scene#Null:C1517; "Impossible d'utiliser la fonction manageConditionSaut sans une scène de définie.")
	
	Case of 
		: ($conditionSaut_o.titre="Mail de la scène précédente ouvert")  // On doit chercher si dans une scène précédente, il y en a au moins une qui a l'action Envoi email
			$table_o:=ds:C1482.CaScene.query("scenarioID is :1 AND numOrdre < :2 AND action = :3"; This:C1470.scene.scenarioID; This:C1470.scene.numOrdre; "Envoi email").orderBy("numOrdre desc")
			
			If ($table_o.length>0)  // On a bien trouvé une des scènes précédentes au scénario dont l'action est "Envoi email", on prend la première puisqu'on a trié par numOrdre décroissant
				$enregistrement_o:=$table_o.first()
				
				// On cherche parmi tous les logs de la scène, celles de la personne sur lequel on fait la vérification et dont l'action a été Envoi d'un email et qui est Terminé
				$table_o:=$enregistrement_o.AllCaScenarioEvent.query("information = :1 AND etat = :2 AND personneScenarioID = :3"; "Envoi d'un email"; "Terminé"; $caPersonneScenario_o.ID).orderBy("tsCreation desc")
				
				If ($table_o.length>0)  // On a bien trouvé un log, on prend le premier puisqu'on a trié par tsCreation décroissant
					$enregistrement_o:=$table_o.first()
					
					$autreTable_o:=$caPersonneScenario_o.OnePersonne.AllCaPersonneMarketing
					
					If ($autreTable_o.length=1)
						$autreEnregistrement_o:=$autreTable_o.first()
						$collection_c:=$autreEnregistrement_o.historique.detail.query("eventTs > :1 AND eventTs <= :2"; $enregistrement_o.tsCreation-60; $enregistrement_o.tsCreation)  // Je prends une marge d'1 minute pour être certain de prendre le bon mail
						
						If ($collection_c.length>0)  // C'est une solution du à peu près en attendant que je mette en place une solution plus précise
							
							Case of 
								: ($conditionSaut_o.value=1)  // Le mail doit avoir été ouvert
									$continue_b:=($autreEnregistrement_o.lastOpened>$collection_c[0].eventTs) | ($autreEnregistrement_o.lastClicked>$collection_c[0].eventTs)
								: ($conditionSaut_o.value=0)  // Le mail ne doit pas avoir été ouvert ou cliqué
									$continue_b:=Not:C34(($autreEnregistrement_o.lastOpened>$collection_c[0].eventTs) | ($autreEnregistrement_o.lastClicked>$collection_c[0].eventTs))
							End case 
							
						End if 
						
					End if 
					
				End if 
				
			End if 
			
	End case 
	
Function manageNumOrdre($scene_o : Object; $entree_el : Integer)->$return_t : Text
/* -----------------------------------------------------------------------------
Fonction : MAScene.manageNumOrdre
	
Permet de contrôler si le numéro d'ordre renseigné est admissible ou pas
	
Historique
01/05/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $table_o; $enregistrement_o; $return_o : Object
	
	$return_o:=New object:C1471("etat"; True:C214; "erreurDetail"; "")
	
	$table_o:=$scene_o.OneCaScenario.AllCaScene.query("ID # :1 AND numOrdre is :2"; $scene_o.ID; $scene_o.numOrdre)
	
	Case of 
		: ($table_o.length=1)  // Il y a déjà une scène avec un numéro d'ordre identique
			$return_o.etat:=False:C215
			$return_o.erreurDetail:="conflitNumeroOrdre"
		: ($scene_o.numOrdre>Num:C11($scene_o.OneCaScenario.AllCaScene.length))  // Attribution d'un numéro plus haut que le nombre de scène
			$return_o.etat:=False:C215
			$return_o.erreurDetail:="Le numéro d'ordre attribué est supérieur au nombre de scènes, impossible de lui attribué celui-ci"
		Else   // Tout va bien
			
			If (Count parameters:C259=2)
				
				Case of 
					: ($entree_el=1)  // Lors de la suppression d'une scène, on doit ré-attribuer les autres numéros d'ordre des autres scènes
						
						If ($scene_o.numOrdre>1)
							$table_o:=$scene_o.OneCaScenario.AllCaScene.query("ID # :1 AND numOrdre is :2"; $scene_o.ID; $scene_o.numOrdre-1)
							
							If ($table_o.length=0)  // Problème le numéro d'ordre juste avant n'existe pas, on attribue donc celui-ci à celui sur lequel je suis en train de boucler
								// Il faut également changer le numéro de la scène suivante dans la scène précédente, car la scène suivante a été supprimé... il faut vraiment penser à tout grrrr !
								$table_o:=$scene_o.OneCaScenario.AllCaScene.query("ID # :1 AND numOrdre is :2"; $scene_o.ID; $scene_o.numOrdre-2)
								
								$scene_o.numOrdre:=$scene_o.numOrdre-1
								$scene_o.save()
								
								If ($table_o.length=1)
									$enregistrement_o:=$table_o.first()
									
									If ($enregistrement_o.sceneSuivanteID>0)
										$enregistrement_o.sceneSuivanteID:=$scene_o.ID
										$enregistrement_o.save()
									End if 
									
								End if 
								
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
	var $table_o; $enregistrement_o; $scene_o; $return_o : Object
	
	$enregistrement_o:=ds:C1482.CaScenario.get($scenarioID_t)
	
	If ($enregistrement_o#Null:C1517)
		$table_o:=$enregistrement_o.AllCaScene.orderBy("numOrdre asc")
		
		For each ($scene_o; $table_o)
			$return_o:=JSON Parse:C1218(This:C1470.manageNumOrdre($scene_o; 1))
			
			If ($return_o.etat=False:C215)  // Il y aura toujours une erreur sur le dernier enregistrement car si ce n'est pas celui-ci qui a été supprimé, son numéro d'ordre sera supérieur aux nombres de scènes
				$scene_o.numOrdre:=$table_o.length
				
				$scene_o.save()
			End if 
			
		End for each 
		
	End if 
	
Function updateStringActiveModel($type_t : Text; $scene_o : Object)->$modeleActif_t : Text
/* -----------------------------------------------------------------------------
Fonction : MAScene.updateStringActiveModel
	
Permet de charger les éléments quand on change un modèle actif
	
Historique
15/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $collection_c : Collection
	
	$collection_c:=$scene_o.paramAction.modele[$type_t].version.query("actif = :1"; True:C214)
	
	If ($collection_c.length=1)
		$modeleActif_t:="• Titre du modèle actif : "+$collection_c[0].titre+Char:C90(Retour à la ligne:K15:40)
		$modeleActif_t:=$modeleActif_t+"• Dernière modification fait le "+cmaTimestampLire("date"; $collection_c[0].modifierLe)+" par "+$collection_c[0].modifierPar
	Else 
		$modeleActif_t:="• Aucun modèle actif de défini"
	End if 