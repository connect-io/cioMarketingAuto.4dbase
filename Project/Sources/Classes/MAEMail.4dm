/* -----------------------------------------------------------------------------
Class : cs.MAEMail

-----------------------------------------------------------------------------*/

Class constructor($transporter_t : Text; $parametre_o : Object)
/* -----------------------------------------------------------------------------
Fonction : MAEMail.constructor
	
Instanciation de la class avec le nom du transporter à utiliser en paramètre (voir fichier de config)
	
Historique
02/01/20 - quentin@connect-io.fr - Création
10/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reprise du code
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Clean code
-----------------------------------------------------------------------------*/
	var $transporter_c : Collection  // Récupère la collection de plumeDemo
	var $server_o; $function_o : Object  // Informations SMTP
	
	ASSERT:C1129($transporter_t#""; "EMail.constructor : le Param $transporter_t est obligatoire.")
	
	If (cwStorage.eMail=Null:C1517)
		$function_o:=Formula from string:C1601("cwEMailConfigLoad").call(This:C1470)
	End if 
	
	$server_o:=New object:C1471()
	
	// Vérifie que le nom du transporteur soit bien dans la config
	$transporter_c:=cwStorage.eMail.transporter.query("name IS :1 AND type = :2"; $transporter_t; "smtp")
	
	If ($transporter_c.length=1)
		$server_o:=$transporter_c[0]
	End if 
	
	// Il est possible de surcharger le transporteur.
	If (Count parameters:C259=2)
		$server_o:=cmaToolObjectMerge($server_o; $parametre_o)
	End if 
	
	If ($server_o#Null:C1517)
		This:C1470.transporter:=SMTP New transporter:C1608($server_o)
	Else 
		ALERT:C41("Aucune occurence trouvé au sein du fichier JSON")
		
		This:C1470.transporter:=New object:C1471()
	End if 
	
	// Initialisation des pieces jointes
	This:C1470.attachmentsPath_c:=New collection:C1472()
	
	If (String:C10($server_o.from)#"")
		This:C1470.from:=$server_o.from
	End if 
	
	If (cwStorage.eMail.globalVar#Null:C1517)
		This:C1470.globalVar:=OB Copy:C1225(cwStorage.eMail.globalVar)
	End if 
	
Function send()->$retour_o : Object
/* -----------------------------------------------------------------------------
Méthode : EMail.send
	
Envoie simple d'un e-mail
	
Les informations sur l'email :
	
Informations obligatoire :
this.to -> text : Destinataire
this.htmlBody ou this.textBody -> text : Corps du message
	
Informataions optionelles :
this.attachmentsPath_c -> Collection : Chemin des pièces jointes.
	
Historique
11/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reécriture du code du composant plume.
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Clean code
-----------------------------------------------------------------------------*/
	var $mailStatus_o : Object  // transporter, info sur mail et envoie de l'email
	var $error_t : Text  // Info concernant les erreurs
	var $cheminPj_v : Variant  // Chemin pièce jointe
	
	$mailStatus_o:=New object:C1471("success"; False:C215)
	
	ASSERT:C1129(This:C1470.transporter#Null:C1517; "Impossible d'utiliser la fonction send sans avoir initialisé un transporter")
	
	If (This:C1470.transporter=Null:C1517)  // On vérifie que l'on a bien notre transporter
		$error_t:="Il n'y a pas de transporter d'initialisé."
	End if 
	
	If (This:C1470.to=Null:C1517)
		$error_t:="Il manque le destinataire de votre e-mail. ($1.to)"
	End if 
	
	If (String:C10(This:C1470.from)="")  // On vérifie que l'on a bien notre émetteur
		This:C1470.from:=This:C1470.transporter.user
	End if 
	
	If (String:C10(This:C1470.htmlBody)="") & (String:C10(This:C1470.textBody)="") & (This:C1470.bodyStructure=Null:C1517)  // On vérifie que notre corps de message n'est pas vide (si This.bodyStructure est null ça veux dire qu'on ne passe pas par un mime mais par du code HTMLEUH classico-classique !)
		$error_t:="Il manque le contenu de votre message."
	End if 
	
	If ($error_t="")  // Si aucune erreur, on envoie le mail
		
		If (This:C1470.attachmentsPath_c.length#0)  // On vérifie que l'on à bien des pièces jointes
			This:C1470.attachments:=New collection:C1472()
			
			For each ($cheminPj_t; This:C1470.attachmentsPath_c)  // On boucle sur les pièces jointes
				
				If (Type:C295($cheminPj_t)=Is text:K8:3)  // On vérifie que le chemin de pièce jointe est bien de type texte
					
					If (Test path name:C476($cheminPj_t)=Is a document:K24:1)  // On vérifie que la pièce jointe est bien un document existant sur le disque
						This:C1470.attachments.push(MAIL New attachment:C1644($cheminPj_t))
					Else 
						$error_t:="Le document suivant n'est pas présent sur le disque : "+$cheminPj_t
					End if 
					
				Else 
					$error_t:="Un élément de la collection des pièces jointes n'est pas une chaine de caractère."
				End if 
				
			End for each 
			
		End if 
		
	End if 
	
	If ($error_t="")  //Envoi du mail
		$mailStatus_o:=This:C1470.transporter.send(This:C1470)
		
		If ($mailStatus_o.success=False:C215)  //Si l'envoie du mail = False
			$error_t:="Une erreur est survenue lors de l'envoi de l'e-mail : "+$error_t+$mailStatus_o.statusText
		End if 
		
	End if 
	
	If ($error_t#"")
		$mailStatus_o.statusText:=$error_t
		$mailStatus_o.status:=-1
	End if 
	
	$retour_o:=$mailStatus_o
	
Function sendModel($model_t : Text; $parametre_o : Object)->$retour_o : Object
/* -----------------------------------------------------------------------------
Méthode : EMail.sendModel
	
Envoi d'un e-mail depuis un modèle du composant
	
Historique
11/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reécriture du code du composant plume.
29/05/21 - Rémy Scanu <remy@connect-io.fr> - Clean code
-----------------------------------------------------------------------------*/
	var $error_t : Text  // Gestion des erreurs.
	var $model_c : Collection  // Informations tableau JSON du modèle
	var $model_o : Object  // Detail du modèle
	var $returnVar_t : Text  // Retourne le texte si 3ème paramètre
	var $mailStatus_o : Object  // Réponse de l'envoi du mail.
	
	ASSERT:C1129($model_t#""; "EMail.sendModel : le Param $model_t est obligatoire (Nom du modèle)")
	
	$mailStatus_o:=New object:C1471("success"; False:C215)
	
	If (Count parameters:C259=2)
		
		For each ($propriete_t; $parametre_o)
			This:C1470[$propriete_t]:=$parametre_o[$propriete_t]
		End for each 
		
	End if 
	
	// Vérification fichier modèle
	$model_c:=cwStorage.eMail.model.query("name IS :1"; $model_t)
	
	// Retrouver les informations du modèle
	If ($model_c.length=1)
		$model_o:=$model_c[0]
		
		corps_t:=File:C1566(cwStorage.eMail.modelPath+$model_o.source).getText()
		
		// Gestion du layout
		If (String:C10($model_o.layout)#"")
			This:C1470.htmlBody:=File:C1566(cwStorage.eMail.modelPath+$model_o.layout).getText()
		Else 
			This:C1470.htmlBody:=corps_t
		End if 
		
	Else 
		$error_t:="EMail.sendModel : Impossible de retrouver le modèle : "+$model_t
	End if 
	
	If ($error_t="")
		
		// Si l'objet n'est pas défini avant on applique celui du modèle.
		If (String:C10(This:C1470.subject)="")
			This:C1470.subject:=String:C10($model_o.subject)
		End if 
		
		PROCESS 4D TAGS:C816(This:C1470.subject; $returnVar_t)
		This:C1470.subject:=$returnVar_t
		
		// On gère les destinataires du message.
		If (This:C1470.to=Null:C1517)
			
			If ($model_o.to#Null:C1517)
				This:C1470.to:=$model_o.to
			End if 
			
		End if 
		
		If (Count parameters:C259=2) | (String:C10($model_o.layout)#"")  // Les variables html sont utilisées dans l'email, il faut les traiter avec 4D.
			PROCESS 4D TAGS:C816(This:C1470.htmlBody; $returnVar_t)
			
			This:C1470.htmlBody:=$returnVar_t
		End if 
		
		// Envoie du mail
		$mailStatus_o:=This:C1470.send()
	End if 
	
	If ($error_t#"")
		$mailStatus_o.statusText:=$error_t
		$mailStatus_o.status:=-1
	End if 
	
	// Retourne les informations concernant l'envoie du mail
	$retour_o:=$mailStatus_o