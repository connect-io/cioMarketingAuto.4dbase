Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT Get pointer:C1124(Object current:K67:2)->:=New object:C1471()
		OBJECT Get pointer:C1124(Object current:K67:2)->values:=New collection:C1472(0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10)
		OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:="Sélection d'un nb max d'erreur"
		OBJECT Get pointer:C1124(Object current:K67:2)->index:=-1
		
		If (Form:C1466.scenarioDetail.configuration.nbErreurMaxExecution#Null:C1517) && (OBJECT Get pointer:C1124(Object current:K67:2)->values.indexOf(Num:C11(Form:C1466.scenarioDetail.configuration.nbErreurMaxExecution))#-1)
			OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:=Num:C11(Form:C1466.scenarioDetail.configuration.nbErreurMaxExecution)
			OBJECT Get pointer:C1124(Object current:K67:2)->index:=OBJECT Get pointer:C1124(Object current:K67:2)->values.indexOf(Num:C11(Form:C1466.scenarioDetail.configuration.nbErreurMaxExecution))
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.scenarioDetail.configuration.nbErreurMaxExecution:=Num:C11(OBJECT Get pointer:C1124(Object current:K67:2)->currentValue)
End case 