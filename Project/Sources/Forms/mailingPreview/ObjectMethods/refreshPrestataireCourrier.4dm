Case of 
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT Get pointer:C1124(Object named:K67:5; "prestataireCourrier")->currentValue:="Sélection d'un prestataire"
		OBJECT Get pointer:C1124(Object named:K67:5; "prestataireCourrier")->index:=-1
		
		Form:C1466.environnementCourrier:=""
		OB REMOVE:C1226(Form:C1466; "Courrier")
		
		OBJECT SET ENABLED:C1123(*; "configSend"; True:C214)
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 