Case of 
	: (Form event code:C388=Sur clic:K2:4)
		
		Case of 
			: (Picture size:C356(Form:C1466.imageMailingMarketing)=Picture size:C356(Storage:C1525.automation.image["toggle"]))
				Form:C1466.imageMailingMarketing:=Storage:C1525.automation.image["toggle-on"]
				
				Form:C1466.scenarioDetail.condition.mailingMarketing:=True:C214
			: (Picture size:C356(Form:C1466.imageMailingMarketing)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
				Form:C1466.imageMailingMarketing:=Storage:C1525.automation.image["toggle-off"]
				
				Form:C1466.scenarioDetail.condition.mailingMarketing:=False:C215
			Else 
				Form:C1466.imageMailingMarketing:=Storage:C1525.automation.image["toggle"]
				
				If (Form:C1466.scenarioDetail.condition.email#Null:C1517)
					OB REMOVE:C1226(Form:C1466.scenarioDetail.condition; "mailingMarketing")
				End if 
				
		End case 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 