var $textDisplay_t : Text
var $fail_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.failed_c.length=0)
			ALERT:C41("Tout le mailing a bien été envoyé.")
			return 
		End if 
		
		For each ($fail_o; Form:C1466.failed_c)
			$textDisplay_t+="Email : "+String:C10($fail_o.email)+", Tel. : "+String:C10($fail_o.telMobile)+" Status : "+String:C10($fail_o.status)+Char:C90(Carriage return:K15:38)
		End for each 
		
		ALERT:C41($textDisplay_t)
End case 