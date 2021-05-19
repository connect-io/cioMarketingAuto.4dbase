var $pos_el : Integer
var $table_o : Object
var $collection_c : Collection

ARRAY TEXT:C222(sceneSuivante_at; 0)
ARRAY TEXT:C222(sceneAction_at; 0)

ARRAY LONGINT:C221(sceneSuivante_ai; 0)

If (Form event code:C388=Sur clic:K2:4) & (Form:C1466.SceneCurrentElement#Null:C1517)
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
	
	cmaToolAddToArray(->sceneAction_at; "Attente"; "Envoi email"; "Changement de scénario"; "Fin du scénario")
	
	If (Form:C1466.sceneDetail.action#"")
		$pos_el:=Find in array:C230(sceneAction_at; Form:C1466.sceneDetail.action)
		
		sceneAction_at:=$pos_el
		sceneAction_at{0}:=sceneAction_at{$pos_el}
	Else 
		sceneSuivante_at{0}:="Sélection d'une action de scène"
	End if 
	
	Form:C1466.updateStringSceneForm(1)
	
	OBJECT SET ENABLED:C1123(*; "sceneDetail@"; True:C214)
Else 
	
	If (Form:C1466.sceneDetail#Null:C1517)
		Form:C1466.sceneDetail:=Null:C1517
		
		Form:C1466.scenePersonneEnCours:=Null:C1517  // Chaine qui indique le nombre de personne auquel la scène du scénario sélectionné est appliqué
		Form:C1466.sceneSuivanteDelai:=Null:C1517  // Chaine qui indique le délai avec la scène suivante du scénario sélectionné
	End if 
	
	OBJECT SET ENABLED:C1123(*; "sceneDetail@"; False:C215)
End if 