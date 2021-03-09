//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwWebAppStart

Permet de faire l'éxécution de la partie WebApp du composant cioWeb

Historique
16/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

// Déclarations
var $0 : Object

// Instanciation de la class
//$0:=cwToolGetClass("webApp").new()

//Si (Type application=4D Server) | (Type application=4D mode local)
//MESSAGE("Arrêt du serveur web..."+Caractère(Retour chariot))
//WEB ARRÊTER SERVEUR

//MESSAGE("Chargement de l'application web..."+Caractère(Retour chariot))
//$0.serverStart()

//MESSAGE("Redémarrage du serveur web..."+Caractère(Retour chariot))
//WEB DÉMARRER SERVEUR

//Si (OK#1)
//ALERTE("Le serveur web n'est pas correctement démarré.")
//Fin de si 

//// Démarrage des sessions.
//$0.sessionWebStart()
//Fin de si 

//// Démarrage de la config pour l'envoie d'email
//cwEMailConfigLoad