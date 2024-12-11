var $pos_el : Integer
var $table_o; $retour_o : Object
var $collection_c : Collection

ARRAY TEXT:C222(sceneSuivante_at; 0)
ARRAY TEXT:C222(sceneAction_at; 0)

ARRAY TEXT:C222(scenarioSuivantNom_at; 0)
ARRAY TEXT:C222(scenarioSuivantID_at; 0)

ARRAY LONGINT:C221(sceneSuivante_ai; 0)

If (Form event code:C388=On Clicked:K2:4) & (Form:C1466.SceneCurrentElement#Null:C1517)
	Form:C1466.sceneDetail:=Form:C1466.SceneSelectedElement[0]
	
	$table_o:=Form:C1466.sceneDetail.OneCaScenario.AllCaScene.query("ID # :1"; Form:C1466.sceneDetail.ID)
	
	// On recherche toutes les autres scènes autre que celle qu'on est en train d'éditer
	$collection_c:=$table_o.toCollection("nom,ID").orderBy("nom asc")
	COLLECTION TO ARRAY:C1562($collection_c; sceneSuivante_at; "nom"; sceneSuivante_ai; "ID")
	
	If (Form:C1466.sceneDetail.sceneSuivanteID>0)
		$pos_el:=Find in array:C230(sceneSuivante_ai; Form:C1466.sceneDetail.sceneSuivanteID)
		
		If ($pos_el>0)
			sceneSuivante_at:=$pos_el
			sceneSuivante_at{0}:=sceneSuivante_at{$pos_el}
			
			sceneSuivante_ai:=$pos_el
			sceneSuivante_ai{0}:=sceneSuivante_ai{$pos_el}
		Else   // ID scène suivante inconnue...
			TRACE:C157
		End if 
		
	Else 
		sceneSuivante_at{0}:="Sélection de la scène suivante"
	End if 
	
	cmaToolAddToArray(->sceneAction_at; "Attente"; "Envoi email"; "Envoi SMS"; "Imprimer document"; "Exécuter une formule"; "Changement de scénario"; "Fin du scénario")
	
	If (Form:C1466.sceneDetail.action#"")
		$pos_el:=Find in array:C230(sceneAction_at; Form:C1466.sceneDetail.action)
		
		sceneAction_at:=$pos_el
		sceneAction_at{0}:=sceneAction_at{$pos_el}
	Else 
		sceneAction_at{0}:="Sélection d'une action de scène"
	End if 
	
	$table_o:=ds:C1482["CaScenario"].query("ID # :1"; Form:C1466.sceneDetail.scenarioID)
	
	$collection_c:=$table_o.toCollection("nom,ID").orderBy("nom asc")
	COLLECTION TO ARRAY:C1562($collection_c; scenarioSuivantNom_at; "nom"; scenarioSuivantID_at; "ID")
	
	If (Form:C1466.sceneDetail.scenarioSuivantID#"00000000000000000000000000000000")
		$pos_el:=Find in array:C230(scenarioSuivantID_at; Form:C1466.sceneDetail.scenarioSuivantID)
		
		If ($pos_el>0)
			scenarioSuivantNom_at:=$pos_el
			scenarioSuivantNom_at{0}:=scenarioSuivantNom_at{$pos_el}
			
			scenarioSuivantID_at:=$pos_el
			scenarioSuivantID_at{0}:=scenarioSuivantID_at{$pos_el}
		Else   // ID scénario suivant inconnue...
			ASSERT:C1129(True:C214; "ID du scénario suivant inconnue...")
		End if 
		
	Else 
		scenarioSuivantNom_at{0}:="Sélection du scénario suivant"
	End if 
	
	Form:C1466.updateStringSceneForm(1)
	OBJECT SET ENABLED:C1123(*; "sceneDetail@"; True:C214)
	
	// Si l'action de la scène est le changement de scénario, on ne peut pas éditer les infos pour mettre une scène suivante
	If (Form:C1466.sceneDetail.action="Changement de scénario")
		OBJECT SET ENABLED:C1123(*; "sceneDetailSceneSuivanteID"; False:C215)
		OBJECT SET ENABLED:C1123(*; "sceneDetailDeleteSceneSuivante"; False:C215)
		
		OBJECT SET ENABLED:C1123(*; "sceneDetailDelai@"; False:C215)
	Else 
		OBJECT SET ENABLED:C1123(*; "sceneDetailScenarioSuivant"; False:C215)
		OBJECT SET ENABLED:C1123(*; "sceneDetailDeleteScenarioSuivant"; False:C215)
	End if 
	
Else 
	
	If (Form:C1466.sceneDetail#Null:C1517)
		Form:C1466.sceneDetail:=Null:C1517
		
		Form:C1466.scenePersonneEnCours:=Null:C1517  // Chaine qui indique le nombre de personne auquel la scène du scénario sélectionné est appliqué
		Form:C1466.sceneSuivanteDelai:=Null:C1517  // Chaine qui indique le délai avec la scène suivante du scénario sélectionné
	End if 
	
	OBJECT SET ENABLED:C1123(*; "sceneDetail@"; False:C215)
End if 