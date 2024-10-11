var $index_el : Integer
var $prestataire_c : Collection

$prestataire_c:=Storage:C1525.courrier.config.prestataire.query("nom = :1"; Form:C1466.prestataire.nom)

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT Get pointer:C1124(Object current:K67:2)->:=New object:C1471()
		OBJECT Get pointer:C1124(Object current:K67:2)->values:=New collection:C1472("SIMPLE"; "DOUBLE")
		OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:="Sélection d'un type d'envoi"
		OBJECT Get pointer:C1124(Object current:K67:2)->index:=-1
		
		If ($prestataire_c.length=1)
			$index_el:=OBJECT Get pointer:C1124(Object current:K67:2)->values.indexOf(String:C10(Form:C1466.envelope_windows_type))
			
			If ($index_el>=0)
				OBJECT Get pointer:C1124(Object current:K67:2)->index:=$index_el
				OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:=String:C10(Form:C1466.envelope_windows_type)
			End if 
			
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.envelope_windows_type:=OBJECT Get pointer:C1124(Object current:K67:2)->currentValue
End case 