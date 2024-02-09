var $class_o : Object

Case of 
	: (Form event code:C388=Sur clic:K2:4)
		// Instanciation de la class
		$class_o:=cmaToolGetClass("MAMailjet").new()
		$table_o:=Form:C1466.personne.AllCaPersonneMarketing[0]
		
		If ($table_o.historique.mailjet#Null:C1517)
			
			If (Num:C11($table_o.historique.mailjet.contactID)>0)
				OPEN URL:C673($class_o.config.domainRequest+"/REST/message?Contact="+String:C10($table_o.historique.mailjet.contactID))
			Else 
				ALERT:C41("Aucun contactID n'est présent dans les informations mailjet de la personne")
			End if 
			
		End if 
		
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 