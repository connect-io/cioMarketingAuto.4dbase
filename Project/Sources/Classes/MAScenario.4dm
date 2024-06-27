/* -----------------------------------------------------------------------------
Class : cs.MAScenario

-----------------------------------------------------------------------------*/

Class constructor($entitySelectionToKeep_o : Object)
/*-----------------------------------------------------------------------------
Fonction : MAScenario.constructor
	
Instanciation de la class MAScenario
	
Historique
15/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	This:C1470.scenario:=ds:C1482["CaScenario"].newSelection()
	This:C1470.scenarioDetail:=New object:C1471()
	
	// Modifié par : Rémy Scanu (10/05/2021)
	If ($entitySelectionToKeep_o#Null:C1517)
		This:C1470.personneSelection:=$entitySelectionToKeep_o
	End if 
	
Function newScenario($nom_t : Text; $condition_o : Object)->$return_b : Boolean
	var $caScenario_o; $retour_o : Object
	
	$caScenario_o:=ds:C1482["CaScenario"].new()
	$caScenario_o.nom:=$nom_t
	
	If ($caScenario_o.nom="")
		$caScenario_o.nom:="Nouveau scénario"
	End if 
	
	$caScenario_o.actif:=True:C214
	$caScenario_o.condition:=New object:C1471("ageMinimum"; 0; "ageMaximum"; 0; "rang"; 0; "dateDebutMailClique"; !00-00-00!; "dateFinMailClique"; !00-00-00!; "dateDebutMailOuvert"; !00-00-00!; "dateFinMailOuvert"; !00-00-00!)
	$caScenario_o.configuration:=New object:C1471("companyNameInPersonList"; False:C215)
	
	If ($condition_o#Null:C1517)
		$caScenario_o.condition:=cmaToolObjectMerge($caScenario_o.condition; $condition_o)
	End if 
	
	$retour_o:=$caScenario_o.save()
	
	If ($retour_o.success=True:C214)
		This:C1470.scenarioDetail:=$caScenario_o
	End if 
	
	$return_b:=$retour_o.success
	
Function loadAllScenario
	This:C1470.scenario:=ds:C1482["CaScenario"].all().orderBy("nom asc")
	
Function loadScenarioDisplay($scenarioID_t : Text)
	
	If (Count parameters:C259=0)
		This:C1470.loadAllScenario()
	Else 
		This:C1470.loadByPrimaryKey($scenarioID_t)
		
		This:C1470.disabledCreateDeleteScenarioButton:=True:C214
	End if 
	
	cwToolWindowsForm("gestionScenario"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 90); This:C1470)
	
Function loadByPrimaryKey($id_t : Text)
	
	This:C1470.scenario:=ds:C1482["CaScenario"].query("ID is :1"; $id_t)
	
	If (This:C1470.scenario.length=1)
		This:C1470.scenarioDetail:=This:C1470.scenario[0]
	Else 
		This:C1470.scenarioDetail:=Null:C1517
	End if 
	
Function searchPersonToScenario($provenance_el : Integer)
	var $lib_t : Text
	var $ts_el : Integer
	var $condition_o; $personne_o; $personneAEnlever_o; $table_o; $statut_o; $class_o : Object
	var $cleValeur_c : Collection
	
	$class_o:=cmaToolGetClass("MAPersonneSelection").new()
	
	// Modifié par : Rémy Scanu (10/05/2021)
	If (This:C1470.personneSelection#Null:C1517)
		$class_o.fromEntitySelection(This:C1470.personneSelection)
	Else 
		$class_o.loadAll()
	End if 
	
	$personne_o:=$class_o.personneSelection
	$personneAEnlever_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].newSelection()
	
	Case of 
		: ($provenance_el=1) | ($provenance_el=2)  // Gestion du scénario OU Après application d'un scénario à des personnes
			
			If (This:C1470.scenarioDetail#Null:C1517)
				$condition_o:=This:C1470.scenarioDetail.condition
				
				If ($provenance_el=2)  // Application d'un scénario à des personnes
					// On est obligé de sauver le scénartio sinon on n'aura pas les nouveaux enregistrements de la table [CaPersonneScenario]
					This:C1470.scenarioDetail.save()
					
					$statut_o:=This:C1470.scenarioDetail.reload()
				End if 
				
				$table_o:=This:C1470.scenarioDetail.AllCaPersonneScenario
				
				If ($table_o.length>0)
					$personneAEnlever_o:=$table_o.OnePersonne
				End if 
				
			End if 
			
	End case 
	
	If ($condition_o#Null:C1517)
		$cleValeur_c:=OB Entries:C1720($condition_o)
		
		For each ($cleValeur_o; $cleValeur_c)
			
			Case of 
				: ($cleValeur_o.key="ageMinimum")
					$lib_t:=Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "dateNaissance")
					
					If ($cleValeur_o.value#0)
						$table_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].query($lib_t+" <= :1"; cwToolNumToDate($cleValeur_o.value; "year"; "less"))
						
						$personne_o:=$personne_o.and($table_o)  // Première propriété de ma collection d'objet $cleValeur_c
					End if 
					
				: ($cleValeur_o.key="ageMaximum")
					$lib_t:=Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "dateNaissance")
					
					If ($cleValeur_o.value#0)
						$table_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].query($lib_t+" >= :1"; cwToolNumToDate($cleValeur_o.value; "year"; "less"))
						
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="dateDebutMailClique")
					
					If ($cleValeur_o.value#!00-00-00!)
						$ts_el:=cmaTimestamp($cleValeur_o.value; ?00:00:00?)
						
						$table_o:=ds:C1482["CaPersonneMarketing"].query("lastClicked # :1 AND lastClicked >= :2"; 0; $ts_el).OnePersonne
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="dateFinMailClique")
					
					If ($cleValeur_o.value#!00-00-00!)
						$ts_el:=cmaTimestamp($cleValeur_o.value; ?23:59:59?)
						
						$table_o:=ds:C1482["CaPersonneMarketing"].query("lastClicked # :1 AND lastClicked <= :2"; 0; $ts_el).OnePersonne
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="dateDebutMailOuvert")
					
					If ($cleValeur_o.value#!00-00-00!)
						$ts_el:=cmaTimestamp($cleValeur_o.value; ?00:00:00?)
						
						$table_o:=ds:C1482["CaPersonneMarketing"].query("lastOpened # :1 AND lastOpened >= :2"; 0; $ts_el).OnePersonne
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="dateFinMailOuvert")
					
					If ($cleValeur_o.value#!00-00-00!)
						$ts_el:=cmaTimestamp($cleValeur_o.value; ?23:59:59?)
						
						$table_o:=ds:C1482["CaPersonneMarketing"].query("lastOpened # :1 AND lastOpened <= :2"; 0; $ts_el).OnePersonne
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="email")
					// Instanciation de la class
					$class_o:=cmaToolGetClass("MAPersonneSelection").new()
					$class_o.loadByField("eMail"; "#"; "")
					
					// Modifié par : Rémy Scanu (10/05/2021)
					If (This:C1470.personneSelection#Null:C1517)
						$class_o.personneSelection:=This:C1470.personneSelection.and($class_o.personneSelection)
					End if 
					
					If ($class_o.personneSelection.length>0)  // Des personnes de ma sélection ont bien un email
						
						If ($cleValeur_o.value=True:C214)  // Si dans les conditions, l'utisateur souhaite uniquement les personnes avec un email
							$personne_o:=$personne_o.and($class_o.personneSelection)
						Else 
							$personne_o:=$personne_o.minus($class_o.personneSelection)
						End if 
						
					Else 
						
						If ($cleValeur_o.value=True:C214)  // Si dans les conditions, l'utisateur souhaite uniquement les personnes avec un email
							$personne_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].newSelection()
						End if 
						
					End if 
					
				: ($cleValeur_o.key="rang")
					
					If ($cleValeur_o.value#0)
						$table_o:=ds:C1482["CaPersonneMarketing"].query("rang = :1"; $cleValeur_o.value).OnePersonne
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="sexe")
					$lib_t:=Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "sexe")
					$table_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].query($lib_t+" = :1"; $cleValeur_o.value)
					
					$personne_o:=$personne_o.and($table_o)
				: ($cleValeur_o.key="desabonnement")
					
					If ($cleValeur_o.value#Null:C1517)  // Si dans les conditions, l'utisateur souhaite ajouter un critère par rapport au statut de désabonnement
						$table_o:=ds:C1482["CaPersonneMarketing"].query("desabonementMail = :1"; $cleValeur_o.value).OnePersonne
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="sansScenario")
					
					If ($cleValeur_o.value#Null:C1517)  // Si dans les conditions, l'utisateur souhaite ajouter un critère lié à la précense d'un scénario
						$table_o:=ds:C1482["CaPersonneScenario"].all().OnePersonne
						
						If ($cleValeur_o.value=True:C214)  // Si l'utilisateur souhaite uniquement celle qui n'ont pas de scénario en cours
							$personne_o:=$personne_o.minus($table_o)
						Else 
							$personne_o:=$personne_o.and($table_o)
						End if 
						
					End if 
					
				: ($cleValeur_o.key="mailingMarketing")
					
					If ($cleValeur_o.value#Null:C1517)  // Si dans les conditions, l'utisateur souhaite ajouter un critère sur le booléen mailing Marketing présent dans la table [Personnes] du client
						$lib_t:=Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "mailingMarketing")
						$table_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].query($lib_t+" = :1"; $cleValeur_o.value)
						
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="sansIBAN")
					
					If ($cleValeur_o.value#Null:C1517)  // Si dans les conditions, l'utisateur souhaite ajouter un critère lié à l'IBAN
						$lib_t:=Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; "iban")
						
						If ($cleValeur_o.value=True:C214)  // Si l'utilisateur souhaite uniquement celle qui n'ont pas d'IBAN
							$table_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].query($lib_t+" = :1"; "")
						Else 
							$table_o:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].query($lib_t+" # :1"; "")
						End if 
						
						$personne_o:=$personne_o.and($table_o)
					End if 
					
			End case 
			
		End for each 
		
	End if 
	
	If ($personne_o.length>0)  // On va extraire celles et ceux qui ont déjà ce scénario affecté
		$personne_o:=$personne_o.minus($personneAEnlever_o)
	End if 
	
	This:C1470.scenarioPersonnePossibleEntity:=$personne_o
	This:C1470.scenarioPersonneEnCoursEntity:=$personneAEnlever_o
	
Function applyScenarioToPerson
	var $enregistrement_o; $caPersonneScenario_o; $retour_o : Object
	
	If (This:C1470.scenarioSelectionPossiblePersonne#Null:C1517)
		
		For each ($enregistrement_o; This:C1470.scenarioSelectionPossiblePersonne)
			$caPersonneScenario_o:=ds:C1482["CaPersonneScenario"].new()
			
			$caPersonneScenario_o.personneID:=$enregistrement_o.getKey()
			$caPersonneScenario_o.scenarioID:=This:C1470.scenarioDetail.getKey()
			
			$caPersonneScenario_o.actif:=This:C1470.scenarioDetail.actif
			
			// Modifié par : Rémy Scanu (19/05/2021)
			// Je commente ça pour le moment...
			//Si ($caPersonneScenario_o.actif=Vrai)
			//$table_o:=$enregistrement_o.AllCaPersonneScenario.query("actif = :1"; Vrai)
			
			//$caPersonneScenario_o.actif:=($table_o.length=0)
			//Fin de si 
			
			$retour_o:=$caPersonneScenario_o.save()
		End for each 
		
		This:C1470.updateStringScenarioForm(2)  // On met à jour les deux variables qui indiquent les différentes applications possibles et en cours pour le scénario X
	End if 
	
Function deleteScenarioToPerson($personneID_v : Variant; $scenarioID_t : Text)->$return_b : Boolean
	var $table_o; $statut_o : Object
	
	$table_o:=ds:C1482["CaPersonneScenario"].query("personneID is :1 AND scenarioID is :2"; $personneID_v; $scenarioID_t)
	
	If (Num:C11($table_o.length)=1)
		$statut_o:=$table_o.first().drop()
		$return_b:=$statut_o.success
	End if 
	
Function loadImageScenarioCondition
	var $lib_v : Variant
	
	$lib_v:=Storage:C1525.automation.passerelle.libelleSexe.query("lib = :1"; "femme")[0].value
	
	This:C1470.imageMale:=Storage:C1525.automation.image["male"]
	This:C1470.imageFemale:=Storage:C1525.automation.image["female"]
	This:C1470.imageMaleFemale:=Storage:C1525.automation.image["male-female-clicked"]
	
	This:C1470.imageEmail:=Storage:C1525.automation.image["toggle"]
	This:C1470.imageDesabonnement:=Storage:C1525.automation.image["toggle"]
	This:C1470.imageSansScenario:=Storage:C1525.automation.image["toggle"]
	This:C1470.imageMailingMarketing:=Storage:C1525.automation.image["toggle"]
	This:C1470.imageSansIBAN:=Storage:C1525.automation.image["toggle"]
	
	If (This:C1470.scenarioDetail.condition.sexe#Null:C1517)
		
		If (This:C1470.scenarioDetail.condition.sexe=$lib_v)  // Il s'agit d'une condition sexe = femme
			This:C1470.imageFemale:=Storage:C1525.automation.image["female-clicked"]
		Else 
			This:C1470.imageMale:=Storage:C1525.automation.image["male-clicked"]
		End if 
		
		This:C1470.imageMaleFemale:=Storage:C1525.automation.image["male-female"]
	End if 
	
	If (This:C1470.scenarioDetail.condition.email#Null:C1517)
		
		If (This:C1470.scenarioDetail.condition.email=True:C214)
			This:C1470.imageEmail:=Storage:C1525.automation.image["toggle-on"]
		Else 
			This:C1470.imageEmail:=Storage:C1525.automation.image["toggle-off"]
		End if 
		
	End if 
	
	If (This:C1470.scenarioDetail.condition.desabonnement#Null:C1517)
		
		If (Not:C34(This:C1470.scenarioDetail.condition.desabonnement)=True:C214)
			This:C1470.imageDesabonnement:=Storage:C1525.automation.image["toggle-on"]
		Else 
			This:C1470.imageDesabonnement:=Storage:C1525.automation.image["toggle-off"]
		End if 
		
	End if 
	
	If (This:C1470.scenarioDetail.condition.sansScenario#Null:C1517)
		
		If (This:C1470.scenarioDetail.condition.sansScenario=True:C214)
			This:C1470.imageSansScenario:=Storage:C1525.automation.image["toggle-on"]
		Else 
			This:C1470.imageSansScenario:=Storage:C1525.automation.image["toggle-off"]
		End if 
		
	End if 
	
	If (This:C1470.scenarioDetail.condition.mailingMarketing#Null:C1517)
		
		If (This:C1470.scenarioDetail.condition.mailingMarketing=True:C214)
			This:C1470.mailingMarketing:=Storage:C1525.automation.image["toggle-on"]
		Else 
			This:C1470.mailingMarketing:=Storage:C1525.automation.image["toggle-off"]
		End if 
		
	End if 
	
	If (This:C1470.scenarioDetail.condition.sansIBAN#Null:C1517)
		
		If (This:C1470.scenarioDetail.condition.sansIBAN=True:C214)
			This:C1470.imageSansIBAN:=Storage:C1525.automation.image["toggle-on"]
		Else 
			This:C1470.imageSansIBAN:=Storage:C1525.automation.image["toggle-off"]
		End if 
		
	End if 
	
Function loadImageScenarioConfiguration
	
	This:C1470.imageCompanyName:=Storage:C1525.automation.image["toggle-off"]
	
	If (This:C1470.scenarioDetail.configuration.companyNameInPersonList#Null:C1517)
		
		If (This:C1470.scenarioDetail.configuration.companyNameInPersonList=True:C214)
			This:C1470.imageCompanyName:=Storage:C1525.automation.image["toggle-on"]
		End if 
		
	End if 
	
Function updateStringScenarioForm($provenance_el : Integer)
	
	Case of 
		: ($provenance_el=1)  // Gestion du scénario
			This:C1470.searchPersonToScenario(1)
		: ($provenance_el=2)  // Application scénario à une sélection de personne
			This:C1470.searchPersonToScenario(2)
	End case 
	
	If ($provenance_el=1) | ($provenance_el=2)
		This:C1470.scenarioPersonnePossible:="Applicable à "+String:C10(This:C1470.scenarioPersonnePossibleEntity.length)+" personne(s)."
		
		If (This:C1470.scenarioSelectionPossiblePersonne#Null:C1517) & ($provenance_el=1)
			This:C1470.scenarioPersonnePossible:=This:C1470.scenarioPersonnePossible+Char:C90(Carriage return:K15:38)+String:C10(This:C1470.scenarioSelectionPossiblePersonne.length)+" personne(s) sélectionnée(s)."
		Else 
			This:C1470.scenarioPersonnePossible:=This:C1470.scenarioPersonnePossible+Char:C90(Carriage return:K15:38)+"0 personne sélectionnée."
			
			If (This:C1470.scenarioSelectionPossiblePersonne#Null:C1517)
				OB REMOVE:C1226(This:C1470; "scenarioSelectionPossiblePersonne")
			End if 
			
		End if 
		
		This:C1470.scenarioPersonneEnCours:="Appliqué à "+String:C10(This:C1470.scenarioPersonneEnCoursEntity.length)+" personne(s)."
	End if 
	
Function newScene($nom_t : Text; $action_t : Text)->$return_b : Boolean
	var $caScene_o; $retour_o : Object
	
	This:C1470.scenarioDetail.reload()
	$caScene_o:=ds:C1482["CaScene"].new()
	
	// Modifié par : Rémy Scanu (10/06/2021)
	// Je suis obligé d'attribuer un nouvel ID à la mano avec les imports possible de scénario sinon ça fou le bazarre dans l'index interne de 4D... vive les UUID moins de problème !
	$caScene_o.ID:=cmaToolGetNewID("CaScene"; "ID")
	$caScene_o.nom:=$nom_t
	
	If ($caScene_o.nom="")
		$caScene_o.nom:="Nouvelle scène"
	End if 
	
	$caScene_o.scenarioID:=This:C1470.scenarioDetail.getKey()
	$caScene_o.action:=$action_t
	
	If ($caScene_o.action="")
		$caScene_o.action:="Attente"
	End if 
	
	$caScene_o.numOrdre:=(This:C1470.scenarioDetail.AllCaScene.length)+1
	$caScene_o.paramAction:=New object:C1471("modele"; New object:C1471("email"; New object:C1471("version"; New collection:C1472); "sms"; New object:C1471("version"; New collection:C1472); "courrier"; New object:C1471("version"; New collection:C1472)))
	
	$caScene_o.conditionAction:=New object:C1471()
	$caScene_o.conditionSaut:=New object:C1471()
	
	$retour_o:=$caScene_o.save()
	
	If ($retour_o.success=True:C214)
		This:C1470.sceneDetail:=$caScene_o
	End if 
	
	$return_b:=$retour_o.success
	
Function updateStringSceneForm($provenance_el : Integer)
	This:C1470.scenePersonneEnCoursEntity:=ds:C1482[Storage:C1525.automation.passerelle.tableHote].newSelection()
	
	Case of 
		: ($provenance_el=1)  // Gestion du scénario (et donc de la scène)
			
			If (Num:C11(This:C1470.sceneDetail.AllCaScenarioEvent.length)>0)  // Il y a eu des logs pour cette scène
				This:C1470.scenePersonneEnCoursEntity:=This:C1470.sceneDetail.AllCaScenarioEvent.OneCaPersonneScenario.OnePersonne
			Else 
				This:C1470.scenePersonneEnCoursEntity:=This:C1470.sceneDetail.OneCaScenario.AllCaPersonneScenario.OnePersonne
			End if 
			
			If (This:C1470.sceneDetail.tsAttente=0)
				This:C1470.sceneSuivanteDelai:="0"
				
				If (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="")
					This:C1470.sceneDetail.paramAction.echelleDelai:="minute(s)"
				End if 
				
			Else 
				
				Case of 
					: (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="minute(s)")
						This:C1470.sceneSuivanteDelai:=String:C10(Round:C94(This:C1470.sceneDetail.tsAttente/60; 0))
					: (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="jour(s)")
						This:C1470.sceneSuivanteDelai:=String:C10(Round:C94(This:C1470.sceneDetail.tsAttente/86400; 0))
					: (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="semaine(s)")
						This:C1470.sceneSuivanteDelai:=String:C10(Round:C94(This:C1470.sceneDetail.tsAttente/(86400*7); 0))
					: (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="mois(s)")
						This:C1470.sceneSuivanteDelai:=String:C10(Round:C94(This:C1470.sceneDetail.tsAttente/(86400*30); 0))
					: (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="année(s)")
						This:C1470.sceneSuivanteDelai:=String:C10(Round:C94(This:C1470.sceneDetail.tsAttente/(86400*365); 0))
				End case 
				
			End if 
			
	End case 
	
	This:C1470.scenePersonneEnCours:="Appliqué à "+String:C10(This:C1470.scenePersonneEnCoursEntity.length)+" personne(s)."
	
Function loadImageSceneActionCondition
	This:C1470.imageEmail:=Storage:C1525.automation.image["toggle"]
	
Function saveFileActionScene($scenarioID_t : Text; $sceneID_el : Integer; $writePro_o : Object; $extension_t : Text; $folderChoice_b : Boolean)
	var $texte_t; $chemin_t : Text
	var $continue_b : Boolean
	var $class_o : Object
	
	$texte_t:=WP Get text:C1575($writePro_o; wk expressions as source:K81:256)
	$chemin_t:=Get 4D folder:C485(Current resources folder:K5:16; *)+"cioMarketingAutomation"+Folder separator:K24:12+"scenario"+Folder separator:K24:12+$scenarioID_t+Folder separator:K24:12
	
	$class_o:=cmaToolGetClass("MarketingAutomation").new()
	
	$continue_b:=$class_o.createFolder($chemin_t)  // Création ou check du dossier scénario
	
	If ($continue_b=True:C214)  // Le dossier du scénario scenarioDetail.ID existe
		$chemin_t:=$chemin_t+String:C10($sceneID_el)+Folder separator:K24:12
		$continue_b:=$class_o.createFolder($chemin_t)  // Création ou check du dossier de la scène
	End if 
	
	If ($continue_b=True:C214)  // Le dossier de la scène sceneDetail.ID du scénario scenarioDetail.ID existe
		
		If ($folderChoice_b=False:C215)
			
			Case of 
				: ($extension_t="pdf")
					WP EXPORT DOCUMENT:C1337($writePro_o; $chemin_t+"action.pdf"; wk pdf:K81:315)
				: ($extension_t="word")
					WP EXPORT DOCUMENT:C1337($writePro_o; $chemin_t+"action.docx"; wk docx:K81:277)
				: ($extension_t="html")
					WP EXPORT DOCUMENT:C1337($writePro_o; $chemin_t+"action.html"; wk web page complete:K81:2)
				: ($extension_t="4wp")
					WP EXPORT DOCUMENT:C1337($writePro_o; $chemin_t+"action.4WP"; wk 4wp:K81:4)
			End case 
			
		Else 
			$chemin_t:=Select document:C905(System folder:C487(Desktop:K41:16); ".4wp"; " title"; File name entry:K24:17)
			
			If ($chemin_t#"")
				WP EXPORT DOCUMENT:C1337($writePro_o; document; wk 4wp:K81:4; wk normal:K81:7)
			End if 
			
		End if 
		
		ALERT:C41("L'action de la scène a été sauvegardé avec succès")
	Else 
		ALERT:C41("L'action de la scène n'a pas pu être sauvegardé")
	End if 