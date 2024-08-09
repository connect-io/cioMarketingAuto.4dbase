Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		Case of 
			: (Picture size:C356(Form:C1466.imageSansIBAN)=Picture size:C356(Storage:C1525.automation.image["toggle"]))
				Form:C1466.imageSansIBAN:=Storage:C1525.automation.image["toggle-on"]
				Form:C1466.scenarioDetail.condition.sansIBAN:=True:C214
			: (Picture size:C356(Form:C1466.imageSansIBAN)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
				Form:C1466.imageSansIBAN:=Storage:C1525.automation.image["toggle-off"]
				Form:C1466.scenarioDetail.condition.sansIBAN:=False:C215
			Else 
				Form:C1466.imageSansIBAN:=Storage:C1525.automation.image["toggle"]
				
				If (Form:C1466.scenarioDetail.condition.sansIBAN#Null:C1517)
					OB REMOVE:C1226(Form:C1466.scenarioDetail.condition; "sansIBAN")
				End if 
				
		End case 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 