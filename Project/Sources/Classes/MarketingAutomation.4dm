/* -----------------------------------------------------------------------------
Class : cs.MarketingAutomation

Class de gestion du marketing automation

-----------------------------------------------------------------------------*/

Class constructor($initialisation_b : Boolean; $configChemin_t : Text)
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.constructor
	
Initialisation du marketing automation
	
Historique
25/01/21 - Grégory Fromain <gregory@connect-io.fr> - clean code
-----------------------------------------------------------------------------*/
	var $chemin_t : Text
	var $configFile_o : 4D:C1709.File
	var $scenarioFolder_o : 4D:C1709.Folder
	
	If (Bool:C1537($initialisation_b)=True:C214)  // On initialise tout ça uniquement au premier appel (Normalement Sur ouverture de la base)
		
		Use (Storage:C1525)
			Storage:C1525.automation:=New shared object:C1526()
		End use 
		
		// Chargement du fichier de config
		$configFile_o:=Folder:C1567(fk resources folder:K87:11; *).file("cioMarketingAutomation/config.json")
		
		If (Not:C34($configFile_o.exists))  // Il n'existe pas de fichier de config dans la base hote, on le génère.
			Folder:C1567(fk resources folder:K87:11).file("modelAutomation/config.json").copyTo($configFile_o.parent; $configFile_o.fullName)
		End if 
		
		If ($configFile_o.exists=True:C214)
			// Je charge toutes les images
			This:C1470.loadImage()
			
			Use (Storage:C1525.automation)
				Storage:C1525.automation.config:=OB Copy:C1225(JSON Parse:C1218($configFile_o.getText()); ck shared:K85:29; Storage:C1525.automation)
				Storage:C1525.automation.image:=OB Copy:C1225(This:C1470.image; ck shared:K85:29; Storage:C1525.automation)
			End use 
			
			This:C1470.loadPasserelle("Personne")
			
			// Chargement des conditions d'action et de saut pour les scènes d'un scénario
			This:C1470.loadSceneConditionActionList()
			This:C1470.loadSceneConditionSautList()
		Else 
			ALERT:C41("Impossible d'intialiser le composant caMarketingAutomation, le fichier de configuration n'a pas pu être trouvé dans la base hôte.")
		End if 
		
		$scenarioFolder_o:=Folder:C1567(fk resources folder:K87:11; *).folder("scenario")
		
		If ($scenarioFolder_o.exists=False:C215)
			$scenarioFolder_o.create()
		End if 
		
	End if 
	
Function createFolder($chemin_t : Text)->$isOk_b : Boolean
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.createFolder
	
Permet de créer un dossier si besoin
	
Historique
27/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	var $dossier_o : Object
	
	$dossier_o:=Folder:C1567($chemin_t; fk platform path:K87:2)
	
	If ($dossier_o.exists=False:C215)  // Création du dossier $chemin_t
		$isOk_b:=$dossier_o.create()
	Else 
		$isOk_b:=True:C214
	End if 
	
	If ($isOk_b=False:C215)
		ALERT:C41("Le dossier dont le chemin est « "+$chemin_t+" » n'a pas pu être créer !")
	End if 
	
Function cronosAction($action_t : Text)
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.cronosAction
	
Mise à jour de certaines propriétés de This suivant l'action mise en paramètre
Va de paire avec la fonction cronosMessageDisplay
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - clean code
-----------------------------------------------------------------------------*/
	
	ASSERT:C1129(This:C1470.cronosImage#Null:C1517; "Impossible d'utiliser la fonction cronosAction sans avoir lancer la fonction loadCronos avant")
	
	Case of 
		: ($action_t="verifTache") | ($action_t="mailjetRecup") | ($action_t="gestionScenario") | ($action_t="gestionProcessAutomatique")
			
			If ($action_t="verifTache")
				This:C1470.cronosMessage:=""
			End if 
			
			This:C1470.cronosVerifTache:=False:C215
			
			DELAY PROCESS:C323(Current process:C322; 100)
		: ($action_t="RAS")
			This:C1470.cronosMessage:=""
			This:C1470.cronosVerifTache:=True:C214
			
			DELAY PROCESS:C323(Current process:C322; 600)
	End case 
	
Function cronosMessageDisplay
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.cronosMessageDisplay
	
Lancement d'une action dans cronos.
	
Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	var $ts_el : Integer
	
	ASSERT:C1129(This:C1470.cronosImage#Null:C1517; "Impossible d'utiliser la fonction cronosAction sans avoir lancer la fonction loadCronos avant")
	
	$ts_el:=cmaTimestamp(Current date:C33; Current time:C178)
	
	Case of 
		: (This:C1470.cronosMessage="Vérification si une tâche doit être effectuée...")
			This:C1470.cronosAction("verifTache")
		: (This:C1470.cronosMessage="Récupération des données de mailjet en cours...")
			This:C1470.cronosAction("mailjetRecup")
		: (This:C1470.cronosMessage="Gestion des scénarios...")
			This:C1470.cronosAction("gestionScenario")
		: (This:C1470.cronosMessage="Gestion des process automatiques personnalisés journalier...")
			This:C1470.cronosAction("gestionProcessAutomatique")
		: (This:C1470.cronosMessage="RAS, prochaine vérification dans 10 secondes.")
			This:C1470.cronosAction("RAS")
		: (This:C1470.cronosMessage="") & ($ts_el>This:C1470.cronosVerifMailjet)
			This:C1470.cronosImage:=This:C1470.image["cronosWork"]
			
			This:C1470.cronosMessage:="Récupération des données de mailjet en cours..."
		: (This:C1470.cronosMessage="") & ($ts_el>This:C1470.cronosVerifScenario)
			This:C1470.cronosImage:=This:C1470.image["cronosWork"]
			
			This:C1470.cronosMessage:="Gestion des scénarios..."
		: (This:C1470.cronosMessage="") & ($ts_el>This:C1470.cronosVerifProcessAuto)
			This:C1470.cronosImage:=This:C1470.image["cronosWork"]
			
			This:C1470.cronosMessage:="Gestion des process automatiques personnalisés journalier..."
		: (This:C1470.cronosVerifTache=True:C214)
			This:C1470.cronosImage:=This:C1470.image["cronosWork"]
			
			This:C1470.cronosMessage:="Vérification si une tâche doit être effectuée..."
		Else 
			This:C1470.cronosImage:=This:C1470.image["cronosSleep"]
			
			This:C1470.cronosMessage:="RAS, prochaine vérification dans 10 secondes."
	End case 
	
Function cronosUpdateCaMarketing
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.cronosUpdateCaMarketing
	
Mise à jour depuis cronos des informations de la table [CaPersonneMarketing]
	
Historique
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	var $1 : Integer  // TS de début
	var $2 : Integer  // TS de fin
	var ${3} : Text  // Numéro chez mailjet de l'eventMessage à mettre à jour exemple : 3 -> Opened, 4 -> Clicked etc.
	
	var $event_t : Text
	var $i_el : Integer
	var $mailjet_o; $mailjetDetail_o; $table_o; $class_o : Object
	var $mailjetDetail_c : Collection
	
	ASSERT:C1129(This:C1470.cronosImage#Null:C1517; "Impossible d'utiliser la fonction cronosAction sans avoir lancer la fonction loadCronos avant")
	
	$mailjetDetail_c:=New collection:C1472
	
	// Instanciation de la class
	$class_o:=cmaToolGetClass("MAPersonne").new()
	
	If (This:C1470.cronosMailjetClass#Null:C1517)
		
		For ($i_el; 3; Count parameters:C259)
			This:C1470.cronosMailjetClass.getMessageEvent(${$i_el}; $1; $2; ->$mailjet_o)
			
			If ($mailjet_o.errorHttp=Null:C1517)
				This:C1470.cronosMailjetClass.AnalysisMessageEvent($mailjet_o; ${$i_el}; $1; $2; ->$mailjetDetail_c)
			End if 
			
			If ($mailjetDetail_c.length>0)
				
				For each ($mailjetDetail_o; $mailjetDetail_c)
					// On vérifie que l'email trouvé est bien dans la base du client
					$class_o.loadByField("eMail"; "="; $mailjetDetail_o.email)  // Initialisation de l'entité de la table [Personne] du client
					
					If ($class_o.personne#Null:C1517)  // On met à jour la table marketing avec les infos de mailjet
						$class_o.updateCaMarketingStatistic(2; New object:C1471("eventNumber"; ${$i_el}; "eventTs"; Num:C11($mailjetDetail_o.tsEvent)))
					End if 
					
				End for each 
				
			End if 
			
		End for 
		
	End if 
	
Function cronosManageScenario
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.cronosManageScenario
	
Gestion depuis la méthode formulaire "cronos" des scénarios des personnes
	
Historique
29/01/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	var $numOrdre_el : Integer
	var $continue_b; $saut_b; $sautEffectue_b; $finScenario_b : Boolean
	var $table_o; $enregistrement_o; $caScenarioEvent_o; $scene_o; $personne_o; $eMail_o; $config_o; $conditionAction_o; $conditionSaut_o; $scene_cs; $retour_o; $scenario_o; $autreTable_o; $autreEnregistrement_o; $caPersonneMarketing_o : Object
	var $collection_c : Collection
	
	ASSERT:C1129(This:C1470.cronosImage#Null:C1517; "Impossible d'utiliser la fonction cronosAction sans avoir lancer la fonction loadCronos avant")
	
	// On recherche toutes les personnes qui ont un scénario actif et dont le prochain check est dépassé
	$table_o:=ds:C1482.CaPersonneScenario.query("actif = :1 AND tsProchainCheck <= :2"; True:C214; cmaTimestamp(Current date:C33; Current time:C178))
	
	$scene_cs:=cmaToolGetClass("MAScene").new()
	
	For each ($enregistrement_o; $table_o)
		Form:C1466.cronosMessage:="Gestion des scénarios..."+Char:C90(Line feed:K15:40)
		Form:C1466.cronosMessage:=Form:C1466.cronosMessage+"Envoi de l'email automatique "+String:C10($enregistrement_o.indexOf($table_o)+1)+" / "+String:C10($table_o.length)
		
		$caScenarioEvent_o:=$enregistrement_o.AllCaScenarioEvent
		
		If ($caScenarioEvent_o.length=0)  // Il n'y a pas encore de scène exécutée
			$scene_o:=ds:C1482.CaScene.query("scenarioID is :1 AND numOrdre = :2"; $enregistrement_o.scenarioID; 1)
			
			If ($scene_o.length=1)  // On a trouvé la première scène
				$scene_o:=$scene_o.first()
			Else   // Impossible de trouver la scène donc de la jouer...
				CLEAR VARIABLE:C89($scene_o)
			End if 
			
		Else   // S'il y a des logs pour le scénario de la personne, on va regarder parmis ceux-ci ceux qui ne sont pas terminés
			$caScenarioEvent_o:=$caScenarioEvent_o.query("etat # :1"; "Terminé").orderBy("tsCreation desc")
			
			If ($caScenarioEvent_o.length>0)  // La dernière scène n'a pas pu se finir
				$caScenarioEvent_o:=$caScenarioEvent_o.first()
				
				Case of 
					: ($caScenarioEvent_o.etat="En cours")
						$caScenarioEvent_o.etat:="Terminé"
						$caScenarioEvent_o.tsMiseAJour:=cmaTimestamp(Current date:C33; Current time:C178)
						
						$caScenarioEvent_o.save()
						
						Case of 
							: ($caScenarioEvent_o.OneCaScene.sceneSuivanteID#0)  // On cherche la scène suivante
								// On remonte du log à la scène puis à la scène suivante
								$scene_o:=$caScenarioEvent_o.OneCaScene.OneCaSceneSuivante
							: ($caScenarioEvent_o.OneCaScene.scenarioSuivantID#"00000000000000000000000000000000")  // On cherche le scénario suivant
								// On remonte du log à la scène puis au scénario suivant puis à toutes les scènes
								$scene_o:=$caScenarioEvent_o.OneCaScene.scenarioSuivantID.AllCaSceneScenarioSuivant.query("numOrdre = :1"; 1)
								
								If ($scene_o.length=1)  // On a trouvé la première scène
									$scene_o:=$scene_o.first()
								Else   // Impossible de trouver la scène donc de la jouer...
									CLEAR VARIABLE:C89($scene_o)
								End if 
								
							Else   // S'il n'y en a pas on regarde les deux différents cas
								
								If ($caScenarioEvent_o.OneCaScene.numOrdre=$caScenarioEvent_o.OneCaScene.OneCaScenario.AllCaScene.length)  // C'est la dernière scène du scénario et il manque la scène de fin, dommage pour le spectacle...
									$scene_cs.loadByPrimaryKey($caScenarioEvent_o.OneCaScene.ID)
									
									// Ajout du log
									$scene_cs.addScenarioEvent("Fin du scénario"; $enregistrement_o.ID)
									$finScenario_b:=True:C214
								Else   // L'utilisateur a oublié de programmer une scène suivante
									CLEAR VARIABLE:C89($scene_o)
									
									$numOrdre_el:=$caScenarioEvent_o.OneCaScene.numOrdre
									
									// On recherche une scène jusqu'à trouver la bonne
									Repeat 
										$numOrdre_el:=$numOrdre_el+1
										$scene_o:=$caScenarioEvent_o.OneCaScene.OneCaScenario.AllCaScene.query("numOrdre = :1"; $numOrdre_el)
										
										If ($scene_o.length=1)  // On a trouvé la bonne scène
											$scene_o:=$scene_o.first()
										End if 
										
									Until ($scene_o#Null:C1517) | ($numOrdre_el>100)
									
								End if 
								
						End case 
						
					: ($caScenarioEvent_o.etat="Évènement mailjet")  // Un évènement mailjet a été détecté
						$scene_o:=$caScenarioEvent_o.OneCaScene
				End case 
				
			Else   // Ce n'est pas normal de se retrouver dans ce cas-là, mais on va faire en sorte que lors du prochain passage cette personne n'y soit plus.
				$finScenario_b:=True:C214
			End if 
			
		End if 
		
		If ($scene_o#Null:C1517)  // Je dois vérifier si la scène est exécutable
			
			Repeat   // Vérification des conditions de saut
				$scene_cs.loadByPrimaryKey($scene_o.ID)
				
				CLEAR VARIABLE:C89($saut_b)
				
				Case of 
					: ($scene_o.conditionSaut=Null:C1517)  // Si la condition de saut n'est pas définie, on exécute la scène
						$continue_b:=True:C214
					: ($scene_o.conditionSaut.elements=Null:C1517)  // Si pas de condition de saut, on exécute la scène
						$continue_b:=True:C214
					Else 
						$personne_o:=$enregistrement_o.OnePersonne
						
						For each ($conditionSaut_o; $scene_o.conditionSaut.elements) Until ($continue_b=False:C215)
							
							If ($conditionSaut_o.formule#"")
								//$continue_b:=$personne_o.manageConditionActionScene($conditionSaut_o.titre; $enregistrement_o.ID)
							Else 
								$continue_b:=$scene_cs.manageConditionSaut($conditionSaut_o; $enregistrement_o)
							End if 
							
						End for each 
						
						If ($continue_b=True:C214)  // Toutes les conditions sont réunis pour qu'on fasse... le grand Saut :D
							$scene_o:=ds:C1482.CaScene.get(Num:C11($scene_o.conditionSaut.sceneSautID))
							
							If ($scene_o#Null:C1517)  // La scène a bien été trouvé, on note qu'on change de scène dans les logs
								$scene_cs.addScenarioEvent("Changement de scène"; $enregistrement_o.ID)
								
								$saut_b:=True:C214
								$sautEffectue_b:=True:C214
							Else 
								CLEAR VARIABLE:C89($continue_b)
							End if 
							
						Else   // On ne peux pas passer à une autre scène, on va voir si on peut quand même la jouer histoire que les comédiens ne se soient pas préparés pour rien :D
							$continue_b:=True:C214
						End if 
						
				End case 
				
			Until ($saut_b=False:C215)
			
			If (OB Is defined:C1231($caScenarioEvent_o; "length")=False:C215)  // On a déjà des logs pour le scénario de la personne
				
				If (String:C10($caScenarioEvent_o.etat)="Évènement mailjet")  // Si l'évènement est un "Évènement mailjet"
					
					If ($sautEffectue_b=False:C215)  // Si cet évènement n'a pas déclenché un saut de scène, on ne fait rien pour la suite
						CLEAR VARIABLE:C89($continue_b)
					Else   // Il faut cloturer le log de l'envoi du mailing qui a occasionné cet évènement mailjet
						$autreTable_o:=ds:C1482.CaScenarioEvent.query("personneScenarioID = :1 AND sceneID = :2 AND etat = :3"; $caScenarioEvent_o.personneScenarioID; $caScenarioEvent_o.sceneID; "En cours")
						
						For each ($autreEnregistrement_o; $autreTable_o)
							$autreEnregistrement_o.etat:="Terminé"
							$autreEnregistrement_o.tsMiseAJour:=cmaTimestamp(Current date:C33; Current time:C178)
							
							$autreEnregistrement_o.save()
						End for each 
						
					End if 
					
					// Dans tous les cas si le dernier event est un "Évènement mailjet", on le clos pour ne pas repasser dessus après
					$caScenarioEvent_o.etat:="Terminé"
					
					// Je restitue le tsProchainCheck qu'il y avait avant la détection de l'évènement
					$enregistrement_o.tsProchainCheck:=$caScenarioEvent_o.tsMiseAJour
					$enregistrement_o.save()
					
					// Et je mets à jour mon log avec le bon timeStamp cette fois-ci
					$caScenarioEvent_o.tsMiseAJour:=cmaTimestamp(Current date:C33; Current time:C178)
					$caScenarioEvent_o.save()
				End if 
				
			End if 
			
			If ($continue_b=True:C214)  // Vérification des conditions d'action
				
				Case of 
					: ($scene_o.conditionAction=Null:C1517)  // Si la condition d'action n'est pas définie, on exécute la scène
						$continue_b:=True:C214
					: ($scene_o.conditionAction.elements=Null:C1517)  // Si pas de condition d'action, on exécute la scène
						$continue_b:=True:C214
					Else 
						$personne_o:=$enregistrement_o.OnePersonne
						
						For each ($conditionAction_o; $scene_o.conditionAction.elements) Until ($continue_b=False:C215)
							
							If ($conditionAction_o.formule#"")
								//$continue_b:=$personne_o.manageConditionActionScene($conditionAction_o.titre; $enregistrement_o.ID)
							Else 
								$continue_b:=$scene_cs.manageConditionAction($conditionAction_o; $enregistrement_o)
							End if 
							
						End for each 
						
						If ($continue_b=False:C215)  // Catastrophe, on ne peut pas jouer la scène car toutes les conditions ne sont pas réunis, il faut rappeler tous les comédiens :'(
							$caScenarioEvent_o.etat:="En cours"
							
							$caScenarioEvent_o.save()
						End if 
						
				End case 
				
			End if 
			
			// On passe aux conditions d'action inhérentes
			Case of 
				: ($continue_b=False:C215)
				: ($scene_o.action="Envoi email")  // Si l'action de la scène est l'envoi d'un email, on doit faire des vérifications de base
					$personne_o:=cmaToolGetClass("MAPersonne").new()
					$personne_o.loadByPrimaryKey($enregistrement_o.personneID)
					
					If ($continue_b=True:C214)
						$continue_b:=(String:C10($personne_o.eMail)#"") & (cmaToolRegexValidate(1; String:C10($personne_o.eMail))=True:C214)  // Si la personne possède bien un email et qu'il est valide
						
						If ($continue_b=False:C215)
							$scene_cs.addScenarioEvent("Erreur email"; $enregistrement_o.ID)
						End if 
						
					End if 
					
					If ($continue_b=True:C214)  // Si la personne n'a pas un email en demande de désabonnement ou en bounce
						$continue_b:=$personne_o.mailjetIsPossible()
						
						If ($continue_b=False:C215)
							$caPersonneMarketing_o:=$personne_o.personne.AllCaPersonneMarketing
							
							If ($caPersonneMarketing_o.length=1)
								$caPersonneMarketing_o:=$caPersonneMarketing_o.first()
								
								Case of 
									: ($caPersonneMarketing_o.desabonementMail=True:C214)
										$scene_cs.addScenarioEvent("Désabonnement"; $enregistrement_o.ID)
									: ($caPersonneMarketing_o.lastBounce#0)
										$scene_cs.addScenarioEvent("Bounce"; $enregistrement_o.ID)
								End case 
								
							End if 
							
						End if 
						
					End if 
					
					If ($continue_b=True:C214)  // Si l'email qui est programmé n'est pas vide
						$collection_c:=$scene_o.paramAction.modele.email.version.query("actif = :1"; True:C214)
						
						If ($collection_c.length=1)  // S'il y a bien une version d'email actif
							
							If ($collection_c[0].contenu4WP#Null:C1517)
								$continue_b:=(WP Get text:C1575($collection_c[0].contenu4WP; wk expressions as value:K81:255)#"")
							Else   // Il n'y a pas de document 4DWP assigné à cette version
								$continue_b:=False:C215
							End if 
							
							If ($continue_b=True:C214)  // On vérifie qu'il y a bien un expéditeur et un objet d'email indiqué
								$continue_b:=((String:C10($collection_c[0].subject)#"") & (String:C10($collection_c[0].expediteur)#""))
							End if 
							
						Else   // Il n'y a aucune version d'email créée pour cette scène là
							$continue_b:=False:C215
						End if 
						
					Else   // Dans ce cas là, soit le mail n'est pas bon, soit il est en demande de désabonnement ou soit il est en bounce
						$finScenario_b:=True:C214
					End if 
					
			End case 
			
			If ($continue_b=True:C214)  // La scène est exécutable, on va voir ce qu'on doit... l'exécuter :D
				$scene_cs.loadByPrimaryKey($scene_o.ID)
				
				Case of 
					: ($scene_o.action="Attente")  // L'action de la scène est juste une attente d'un certains délai... on créé donc le log
						$scene_cs.addScenarioEvent($scene_o.action; $enregistrement_o.ID)
					: ($scene_o.action="Envoi email")  // L'action de la scène est l'envoi d'un email
						$eMail_o:=cmaToolGetClass("MAEMail").new($collection_c[0].expediteur)
						$eMail_o.subject:=$collection_c[0].subject
						
						$config_o:=New object:C1471("success"; True:C214; "type"; "Email"; "eMailConfig"; $eMail_o; "contenu4WP"; $collection_c[0].contenu4WP; "expediteur"; $collection_c[0].expediteur)
						
						$personne_o.sendMailing($config_o)
						
						// Ajout du log
						$scene_cs.addScenarioEvent($scene_o.action; $enregistrement_o.ID)
					: ($scene_o.action="Changement de scénario") | ($scene_o.action="Fin du scénario")  // L'action de la scène est qu'on arrête le scénario de la personne ou qu'on change de scénario
						// On passe en inactif l'inscription au scénario
						$enregistrement_o.actif:=False:C215
						
						// Ajout du log
						$scene_cs.addScenarioEvent($scene_o.action; $enregistrement_o.ID)
				End case 
				
				If ($scene_o.action="Changement de scénario") | ($scene_o.action="Fin du scénario")
					$enregistrement_o.tsProchainCheck:=0
				Else 
					$enregistrement_o.tsProchainCheck:=cmaTimestamp(Current date:C33; Current time:C178)+$scene_o.tsAttente
				End if 
				
				$retour_o:=$enregistrement_o.save()
				
				If ($retour_o.success=False:C215)
					// toDo
				End if 
				
			End if 
			
		End if 
		
		If ($finScenario_b=True:C214)  // Pas de scène "Fin de scénario" OU problème dans l'adresse email OU Désabonnement/Bounce
			$enregistrement_o.actif:=False:C215
			$enregistrement_o.tsProchainCheck:=0
			
			$enregistrement_o.save()
		End if 
		
		cmaToolCleanVariable(->$finScenario_b; ->$scene_o; ->$continue_b)
	End for each 
	
Function loadCronos
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.loadCronos
	
Initialisation des propriétés de This nécessaire au bon fonctionnement de cronos
Et lance le formulaire projet "cronos"
	
Historique
29/01/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	var $process_el : Integer
	
	ASSERT:C1129(This:C1470.image["cronosSleep"]#Null:C1517; "Impossible d'utiliser la fonction loadCronos sans avoir lancer la fonction loadImage avant")
	
	If (This:C1470.image["cronosSleep"]#Null:C1517) & (This:C1470.image["cronosWork"]#Null:C1517)
		This:C1470.cronosImage:=This:C1470.image["cronosSleep"]
		This:C1470.cronosMessage:="Démarrage en cours de Cronos (Marketing automation)"
		This:C1470.cronosStop:=False:C215
		This:C1470.cronosVerifTache:=True:C214
		
		This:C1470.cronosVerifMailjet:=0
		This:C1470.cronosVerifScenario:=0
		This:C1470.cronosVerifProcessAuto:=0
		
		This:C1470.cronosMailjetClass:=cmaToolGetClass("MAMailjet").new()
		
		$process_el:=New process:C317("cwCronosDisplay"; 0; "cronosMarketingAutomation"; This:C1470; *)
	End if 
	
Function loadCurrentPeople()->$entitySelection_o : Object
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.loadCurrentPeople
	
Créer une entitySelection des enregistrements en cours de la table [personne] du client
	
Historique
29/01/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	var $formule_o : Object
	
	This:C1470.loadPasserelle("Personne")  // On change de passerelle de recherche
	$formule_o:=New object:C1471("loadPeople"; Formula from string:C1601("Create entity selection:C1512(["+Storage:C1525.automation.passerelle.tableHote+"])"))
	
	$entitySelection_o:=$formule_o.loadPeople()
	
Function loadImage
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.loadImage
	
Charge dans This, toutes les images mises dans le dossier /Resources/Images/ du composant
	
Historique
29/01/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	var ${1} : Text  // Nom de l'image
	
	var $fichier_o : 4D:C1709.File
	var $dossier_o : 4D:C1709.Folder
	var $blob_b : Blob
	var $image_i : Picture
	
	ASSERT:C1129(Storage:C1525.automation#Null:C1517; "Impossible d'utiliser la fonction loadImage sans avoir fait une initialisation complète de la class MarketingAutomation")
	
	If (This:C1470.image=Null:C1517)
		This:C1470.image:=New object:C1471()
	End if 
	
	$dossier_o:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12; fk platform path:K87:2)
	
	For each ($fichier_o; $dossier_o.files(fk ignore invisible:K87:22))
		$blob_b:=$fichier_o.getContent()
		
		BLOB TO PICTURE:C682($blob_b; $image_i)
		
		This:C1470.image[$fichier_o.name]:=$image_i
	End for each 
	
Function loadPasserelle($passerelle_t : Text)->$marketingAutomation_o : Object
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.loadPasserelle
	
Change suivant le besoin de passerelle "Personne OU Telecom" (voir fichier de config du composant)
	
Historique
29/01/21 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	
	ASSERT:C1129(Storage:C1525.automation#Null:C1517; "Impossible d'utiliser la fonction loadPasserelle sans avoir fait une initialisation complète de la class MarketingAutomation")
	
	Use (Storage:C1525.automation)
		Storage:C1525.automation.passerelle:=Storage:C1525.automation.config.passerelle.query("tableComposant = :1"; $passerelle_t)[0]
		Storage:C1525.automation.formule:=New shared object:C1526("getFieldName"; Formula:C1597($1.query("lib = :1"; $2)[0].personAccess))  // $passerelle_t contient le nom de la collection dans le fichier config où la recherche doit s'effectuer et $2 doit être la valeur du champ recherché
	End use 
	
	$marketingAutomation_o:=New object:C1471("passerelle"; Storage:C1525.automation.passerelle; "formule"; Storage:C1525.automation.formule)
	
Function loadSceneConditionActionList
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.loadSceneConditionActionList
	
Permet de charger dans le Storage du composant la liste des conditions d'actions sélectionnable pour une scène
	
Historique
17/05/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $fichierConfig_o : Object
	
	ASSERT:C1129(Storage:C1525.automation#Null:C1517; "Impossible d'utiliser la fonction loadSceneConditionActionList sans avoir fait une initialisation complète de la class MarketingAutomation")
	
	$fichierConfig_o:=File:C1566(Get 4D folder:C485(Current resources folder:K5:16; *)+"cioMarketingAutomation"+Folder separator:K24:12+"scene"+Folder separator:K24:12+"conditionAction.json"; fk platform path:K87:2)
	
	If ($fichierConfig_o.exists=True:C214)
		
		Use (Storage:C1525.automation)
			Storage:C1525.automation.sceneConditionAction:=OB Copy:C1225(JSON Parse:C1218($fichierConfig_o.getText()); ck shared:K85:29; Storage:C1525.automation)
		End use 
		
	End if 
	
Function loadSceneConditionSautList
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.loadSceneConditionSautList
	
Permet de charger dans le Storage du composant la liste des conditions d'actions sélectionnable pour une scène
	
Historique
25/05/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $fichierConfig_o : Object
	
	ASSERT:C1129(Storage:C1525.automation#Null:C1517; "Impossible d'utiliser la fonction loadSceneConditionSautList sans avoir fait une initialisation complète de la class MarketingAutomation")
	
	$fichierConfig_o:=File:C1566(Get 4D folder:C485(Current resources folder:K5:16; *)+"cioMarketingAutomation"+Folder separator:K24:12+"scene"+Folder separator:K24:12+"conditionSaut.json"; fk platform path:K87:2)
	
	If ($fichierConfig_o.exists=True:C214)
		
		Use (Storage:C1525.automation)
			Storage:C1525.automation.sceneConditionSaut:=OB Copy:C1225(JSON Parse:C1218($fichierConfig_o.getText()); ck shared:K85:29; Storage:C1525.automation)
		End use 
		
	End if 