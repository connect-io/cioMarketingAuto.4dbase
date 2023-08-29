var $class_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$class_o:=cmaToolGetClass("MAPersonne").new()
		$class_o.loadByPrimaryKey(Form:C1466.PersonneCurrentElement[Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "UID")])
		
		If ($class_o.personne#Null:C1517)
			$class_o.loadPersonDetailForm()  // Affichage du détail de la table [Personne] de la base hôte
		Else 
			ALERT:C41("Impossible de trouver la personne dans la base de données (ID : "+String:C10(Form:C1466.PersonneCurrentElement[Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "UID")])+")")
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 