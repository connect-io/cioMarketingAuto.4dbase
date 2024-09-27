//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cmaToolGetCwEMailConfigLoad

Copie dans le Storage du composant l'objet cwStorage.eMail

Historique
06/01/23 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
var $1 : Pointer

If (Value type:C1509($1->)=Is object:K8:27) && ($1->eMail#Null:C1517)
	
	Use (Storage:C1525)
		Storage:C1525.eMail:=New shared object:C1526
	End use 
	
	Use (Storage:C1525.eMail)
		Storage:C1525.eMail.detail:=OB Copy:C1225($1->eMail; ck shared:K85:29; Storage:C1525.eMail)
	End use 
	
End if 