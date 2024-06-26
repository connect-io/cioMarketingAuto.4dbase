var $numOrdre_el : Integer
var $class_o; $return_o; $table_o : Object

$class_o:=cmaToolGetClass("MAScene").new()

$return_o:=JSON Parse:C1218($class_o.manageNumOrdre(Form:C1466.sceneDetail))

If ($return_o.etat=False:C215)
	// On va rechercher l'ancien numéro d'ordre de la scène qu'on est en train de modifier
	$numOrdre_el:=Form:C1466.sceneDetail.OneCaScenario.AllCaScene.query("ID = :1"; Form:C1466.sceneDetail.ID).first().numOrdre
	
	If ($return_o.erreurDetail="conflitNumeroOrdre")
		CONFIRM:C162("Il y a déjà une scène avec le numéro d'ordre \""+String:C10(Form:C1466.sceneDetail.numOrdre)+"\", voulez-vous vraiment lui attribuer celui-ci ?"; "Oui"; "Non")
		
		If (OK=1)
			$table_o:=Form:C1466.sceneDetail.OneCaScenario.AllCaScene.query("numOrdre = :1 AND ID # :2"; Form:C1466.sceneDetail.numOrdre; Form:C1466.sceneDetail.ID)
			
			If ($table_o.length=1)
				$table_o:=$table_o.first()
				
				$table_o.numOrdre:=$numOrdre_el
				$return_o:=$table_o.save()
				
				If ($return_o.success=False:C215)
					ALERT:C41("Erreur lors de l'enregistrement")
				End if 
				
			Else 
				ALERT:C41("Impossible de trouver l'autre scène, merci de ré-essayer !")
				Form:C1466.sceneDetail.numOrdre:=$numOrdre_el
			End if 
			
		Else 
			Form:C1466.sceneDetail.numOrdre:=$numOrdre_el
		End if 
		
	Else 
		ALERT:C41($return_o.erreurDetail)
		Form:C1466.sceneDetail.numOrdre:=$numOrdre_el
	End if 
	
End if 