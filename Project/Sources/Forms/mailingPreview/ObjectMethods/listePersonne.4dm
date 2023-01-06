If (Form event code:C388=On Double Clicked:K2:5)
	var $class_o : Object
	
	$class_o:=cmaToolGetClass("MAPersonne").new()
	$class_o.loadByPrimaryKey(Form:C1466.PersonneCurrentElement.UID)
	
	If ($class_o.personne#Null:C1517)
		$class_o.loadPersonDetailForm()  // Affichage du détail de la table [Personne] de la base hôte
		
		If (OK=1)
			Form:C1466.MAPersonneSelection.personneSelection.refresh()
			Form:C1466.MAPersonneSelection.toCollectionAndExtractField(New collection:C1472("nom"; "prenom"; "eMail"; "UID"))
			Form:C1466.personneCollectionInit:=Form:C1466.MAPersonneSelection.personneCollection.copy()
			
			Form:C1466.MAPersonneSelection.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageFilter()
			Form:C1466.MAPersonneSelection.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageSort("")
		End if 
		
	End if 
	
End if 