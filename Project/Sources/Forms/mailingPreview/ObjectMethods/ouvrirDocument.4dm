var $height_el : Integer

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		Form:C1466.rowHeight+=1
		
		If (Form:C1466.rowHeight>3)
			Form:C1466.rowHeight:=1
		End if 
		
		LISTBOX SET ROWS HEIGHT:C835(*; "listePersonne"; Form:C1466.rowHeight; lk lines:K53:23)
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 