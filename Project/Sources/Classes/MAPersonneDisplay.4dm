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
	
Function updateScenarioListToPerson
/* -----------------------------------------------------------------------------
Fonction : MAPersonneDisplay.updateScenarioListToPerson
	
Retourne la liste des scénarios d'une personne
	
Historique
15/04/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $0 : Object
	
	var $class_o : Object
	
	$0:=ds:C1482.CaScenario.newSelection()
	
	$class_o:=cmaToolGetClass("MAPersonne").new()
	$class_o.loadByPrimaryKey(Form:C1466.PersonneCurrentElement.UID)
	
	If ($class_o.personne#Null:C1517)
		$0:=$class_o.personne.AllCaPersonneScenario.OneCaScenario
	End if 
	
Function updateStringPersonneForm
/* -----------------------------------------------------------------------------
Fonction : MAPersonneDisplay.updateStringPersonneForm
	
Mets à jour une chaine de caractère suivant les infos de la personne chargée
	
Historique
15/04/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $1 : Object  // Entity personne
	
	var $civilite_t : Text
	var $table_o; $class_o : Object
	var $libHomme_v; $libFemme_v : Variant
	
	$libHomme_v:=Storage:C1525.automation.passerelle.libelleSexe.query("lib = :1"; "homme")[0].value
	$libFemme_v:=Storage:C1525.automation.passerelle.libelleSexe.query("lib = :1"; "femme")[0].value
	
	Case of 
		: ($1.sexe=$libHomme_v)
			$civilite_t:="Mr."
		: ($1.sexe=$libFemme_v)
			$civilite_t:="Mme."
	End case 
	
	Case of 
		: (Num:C11($1.modeSelection)=1) | (Num:C11($1.modeSelection)=2) & (Bool:C1537($1.multiSelection)=False:C215)  // Sélection unique OU Sélection multi-lignes mais qu'une seule ligne sélectionnée
			$1.resume:=Choose:C955($civilite_t#""; $civilite_t+" "; "")+$1.nom+" "+$1.prenom+", habite à "+$1.ville+" ("+$1.codePostal+")."+Char:C90(Retour à la ligne:K15:40)
			
			$1.resume:=$1.resume+"• Adresse email : "+$1.eMail+Char:C90(Retour à la ligne:K15:40)
			$1.resume:=$1.resume+"• Téléphone fixe : "+$1.telFixe+Char:C90(Retour à la ligne:K15:40)
			$1.resume:=$1.resume+"• Téléphone portable : "+$1.telMobile
			
			$class_o:=cmaToolGetClass("MAPersonne").new()
			$class_o.loadByPrimaryKey($1.UID)
			
			If ($class_o.personne#Null:C1517)
				$table_o:=$class_o.personne.AllCaPersonneMarketing
				
				If (Num:C11($table_o.length)=1)
					$table_o:=$table_o.first()
					
					Case of 
						: ($table_o.rang=1)
							$1.resumeMarketing:="• Rang : suspect"
						: ($table_o.rang=2)
							$1.resumeMarketing:="• Rang : prospect"
						: ($table_o.rang=3)
							$1.resumeMarketing:="• Rang : client"
						: ($table_o.rang=4)
							$1.resumeMarketing:="• Rang : client fidèle"
						: ($table_o.rang=5)
							$1.resumeMarketing:="• Rang : ambassadeur"
					End case 
					
					$1.resumeMarketing:=$1.resumeMarketing+Char:C90(Retour à la ligne:K15:40)
					$1.resumeMarketing:=$1.resumeMarketing+"Dernière(s) activité(s) des mails envoyés :"+Char:C90(Retour à la ligne:K15:40)
					
					If ($table_o.lastOpened#0)
						$1.resumeMarketing:=$1.resumeMarketing+"• Dernier mail ouvert : "+cmaTimestampLire("date"; $table_o.lastOpened)+Char:C90(Retour à la ligne:K15:40)
					Else 
						$1.resumeMarketing:=$1.resumeMarketing+"• Aucun email ouvert"+Char:C90(Retour à la ligne:K15:40)
					End if 
					
					If ($table_o.lastClicked#0)
						$1.resumeMarketing:=$1.resumeMarketing+"• Dernier mail cliqué : "+cmaTimestampLire("date"; $table_o.lastClicked)+Char:C90(Retour à la ligne:K15:40)
					Else 
						$1.resumeMarketing:=$1.resumeMarketing+"• Aucun email cliqué"+Char:C90(Retour à la ligne:K15:40)
					End if 
					
					If ($table_o.lastBounce#0)
						$1.resumeMarketing:=$1.resumeMarketing+"• Email détecté en bounce le : "+cmaTimestampLire("date"; $table_o.lastBounce)+Char:C90(Retour à la ligne:K15:40)
					Else 
						$1.resumeMarketing:=$1.resumeMarketing+"• Aucun bounce"+Char:C90(Retour à la ligne:K15:40)
					End if 
					
					If ($table_o.desabonementMail=True:C214)
						$1.resumeMarketing:=$1.resumeMarketing+"• Désabonnement souhaité"
					Else 
						$1.resumeMarketing:=$1.resumeMarketing+"• Aucune demande de désabonnement"
					End if 
					
				Else 
					$1.resumeMarketing:="Aucune donnée disponible"
				End if 
				
			Else 
				$1.resumeMarketing:="La personne n'a pas pu être retrouver dans votre base de donnée."
			End if 
			
		: (Num:C11($1.modeSelection)=2) & (Bool:C1537($1.multiSelection)=True:C214)  // Sélection multi-lignes
			$1.resume:="Aperçu indisponible plusieurs personnes sélectionnées"
			$1.resumeMarketing:="Aperçu indisponible plusieurs personnes sélectionnées"
	End case 
	
Function viewPersonList
/* -----------------------------------------------------------------------------
Fonction : MAPersonneDisplay.updateStringPersonneForm
	
Suivant la provenance, on charge différentes entitySelection dans le formulaire
gestionPersonne
	
Historique
15/04/22 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $1 : Object  // Objet Form scénario
	
	var $i_el : Integer
	var $continue_b : Boolean
	var $table_o; $class_o; $enregistrement_o : Object
	var $column_c : Collection
	
	var entitySelection_o : Object
	
	$column_c:=New collection:C1472("nom"; "prenom"; "UID")
	
	//$class_o:=cmaToolGetClass("MAPersonneSelection").new()  // Instanciation de la class
	entitySelection_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].newSelection()
	
	Case of 
		: ($1.entree=1)  // Gestion du scénario (Personne possible)
			
			If ($1.donnee.scenarioPersonnePossibleEntity#Null:C1517)  // On souhait voir les personnes possiblement applicable à un scénario
				//$class_o.fromEntitySelection($1.donnee.scenarioPersonnePossibleEntity)
				$table_o:=$1.donnee.scenarioPersonnePossibleEntity
				
				$continue_b:=True:C214
			End if 
			
			OBJECT SET ENABLED:C1123(*; "supprimerScenarioEnCours"; False:C215)
			
			If ($1.donnee.scenarioSelectionPossiblePersonne#Null:C1517) & ($1.personne#Null:C1517)
				
				For each ($enregistrement_o; $1.personne)
					$table_o:=$1.donnee.scenarioSelectionPossiblePersonne.get($enregistrement_o.UID)
					
					If ($table_o=Null:C1517)
						LISTBOX SELECT ROW:C912(*; "listePersonne"; $1.personne.indexOf($enregistrement_o)+1; lk ajouter à sélection:K53:2)
					End if 
					
				End for each 
				
			End if 
			
			LISTBOX SET PROPERTY:C1440(*; "listePersonne"; lk mode de sélection:K53:35; lk multilignes:K53:59)
		: ($1.entree=2)  // Gestion du scénario (Personne en cours)
			
			If ($1.donnee.scenarioPersonneEnCoursEntity#Null:C1517)  // On souhait voir les personnes où le scénario est déjà appliqué
				//$class_o.fromEntitySelection($1.donnee.scenarioPersonneEnCoursEntity)
				$table_o:=$1.donnee.scenarioPersonneEnCoursEntity
				
				$continue_b:=True:C214
			End if 
			
		: ($1.entree=3)  // Gestion des personnes (Sans passer par Gestion du scénario)
			//$class_o.loadAll()
			$table_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].all()
			
			$continue_b:=True:C214
		: ($1.entree=4)  // Gestion de la scène (Personne en cours)
			
			If ($1.donnee.scenePersonneEnCoursEntity#Null:C1517)  // On souhait voir les personnes où la scène est en cours d'éxécution
				//$class_o.fromEntitySelection($1.donnee.scenePersonneEnCoursEntity)
				$table_o:=$1.donnee.scenePersonneEnCoursEntity
				
				$continue_b:=True:C214
			End if 
			
	End case 
	
	If ($continue_b=True:C214)
		//$class_o.toCollectionAndExtractField(Créer collection("UID"; "sexe"; "nom"; "prenom"; "codePostal"; "ville"; "eMail"; "telFixe"; "telMobile"))
		
		//Form.personneCollectionInit:=$class_o.personneCollection
		//$1.personneCollection:=$class_o.personneCollection
		//Form.personneCollectionInit:=$class_o.personneSelection
		//$1.personneCollection:=$class_o.personneSelection
		
		Form:C1466.personneCollectionInit:=$table_o.copy()
		
		For ($i_el; 1; $column_c.length)
			LISTBOX SET COLUMN FORMULA:C1203(*; cmaToolMajuscFirstChar($column_c[$i_el-1]); "This."+Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; $column_c[$i_el-1]); Est un texte:K8:3)
		End for 
		
		$1.personneCollection:=Form:C1466.personneCollectionInit.copy()
	End if 