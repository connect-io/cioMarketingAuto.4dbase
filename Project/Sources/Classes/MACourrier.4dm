/* -----------------------------------------------------------------------------
Class : cs.MACourrier

-----------------------------------------------------------------------------*/

Class constructor($initialisation_b : Boolean; $parametre_o : Object)
/* -----------------------------------------------------------------------------
Fonction : MACourrier.constructor
	
Instanciation de la class avec les informations du compte d'un prestataire
pour envoyer un courrier de manière dématérialiser
	
Historique
14/05/24 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $prestataire_o : Object
	var $prestataire_c; $environnement_c : Collection
	
	var $configFile_o : 4D:C1709.File
	
	If (Bool:C1537($initialisation_b)=True:C214) | (Storage:C1525.courrier.config=Null:C1517)  // On initialise tout ça uniquement au premier appel (Normalement Sur ouverture de la base)
		
		Use (Storage:C1525)
			Storage:C1525.courrier:=New shared object:C1526()
		End use 
		
		// Chargement du fichier de config
		$configFile_o:=Folder:C1567(fk resources folder:K87:11; *).file("cioMarketingAutomation/courrier/config.json")
		
		If (Not:C34($configFile_o.exists))  // Il n'existe pas de fichier de config dans la base hote, on le génère.
			Folder:C1567(fk resources folder:K87:11).file("cioMarketingAutomation/courrier/config.json").copyTo($configFile_o.parent; $configFile_o.fullName)
		End if 
		
		If ($configFile_o.exists=True:C214)
			
			Use (Storage:C1525.courrier)
				Storage:C1525.courrier.config:=OB Copy:C1225(JSON Parse:C1218($configFile_o.getText()); ck shared:K85:29; Storage:C1525.courrier)
			End use 
			
			$configFile_o:=Folder:C1567(fk resources folder:K87:11; *).file("cioMarketingAutomation/courrier/config.jsonc")
			
			If (Not:C34($configFile_o.exists))  // Il n'existe pas de fichier de config dans la base hote, on le génère.
				Folder:C1567(fk resources folder:K87:11).file("cioMarketingAutomation/courrier/config.jsonc").copyTo($configFile_o.parent; $configFile_o.fullName)
			End if 
			
		Else 
			ALERT:C41("Impossible d'instancier la class MACourrier du composant caMarketingAutomation, le fichier de configuration n'a pas pu être trouvé dans la base hôte.")
		End if 
		
		return 
	End if 
	
	If (Storage:C1525.courrier.config=Null:C1517)
		ALERT:C41("Le fichier ne configuration n'a pas été chargé auparavant")
		return 
	End if 
	
	$prestataire_c:=Storage:C1525.courrier.config.prestataire.query("nom = :1"; $parametre_o.nom)
	
	If ($prestataire_c.length=0)
		ALERT:C41("Impossible de retrouver le prestataire "+String:C10($parametre_o.nom))
		return 
	End if 
	
	$prestataire_o:=$prestataire_c[0]
	
	$prestataire_o:=cmaToolObjectMerge($prestataire_o; $parametre_o)
	This:C1470.prestataire:=$prestataire_o
	
	$environnement_c:=$prestataire_c[0].environnement.query("nom = :1"; String:C10($parametre_o.environnement))
	
	If ($environnement_c.length=0)
		ALERT:C41("Impossible de retrouver l'environnement "+String:C10($parametre_o.environnement))
		return 
	End if 
	
	This:C1470.attachmentsPath_c:=New collection:C1472
	This:C1470.useCurrentPrinter:=($parametre_o.nom="Imprimante courante")
	This:C1470.environnement:=$environnement_c[0]
	This:C1470.token:=""
	
Function getTokenAPIMaileva()->$result_o : Object
/*------------------------------------------------------------------------------
Fonction : MACourrier.getTokenAPIMaileva()
	
Obtenir un token pour faire des requêtes à Maileva au format JWT
Dans l'entête HTTP pour utiliser l'API il faut mettre : $option_o.headers.Authorization:="Bearer "+String(This.token)
	
Historique
06/09/24 - Rémy Scanu remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $url_t; $parameter_t : Text
	var $body_b : Blob
	var $option_o : Object
	
	var $request_hr : 4D:C1709.HTTPRequest
	
	If (This:C1470.environnement.username="") | (This:C1470.environnement.password="") | (This:C1470.environnement.clientID="") | (This:C1470.environnement.clientSecret="")
		ALERT:C41("Des paramètres sont manquants dans le fichier de config pour la génération du token de Maileva, veuillez vérifier parmis ces informations :"+Char:C90(Carriage return:K15:38)+JSON Stringify:C1217(This:C1470.environnement; *))
		return 
	End if 
	
	$parameter_t:="grant_type=password&username="+This:C1470.environnement.username+"&password="+This:C1470.environnement.password+""
	CONVERT FROM TEXT:C1011($parameter_t; "utf-8"; $body_b)
	
	$option_o:=New object:C1471()
	$option_o.method:="POST"
	
	$option_o.headers:=New object:C1471("Content-Type"; "application/x-www-form-urlencoded")
	$option_o.serverAuthentication:=New object:C1471("name"; This:C1470.environnement.clientID; "password"; This:C1470.environnement.clientSecret)
	$option_o.body:=$body_b
	
	$url_t:=This:C1470.content_o.requestElement.query("lib = :1"; "getToken")[0]
	
	$request_hr:=4D:C1709.HTTPRequest.new($url_t; $option_o)
	$request_hr.wait()
	
	$result_o:=$request_hr.response
	
	If (Num:C11($request_hr.response.status)=200) | (Num:C11($request_hr.response.status)=201)
		This:C1470.token:=$result_o.body
	End if 
	
Function request($lib_t : Text; $body_v : Variant)->$result_o : Object
/*------------------------------------------------------------------------------
Fonction : APIMaileva.request()
	
Fait une requête simple
	
Historique
18/06/24 - Rémy Scanu remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $property_t; $url_t; $boundary_t : Text
	var $body_b : Blob
	var $option_o; $requestElement_o; $keyValue_o : Object
	var $keyValue_c : Collection
	
	ARRAY TEXT:C222($key_at; 0)  // Nom de la variable
	ARRAY TEXT:C222($val_at; 0)  // Contenu de la variable.
	
	var $request_hr : 4D:C1709.HTTPRequest
	
	$result_o:=New object:C1471
	$requestElement_o:=OB Copy:C1225(This:C1470.content_o.requestElement.query("lib = :1"; $lib_t)[0])
	
	$option_o:=New object:C1471()
	$option_o.method:=$requestElement_o.method
	
	If ($requestElement_o.formDataList#Null:C1517)
		
		For each ($formData_o; $requestElement_o.formDataList)
			
			If ($formData_o.type="document")
				APPEND TO ARRAY:C911($key_at; $formData_o.name+"\"; filename=\""+$body_v.file.name+"\"")
				APPEND TO ARRAY:C911($val_at; "{{RAW_JFIF_DATA}}")
			Else 
				APPEND TO ARRAY:C911($key_at; $formData_o.name)
				APPEND TO ARRAY:C911($val_at; String:C10($body_v[$formData_o.name]))
			End if 
			
		End for each 
		
		$document_b:=$body_v.file.getContent()
		$boundary_t:=cmaToolWebSetWebFormVariables(->$key_at; ->$val_at; ->$body_b; ->$document_b)
		
		If ($boundary_t="Error@")
			return New object:C1471("state"; False:C215; "message"; "Error setting web form variables")
		End if 
		
		OB REMOVE:C1226($body_v; "file")
		$option_o.headers:=New object:C1471("Content-Type"; "multipart/form-data; boundary="+$boundary_t)
	Else 
		$option_o.headers:=New object:C1471("Content-Type"; "application/json")
	End if 
	
	$option_o.headers.Authorization:="Bearer "+String:C10(This:C1470.token)
	$url_t:=This:C1470.environnement.urlAPI+$requestElement_o.url
	
	Case of 
		: (Value type:C1509($body_v)=Is object:K8:27)
			
			If ($body_v.modifyURL#Null:C1517)
				
				For each ($property_t; $body_v.modifyURL)
					$url_t:=Replace string:C233($url_t; $property_t; $body_v.modifyURL[$property_t])
				End for each 
				
				OB REMOVE:C1226($body_v; "modifyURL")
			End if 
			
			Case of 
				: ($requestElement_o.formDataList#Null:C1517)
					$option_o.body:=$body_b
				: (Bool:C1537($body_v.contentInURL)=False:C215)
					$option_o.body:=$body_v
				Else 
					OB REMOVE:C1226($body_v; "contentInURL")
					$keyValue_c:=OB Entries:C1720($body_v)
					
					For each ($keyValue_o; $keyValue_c)
						
						If ($keyValue_o.key#"inUrl")
							
							If ($keyValue_c.indexOf($keyValue_o)=0) & (Position:C15("?"; $url_t; 1)=0)
								$url_t:=$url_t+"?"
							Else 
								$url_t:=$url_t+"&"
							End if 
							
							$url_t:=$url_t+$keyValue_o.key+"="+String:C10($keyValue_o.value)
						End if 
						
					End for each 
					
			End case 
			
		: (Value type:C1509($body_v)=Is text:K8:3)
			$url_t:=$url_t+$body_v
	End case 
	
	$request_hr:=4D:C1709.HTTPRequest.new($url_t; $option_o)
	$request_hr.wait()
	
	$result_o:=$request_hr.response
	
	If (Num:C11($request_hr.response.status)=200) | (Num:C11($request_hr.response.status)=201) | (Num:C11($request_hr.response.status)=204)
		$result_o:=$result_o.body
	Else 
		$result_o.messageError:=$requestElement_o.messageError
	End if 