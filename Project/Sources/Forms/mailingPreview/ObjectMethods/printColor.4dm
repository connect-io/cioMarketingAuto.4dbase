If (Form:C1466.Courrier=Null:C1517)
	ALERT:C41("Veuillez sélectionner un prestataire ou cliquer sur le bouton \"Utiliser imprimante courante\" avant de pouvoir sélectionner cette option")
	OBJECT Get pointer:C1124(Object current:K67:2)->:=False:C215
	
	return 
End if 