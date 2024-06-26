/* -----------------------------------------------------------------------------
Class : cs.MASms

-----------------------------------------------------------------------------*/

Class constructor($initialisation_b : Boolean; $prestataire_t : Text)
/* -----------------------------------------------------------------------------
Fonction : MASms.constructor
	
Instanciation de la class avec le nom du prestataire à utiliser en paramètre (voir fichier de config)
	
Historique
14/05/24 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
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
			
		End if 
		
	End if 
	
	