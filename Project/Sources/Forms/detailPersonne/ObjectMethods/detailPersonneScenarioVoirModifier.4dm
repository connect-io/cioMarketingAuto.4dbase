var $class_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$class_o:=cmaToolGetClass("MAScenario").new()
		$class_o.loadScenarioDisplay(Form:C1466.scenarioSelected.ID)
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 