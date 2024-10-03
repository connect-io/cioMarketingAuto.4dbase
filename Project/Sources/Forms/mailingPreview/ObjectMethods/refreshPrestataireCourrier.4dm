Case of 
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT Get pointer:C1124(Object named:K67:5; "prestataireCourrier")->currentValue:="Sélection d'un prestataire"
		OBJECT Get pointer:C1124(Object named:K67:5; "prestataireCourrier")->index:=-1
		
		Form:C1466.environnementCourrier:=""
		OB REMOVE:C1226(Form:C1466; "Courrier")
		
		Form:C1466.delaiCourrier:=""
		OBJECT Get pointer:C1124(Object named:K67:5; "typeEnvoiCourrier")->values:=New collection:C1472
		
		OBJECT Get pointer:C1124(Object named:K67:5; "typeEnvoiCourrier")->currentValue:="Sélection d'un type d'envoi"
		OBJECT Get pointer:C1124(Object named:K67:5; "typeEnvoiCourrier")->index:=-1
		
		OBJECT SET ENABLED:C1123(*; "configSend"; True:C214)
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 