var $elementSelected_o : Object

If (versionList_at{versionList_at}#"Merci de sélectionner une version")
	$elementSelected_o:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; versionList_at{versionList_at})[0]
	$elementSelected_o.smsMarketing:=Form:C1466.smsMarketing
Else 
	ALERT:C41("Impossible de signifier que ce SMS est un SMS marketing car il n'y a pas de version de sélectionner")
	OBJECT Get pointer:C1124(Object current:K67:2)->:=False:C215
End if 