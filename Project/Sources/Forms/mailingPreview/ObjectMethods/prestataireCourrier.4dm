Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT Get pointer:C1124(Object current:K67:2)->:=New object:C1471()
		OBJECT Get pointer:C1124(Object current:K67:2)->values:=Storage:C1525.courrier.config.prestataire.query("nom # :1"; "Imprimante courante").extract("nom")
		OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:="Sélection d'un prestataire"
		OBJECT Get pointer:C1124(Object current:K67:2)->index:=-1
	: (Form event code:C388=On Data Change:K2:15)
		OBJECT SET ENABLED:C1123(*; "configSend"; False:C215)
		
		cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; New collection:C1472(New object:C1471("environnement"; "sandbox"); New object:C1471("environnement"; "production")); \
			"property"; "environnement"; "selectSubTitle"; "Merci de sélectionner un environnement"; "title"; "Choix de l'environnement :"))
		
		If (selectValue_t="")
			OBJECT Get pointer:C1124(Object current:K67:2)->currentValue:="Sélection d'un prestataire"
			OBJECT Get pointer:C1124(Object current:K67:2)->index:=-1
			
			return 
		End if 
		
		Form:C1466.environnementCourrier:=selectValue_t
		Form:C1466.Courrier:=cmaToolGetClass("MACourrier").new(False:C215; New object:C1471("nom"; OBJECT Get pointer:C1124(Object current:K67:2)->currentValue; "environnement"; String:C10(Form:C1466.environnementCourrier)))
		
		If (OBJECT Get pointer:C1124(Object current:K67:2)->currentValue="Maileva")
			Form:C1466.Courrier.getTokenAPIMaileva()
			OBJECT SET ENABLED:C1123(*; "configSend"; True:C214)
		End if 
		
End case 