var $colonne_el; $ligne_el : Integer

LISTBOX GET CELL POSITION:C971(*; "listePieceJointe"; $colonne_el; $ligne_el)
CONFIRM:C162("Souhaitez-vous vraiment supprimer la pièce-jointe « "+Form:C1466.pieceJointe[$ligne_el-1].nom+" »"; "Supprimer"; "Conserver la pièce-jointe")

If (OK=1)
	Form:C1466.pieceJointe.remove($ligne_el-1)
	Frm.EMail.attachmentsPath_c.remove($ligne_el-1)
End if 