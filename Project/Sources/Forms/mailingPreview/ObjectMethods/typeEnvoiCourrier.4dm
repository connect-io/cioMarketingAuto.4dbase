var $type_c : Collection

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT Get pointer:C1124(Object current:K67:2)->:=New object:C1471()
		OBJECT Get pointer:C1124(Object current:K67:2)->values:=New collection:C1472
		OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:="Sélection d'un type d'envoi"
		OBJECT Get pointer:C1124(Object current:K67:2)->index:=-1
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.delaiCourrier:=""
		$type_c:=Form:C1466.Courrier.prestataire.postageType.query("lib = :1"; OBJECT Get pointer:C1124(Object current:K67:2)->currentValue)
		
		If ($type_c.length=1)
			Form:C1466.delaiCourrier:=String:C10($type_c[0].delay)+" jours"
		End if 
		
End case 