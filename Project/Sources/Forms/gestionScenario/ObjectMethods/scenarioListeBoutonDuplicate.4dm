Case of 
	: (Form event code:C388=Sur clic:K2:4) & (Form:C1466.ScenarioCurrentElement#Null:C1517)
		var $element_t; $idScenario_t : Text
		var $collection_c : Collection
		var $table_o; $enregistrement_o; $copy_o : Object
		
		CONFIRM:C162("Voulez-vous vraiment faire une duplication du scénario "+Form:C1466.scenarioDetail.nom; "Oui"; "Non")
		TRACE:C157
		If (OK=1)
			$table_o:=ds:C1482.CaScenario.query("nom = :1"; Form:C1466.scenarioDetail.nom+"@")
			
			$collection_c:=OB Keys:C1719(Form:C1466.scenarioDetail)
			
			// On commence par dupliquer la table [CaScenario]
			$copy_o:=ds:C1482.CaScenario.new()
			
			For each ($element_t; $collection_c)
				
				If ($element_t#"One@") & ($element_t#"All@") & ($element_t#"ID")
					$copy_o[$element_t]:=Form:C1466.scenarioDetail[$element_t]
				End if 
				
			End for each 
			
			$copy_o.nom:=$copy_o.nom+" ("+String:C10($table_o.length)+")"
			
			$copy_o.save()
			$idScenario_t:=$copy_o.ID
			
			// Puis la table [CaScene]
			For each ($enregistrement_o; Form:C1466.scenarioDetail.AllCaScene)
				$collection_c:=OB Keys:C1719($enregistrement_o)
				
				$copy_o:=ds:C1482.CaScene.new()
				
				For each ($element_t; $collection_c)
					
					If ($element_t#"One@") & ($element_t#"All@") & ($element_t#"ID")
						$copy_o[$element_t]:=$enregistrement_o[$element_t]
					End if 
					
				End for each 
				
				$copy_o.scenarioID:=$idScenario_t
				
				$copy_o.save()
			End for each 
			
			Form:C1466.loadAllScenario()
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 