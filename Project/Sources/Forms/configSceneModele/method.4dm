If (Form event code:C388=Sur chargement:K2:1)
	var $gauche_el; $haut_el; $droite_el; $bas_el; $hauteurForm_el : Integer
	
	ARRAY TEXT:C222(versionList_at; 0)
	ARRAY TEXT:C222(expediteurList_at; 0)
	
	If (Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version#Null:C1517)
		COLLECTION TO ARRAY:C1562(Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.orderBy("titre asc"); versionList_at; "titre")
	End if 
	
	APPEND TO ARRAY:C911(versionList_at; "Créer une nouvelle version...")
	
	versionList_at{0}:="Merci de sélectionner une version"
	versionList_at:=0
	
	expediteurList_at{0}:="Merci de sélectionner un expéditeur"
	expediteurList_at:=0
	
	Form:C1466.modeleDetail:=""
	Form:C1466.modeleObjetEmail:=""
	
	OBJECT SET ENTERABLE:C238(*; "expediteurList"; False:C215)
	
	If (Lowercase:C14(Form:C1466.sceneTypeSelected)#"email")  // Si on édite pas une version "Email" on affiche pas les champs en rapport avec l'Email
		OBJECT SET VISIBLE:C603(*; "Texte2"; False:C215)
		OBJECT SET VISIBLE:C603(*; "modeleObjetEmail"; False:C215)
		
		OBJECT SET VISIBLE:C603(*; "Texte3"; False:C215)
		OBJECT SET VISIBLE:C603(*; "expediteurList"; False:C215)
		
		OBJECT MOVE:C664(*; "Texte1"; 0; -120)
		OBJECT MOVE:C664(*; "modeleDetail"; 0; -120)
		
		OBJECT MOVE:C664(*; "Bouton"; 0; -120)
		
		cmaToolResizeWindows(Frontmost window:C447; -120)
	Else 
		
		If (cwStorage.eMail.smtp.length>0)
			COLLECTION TO ARRAY:C1562(cwStorage.eMail.transporter; expediteurList_at; "name")
		End if 
		
	End if 
	
	Form:C1466.imageModeleActif:=Storage:C1525.automation.image["toggle-off"]
End if 