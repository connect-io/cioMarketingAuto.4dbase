var $zone4WP_t : Text

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$zone4WP_t:="WParea"
		
		If (Bool:C1537(Form:C1466.voirVariable)=False:C215)
			ST SET OPTIONS:C1289(*; $zone4WP_t; ST Expressions display mode:K78:5; ST References:K78:7)
			Form:C1466.voirVariable:=True:C214
		Else 
			ST COMPUTE EXPRESSIONS:C1285(*; $zone4WP_t; ST Start text:K78:15; ST End text:K78:16)
			ST SET OPTIONS:C1289(*; $zone4WP_t; ST Expressions display mode:K78:5; ST Values:K78:6)
			
			Form:C1466.voirVariable:=False:C215
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 