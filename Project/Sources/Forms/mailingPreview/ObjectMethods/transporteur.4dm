Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		OBJECT Get pointer:C1124(Objet courant:K67:2)->:=New object:C1471()
		OBJECT Get pointer:C1124(Objet courant:K67:2)->values:=cwStorage.eMail.smtp.extract("name")
		OBJECT Get pointer:C1124(Objet courant:K67:2)->currentValue:="Sélection d'un expéditeur"
		OBJECT Get pointer:C1124(Objet courant:K67:2)->index:=-1
	: (Form event code:C388=Sur données modifiées:K2:15)
		Form:C1466.EMail:=cmaToolGetClass("MAEMail").new(OBJECT Get pointer:C1124(Objet courant:K67:2)->currentValue)
End case 