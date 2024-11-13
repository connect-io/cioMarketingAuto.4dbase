/* -----------------------------------------------------------------------------
Class : cs.MAPersonneDisplay

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAPersonneDisplay.constructor
	
Instanciation de la class MAPersonneDisplay
	
Historique
15/04/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $class_o : cs:C1710.MarketingAutomation
	
	$class_o:=cs:C1710.MarketingAutomation.new()  // Instanciation de la class
	$class_o.loadPasserelle("Personne")
	
Function updateScenarioListToPerson()->$scenario_es : Object
/* -----------------------------------------------------------------------------
Fonction : MAPersonneDisplay.updateScenarioListToPerson
	
Retourne la liste des scénarios d'une personne
	
Historique
15/04/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $class_o : Object
	
	$scenario_es:=ds:C1482["CaScenario"].newSelection()
	
	$class_o:=cmaToolGetClass("MAPersonne").new()
	$class_o.loadByPrimaryKey(Form:C1466.personneDetail.UID)
	
	If ($class_o.personne#Null:C1517)
		$scenario_es:=$class_o.personne.AllCaPersonneScenario.OneCaScenario
	End if 
	
Function updateStringPersonneForm($personne_o : Object)
/* -----------------------------------------------------------------------------
Fonction : MAPersonneDisplay.updateStringPersonneForm
	
Mets à jour une chaine de caractère suivant les infos de la personne chargée
	
Historique
15/04/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $civilite_t : Text
	var $table_o; $class_o : Object
	var $libHomme_v; $libFemme_v : Variant
	
	$libHomme_v:=Storage:C1525.automation.passerelle.libelleSexe.query("lib = :1"; "homme")[0].value
	$libFemme_v:=Storage:C1525.automation.passerelle.libelleSexe.query("lib = :1"; "femme")[0].value
	
	Case of 
		: ($personne_o.sexe=$libHomme_v)
			$civilite_t:="Mr."
		: ($personne_o.sexe=$libFemme_v)
			$civilite_t:="Mme."
	End case 
	
	Case of 
		: (Num:C11($personne_o.modeSelection)=1) | (Num:C11($personne_o.modeSelection)=2) & (Bool:C1537($personne_o.multiSelection)=False:C215)  // Sélection unique OU Sélection multi-lignes mais qu'une seule ligne sélectionnée
			$personne_o.resume:=Choose:C955($civilite_t#""; $civilite_t+" "; "")+String:C10($personne_o.nom)+" "+String:C10($personne_o.prenom)+", habite à "+String:C10($personne_o.ville)+" ("+String:C10($personne_o.codePostal)+")."+Char:C90(Line feed:K15:40)
			
			$personne_o.resume:=$personne_o.resume+"• Adresse email : "+String:C10($personne_o.eMail)+Char:C90(Line feed:K15:40)
			$personne_o.resume:=$personne_o.resume+"• Téléphone fixe : "+String:C10($personne_o.telFixe)+Char:C90(Line feed:K15:40)
			$personne_o.resume:=$personne_o.resume+"• Téléphone portable : "+String:C10($personne_o.telMobile)
			
			$class_o:=cmaToolGetClass("MAPersonne").new()
			$class_o.loadByPrimaryKey($personne_o.UID)
			
			If ($class_o.personne#Null:C1517)
				$table_o:=$class_o.personne.AllCaPersonneMarketing
				
				If (Num:C11($table_o.length)=1)
					$table_o:=$table_o.first()
					
					Case of 
						: ($table_o.rang=1)
							$personne_o.resumeMarketing:="• Rang : suspect"
						: ($table_o.rang=2)
							$personne_o.resumeMarketing:="• Rang : prospect"
						: ($table_o.rang=3)
							$personne_o.resumeMarketing:="• Rang : client"
						: ($table_o.rang=4)
							$personne_o.resumeMarketing:="• Rang : client fidèle"
						: ($table_o.rang=5)
							$personne_o.resumeMarketing:="• Rang : ambassadeur"
					End case 
					
					$personne_o.resumeMarketing:=$personne_o.resumeMarketing+Char:C90(Line feed:K15:40)
					$personne_o.resumeMarketing:=$personne_o.resumeMarketing+"Dernière(s) activité(s) des mails envoyés :"+Char:C90(Line feed:K15:40)
					
					If ($table_o.lastOpened#0)
						$personne_o.resumeMarketing:=$personne_o.resumeMarketing+"• Dernier mail ouvert : "+cmaTimestampLire("date"; $table_o.lastOpened)+Char:C90(Line feed:K15:40)
					Else 
						$personne_o.resumeMarketing:=$personne_o.resumeMarketing+"• Aucun email ouvert"+Char:C90(Line feed:K15:40)
					End if 
					
					If ($table_o.lastClicked#0)
						$personne_o.resumeMarketing:=$personne_o.resumeMarketing+"• Dernier mail cliqué : "+cmaTimestampLire("date"; $table_o.lastClicked)+Char:C90(Line feed:K15:40)
					Else 
						$personne_o.resumeMarketing:=$personne_o.resumeMarketing+"• Aucun email cliqué"+Char:C90(Line feed:K15:40)
					End if 
					
					If ($table_o.lastBounce#0)
						$personne_o.resumeMarketing:=$personne_o.resumeMarketing+"• Email détecté en bounce le : "+cmaTimestampLire("date"; $table_o.lastBounce)+Char:C90(Line feed:K15:40)
					Else 
						$personne_o.resumeMarketing:=$personne_o.resumeMarketing+"• Aucun bounce"+Char:C90(Line feed:K15:40)
					End if 
					
					If ($table_o.desabonementMail=True:C214)
						$personne_o.resumeMarketing:=$personne_o.resumeMarketing+"• Désabonnement souhaité"
					Else 
						$personne_o.resumeMarketing:=$personne_o.resumeMarketing+"• Aucune demande de désabonnement"
					End if 
					
				Else 
					$personne_o.resumeMarketing:="Aucune donnée disponible"
				End if 
				
			Else 
				$personne_o.resumeMarketing:="La personne n'a pas pu être retrouver dans votre base de donnée."
			End if 
			
		: (Num:C11($personne_o.modeSelection)=2) & (Bool:C1537($personne_o.multiSelection)=True:C214)  // Sélection multi-lignes
			$personne_o.resume:="Aperçu indisponible plusieurs personnes sélectionnées"
			$personne_o.resumeMarketing:="Aperçu indisponible plusieurs personnes sélectionnées"
	End case 
	
Function viewPersonList($formScenario_o : Object)
/* -----------------------------------------------------------------------------
Fonction : MAPersonneDisplay.updateStringPersonneForm
	
Suivant la provenance, on charge différentes entitySelection dans le formulaire
gestionPersonne
	
Historique
15/04/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $i_el : Integer
	var $continue_b; $companyName_b : Boolean
	var $table_o; $enregistrement_o : Object
	var $column_c : Collection
	
	var entitySelection_o : Object
	
	$column_c:=New collection:C1472("nom"; "prenom"; "eMail"; "nomComplet"; "UID")
	
	If ($formScenario_o.donnee.scenarioDetail#Null:C1517)
		
		If ($formScenario_o.donnee.scenarioDetail.configuration#Null:C1517)
			$companyName_b:=$formScenario_o.donnee.scenarioDetail.configuration.companyNameInPersonList
		End if 
		
	End if 
	
	//$class_o:=cmaToolGetClass("MAPersonneSelection").new()  // Instanciation de la class
	entitySelection_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].newSelection()
	
	Case of 
		: ($formScenario_o.entree=1)  // Gestion du scénario (Personne possible)
			
			If ($formScenario_o.donnee.scenarioPersonnePossibleEntity#Null:C1517)  // On souhait voir les personnes possiblement applicable à un scénario
				//$class_o.fromEntitySelection($1.donnee.scenarioPersonnePossibleEntity)
				$table_o:=$formScenario_o.donnee.scenarioPersonnePossibleEntity
				$continue_b:=True:C214
			End if 
			
			OBJECT SET ENABLED:C1123(*; "supprimerScenarioEnCours"; False:C215)
			
			If ($formScenario_o.donnee.scenarioSelectionPossiblePersonne#Null:C1517) & ($formScenario_o.personne#Null:C1517)
				
				For each ($enregistrement_o; $formScenario_o.personne)
					$table_o:=$formScenario_o.donnee.scenarioSelectionPossiblePersonne.get($enregistrement_o.getKey())
					
					If ($table_o=Null:C1517)
						LISTBOX SELECT ROW:C912(*; "listePersonne"; $formScenario_o.personne.indexOf($enregistrement_o)+1; lk add to selection:K53:2)
					End if 
					
				End for each 
				
			End if 
			
			LISTBOX SET PROPERTY:C1440(*; "listePersonne"; lk selection mode:K53:35; lk multiple:K53:59)
		: ($formScenario_o.entree=2)  // Gestion du scénario (Personne en cours)
			
			If ($formScenario_o.donnee.scenarioPersonneEnCoursEntity#Null:C1517)  // On souhait voir les personnes où le scénario est déjà appliqué
				//$class_o.fromEntitySelection($1.donnee.scenarioPersonneEnCoursEntity)
				$table_o:=$formScenario_o.donnee.scenarioPersonneEnCoursEntity
				$continue_b:=True:C214
			End if 
			
		: ($formScenario_o.entree=3)  // Gestion des personnes (Sans passer par Gestion du scénario)
			$table_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].all()
			$continue_b:=True:C214
		: ($formScenario_o.entree=4)  // Gestion de la scène (Personne en cours)
			
			If ($formScenario_o.donnee.scenePersonneEnCoursEntity#Null:C1517)  // On souhait voir les personnes où la scène est en cours d'éxécution
				//$class_o.fromEntitySelection($1.donnee.scenePersonneEnCoursEntity)
				$table_o:=$formScenario_o.donnee.scenePersonneEnCoursEntity
				$continue_b:=True:C214
			End if 
			
		: ($formScenario_o.entree=5)  // Affichage des scénarios d'une sélection particulière de personne (Sans passer par Gestion du scénario)
			$table_o:=$formScenario_o.entitySelection.copy()
			$continue_b:=True:C214
	End case 
	
	If ($table_o=Null:C1517)
		$table_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].newSelection()
	End if 
	
	If ($continue_b=True:C214)
		//$class_o.toCollectionAndExtractField(Créer collection("UID"; "sexe"; "nom"; "prenom"; "codePostal"; "ville"; "eMail"; "telFixe"; "telMobile"))
		
		//Form.personneCollectionInit:=$class_o.personneCollection
		//$1.personneCollection:=$class_o.personneCollection
		//Form.personneCollectionInit:=$class_o.personneSelection
		//$1.personneCollection:=$class_o.personneSelection
		
		Form:C1466.personneCollectionInit:=$table_o.copy()
		
		For ($i_el; 1; $column_c.length)
			LISTBOX SET COLUMN FORMULA:C1203(*; cmaToolMajuscFirstChar($column_c[$i_el-1]); "This."+Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; $column_c[$i_el-1]); Is text:K8:3)
			
			If ($companyName_b=True:C214) & ($column_c[$i_el-1]="nom")
				LISTBOX SET COLUMN FORMULA:C1203(*; cmaToolMajuscFirstChar($column_c[$i_el-1]); "This."+Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "nomCompagnie"); Is text:K8:3)
			End if 
			
		End for 
		
		$formScenario_o.personneCollection:=Form:C1466.personneCollectionInit.copy()
	End if 