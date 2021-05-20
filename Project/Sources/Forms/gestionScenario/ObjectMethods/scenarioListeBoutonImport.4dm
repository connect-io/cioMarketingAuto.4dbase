Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $table_o : Object
		
		If (Form:C1466.ScenarioCurrentElement=Null:C1517)
			CONFIRM:C162("Voulez-vous vraiment faire un import de scénario ?"; "Oui"; "Non")
			
			If (OK=1)
				$table_o:=ds:C1482.CaScenario.newSelection()
				$table_o.importScenario()
				
				Form:C1466.loadAllScenario()
			End if 
			
		Else 
			ALERT:C41("Aucun scénario ne doit être sélectionner pour faire un import")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 