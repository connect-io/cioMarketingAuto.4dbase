Case of 
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET ENABLED:C1123(*; "acknowledgementOfReceipt"; Bool:C1537(Form:C1466.recommendedShipping))
		
		If (Bool:C1537(Form:C1466.recommendedShipping)=False:C215)
			Form:C1466.acknowledgement_of_receipt:=False:C215
		Else 
			Form:C1466.delaiCourrier:=""
			
			OBJECT Get pointer:C1124(Object named:K67:5; "postageType")->values:=New collection:C1472("FAST"; "URGENT")
			OBJECT Get pointer:C1124(Object named:K67:5; "postageType")->currentValue:="Sélection d'un type d'envoi"
			OBJECT Get pointer:C1124(Object named:K67:5; "postageType")->index:=-1
		End if 
		
End case 