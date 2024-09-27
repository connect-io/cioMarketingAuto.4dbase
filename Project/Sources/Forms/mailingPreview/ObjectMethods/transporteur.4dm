Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT Get pointer:C1124(Object current:K67:2)->:=New object:C1471()
		OBJECT Get pointer:C1124(Object current:K67:2)->values:=cmaStorage.eMail.detail.transporter.query("type = :1"; "smtp").extract("name")
		OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:="Sélection d'un expéditeur"
		OBJECT Get pointer:C1124(Object current:K67:2)->index:=-1
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.EMail:=cmaToolGetClass("MAEMail").new(OBJECT Get pointer:C1124(Object current:K67:2)->currentValue)
End case 