If (Form event code:C388=On Load:K2:1)
	
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
	
	Form:C1466.smsMarketing:=False:C215
	
	OBJECT SET ENTERABLE:C238(*; "expediteurList"; False:C215)
	OBJECT SET VISIBLE:C603(*; "smsMarketing"; False:C215)
	
	Case of 
		: (Lowercase:C14(Form:C1466.sceneTypeSelected)="email")
			
			If (cwStorage.eMail.transporter.length>0)
				COLLECTION TO ARRAY:C1562(cwStorage.eMail.transporter; expediteurList_at; "name")
			End if 
			
		: (Lowercase:C14(Form:C1466.sceneTypeSelected)="sms")
			OBJECT SET VISIBLE:C603(*; "Texte2"; False:C215)
			OBJECT SET VISIBLE:C603(*; "modeleObjetEmail"; False:C215)
			
			OBJECT SET VISIBLE:C603(*; "smsMarketing"; True:C214)
			
			If (cmaStorage.sms#Null:C1517)
				COLLECTION TO ARRAY:C1562(cmaStorage.sms.config.prestataire; expediteurList_at; "nom")
			End if 
			
			OBJECT MOVE:C664(*; "Texte3"; 0; -60)
			OBJECT MOVE:C664(*; "expediteurList"; 0; -60)
			
			OBJECT MOVE:C664(*; "Texte1"; 0; -60)
			OBJECT MOVE:C664(*; "modeleDetail"; 0; -60)
			
			OBJECT MOVE:C664(*; "Bouton"; 0; -60)
			
			cmaToolResizeWindows(Frontmost window:C447; -60)
		Else   // Si on édite pas une version "Courrier" on affiche pas les champs en rapport avec l'Email
			OBJECT SET VISIBLE:C603(*; "Texte2"; False:C215)
			OBJECT SET VISIBLE:C603(*; "modeleObjetEmail"; False:C215)
			
			OBJECT SET VISIBLE:C603(*; "Texte3"; False:C215)
			OBJECT SET VISIBLE:C603(*; "expediteurList"; False:C215)
			
			OBJECT MOVE:C664(*; "Texte1"; 0; -120)
			OBJECT MOVE:C664(*; "modeleDetail"; 0; -120)
			
			OBJECT MOVE:C664(*; "Bouton"; 0; -120)
			
			cmaToolResizeWindows(Frontmost window:C447; -120)
	End case 
	
	Form:C1466.imageModeleActif:=Storage:C1525.automation.image["toggle-off"]
End if 