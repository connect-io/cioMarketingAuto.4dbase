var $config_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$config_o:=New object:C1471("entree"; 2; "donnee"; Form:C1466)
		cwToolWindowsForm("gestionPersonne"; "center"; $config_o)
		
		Form:C1466.updateStringScenarioForm(1)
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 