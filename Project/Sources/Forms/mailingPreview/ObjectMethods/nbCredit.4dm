var $heure_t : Text

Case of 
	: (Form event code:C388=On Load:K2:1)
		$heure_t:=Time string:C180(Current time:C178)
		Form:C1466.time:=Substring:C12($heure_t; 1; Length:C16($heure_t)-3)
	: (Form event code:C388=On Getting Focus:K2:7)
		Form:C1466.time:=Time:C179(Substring:C12(String:C10(Form:C1466.time); 0; 2)+":"+Substring:C12(String:C10(Form:C1466.time); 3)+":00")
	: (Form event code:C388=On Data Change:K2:15) | (Form event code:C388=On Losing Focus:K2:8)
		$heure_t:=Time string:C180(Form:C1466.time)
		Form:C1466.time:=Substring:C12($heure_t; 1; Length:C16($heure_t)-3)
End case 