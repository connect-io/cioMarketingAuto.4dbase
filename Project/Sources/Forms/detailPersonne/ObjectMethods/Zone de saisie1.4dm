Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		var $sexe_t : Text
		var $sexe_c : Collection
		
		$sexe_c:=Storage:C1525.automation.passerelle.libelleSexe.query("value = :1"; Form:C1466.sexe)
		
		If ($sexe_c.length>0)
			$sexe_t:=$sexe_c[0].lib
		End if 
		
		Case of 
			: ($sexe_t="homme")
				Form:C1466.imageSexe:=Storage:C1525.automation.image["male"]
			: ($sexe_t="femme")
				Form:C1466.imageSexe:=Storage:C1525.automation.image["female"]
			Else 
				Form:C1466.imageSexe:=Storage:C1525.automation.image["male-female"]
		End case 
		
End case 