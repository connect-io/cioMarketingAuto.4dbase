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
	
Function updateStringActiveModel($type_t : Text)->$modeleActif_t : Text
/* -----------------------------------------------------------------------------
Fonction : MAScene.changeModeleActif
	
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
	
Function manageNumOrdre($numOrdre_el)->$return_t : Text
	var $table_o; $return_o : Object
	
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
	End case 
	
	$return_t:=JSON Stringify:C1217($return_o)