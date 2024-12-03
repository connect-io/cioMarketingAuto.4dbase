var $personne_es : Object

Case of 
	: (Form event code:C388=On Load:K2:1)
		Form:C1466.imageStatutScenario:=Storage:C1525.automation.image["toggle"]
	: (Form event code:C388=On Clicked:K2:4)
		$personne_es:=Form:C1466.personneCollectionInit
		
		Case of 
			: (Picture size:C356(Form:C1466.imageStatutScenario)=Picture size:C356(Storage:C1525.automation.image["toggle"]))
				Form:C1466.imageStatutScenario:=Storage:C1525.automation.image["toggle-on"]
				$personne_es:=$personne_es.AllCaPersonneScenario.query("scenarioID = :1 AND actif = :2"; Form:C1466.donnee.scenarioDetail.getKey(); True:C214).OnePersonne
			: (Picture size:C356(Form:C1466.imageStatutScenario)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
				Form:C1466.imageStatutScenario:=Storage:C1525.automation.image["toggle-off"]
				$personne_es:=$personne_es.AllCaPersonneScenario.query("scenarioID = :1 AND actif = :2"; Form:C1466.donnee.scenarioDetail.getKey(); False:C215).OnePersonne
			Else 
				Form:C1466.imageStatutScenario:=Storage:C1525.automation.image["toggle"]
		End case 
		
		Form:C1466.personneCollection:=$personne_es
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 