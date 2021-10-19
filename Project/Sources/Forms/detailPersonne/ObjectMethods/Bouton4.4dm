var $propriete_t; $fieldName_t : Text
var $class_o; $table_o : Object

$class_o:=cmaToolGetClass("MAPersonne").new()

For each ($propriete_t; Form:C1466)
	$fieldName_t:=$class_o.getFieldName($propriete_t)
	
	If ($fieldName_t#"")
		
		If (OB Is defined:C1231(Form:C1466.personne; $fieldName_t)=True:C214)  // Si la propriété est un champ de la table [Personne] de la base hôte
			Form:C1466.personne[$fieldName_t]:=Form:C1466[$propriete_t]
		End if 
		
	End if 
	
End for each 

Form:C1466.personne.save()

// Sauvegarde de la table [CaMarketing]
$table_o:=Form:C1466.personne.AllCaPersonneMarketing[0]

Case of 
	: (Picture size:C356(Form:C1466.imageDesabonnement)=Picture size:C356(Storage:C1525.automation.image["toggle-off"]))
		$table_o.desabonementMail:=True:C214
	: (Picture size:C356(Form:C1466.imageDesabonnement)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
		$table_o.desabonementMail:=False:C215
End case 

$table_o.rang:=Num:C11(Form:C1466.rang)

$table_o.save()

ACCEPT:C269