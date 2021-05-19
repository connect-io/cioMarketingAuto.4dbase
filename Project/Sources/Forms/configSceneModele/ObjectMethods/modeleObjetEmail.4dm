var $elementSelected_o : Object

If (versionList_at>0)
	$elementSelected_o:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; versionList_at{versionList_at})[0]
	
	If (Form:C1466.modeleObjetEmail="")
		OB REMOVE:C1226($elementSelected_o; "subject")
	Else 
		$elementSelected_o.subject:=Form:C1466.modeleObjetEmail
		
		Form:C1466.sceneDetail.save()
	End if 
	
End if 