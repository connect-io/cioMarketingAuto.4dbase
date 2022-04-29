var $class_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$class_o:=cmaToolGetClass("MAPersonne").new()
		$class_o.loadByPrimaryKey(Form:C1466.PersonneCurrentElement.UID)
		
		If ($class_o.personne#Null:C1517)
			$class_o.loadPersonDetailForm()  // Affichage du détail de la table [Personne] de la base hôte
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 