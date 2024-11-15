var $historiqueMailingSelected_o : Object
var $historiqueMailing_c : Collection

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.HistoriqueMailingSelectedElement#Null:C1517)
			CONFIRM:C162("Souhaitez-vous vraiment supprimer "+String:C10(Form:C1466.HistoriqueMailingSelectedElement.length)+" éléments ?"; "Oui"; "Non")
			
			If (OK=1)
				Form:C1466.updateHistoriqueDetail:=True:C214
				
				For each ($historiqueMailingSelected_o; Form:C1466.HistoriqueMailingSelectedElement)
					$historiqueMailing_c:=Form:C1466.envoiMailEnCours.indices("eventTs = :1"; $historiqueMailingSelected_o.eventTs)
					
					If ($historiqueMailing_c.length=1)
						Form:C1466.envoiMailEnCours.remove($historiqueMailing_c[0])
					End if 
					
				End for each 
				
			End if 
			
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 