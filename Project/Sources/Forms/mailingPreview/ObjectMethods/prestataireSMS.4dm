Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT Get pointer:C1124(Object current:K67:2)->:=New object:C1471()
		OBJECT Get pointer:C1124(Object current:K67:2)->values:=Storage:C1525.sms.config.prestataire.extract("nom")
		OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:="Sélection d'un prestataire"
		OBJECT Get pointer:C1124(Object current:K67:2)->index:=-1
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.Sms:=cmaToolGetClass("MASms").new(False:C215; New object:C1471("nom"; OBJECT Get pointer:C1124(Object current:K67:2)->currentValue))
		Form:C1466.nbCredit:=""
		
		If (OBJECT Get pointer:C1124(Object current:K67:2)->currentValue="SMSBOX")
			Form:C1466.nbCredit:=Form:C1466.Sms.SMSBOXGetNbCredit()
		End if 
		
End case 