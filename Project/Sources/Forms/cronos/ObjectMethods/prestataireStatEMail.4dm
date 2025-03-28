var $prestataire_o : Object

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT Get pointer:C1124->:=New object:C1471
		OBJECT Get pointer:C1124->values:=Form:C1466.statistiqueEmail.extract("prestataire")
		
		OBJECT Get pointer:C1124->currentValue:=Form:C1466.statistiqueEmail.query("actif = :1"; True:C214)[0].prestataire
		OBJECT Get pointer:C1124->index:=Form:C1466.statistiqueEmail.indices("actif = :1"; True:C214)[0]
	: (Form event code:C388=On Data Change:K2:15)
		
		For each ($prestataire_o; Form:C1466.statistiqueEmail)
			$prestataire_o.actif:=($prestataire_o.prestataire=OBJECT Get pointer:C1124->currentValue)
		End for each 
		
		Form:C1466.cronosVerifStatistiqueEmail:=0
End case 