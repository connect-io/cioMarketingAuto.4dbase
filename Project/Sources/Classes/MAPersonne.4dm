/* -----------------------------------------------------------------------------
Class : cs.MAPersonne

Class de gestion du marketing automation pour une entité [Personne]

------------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.constructor
	
Instanciation de la class MAPersonne pour le marketing automotion
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Clean code
------------------------------------------------------------------------------*/
	This:C1470.personne:=Null:C1517
	
	// Chargement des éléments nécessaires au bon fonctionnement de la classe par rapport à la table [Personne] de la base hote.
	This:C1470.passerelle:=OB Copy:C1225(Storage:C1525.automation.config.passerelle.query("tableComposant = :1"; "Personne")[0])
	
Function addScenario($scenarioName_t : Text; $externalReference_t : Text)->$retour_o : Object
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.addScenario
	
On vient lier la personne à un scénario
	
Historique
27/06/24 - Grégory Fromain <gregory@connect-io.fr> - Relecture de code
------------------------------------------------------------------------------*/
	var $scenario_o; $caPersonneMarketing_o : Object
	var $caPersonneScenario_o : Object
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction addScenario sans une personne de définie.")
	
	This:C1470.personne.reload()
	$scenario_o:=ds:C1482["CaScenario"].query("nom = :1"; $scenarioName_t)
	
	// On vient lier la personne à un scénario
	If ($scenario_o.length>0)
		$scenario_o:=$scenario_o.first()
		$caPersonneScenario_o:=ds:C1482["CaPersonneScenario"].new()
		
		$caPersonneScenario_o.personneID:=This:C1470.personne.getKey()
		$caPersonneScenario_o.scenarioID:=$scenario_o.getKey()
		
		$caPersonneScenario_o.actif:=$scenario_o.actif
		$caPersonneScenario_o.situation:=New object:C1471("detail"; New collection:C1472)
		
		If ($externalReference_t#"")
			
			For ($i; 1; $caPersonneScenario_o.OneCaScenario.AllCaScene.length)
				$caPersonneScenario_o.situation.detail.push(New object:C1471("scene"; $i; "externalReference"; $externalReference_t))
			End for 
			
		End if 
		
		$retour_o:=$caPersonneScenario_o.save()
		
		If ($retour_o.success=False:C215)
			return $retour_o
		End if 
		
	End if 
	
	If (This:C1470.personne.AllCaPersonneMarketing.length=0)
		$caPersonneMarketing_o:=ds:C1482["CaPersonneMarketing"].new()
		
		$caPersonneMarketing_o.personneID:=This:C1470.personne.getKey()
		$caPersonneMarketing_o.rang:=1  // 1 pour Suspect
		$caPersonneMarketing_o.historique:=New object:C1471("detail"; New collection:C1472)
		
		$retour_o:=$caPersonneMarketing_o.save()
	End if 
	
	return $retour_o
	
Function getFieldName($field_t : Text)->$fieldName_t : Text
	var $field_c : Collection
	
	$field_c:=This:C1470.passerelle.champ.query("lib = :1"; $field_t)
	
	If ($field_c.length=1)
		$fieldName_t:=String:C10($field_c[0].personAccess)
	End if 
	
Function load($field_c : Collection)
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.load
	
Charge le profil de la personne depuis la base hôte.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ré-écriture
-----------------------------------------------------------------------------*/
	var $formule_t : Text
	var $field_t : Text  // Lib du champ
	var $collectionField_c; $collection_c : Collection
	
	$collection_c:=New collection:C1472
	$collectionField_c:=New collection:C1472
	
	// On récupére la liste des champs que l'on souhaite intégrer à la personne.
	If (Count parameters:C259=0)
		$collectionField_c:=This:C1470.passerelle.champ.extract("lib")
	Else 
		$collectionField_c:=$field_c.copy()
	End if 
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser cette fonction sans une personne de définie.")
	ASSERT:C1129($collectionField_c.length#0; "Impossible de déterminer les champs d'une personne.")
	
	For each ($field_t; $collectionField_c)
		// On récupére la config du champs.
		$collection_c:=This:C1470.passerelle.champ.query("lib is :1"; $field_t)
		ASSERT:C1129($collection_c.length#0; "Fonction load (Class MAPersonne) : Impossible de trouver la configuration du champ : "+$field_t)
		
		// Reset de la formule.
		$formule_t:="This.personne"
		
		For each ($element_t; Split string:C1554($collection_c[0].personAccess; ".")) Until (This:C1470[$field_t]=Null:C1517)
			// On concaténe la formule.
			$formule_t:=$formule_t+"."+$element_t
			
			// On applique la formule et l'on fixe le résultat dans this.
			This:C1470[$field_t]:=Formula from string:C1601($formule_t).call(This:C1470)
			
			// Si This[$field_t] = null, on sort de la boucle.
		End for each 
		
	End for each 
	
Function loadByField($fieldName_t : Text; $signComparaison_t : Text; $value_v : Variant)
	var $table_o : Object
	var $field_c : Collection
	
	$field_c:=This:C1470.passerelle.champ.query("lib = :1"; $fieldName_t)
	
	This:C1470.personne:=Null:C1517  // Par défaut je ré-initialise la propriété
	
	If ($field_c.length=1)
		
		Case of 
			: ($field_c[0].personAccess#Null:C1517) & ($field_c[0].directAccess=Null:C1517)  // La recherche doit se faire directement sur la table [Personne] de la base hôte
				This:C1470.fieldName:=$field_c[0].personAccess
				This:C1470.fieldSignComparaison:=$signComparaison_t
				This:C1470.fieldValue:=$value_v
				
				$table_o:=Formula from string:C1601("ds[\""+This:C1470.passerelle.tableHote+"\"].query(\""+This:C1470.fieldName+" "+This:C1470.fieldSignComparaison+" :1\";This.fieldValue)").call(This:C1470)
				
				If ($table_o.length>0)
					This:C1470.personne:=$table_o.first()
					This:C1470.load()
				End if 
				
				OB REMOVE:C1226(This:C1470; "fieldName")
				OB REMOVE:C1226(This:C1470; "fieldSignComparaison")
				OB REMOVE:C1226(This:C1470; "fieldValue")
			: ($field_c[0].directAccess#Null:C1517)  // Il faut faire la recherche sur une table [Enfant]
				This:C1470.childFieldSignComparaison:=$signComparaison_t
				This:C1470.childFieldValue:=$value_v
				
				$table_o:=Formula from string:C1601($field_c[0].directAccess).call(This:C1470)
				
				If ($table_o.length>0)
					This:C1470.personne:=$table_o[0][$field_c[0].valueReturn]
					
					// Modifié par : Scanu Rémy (08/12/2022)
					// Pour certaines raisons il peut arriver que le lien avec une table [Enfant] soit cassée...
					If (This:C1470.personne#Null:C1517)
						This:C1470.load()
					End if 
					
				End if 
				
				OB REMOVE:C1226(This:C1470; "childFieldValue")
				OB REMOVE:C1226(This:C1470; "childFieldSignComparaison")
		End case 
		
	End if 
	
Function loadByChild($field_t : Text; $childField_t : Text; $childFieldValue_t : Text)->$isOk_b : Boolean
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.loadByChild
	
Retrouve le profil d'une personne depuis une recherche d'une table enfant.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Début de création
-----------------------------------------------------------------------------*/
	var $entityChild_o : Object
	var $formule_t : Text
	
	// 1/ Il faut faire un accès direct à l'entité. ("directAccess")
	This:C1470.childField:=$childField_t
	This:C1470.childFieldValue:=$childFieldValue_t
	
	$formule_t:=This:C1470.passerelle.champ.query("lib is :1"; $field_t)[0].directAccess
	$entityChild_o:=Formula from string:C1601($formule_t).call(This:C1470)
	
	// 2/ Puis il faut remonter vers la personne.
	$contentQuery_t:=This:C1470.passerelle.champ.query("lib is :1"; $field_t)[0].personAccess
	This:C1470.personne:=$entityChild_o.query($contentQuery_t)
	
	If (This:C1470.personne#Null:C1517)
		This:C1470.load()
		$isOk_b:=True:C214
	End if 
	
	// On supprime les deux propriétés nécessaires pour la recherche
	OB REMOVE:C1226(This:C1470; "childField")
	OB REMOVE:C1226(This:C1470; "childFieldValue")
	
Function loadByPrimaryKey($PersonneID_v : Variant)->$isOk_b : Boolean
/* -----------------------------------------------------------------------------
Fonction : MAPersonne.loadByPrimaryKey
	
Retrouve et charge le profil d'une personne via, sa clé primaire.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ré-écriture
-----------------------------------------------------------------------------*/
	This:C1470.personne:=ds:C1482[This:C1470.passerelle.tableHote].get($PersonneID_v)
	
	If (This:C1470.personne#Null:C1517)
		This:C1470.load()
		$isOk_b:=True:C214
	End if 
	
Function loadPersonDetailForm($primaryKey_v : Variant)
/* -----------------------------------------------------------------------------
Fonction : MAPersonne.loadPersonDetailForm
	
Permet de charger le formulaire détail dans la liste de la table [Personne]
	
Historique
01/02/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	cwToolWindowsForm("detailPersonne"; "center"; This:C1470)
	
Function mailjetIsPossible()->$isOk_b : Boolean
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.mailjetIsPossible
	
Permet de savoir si on peut envoi un email à This.personne
	
Historique
12/05/21 - Rémy Scanu <remy@connect-io.fr> -  Création
-----------------------------------------------------------------------------*/
	var $caPersonneMarketing_o : Object
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction mailjetIsPossible sans une personne de définie.")
	
	$caPersonneMarketing_o:=This:C1470.personne.AllCaPersonneMarketing
	
	If ($caPersonneMarketing_o.length=1)
		$caPersonneMarketing_o:=$caPersonneMarketing_o.first()
		
		If ($caPersonneMarketing_o.desabonementMail=False:C215) & ($caPersonneMarketing_o.lastBounce=0)
			$isOk_b:=True:C214
		End if 
		
	End if 
	
Function mailjetGetStat
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.mailjetGetStat
	
Remonte les informations de mailjet.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	var $class_o : Object
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction mailjetGetStat sans une personne de définie.")
	
	// Instanciation de la class
	$class_o:=cmaToolGetClass("MAMailjet").new()
	
	This:C1470.statMailjet:=$class_o.getStatistic(This:C1470.eMail)
	
Function mailjetGetDetailStat
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.mailjetGetDetailStat
	
Remonte les informations de mailjet.
	
Historique
03/02/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $1 : Text
	var ${2} : Text
	
	var $i_el : Integer
	var $class_o; $mailjet_o; $mailjetDetail_o; $personne_o : Object
	var $mailjetDetail_c : Collection
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction mailjetGetDetailStat sans une personne de définie.")
	
	// Instanciation de la class
	$class_o:=cmaToolGetClass("MAMailjet").new()
	
	// Instanciation de la class
	$personne_o:=cmaToolGetClass("MAPersonne").new()
	
	For ($i_el; 2; Count parameters:C259)
		$class_o.getMessageEvent(${$i_el}; 0; cmaTimestamp(Current date:C33; Current time:C178); ->$mailjet_o)
		
		If ($mailjet_o.errorHttp=Null:C1517)
			$class_o.AnalysisMessageEvent($mailjet_o; ${$i_el}; 0; cmaTimestamp(Current date:C33; Current time:C178); ->$mailjetDetail_c)
		End if 
		
		If ($1#"")
			$mailjetDetail_c:=$mailjetDetail_c.query("email = :1"; $1)
		End if 
		
		For each ($mailjetDetail_o; $mailjetDetail_c)
			// On vérifie que l'email trouvé est bien dans la base du client
			$personne_o.loadByField("eMail"; "="; $mailjetDetail_o.email)  // Initialisation de l'entité sélection de la table [Personne] du client
			
			If ($personne_o.personne#Null:C1517)  // On met à jour la table marketing avec les infos de mailjet
				$personne_o.updateCaMarketingStatistic(2; New object:C1471("eventNumber"; ${$i_el}; "eventTs"; Num:C11($mailjetDetail_o.tsEvent)))
			End if 
			
		End for each 
		
	End for 
	
Function sendMailing($configPreCharge_o : Object) : Object
	var $canalEnvoi_t; $corps_t; $mime_t; $propriete_t; $retour_t; $strategy_t : Text
	var $i_el : Integer
	var $erreur_b; $printSetting_b : Boolean
	var $date_d : Date
	var $time_t : Time
	var $class_o; $config_o; $mime_o; $statut_o; $wpVar_o; $fichier_o; $signature_o; $document_o; $entity_e; $param_o; $body_o; $externalReference_o : Object
	var $transporter_c; $detail_c; $context_c : Collection
	var $file_f : 4D:C1709.File
	
	var $formule_f : Object
	var $parameter_es : Object
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction sendMailing sans une personne de définie.")
	$param_o:=New object:C1471
	
	If (Count parameters:C259=0)  // Le mailing ne part pas en automatique, on sélectionne le canal d'envoi
		// Instanciation de la class
		$class_o:=cmaToolGetClass("MAMailing").new()
		
		// On détermine le canal d'envoi du mailing
		$canalEnvoi_t:=$class_o.sendGetType()
	Else   // Le mail part en automatique via cronos, le canal est pré-programmé
		$canalEnvoi_t:=$configPreCharge_o.type
	End if 
	
	$erreur_b:=($canalEnvoi_t="")
	
	If ($erreur_b=False:C215)
		
		If (Count parameters:C259=0)  // Le mailing ne part pas en automatique, on configure correctement le mailing
			$config_o:=$class_o.sendGetConfig($canalEnvoi_t)
		Else   // Le mail part en automatique via cronos, le mailing est pré-configuré
			$config_o:=New object:C1471
			
			For each ($propriete_t; $configPreCharge_o)
				$config_o[$propriete_t]:=$configPreCharge_o[$propriete_t]
			End for each 
			
		End if 
		
		$erreur_b:=Not:C34($config_o.success)
		
		If ($erreur_b=False:C215)
			
			If (Count parameters:C259=0)  // Le mailing ne part pas en automatique, on configure le contenu du mailing
				cwToolWindowsForm("gestionDocument"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); New object:C1471("entree"; 1))
			End if 
			
			// Modifié par : Rémy Scanu (21/05/2021)
			// Permet d'instancier la variable wpVar_o utilisée dans les documents 4WPRO créé depuis le composant
			$wpVar_o:=This:C1470.personne
			Formula from string:C1601("_cmaInit4WPVar(this)").call($wpVar_o)
			
			If (Count parameters:C259=0)
				$document_o:=WP New:C1317(WParea)
			Else 
				$document_o:=WP New:C1317($config_o.contenu4WP)
			End if 
			
			If ($config_o.externalReference#Null:C1517)
				$parameter_es:=ds:C1482[$config_o.externalReference.table].query($config_o.externalReference.field+" = :1"; $config_o.externalReference.value)
				
				If ($parameter_es.length>0)
					
					If ($parameter_es[0].formula#"")
						$formule_f:=Formula from string:C1601($parameter_es[0].formula)
						
						Case of 
							: ($config_o.externalReference.situation#Null:C1517)  // Concerne un scénario
								$detail_c:=$config_o.externalReference.situation.detail.query("scene = :1"; $config_o.externalReference.scene)
							: ($config_o.contextValue#Null:C1517)  // Mailing de masse
								
								If ($config_o.contextValue="This@")
									$context_c:=Split string:C1554($config_o.contextValue; ".")
									$config_o.contextValue:=This:C1470.personne
									
									For each ($propriete_t; $context_c)
										
										If ($i_el=0)
											$i_el+=1
											continue
										End if 
										
										If ($config_o.contextValue[$propriete_t]#Null:C1517)
											$config_o.contextValue:=$config_o.contextValue[$propriete_t]
										End if 
										
										$i_el+=1
									End for each 
									
									If (Value type:C1509($config_o.contextValue)#Is text:K8:3)
										$config_o.contextValue:=""
									End if 
									
								End if 
								
								$detail_c:=New collection:C1472(New object:C1471("externalReference"; $config_o.contextValue))
						End case 
						
						If ($detail_c.length>0)
							WP SET DATA CONTEXT:C1786($document_o; $formule_f.call({value: $detail_c[0].externalReference}))
						End if 
						
					End if 
					
				End if 
				
			End if 
			
			WP COMPUTE FORMULAS:C1707($document_o)
			
			Case of 
				: ($canalEnvoi_t="Email")
					$corps_t:=WP Get text:C1575($document_o; wk expressions as value:K81:255)
					
					If ($corps_t#"")
						
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
							
							If ($fichier_o.exists=True:C214)
								$transporter_c:=cwStorage.eMail.transporter.query("name = :1 AND type = :2"; String:C10($config_o.expediteur); "smtp")
								
								If ($transporter_c.length=1)
									$mime_o.bodyValues.p0001.value:=Replace string:C233($mime_o.bodyValues.p0001.value; "nomVendeur"; $transporter_c[0].name)
									
									If ($transporter_c[0].from=Null:C1517)  // Si on utilise pas d'emetteur particulier
										$mime_o.bodyValues.p0001.value:=Replace string:C233($mime_o.bodyValues.p0001.value; "emailVendeur"; $transporter_c[0].user)
									Else 
										$mime_o.bodyValues.p0001.value:=Replace string:C233($mime_o.bodyValues.p0001.value; "emailVendeur"; $transporter_c[0].from)
									End if 
									
								End if 
								
							End if 
							
							For each ($propriete_t; $mime_o)
								$config_o.eMailConfig[$propriete_t]:=$mime_o[$propriete_t]
							End for each 
							
						Else 
							$config_o.eMailConfig.htmlBody:=$corps_t
						End if 
						
						$config_o.eMailConfig.to:=This:C1470.eMail
						
						ON ERR CALL:C155("outilsCatchErrorSendMail")
						
						$statut_o:=$config_o.eMailConfig.send()
						$retour_t:=String:C10($statut_o.statusText)
						
						$erreur_b:=($retour_t#"ok@")
						
						ON ERR CALL:C155("")
						
						If (Count parameters:C259=0)  // Le mailing ne part pas en automatique, on affiche l'alerte sur le statut d'envoi du mail 
							
							If ($erreur_b=False:C215)  // Statut de l'envoie du mail
								ALERT:C41("Votre email a bien été envoyé")
							Else 
								ALERT:C41("Statut erreur envoi de l'e-mail : "+$statut_o.statusText)
							End if 
							
						End if 
						
					End if 
					
				: ($canalEnvoi_t="Courrier")
					
					If (Is compiled mode:C492=False:C215) && (($config_o.CourrierConfig=Null:C1517) || ($config_o.CourrierConfig.prestataire.nom="Imprimante courante"))
						$printSetting_b:=True:C214
						
						If ($config_o.displayPrintSetting#Null:C1517)
							$printSetting_b:=Bool:C1537($config_o.displayPrintSetting)
						End if 
						
						If ($printSetting_b=True:C214)
							PRINT SETTINGS:C106
							$erreur_b:=(OK=0)
						End if 
						
					End if 
					
					Case of 
						: ($config_o.CourrierConfig=Null:C1517) || (Bool:C1537($config_o.CourrierConfig.useCurrentPrinter)=True:C214)
							
							If ($erreur_b=False:C215)
								WP PRINT:C1343($document_o; wk 4D Write Pro layout:K81:176)
							End if 
							
						: ($config_o.CourrierConfig.prestataire.nom="Maileva")
							// Première requête on créé l'envoi
							$body_o:=New object:C1471
							$body_o.name:=String:C10($config_o.CourrierConfig.sendingName)
							$body_o.custom_id:=String:C10($config_o.CourrierConfig.custom_id)
							$body_o.custom_data:=String:C10($config_o.CourrierConfig.custom_data)
							$body_o.duplex_printing:=Bool:C1537($config_o.CourrierConfig.duplexPrinting)
							$body_o.color_printing:=Bool:C1537($config_o.CourrierConfig.printColor)
							$body_o.notification_email:=String:C10($config_o.CourrierConfig.deliveryEmail)
							
							$body_o.print_sender_address:=Bool:C1537($config_o.CourrierConfig.senderPrintAdress)
							$body_o.sender_address_line_1:=String:C10($config_o.CourrierConfig.senderAdressLine1)
							$body_o.sender_address_line_2:=String:C10($config_o.CourrierConfig.senderAdressLine2)
							$body_o.sender_address_line_3:=String:C10($config_o.CourrierConfig.senderAdressLine3)
							$body_o.sender_address_line_4:=String:C10($config_o.CourrierConfig.senderAdressLine4)
							$body_o.sender_address_line_5:=String:C10($config_o.CourrierConfig.senderAdressLine5)
							$body_o.sender_address_line_6:=String:C10($config_o.CourrierConfig.senderAdressLine6)
							
							$body_o.sender_country_code:=String:C10($config_o.CourrierConfig.senderCountryISOCode)
							$config_o.CourrierConfig.request("sendingNew"; $body_o)
					End case 
					
				: ($canalEnvoi_t="SMS")
					$corps_t:=WP Get text:C1575($document_o; wk expressions as value:K81:255)
					
					If ($corps_t#"")
						
						Case of 
							: ($config_o.SMSConfig.prestataire.nom="SMSBox")
								
								If (Bool:C1537($config_o.smsMarketing)=True:C214)
									$strategy_t:="4"
								Else 
									$strategy_t:="2"
								End if 
								
								$date_d:=Current date:C33
								$time_t:=Current time:C178
								
								If ($config_o.SMSConfig.date#Null:C1517)
									$date_d:=Date:C102($config_o.SMSConfig.date)
								End if 
								
								If ($config_o.SMSConfig.time#Null:C1517)
									$time_t:=Time:C179($config_o.SMSConfig.time)
								End if 
								
								$retour_t:=$config_o.SMSConfig.SMSBOXSendMessage(True:C214; $corps_t; This:C1470.telMobile; $date_d; $time_t; "Reponse"; $strategy_t)
								$erreur_b:=($retour_t#"Le sms a bien été envoyé !")
							: ($config_o.SMSConfig.prestataire.nom="Mailjet")
								$retour_t:=$config_o.SMSConfig.MailjetSendMessage($corps_t; This:C1470.telMobile)
						End case 
						
					End if 
					
			End case 
			
			If ($erreur_b=False:C215)  // S'il s'agit d'un Courrier ou SMS ou un mail qui possède un corps non vide, on rajoute l'historique de l'envoi
				
				If (Count parameters:C259=0)
					$param_o:=New object:C1471("type"; $canalEnvoi_t; "contenu4WP"; WParea; "statut"; "2")
				Else 
					$param_o:=New object:C1471("type"; $canalEnvoi_t; "contenu4WP"; $document_o; "statut"; "2")
				End if 
				
				If ($config_o.externalReference#Null:C1517)
					$param_o.externalReference:=$config_o.externalReference
				End if 
				
			End if 
			
		Else 
			$retour_t:="Le mailing n'a pas pu être initialiser pour le canal d'envoi "+$canalEnvoi_t+", voici le détail :"+JSON Stringify:C1217($config_o; *)
		End if 
		
	Else 
		$retour_t:="Aucun canal d'envoi sélectionné"
	End if 
	
	If ($erreur_b=True:C214)  // S'il y a eu une erreur
		
		If (Count parameters:C259=0)
			$param_o:=New object:C1471("type"; $canalEnvoi_t; "contenu4WP"; WParea; "statut"; "2")
		Else 
			$param_o:=New object:C1471("type"; $canalEnvoi_t; "contenu4WP"; $document_o; "statut"; "2")
		End if 
		
		$param_o.statutLib:="Erreur"
		$param_o.externalReference:=New object:C1471("value"; $retour_t)
	End if 
	
	This:C1470.updateCaMarketingStatistic(3; $param_o)
	
	If ($erreur_b=False:C215) & ($canalEnvoi_t="Courrier") & (Bool:C1537($config_o.notifEmail)=True:C214)  // L'utilisateur souhaite notifier par email de l'envoi d'un courrier avec le courrier en pièce-jointe
		
		If (String:C10(This:C1470.eMail)#"") & (cmaToolRegexValidate(1; String:C10(This:C1470.eMail))=True:C214)
			$MAEmail_cs:=cs:C1710.MAEMail.new(String:C10($config_o.notif.expediteur))
			$MAEmail_cs.subject:=String:C10($config_o.notif.subject)
			
			$MAEmail_cs.to:=This:C1470.eMail
			
			$folder_f:=Folder:C1567(fk resources folder:K87:11; *).folder("TEMP")
			
			If ($folder_f.exists=False:C215)
				$folder_f.create()
			End if 
			
			$file_f:=$folder_f.file(Generate UUID:C1066+".pdf")
			WP EXPORT DOCUMENT:C1337($document_o; $file_f.platformPath; wk pdf:K81:315)
			
			$MAEmail_cs.attachmentsPath_c:=New collection:C1472($file_f.platformPath)
			
			If ($config_o.notif.contenu4WP#Null:C1517) || ($config_o.notif.externalReference#Null:C1517)
				
				Case of 
					: ($config_o.notif.externalReference#Null:C1517)
						$parameter_es:=ds:C1482[$config_o.notif.externalReference.table].query($config_o.notif.externalReference.field+" = :1"; $config_o.notif.externalReference.value)
						
						If ($parameter_es.length>=1)
							$document_o:=WP New:C1317($parameter_es.first().value_b)
						End if 
						
					: ($config_o.notif.contenu4WP#Null:C1517)
						$document_o:=$config_o.notif.contenu4WP
				End case 
				
				If ($config_o.notif.externalReference#Null:C1517)
					$externalReference_o:=OB Copy:C1225($config_o.notif.externalReference)
				End if 
				
				$config_o:=New object:C1471("success"; True:C214; "type"; "Email"; "eMailConfig"; $MAEmail_cs; "contenu4WP"; $document_o; "expediteur"; $config_o.notif.expediteur)
				
				If ($externalReference_o#Null:C1517)
					$config_o.externalReference:=OB Copy:C1225($externalReference_o)
				End if 
				
				$retour_o:=This:C1470.sendMailing($config_o)
			End if 
			
		End if 
		
	End if 
	
	return {success: Not:C34($erreur_b); erreurDetail: $retour_t}
	
Function updateCaMarketingStatistic($provenance_el : Integer; $detail_o : Object)->$isOk_b : Boolean
/*------------------------------------------------------------------------------
Fonction : MAPersonne.updateCaMarketingStatistic
	
Permet de mettre à jour la table marketing
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête
------------------------------------------------------------------------------*/
	var $continue_b : Boolean
	var $table_o; $enregistrement_o; $autreTable_o; $caScenarioEvents_o; $caScenarioEvent_o; $scene_cs; $caScenarioPersonne_o : Object
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction updateCaMarketingStatistic sans une personne de définie.")
	
	// On pensera à mettre à jour les informations marketing.
	$table_o:=This:C1470.personne.AllCaPersonneMarketing
	
	If ($table_o.length=0)
		$enregistrement_o:=ds:C1482["CaPersonneMarketing"].new()
		
		$enregistrement_o.personneID:=This:C1470.UID
		$enregistrement_o.rang:=1  // 1 pour Suspect
		$enregistrement_o.historique:=New object:C1471("detail"; New collection:C1472)
	Else 
		$enregistrement_o:=$table_o.first()
	End if 
	
	Case of 
		: ($provenance_el=1)  // On souhaite mettre à jour les stats de mailjet
			// On va récupérer les informations utiles sur mailjet pour mettre à jour la stratégie de relance.
			This:C1470.mailjetGetStat()
			
			// Mise à jour des stats de mailjet (besoin d'éxécuter avant mailjetGetStat() pour fonctionner correctement)
			$enregistrement_o.mailjetInfo:=This:C1470.statMailjet
			$retour_o:=$enregistrement_o.save()
			
			// Il faut également mettre à jour les autres champs
			This:C1470.mailjetGetDetailStat(This:C1470.eMail; "3"; "4"; "7"; "8"; "10")
		: ($provenance_el=2)  // On souhaite mettre à jour un des event (opened, clicked, unsubscribe ou bounce)
			$scene_cs:=cmaToolGetClass("MAScene").new()
			
			Case of 
				: (String:C10($detail_o.eventNumber)="3")
					$enregistrement_o.lastOpened:=$detail_o.eventTs
				: (String:C10($detail_o.eventNumber)="4")
					$enregistrement_o.lastClicked:=$detail_o.eventTs
				: (String:C10($detail_o.eventNumber)="7")
					$enregistrement_o.lastUnsubscribe:=$detail_o.eventTs
					$enregistrement_o.desabonementMail:=True:C214
					
					// Gestion du désabonnement qui peut avoir un traitement particulier suivant la base
					If (OB Is defined:C1231(This:C1470.personne; "manageUnsubscribe")=True:C214)
						This:C1470.personne.manageUnsubscribe()
					End if 
					
				: (String:C10($detail_o.eventNumber)="10")
					$enregistrement_o.lastBounce:=$detail_o.eventTs
			End case 
			
			// On doit chercher si pour cette personne le mailing de la scène qui a déclenché cet évènement doit déclencher quelque chose (saut de scène par exemple)
			$autreTable_o:=This:C1470.personne.AllCaPersonneScenario.query("actif = :1"; True:C214)
			
			If ($autreTable_o.length>0)  // Il y a des scénarios actifs pour la personne
				$caScenarioEvents_o:=$autreTable_o.AllCaScenarioEvent.query("etat # :1"; "Terminé")
				
				For each ($caScenarioEvent_o; $caScenarioEvents_o)
					$continue_b:=$scene_cs.loadByPrimaryKey($caScenarioEvent_o.OneCaScene.ID)
					
					If ($continue_b=True:C214)
						$caScenarioPersonne_o:=$caScenarioEvent_o.OneCaPersonneScenario
						
						Case of 
							: (String:C10($detail_o.eventNumber)="3")  // Si ouvert, on met à jour le log de la scène de la personne
								$scene_cs.addScenarioEvent("Évènement mailjet, mail ouvert"; $caScenarioPersonne_o.ID; $caScenarioPersonne_o.tsProchainCheck; "")
							: (String:C10($detail_o.eventNumber)="4")  // Si clic, on met à jour le log de la scène de la personne
								$scene_cs.addScenarioEvent("Évènement mailjet, mail cliqué"; $caScenarioPersonne_o.ID; $caScenarioPersonne_o.tsProchainCheck; "")
						End case 
						
						// On force le timeStamp du prochainCheck à maintenant pour voir si cet évènement déclenchera un saut de scène par exemple
						$caScenarioPersonne_o.tsProchainCheck:=cmaTimestamp(Current date:C33; Current time:C178)
						$caScenarioPersonne_o.save()
					End if 
					
				End for each 
				
			End if 
			
		: ($provenance_el=3)  // On souhaite mettre à jour l'historique des mailings envoyés à la personne
			
			$enregistrement_o.historique.detail.push(New object:C1471(\
				"eventTs"; cmaTimestamp(Current date:C33; Current time:C178); \
				"eventUser"; ($detail_o.currentUser#Null:C1517) ? $detail_o.currentUser : Current user:C182; \
				"eventDetail"; New object:C1471("type"; String:C10($detail_o.type); \
				"nomDocument"; String:C10($detail_o.nomDocument); \
				"contenu4WP"; $detail_o.contenu4WP; \
				"statut"; String:C10($detail_o.statut); \
				"statutLib"; ($detail_o.statutLib#Null:C1517) ? String:C10($detail_o.statutLib) : cmaToolMailjetGetLib(String:C10($detail_o.statut)); \
				"statutColor"; cmaToolMailjetGetColor(String:C10($detail_o.statut)); \
				"subject"; String:C10($detail_o.subject); \
				"externalReference"; ($detail_o.externalReference#Null:C1517) ? $detail_o.externalReference : Null:C1517; \
				"messageID"; "")))
			
			If ($detail_o.uuid#Null:C1517)
				$enregistrement_o.historique.detail[$enregistrement_o.historique.detail.length-1].uuid:=$detail_o.uuid
			End if 
			
	End case 
	
	If ($provenance_el#1)  // On sauvegarde juste avant inutile de refaire cela
		$retour_o:=$enregistrement_o.save()
	End if 
	
	Case of 
		: ($provenance_el=1)  // On souhaite mettre à jour manuellement les stats de mailjet
			
			If ($retour_o.success=True:C214)
				ALERT:C41("Les dernières stats de mailjet on bien été mis à jour dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom)
			Else 
				ALERT:C41("Impossible de mettre à jour la table marketing dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom)
			End if 
			
		: ($provenance_el=2)  // On souhaite mettre à jour un des event (opened, clicked ou bounce)
			
			If ($retour_o.success=False:C215)
				
				Case of 
					: (String:C10($detail_o.eventNumber)="3")
						$event_t:="Opened"
					: (String:C10($detail_o.eventNumber)="4")
						$event_t:="Clicked"
					: (String:C10($detail_o.eventNumber)="10")
						$event_t:="Bounce"
				End case 
				
				ALERT:C41("Impossible de mettre à jour la table marketing pour l'event "+$event_t+" dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom)
			End if 
			
	End case 
	
	$isOk_b:=$retour_o.success