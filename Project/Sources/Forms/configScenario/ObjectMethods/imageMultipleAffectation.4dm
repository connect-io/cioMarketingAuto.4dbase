Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		Case of 
			: (Picture size:C356(Form:C1466.imageMultipleAffectation)=Picture size:C356(Storage:C1525.automation.image["toggle-off"]))
				Form:C1466.imageMultipleAffectation:=Storage:C1525.automation.image["toggle-on"]
				Form:C1466.scenarioDetail.configuration.multipleAffectation:=True:C214
			: (Picture size:C356(Form:C1466.imageMultipleAffectation)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
				Form:C1466.imageMultipleAffectation:=Storage:C1525.automation.image["toggle-off"]
				Form:C1466.scenarioDetail.configuration.multipleAffectation:=False:C215
		End case 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 