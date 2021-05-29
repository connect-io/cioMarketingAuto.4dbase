//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : caNumToDate

Permet de faire des opérations sur une date

Historique
16/07/20 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $0 : Date
var $1 : Integer
var $2 : Text
var $3 : Text

Case of 
	: ($2="year")
		
		If ($3="add")
			$0:=Add to date:C393(Current date:C33; $1; 0; 0)
		Else 
			$0:=Add to date:C393(Current date:C33; -$1; 0; 0)
		End if 
		
End case 