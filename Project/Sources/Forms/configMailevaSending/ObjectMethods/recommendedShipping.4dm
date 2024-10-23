Case of 
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET VISIBLE:C603(*; "acknowledgementOfReceipt"; Bool:C1537(Form:C1466.recommendedShipping))
		Form:C1466.delaiCourrier:=""
		
		If (Bool:C1537(Form:C1466.recommendedShipping)=False:C215)
			Form:C1466.acknowledgement_of_receipt:=False:C215
			OBJECT Get pointer:C1124(Object named:K67:5; "postageType")->values:=New collection:C1472("ECONOMIC"; "FAST"; "URGENT")
		Else 
			OBJECT Get pointer:C1124(Object named:K67:5; "postageType")->values:=New collection:C1472("FAST"; "URGENT")
		End if 
		
		OBJECT Get pointer:C1124(Object named:K67:5; "postageType")->currentValue:="Sélection d'un type d'envoi"
		OBJECT Get pointer:C1124(Object named:K67:5; "postageType")->index:=-1
End case 