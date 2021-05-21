Case of 
	: (Form event code:C388=Sur clic:K2:4)
		CONFIRM:C162("Voulez-vous imprimer le document ?"; "Oui"; "Non")
		
		If (OK=1)
			cmaToolWrProImpr(True:C214; "simple"; ""; WParea)
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 