var $canalEnvoi_t : Text

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT Get pointer:C1124(Object current:K67:2)->:=New object:C1471()
		OBJECT Get pointer:C1124(Object current:K67:2)->values:=New collection:C1472("EMail"; "SMS"; "Courrier")
		OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:="Sélection d'un canal d'envoi"
		OBJECT Get pointer:C1124(Object current:K67:2)->index:=-1
	: (Form event code:C388=On Data Change:K2:15)
		OBJECT SET VISIBLE:C603(*; "Texte5"; True:C214)
		OBJECT SET VISIBLE:C603(*; "modele"; True:C214)
		
		OBJECT SET VISIBLE:C603(*; "WPtoolbar"; True:C214)
		OBJECT SET VISIBLE:C603(*; "WParea"; True:C214)
		
		$canalEnvoi_t:=OBJECT Get pointer:C1124(Object current:K67:2)->currentValue
		
		Case of 
			: ($canalEnvoi_t="EMail")
				FORM GOTO PAGE:C247(2)
			: ($canalEnvoi_t="SMS")
				ALERT:C41("Fonction indisponible")
			: ($canalEnvoi_t="Courrier")
				ALERT:C41("Fonction indisponible")
		End case 
		
End case 