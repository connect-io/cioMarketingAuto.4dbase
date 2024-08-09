var $pos_el : Integer
var $collection_c : Collection

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (versionList_at>0)
			$collection_c:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.indices("titre = :1"; versionList_at{versionList_at})
			
			If ($collection_c.length=1)
				CONFIRM:C162("Souhaitez-vous vraiment supprimer la version du modèle "+Lowercase:C14(Form:C1466.sceneTypeSelected)+" qui porte le nom "+versionList_at{versionList_at}+" ?"; "Oui"; "Non")
				
				If (OK=1)
					Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.remove($collection_c[0])
					
					$pos_el:=Find in array:C230(versionList_at; versionList_at{versionList_at})
					DELETE FROM ARRAY:C228(versionList_at; $pos_el)
					
					versionList_at{0}:="Merci de sélectionner une version"
					versionList_at:=0
					
					expediteurList_at{0}:="Merci de sélectionner un expéditeur"
					expediteurList_at:=0
					
					Form:C1466.modeleDetail:=""
					Form:C1466.modeleObjetEmail:=""
					
					Form:C1466.smsMarketing:=False:C215
				End if 
				
			End if 
			
		Else 
			ALERT:C41("Merci de sélectionner une version avant de pouvoir la supprimer")
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 