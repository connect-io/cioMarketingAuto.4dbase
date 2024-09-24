var $parameter_es : Object

Case of 
	: (Form event code:C388=On Load:K2:1)
		Form:C1466.modele:=ds:C1482["Parameter"].query("type = :1"; "courrier")
		
		OBJECT Get pointer:C1124(Object current:K67:2)->:=New object:C1471()
		OBJECT Get pointer:C1124(Object current:K67:2)->values:=Form:C1466.modele.toCollection("wording").extract("wording")
		OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:="Sélection d'un modèle"
		OBJECT Get pointer:C1124(Object current:K67:2)->index:=-1
	: (Form event code:C388=On Data Change:K2:15)
		$parameter_es:=Form:C1466.modele.query("wording = :1"; OBJECT Get pointer:C1124(Object current:K67:2)->currentValue)
		
		If ($parameter_es.length>0)
			Form:C1466.wpFormula:=String:C10($parameter_es.first().formula)
			WParea:=WP New:C1317($parameter_es.first().value_b)
		End if 
		
End case 