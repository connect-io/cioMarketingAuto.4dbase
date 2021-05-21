Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $zone4WP_t : Text
		
		$zone4WP_t:="WParea"
		
		If (Bool:C1537(Form:C1466.voirVariable)=False:C215)
			ST SET OPTIONS:C1289(*; $zone4WP_t; ST Mode affichage expressions:K78:5; ST Références:K78:7)
			
			Form:C1466.voirVariable:=True:C214
		Else 
			ST COMPUTE EXPRESSIONS:C1285(*; $zone4WP_t; ST Début texte:K78:15; ST Fin texte:K78:16)
			ST SET OPTIONS:C1289(*; $zone4WP_t; ST Mode affichage expressions:K78:5; ST Valeurs:K78:6)
			
			Form:C1466.voirVariable:=False:C215
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 