var $document_t : Text
var $i_el : Integer
var $fichier_f : 4D:C1709.File

ARRAY TEXT:C222($attachmentsFiles_at; 0)

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (OBJECT Get pointer:C1124(Object named:K67:5; "prestataireCourrier")->index=-1) && ((Form:C1466.Courrier=Null:C1517) || (Form:C1466.Courrier.useCurrentPrinter=False:C215))
			ALERT:C41("Merci de sélectionner un prestataire.")
			return 
		End if 
		
		If (Form:C1466.Courrier#Null:C1517)
			Form:C1466.Courrier.attachmentsPath_c:=New collection:C1472
		End if 
		
		$document_t:=Select document:C905(""; "*"; "Fichiers à insérer en pièce-jointe"; Multiple files:K24:7+Use sheet window:K24:11; $attachmentsFiles_at)
		
		If ($document_t#"")
			
			For ($i_el; 1; Size of array:C274($attachmentsFiles_at))
				$fichier_f:=File:C1566($attachmentsFiles_at{$i_el}; fk platform path:K87:2)
				
				Form:C1466.pieceJointe.push(New object:C1471("nom"; $fichier_f.name))
				Form:C1466.Courrier.attachmentsPath_c.push($attachmentsFiles_at{$i_el})
			End for 
			
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 