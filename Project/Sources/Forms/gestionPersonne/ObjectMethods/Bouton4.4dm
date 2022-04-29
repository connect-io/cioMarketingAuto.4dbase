var $element_o; $enregistrement_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.entree=1)  // Si gestion du scénario (personne possible)
			
			If (Type:C295(entitySelection_o)#Is undefined:K8:13) & (Form:C1466.PersonneCurrentElement#Null:C1517)
				
				For each ($element_o; Form:C1466.PersonneSelectedElement)
					$enregistrement_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].get($element_o.UID)
					
					entitySelection_o.add($enregistrement_o)  // Je le mets en dur car c'est moi qui le défini sur chargement du formulaire
				End for each 
				
			End if 
			
		End if 
		
		ACCEPT:C269
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 