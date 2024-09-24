var $marketingAutomation_cs : Object

Case of 
	: (Form event code:C388=On Load:K2:1)
		$marketingAutomation_cs:=cmaToolGetClass("MarketingAutomation").new(True:C214)
		
		Form:C1466.MAPersonneSelection:=cmaToolGetClass("MAPersonneSelection").new()
		Form:C1466.MAPersonneSelection.fromEntitySelection(Form:C1466.entitySelection)
		
		Form:C1466.MAPersonneSelection.toCollectionAndExtractField(New collection:C1472("nom"; "prenom"; "eMail"; "telMobile"; "adresse"; "codePostal"; "ville"; "UID"))
		Form:C1466.personneCollectionInit:=Form:C1466.MAPersonneSelection.personneCollection.copy()
		
		// Instanciation de la class pour la gestion des filtres
		Form:C1466.personneSelectionDisplayClass:=cmaToolGetClass("MAPersonneSelectionDisplay").new()
		
		Form:C1466.imageSortNom:=Storage:C1525.automation.image["sort"]
		Form:C1466.imageSortPrenom:=Storage:C1525.automation.image["sort"]
		Form:C1466.imageSortEMail:=Storage:C1525.automation.image["sort"]
		
		Form:C1466.imageTrash:=Storage:C1525.automation.image["trash"]
		
		Form:C1466.rowHeight:=0
		Form:C1466.pieceJointe:=New collection:C1472
		
		OBJECT SET VISIBLE:C603(*; "Texte5"; False:C215)
		OBJECT SET VISIBLE:C603(*; "modele"; False:C215)
		
		OBJECT SET VISIBLE:C603(*; "WPtoolbar"; False:C215)
		OBJECT SET VISIBLE:C603(*; "WParea"; False:C215)
		
		WParea:=WP New:C1317()
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.MAPersonneSelection.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageFilter()
		Form:C1466.MAPersonneSelection.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageSort("")
End case 