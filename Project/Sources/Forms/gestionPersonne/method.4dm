var $version_c : Collection

Case of 
	: (Form event code:C388=On Load:K2:1)
		// Instanciation de la class pour la gestion des filtres
		Form:C1466.personneSelectionDisplayClass:=cmaToolGetClass("MAPersonneSelectionDisplay").new()
		
		Form:C1466.imageSortNom:=Storage:C1525.automation.image["sort"]
		Form:C1466.imageSortPrenom:=Storage:C1525.automation.image["sort"]
		Form:C1466.imageSortEMail:=Storage:C1525.automation.image["sort"]
		Form:C1466.imageSortNomComplet:=Storage:C1525.automation.image["sort"]
		
		If (Form:C1466.entree=Null:C1517)  // Affichage directement du formulaire sans passer par le formulaire de gestion des scénarios
			Form:C1466.entree:=3
		End if 
		
		If (Form:C1466.entree=1) | (Form:C1466.entree=2)  // Si gestion du scénario (personne possible) OU (personne sélectionnée)
			
			If (Form:C1466.donnee.scenarioDetail.configuration#Null:C1517)
				
				If (Form:C1466.donnee.scenarioDetail.configuration.companyNameInPersonList=True:C214)
					OBJECT SET TITLE:C194(*; "Texte1"; "Nom compagnie")
					OBJECT SET TITLE:C194(*; "Texte5"; "P̶r̶é̶n̶o̶m̶")
					
					OBJECT SET ENABLED:C1123(*; "filtrePrenom"; False:C215)
					OBJECT SET ENABLED:C1123(*; "Prenom"; False:C215)
					
					OBJECT SET PLACEHOLDER:C1295(*; "filtreNom"; "Connect IO")
				End if 
				
			End if 
			
		End if 
		
		Form:C1466.MAPersonneDisplay:=cmaToolGetClass("MAPersonneDisplay").new()
		Form:C1466.MAPersonneDisplay.viewPersonList(Form:C1466)
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET VISIBLE:C603(*; "personneDetailVoirStatutEnvoi"; (Form:C1466.SceneLogCurrentElement#Null:C1517))
		OBJECT SET ENABLED:C1123(*; "personneDetailVoirStatutEnvoi"; False:C215)
		
		If (Form:C1466.SceneLogCurrentElement#Null:C1517)
			$version_c:=Form:C1466.SceneCurrentElement.paramAction.modele.courrier.version.query("actif = :1"; True:C214)
			
			If ($version_c.length>0) && (Form:C1466.SceneLogCurrentElement.information="Impression d'un document") && ($version_c[0].expediteur="Maileva")
				OBJECT SET ENABLED:C1123(*; "personneDetailVoirStatutEnvoi"; True:C214)
			End if 
			
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageFilter()
		Form:C1466.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageSort("")
End case 