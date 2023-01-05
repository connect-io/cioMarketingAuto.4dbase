Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		Form:C1466.MAPersonneSelection:=cs:C1710.MAPersonneSelection().new()
		Form:C1466.MAPersonneSelection.fromEntitySelection(Form:C1466.entitySelection)
		
		Form:C1466.MAPersonneSelection.toCollectionAndExtractField(New collection:C1472("nom"; "prenom"; "eMail"; "UID"))
		Form:C1466.personneCollectionInit:=Form:C1466.MAPersonneSelection.personneCollection.copy()
		
		// Instanciation de la class pour la gestion des filtres
		Form:C1466.personneSelectionDisplayClass:=cmaToolGetClass("MAPersonneSelectionDisplay").new()
		
		Form:C1466.imageSortNom:=Storage:C1525.automation.image["sort"]
		Form:C1466.imageSortPrenom:=Storage:C1525.automation.image["sort"]
		Form:C1466.imageSortEMail:=Storage:C1525.automation.image["sort"]
	: (Form event code:C388=Sur données modifiées:K2:15)
		Form:C1466.MAPersonneSelection.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageFilter()
		Form:C1466.MAPersonneSelection.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageSort("")
End case 