var $textDisplay_t : Text


Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.emailFailed_c.length=0)
			ALERT:C41("Tous les mails ont bien été expédiés.")
			return 
		End if 
		
		For each ($emailfail_o; Form:C1466.emailFailed_c)
			$textDisplay_t+="Email : "+$emailfail_o.email+" Status : "+$emailfail_o.status+Char:C90(Carriage return:K15:38)
		End for each 
		
		ALERT:C41($textDisplay_t)
End case 