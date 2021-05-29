//%attributes = {"shared":true,"executedOnServer":true}
/* -----------------------------------------------------------------------------
Méthode : cwWebAppStart

Permet de faire l'éxécution de la partie WebApp du composant cioWeb

Historique
16/02/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $0 : Object

var $function_o : Object

// Instanciation de la class
$0:=Formula from string:C1601("cwToolGetClass(\"webApp\").new()").call(This:C1470)

If (Application type:C494#4D mode distant:K5:5)
	MESSAGE:C88("Arrêt du serveur web..."+Char:C90(Retour chariot:K15:38))
	WEB STOP SERVER:C618
	
	MESSAGE:C88("Chargement de l'application web..."+Char:C90(Retour chariot:K15:38))
	$0.serverStart()
	
	MESSAGE:C88("Redémarrage du serveur web..."+Char:C90(Retour chariot:K15:38))
	WEB START SERVER:C617
	
	If (OK#1)
		ALERT:C41("Le serveur web n'est pas correctement démarré.")
	End if 
	
	// Démarrage des sessions.
	$0.sessionWebStart()
End if 

// Démarrage de la config pour l'envoie d'email
If (cwStorage.eMail=Null:C1517)
	$function_o:=Formula from string:C1601("cwEMailConfigLoad").call(This:C1470)
End if 