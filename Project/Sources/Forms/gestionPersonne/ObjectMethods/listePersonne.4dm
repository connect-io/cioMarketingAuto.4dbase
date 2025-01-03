If (Form event code:C388=Sur clic:K2:4) & (Form:C1466.PersonneCurrentElement#Null:C1517)
	Form:C1466.personneDetail:=Form:C1466.PersonneSelectedElement[0].toObject()
	
	For each ($element_t; New collection:C1472("nom"; "prenom"; "UID"; "sexe"; "codePostal"; "ville"; "eMail"; "telFixe"; "telMobile"))
		Form:C1466.personneDetail[$element_t]:=Form:C1466.personneDetail[Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; $element_t)]
	End for each 
	
	Form:C1466.personneDetail.modeSelection:=LISTBOX Get property:C917(*; "listePersonne"; lk mode de sélection:K53:35)
	
	If (Num:C11(Form:C1466.PersonneSelectedElement.length)>1)
		Form:C1466.personneDetail.multiSelection:=True:C214
	Else 
		Form:C1466.personneDetail.multiSelection:=False:C215
	End if 
	
	Form:C1466.MAPersonneDisplay.updateStringPersonneForm(Form:C1466.personneDetail)
	
	If (Num:C11(Form:C1466.PersonneSelectedElement.length)=1)  // S'il n'y a qu'une seule personne de sélectionner
		OBJECT SET ENABLED:C1123(*; "personneDetail@"; True:C214)  // Activation champ et listbox scenario et scène
		
		If (Form:C1466.entree=2)
			OBJECT SET ENABLED:C1123(*; "supprimerScenarioEnCours"; True:C214)  // Activation du bouton pour supprimer le scénario en cours
		End if 
		
	Else 
		Form:C1466.scenarioPersonne:=Null:C1517  // On Ré-initialise la ListBox des scénarios
	End if 
	
	Form:C1466.scenarioPersonne:=Form:C1466.MAPersonneDisplay.updateScenarioListToPerson()
Else 
	
	If (Form:C1466.personneDetail#Null:C1517)
		Form:C1466.personneDetail:=Null:C1517
		Form:C1466.scenarioPersonne:=Null:C1517
	End if 
	
	OBJECT SET ENABLED:C1123(*; "personneDetail@"; False:C215)  // Désactivation champ et listbox scenario et scène
	
	If (Num:C11(Form:C1466.entree)#2)  // Différent de gestion du scénario (Personne en cours)
		OBJECT SET ENABLED:C1123(*; "supprimerScenarioEnCours"; False:C215)  // Désactivation du bouton pour supprimer le scénario en cours tant qu'il n'y a pas de personne sélectionné
	Else 
		LISTBOX SET PROPERTY:C1440(*; "listePersonne"; lk mode de sélection:K53:35; lk multilignes:K53:59)
	End if 
	
End if 

Form:C1466.scene:=Null:C1517  // Dans tous les cas je dois réinitialiser mon entitySelection des scènes
Form:C1466.scenarioEvent:=Null:C1517  // Dans tous les cas je dois réinitialiser mon entitySelection des logs des scènes