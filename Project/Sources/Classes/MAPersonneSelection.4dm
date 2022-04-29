/* -----------------------------------------------------------------------------
Class : cs.MAPersonneSelection

Class de gestion du marketing automation pour une entité Sélection [Personne]

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAPersonneSelection.constructor
	
Instanciation de la class MAPersonneSelection pour le marketing automotion
	
Historique
27/01/21 - RémyScanu <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	This:C1470.personneSelection:=Null:C1517
	
	// Chargement des éléments nécessaires au bon fonctionnement de la classe par rapport à la table [Personne] de la base hote.
	This:C1470.passerelle:=OB Copy:C1225(Storage:C1525.automation.config.passerelle.query("tableComposant = :1"; "Personne")[0])
	
Function loadAll
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.loadAll
	
Permet de sélectionner tous les enregistrements de la table [Personne]
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	This:C1470.personneSelection:=ds:C1482[This:C1470.passerelle.tableHote].all()
	
Function loadByField
	var $1 : Text  // Nom du champ
	var $2 : Text  // Signe de la recherche
	var $3 : Variant  // Valeur à rechercher
	
	var $table_o : Object
	var $field_c : Collection
	
	$field_c:=This:C1470.passerelle.champ.query("lib = :1"; $1)
	
	This:C1470.newSelection()  // Par défaut je ré-initialise la propriété
	
	If ($field_c.length=1)
		
		Case of 
			: ($field_c[0].personAccess#Null:C1517) & ($field_c[0].directAccess=Null:C1517)  // La recherche doit se faire directement sur la table [Personne] de la base hôte
				This:C1470.fieldName:=$field_c[0].personAccess
				This:C1470.fieldSignComparaison:=$2
				This:C1470.fieldValue:=$3
				
				This:C1470.personneSelection:=Formula from string:C1601("ds[\""+This:C1470.passerelle.tableHote+"\"].query(\""+This:C1470.fieldName+" "+This:C1470.fieldSignComparaison+" :1\";This.fieldValue)").call(This:C1470)
				
				OB REMOVE:C1226(This:C1470; "fieldName")
				OB REMOVE:C1226(This:C1470; "fieldSignComparaison")
				OB REMOVE:C1226(This:C1470; "fieldValue")
			: ($field_c[0].directAccess#Null:C1517)  // Il faut faire la recherche sur une table [Enfant]
				This:C1470.childFieldSignComparaison:=$2
				This:C1470.childFieldValue:=$3
				
				$table_o:=Formula from string:C1601($field_c[0].directAccess).call(This:C1470)
				
				If ($table_o.length>0)
					This:C1470.personneSelection:=$table_o[$field_c[0].valueReturn]
				End if 
				
				OB REMOVE:C1226(This:C1470; "childFieldValue")
				OB REMOVE:C1226(This:C1470; "childFieldSignComparaison")
		End case 
		
	Else 
		This:C1470.newSelection()
	End if 
	
Function loadPersonListForm
	cwToolWindowsForm("listePersonne"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); This:C1470)
	
Function fromEntitySelection($table_o : Object)
	This:C1470.personneSelection:=$table_o
	
Function fromListPersonCollection($collection_c : Collection)
	var $personne_o; $element_o : Object
	
	This:C1470.newSelection()
	
	For each ($element_o; $collection_c)
		$personne_o:=ds:C1482[This:C1470.passerelle.tableHote].get($element_o.UID)
		
		If ($personne_o#Null:C1517)
			This:C1470.personneSelection.add($personne_o)
		End if 
		
	End for each 
	
Function newSelection
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.newSelection
	
Permet de ré-initialiser l'entitySelection
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	This:C1470.personneSelection:=ds:C1482[This:C1470.passerelle.tableHote].newSelection()
	
Function sendMailing
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.sendMailing
	
Permet d'envoyer un mailing à une entitySelection
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $canalEnvoi_t; $corps_t; $mime_t; $propriete_t; $contenu_t : Text
	var $statut_b : Boolean
	var $class_o; $config_o; $mime_o; $statut_o; $enregistrement_o; $personne_o; $compteur_o; $wpVar_o; $document_o; $signature_o : Object
	
	ASSERT:C1129(This:C1470.personneSelection#Null:C1517; "Impossible d'utiliser la fonction sendMailing sans une sélection de personne de définie.")
	
	// Instanciation de la class
	$class_o:=cmaToolGetClass("MAMailing").new()
	
	// On détermine le canal d'envoi du mailing
	$canalEnvoi_t:=$class_o.sendGetType()
	
	If ($canalEnvoi_t#"")
		// On configure correctement le mailing
		$config_o:=$class_o.sendGetConfig($canalEnvoi_t)
		
		If ($config_o.success=True:C214)
			cwToolWindowsForm("gestionDocument"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); New object:C1471("entree"; 1))  // On récupère le contenu
			$compteur_o:=New object:C1471("success"; 0; "fail"; 0)
			
			cmaProgressBar(0; "Initialisation"; True:C214)
			
			For each ($enregistrement_o; This:C1470.personneSelection)
				cmaProgressBar(($enregistrement_o.indexOf(This:C1470.personneSelection)/This:C1470.personneSelection.length); "Envoi du mailing en cours...")
				
				$personne_o:=cmaToolGetClass("MAPersonne").new()
				$personne_o.loadByPrimaryKey($enregistrement_o.getKey())
				
				If ($personne_o.personne#Null:C1517)
					$statut_b:=True:C214
					
					// Modifié par : Rémy Scanu (21/05/2021)
					// Permet d'instancier la variable wpVar_o utilisée dans les documents 4WPRO créé depuis le composant
					$wpVar_o:=$personne_o.personne
					Formula from string:C1601("_cmaInit4WPVar(this)").call($wpVar_o)
					
					$document_o:=WP New:C1317(WParea)
					
					Case of 
						: ($canalEnvoi_t="Email")
							$corps_t:=WP Get text:C1575($document_o; wk expressions as value:K81:255)
							
							If ($corps_t#"")
								// toDo charger enregistrement pour table [Personne] de la base hôte
								
								If ($corps_t#"@<body@")  // Nouvelle façon d'envoyer des emails
									// Ajout de la signature
									$fichier_o:=File:C1566(Get 4D folder:C485(Current resources folder:K5:16; *)+"cioMarketingAutomation"+Folder separator:K24:12+"scene"+Folder separator:K24:12+"signatureEmail.4wp"; fk platform path:K87:2)
									
									If ($fichier_o.exists=True:C214)
										WP INSERT BREAK:C1413($document_o; wk paragraph break:K81:259; wk append:K81:179)
										
										$signature_o:=WP Import document:C1318($fichier_o.platformPath)
										WP INSERT DOCUMENT:C1411($document_o; $signature_o; wk append:K81:179)
									End if 
									
									WP EXPORT VARIABLE:C1319($document_o; $mime_t; wk mime html:K81:1)  // Mime export of Write Pro document
									$mime_o:=MAIL Convert from MIME:C1681($mime_t)
									
									For each ($propriete_t; $mime_o)
										$config_o.eMailConfig[$propriete_t]:=$mime_o[$propriete_t]
									End for each 
									
								Else 
									$config_o.eMailConfig.htmlBody:=$corps_t
								End if 
								
								$config_o.eMailConfig.to:=$personne_o.eMail
								$statut_o:=$config_o.eMailConfig.send()
								
								$contenu_t:=$config_o.eMailConfig.subject
								$statut_b:=(String:C10($statut_o.statusText)="ok@")
								
								If ($statut_b=True:C214)  // Statut de l'envoie du mail
									$compteur_o.success:=$compteur_o.success+1
								Else 
									$compteur_o.fail:=$compteur_o.fail+1
								End if 
								
							End if 
							
						: ($canalEnvoi_t="Courrier")
							WP PRINT:C1343($document_o; wk 4D Write Pro layout:K81:176)
							
							$compteur_o.success:=$compteur_o.success+1
						: ($canalEnvoi_t="SMS")
					End case 
					
					// S'il s'agit d'un Courrier ou SMS ou un mail qui possède un corps non vide, on rajoute l'historique de l'envoi
					If ($canalEnvoi_t#"Email") | (($canalEnvoi_t="Email") & ($corps_t#""))
						$personne_o.updateCaMarketingStatistic(3; New object:C1471("type"; $canalEnvoi_t; "contenu"; $contenu_t; "statut"; $statut_b))
					End if 
					
				End if 
				
				CLEAR VARIABLE:C89($contenu_t)
				CLEAR VARIABLE:C89($statut_b)
			End for each 
			
			cmaProgressBar(1; "arrêt")
			
			If ($compteur_o.success>0)
				ALERT:C41("Le mailing a bien été envoyé à "+String:C10($compteur_o.success)+" personne(s)")
			End if 
			
			If ($compteur_o.fail>0)
				ALERT:C41("Le mailing n'a pas pu être envoyé à "+String:C10($compteur_o.fail)+" personne(s)")
			End if 
			
			If ($compteur_o.success=0) & ($compteur_o.fail=0)
				ALERT:C41("Le mailing a été annulé !")
			End if 
			
		End if 
		
	End if 
	
Function toCollectionAndExtractField($field_c : Collection)
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.toCollectionAndExtractField
	
Permet de transformer l'entitySelection This.personneSelection à This.personneCollection suivant les propriétés voulues
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $field_t; $fieldExtract_t; $element_t; $chaineCompare_t : Text
	var $extractFieldChild : Boolean
	var $formule_o; $childElement_o; $element_o : Object
	var $collection_c; $extraField_c; $autreCollection_c : Collection
	
	$collection_c:=New collection:C1472
	$extraField_c:=New collection:C1472
	
	If ($field_c=Null:C1517)
		$field_c:=This:C1470.passerelle.champ.extract("lib")
	End if 
	
	For each ($field_t; $field_c)
		
		Case of 
			: (This:C1470.passerelle.champ[This:C1470.passerelle.champ.indices("lib = :1"; $field_t)[0]].personAccess#Null:C1517) & (This:C1470.passerelle.champ[This:C1470.passerelle.champ.indices("lib = :1"; $field_t)[0]].extractToCollection=Null:C1517)  // L'extraction doit se faire directement sur la table [Personne] de la base hôte
				
				If (String:C10(This:C1470.passerelle.champ[This:C1470.passerelle.champ.indices("lib = :1"; $field_t)[0]].personAccess)#"")
					$fieldExtract_t:=$fieldExtract_t+Char:C90(Double quote:K15:41)+String:C10(This:C1470.passerelle.champ[This:C1470.passerelle.champ.indices("lib = :1"; $field_t)[0]].personAccess)+Char:C90(Double quote:K15:41)+\
						"; "+Char:C90(Double quote:K15:41)+$field_t+Char:C90(Double quote:K15:41)
					
					If ($field_c.indexOf($field_t)#($field_c.length-1))
						$fieldExtract_t:=$fieldExtract_t+";"
					End if 
					
				End if 
				
			: (This:C1470.passerelle.champ[This:C1470.passerelle.champ.indices("lib = :1"; $field_t)[0]].extractToCollection#Null:C1517)  // Il faut faire l'extraction sur une table [Enfant]
				$extractFieldChild:=True:C214
				
				$collection_c.push(New object:C1471("field"; $field_t; "collectionToExtract"; Formula from string:C1601("This.personneSelection."+\
					String:C10(This:C1470.passerelle.champ[This:C1470.passerelle.champ.indices("lib = :1"; $field_t)[0]].extractToCollection.formule)).call(This:C1470)))
				
				$collection_c[$collection_c.length-1].fieldInRelation:=String:C10(This:C1470.passerelle.champ[This:C1470.passerelle.champ.indices("lib = :1"; $field_t)[0]].extractToCollection.fieldInRelation)
				$extraField_c.push($collection_c[$collection_c.length-1].fieldInRelation)
		End case 
		
	End for each 
	
	If ($extraField_c.length>0)
		$extraField_c:=$extraField_c.distinct()
		
		For each ($element_t; $extraField_c)
			$chaineCompare_t:="@"+$element_t+"@"
			
			If ($fieldExtract_t#$chaineCompare_t)
				$fieldExtract_t:=$fieldExtract_t+";"+Char:C90(Double quote:K15:41)+$element_t+Char:C90(Double quote:K15:41)+\
					"; "+Char:C90(Double quote:K15:41)+$element_t+Char:C90(Double quote:K15:41)+";"
			End if 
			
		End for each 
		
		// Il y a eu une extraction d'un champ en plus
		If (Substring:C12($fieldExtract_t; Length:C16($fieldExtract_t); 1)=";")
			$fieldExtract_t:=Substring:C12($fieldExtract_t; 0; Length:C16($fieldExtract_t)-1)
		End if 
		
	End if 
	
	$fieldExtract_t:=Replace string:C233($fieldExtract_t; ";;"; ";")
	//This.personneCollection:=Créer collection
	
	//LISTBOX FIXER FORMULE COLONNE(*; "Nom"; "This."+This.passerelle.champ[This.passerelle.champ.indices("lib = :1"; "nom")[0]].personAccess; Est un texte)
	//LISTBOX FIXER FORMULE COLONNE(*; "Prenom"; "This."+This.passerelle.champ[This.passerelle.champ.indices("lib = :1"; "prenom")[0]].personAccess; Est un texte)
	This:C1470.personneCollection:=Formula from string:C1601("This.personneSelection.toCollection().extract("+$fieldExtract_t+")").call(This:C1470)
	
	If ($extractFieldChild=True:C214)
		cmaProgressBar(0; "Initialisation"; True:C214)
		
		For each ($childElement_o; $collection_c)
			cmaProgressBar($collection_c.indexOf($childElement_o)/$collection_c.length; "Extraction du champ "+$childElement_o.field+" en cours...")
			
			For each ($element_o; This:C1470.personneCollection)
				
				If ($element_o[$childElement_o.field]=Null:C1517)  // Il s'agit d'un champ d'une table [Enfant]
					$autreCollection_c:=$childElement_o.collectionToExtract.query($childElement_o.fieldInRelation+" = :1"; $element_o[$childElement_o.fieldInRelation])
					
					Case of 
						: ($autreCollection_c.length=1)
							$element_o[$childElement_o.field]:=$autreCollection_c[0][$childElement_o.field]
						: ($autreCollection_c.length>1)
							$element_o[$childElement_o.field]:="Erreur plusieurs personnes avec le même attribut "+$childElement_o.fieldInRelation
						Else 
							$element_o[$childElement_o.field]:=""
					End case 
					
				End if 
				
			End for each 
			
		End for each 
		
		cmaProgressBar(1; "arrêt")
	End if 
	
Function updateCaMarketingStatistic
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.updateCaMarketingStatistic
	
Permet de mettre à jour la table marketing
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $progressBar_i : Integer
	var $class_o; $enregistrement_o : Object
	
	ASSERT:C1129(This:C1470.personneSelection#Null:C1517; "Impossible d'utiliser la fonction updateCaMarketingStatistic sans une sélection de personne de définie.")
	
	// Instanciation de la class
	$class_o:=cmaToolGetClass("MAPersonne").new()
	
	$progressBar_i:=Progress New
	
	For each ($enregistrement_o; This:C1470.personneSelection)
		$class_o.loadByPrimaryKey($enregistrement_o.getKey())
		
		If ($class_o.personne#Null:C1517)
			$class_o.updateCaMarketingStatistic(4)  // Je génère à la volée l'enregistrement dans la table [CaMarketing], s'il n'y a pas eu d'enregistrement
		End if 
		
		Progress SET PROGRESS($progressBar_i; ($enregistrement_o.indexOf(This:C1470.personneSelection)/This:C1470.personneSelection.length); "Mise à jour de la table CaMarketing en cours..."; True:C214)
	End for each 
	
	Progress QUIT($progressBar_i)