//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cmaToolGetNewID

Retour un nouvel ID pour une table qui possède une clé primaire numérique

Historique
10/06/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $0 : Integer
var $1 : Text  // Nom de la table
var $2 : Text  // Nom du champ (Clé primaire)

var $table_o : Object

$table_o:=ds:C1482[$1].all()
$table_o.refresh()

If ($table_o.length=0)
	$0:=1
Else 
	$table_o:=$table_o.orderBy($2+" desc")
	$0:=$table_o[0][$2]+1
End if 