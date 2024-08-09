/* -----------------------------------------------------------------------------
Class : cs.MASms

-----------------------------------------------------------------------------*/

Class constructor($initialisation_b : Boolean; $parametre_o : Object)
/* -----------------------------------------------------------------------------
Fonction : MASms.constructor
	
Instanciation de la class avec le nom du prestataire à utiliser en paramètre (voir fichier de config)
	
Historique
14/05/24 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $prestataire_o : Object
	var $prestataire_c : Collection
	
	var $configFile_o : 4D:C1709.File
	
	If (Bool:C1537($initialisation_b)=True:C214)  // On initialise tout ça uniquement au premier appel (Normalement Sur ouverture de la base)
		
		Use (Storage:C1525)
			Storage:C1525.sms:=New shared object:C1526()
		End use 
		
		// Chargement du fichier de config
		$configFile_o:=Folder:C1567(fk resources folder:K87:11; *).file("cioMarketingAutomation/sms/config.json")
		
		If (Not:C34($configFile_o.exists))  // Il n'existe pas de fichier de config dans la base hote, on le génère.
			Folder:C1567(fk resources folder:K87:11).file("cioMarketingAutomation/sms/config.json").copyTo($configFile_o.parent; $configFile_o.fullName)
		End if 
		
		If ($configFile_o.exists=True:C214)
			
			Use (Storage:C1525.sms)
				Storage:C1525.sms.config:=OB Copy:C1225(JSON Parse:C1218($configFile_o.getText()); ck shared:K85:29; Storage:C1525.sms)
			End use 
			
		Else 
			ALERT:C41("Impossible d'instancier la class MASms du composant caMarketingAutomation, le fichier de configuration n'a pas pu être trouvé dans la base hôte.")
		End if 
		
		return 
	End if 
	
	If (Storage:C1525.sms.config=Null:C1517)
		ALERT:C41("Le fichier ne configuration n'a pas été chargé auparavant")
		return 
	End if 
	
	$prestataire_c:=Storage:C1525.sms.config.prestataire.query("nom = :1"; $parametre_o.nom)
	
	If ($prestataire_c.length=1)
		$prestataire_o:=$prestataire_c[0]
	End if 
	
	$prestataire_o:=cmaToolObjectMerge($prestataire_o; $parametre_o)
	This:C1470.prestataire:=$prestataire_o
	
	This:C1470.message:=""
	This:C1470.destinataire:=""
	
Function MailjetSendMessage($message_t : Text; $destinataire_t : Text) : Text
/* -----------------------------------------------------------------------------
Fonction : MASms.MailjetSendMessage()
	
Envoi un SMS avec Mailjet
	
Historique
05/08/24 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	cwToolWebHttpRequest("POST"; This:C1470.prestataire.domaine+"/sms-send"; JSON Stringify:C1217(New object:C1471("From"; This:C1470.prestataire.from; "To"; $destinataire_t; "Text"; $message_t); *); ->$reponse_t; \
		New collection:C1472("Authorization"; "Content-Type"); New collection:C1472("Bearer "+This:C1470.prestataire.token; "application/json"))
	
	return $message_t
	
Function SMSBOXCheckCredit()->$creditOK_b : Boolean
/* -----------------------------------------------------------------------------
Fonction : MASms.SMSBOXCheckCredit()
	
Vérifie si suffisament de crédit pour envoyer un SMS
Note pour nouveau compte il faut utiliser authentification par entête HTTP
	
Historique
02/08/24 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $reponse_t : Text
	
	cwToolWebHttpRequest("GET"; "https://api.smsbox.pro/1.1/api.php?action=credit"; ""; ->$reponse_t; New collection:C1472("Authorization"); New collection:C1472("App "+This:C1470.prestataire.apiKey))
	$creditOK_b:=($reponse_t#"CREDIT 0") & ($reponse_t#"ERROR@")
	
Function SMSBOXSendMessage($checkCredit_b : Boolean; $message_t : Text; $destinataire_t : Text; $date_d : Date; $heure_h : Time; $mode_t : Text; $strategy_t : Text) : Text
/* -----------------------------------------------------------------------------
Fonction : MASms.SMSBOXSendMessage()
	
Envoi un SMS avec SMSBox
	
Historique
01/08/24 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $reponse_t : Text
	
	$mode_t:=Replace string:C233($mode_t; "é"; "e")
	
	If (Day number:C114($date_d)=Sunday:K10:19) | ((cmaToolDateIsPublicHoliday("fr"; $date_d)=True:C214) & (($destinataire_t="33@") | ($destinataire_t="+33@")))
		$strategy_t:="2"
	End if 
	
	This:C1470.destinataire:=$destinataire_t
	This:C1470.message:=$message_t
	
	// Gestion de la desinscription
	Case of 
		: ($mode_t="Expert") & ($strategy_t="4")
			This:C1470.message:=This:C1470.message+Char:C90(Line feed:K15:40)+"STOP SMS #XYZ#"  // 17 car.
		: ($mode_t="Standard") & ($strategy_t="4")
			This:C1470.message:=This:C1470.message+Char:C90(Line feed:K15:40)+"STOP si refus SMS"  // 17 car.
		: ($mode_t="Reponse") & ($strategy_t="4")
			This:C1470.message:=This:C1470.message+Char:C90(Line feed:K15:40)+"STOP SMS 36111"  // 17 car.
	End case 
	
	This:C1470.cleanMessage()
	
	If ($mode_t#"Expert") | ($mode_t#"expert")
		This:C1470.url:="https://api.smsbox.pro/1.1/api.php?dest="+$destinataire_t+"&msg="+This:C1470.messageEncode+"&mode="+$mode_t+"&date="+String:C10($date_d)+\
			"&heure="+Time string:C180($heure_h)+"&strategy="+$strategy_t
	Else 
		This:C1470.url:="https://api.smsbox.pro/1.1/api.php?dest="+$destinataire_t+"&msg="+This:C1470.messageEncode+"&mode="+$mode_t+"&date="+String:C10($date_d)+\
			"&heure="+Time string:C180($heure_h)+"&origine="+This:C1470.prestataire.origine+"&strategy="+$strategy_t
	End if 
	
	This:C1470.url+="&enable_short_url=yes"
	
	If ($checkCredit_b=True:C214) && (This:C1470.SMSBOXCheckCredit()=False:C215)
		return "Crédit insuffisant"
	End if 
	
	// Envoi du message
	cwToolWebHttpRequest("GET"; This:C1470.url; ""; ->$reponse_t; New collection:C1472("Authorization"); New collection:C1472("App "+This:C1470.prestataire.apiKey))
	
	Case of 
		: ($reponse_t="OK")  // Pas d'erreur
			return "Le sms a bien été envoyé !"
		: ($reponse_t="ERROR 01")  // Paramètres manquants
			return "Le sms n'a pas pu être envoyé, des paramètres sont manquants !"+Char:C90(Line feed:K15:40)+"Url : "+This:C1470.url
		: ($reponse_t="ERROR 02")  // Identifiants incorrects, clé API suspendue
			return "Le sms n'a pas pu être envoyé, car les identifiants utilisés sont incorrects !"+Char:C90(Line feed:K15:40)+"Login : "+This:C1470.prestataire.login+", mot de passe : "+This:C1470.prestataire.password
		: ($reponse_t="ERROR 03")  // Solde épuisé
			return "Le sms n'a pas pu être envoyé, car votre solde est épuisé !"
		: ($reponse_t="ERROR 04")  // Téléphone destinataire invalide
			return "Le sms n'a pas pu être envoyé, car le numéro du destinataire n'est pas au bon format !"+Char:C90(Line feed:K15:40)+"Téléphone : "+$destinataire_t
		Else 
			return $reponse_t
	End case 
	
Function cleanMessage()
/* -----------------------------------------------------------------------------
Fonction : MASms.sendWithSMSBox()
	
Nettoye le message envoyé
	
Historique
02/08/24 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $charCode_t : Text
	var $i_el : Integer
	
	This:C1470.messageEncode:=""
	
	For ($i_el; 1; Length:C16(This:C1470.message))
		$charCode_t:=String:C10(Character code:C91(This:C1470.message[[$i_el]]); "&$")
		
		If ($charCode_t="$D")
			$charCode_t:="$A"
		End if 
		
		If (Length:C16($charCode_t)=2)  // Gére les caractéres dont le code HEXA n'est que sur un chiffre.
			$charCode_t:=Insert string:C231($charCode_t; "0"; 2)
		End if 
		
		This:C1470.messageEncode:=This:C1470.messageEncode+$charCode_t
	End for 
	
	This:C1470.messageEncode:=Replace string:C233(This:C1470.messageEncode; "$"; "%")
	
Function cleanMobilePhone($isoCode_t : Text)
/* -----------------------------------------------------------------------------
Fonction : MASms.cleanMobilePhone()
	
Met au format international le numéro de téléphone mobile
	
Historique
07/08/24 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	
	Case of 
		: ($isoCode_t="fr")
			
	End case 