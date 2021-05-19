var $elementSelected_o : Object

If (versionList_at{versionList_at}#"Merci de sélectionner une version")
	$elementSelected_o:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; versionList_at{versionList_at})[0]
	$elementSelected_o.expediteur:=expediteurList_at{expediteurList_at}
Else 
	ALERT:C41("Impossible de fixer un expéditeur car il n'y a pas de version de sélectionner")
	
	expediteurList_at{0}:="Merci de sélectionner un expéditeur"
	expediteurList_at:=0
End if 