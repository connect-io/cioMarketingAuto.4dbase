If (Bool:C1537(OBJECT Get pointer:C1124(Object current:K67:2)->)=True:C214)
	OBJECT SET ENABLED:C1123(*; "prestataireCourrier"; False:C215)
	
	OBJECT Get pointer:C1124(Object named:K67:5; "prestataireCourrier")->currentValue:="Sélection d'un prestataire"
	OBJECT Get pointer:C1124(Object named:K67:5; "prestataireCourrier")->index:=-1
	
	Form:C1466.Courrier:=cmaToolGetClass("MACourrier").new(False:C215; New object:C1471("nom"; "Imprimante courante"; "environnement"; "production"))
	Form:C1466.environnementCourrier:=""
Else 
	OBJECT SET ENABLED:C1123(*; "prestataireCourrier"; True:C214)
End if 