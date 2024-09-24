var $elementSelected_o : Object

If (versionList_at{versionList_at}#"Merci de sélectionner une version")
	$elementSelected_o:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; versionList_at{versionList_at})[0]
	$elementSelected_o.notifEmail:=Form:C1466.notifEmail
Else 
	ALERT:C41("Impossible de mettre en place une notification par email pour ce courrier car il n'y a pas de version de sélectionner")
	Form:C1466.notifEmail:=False:C215
End if 

OBJECT SET ENABLED:C1123(*; "configNotifEmail"; Form:C1466.notifEmail)