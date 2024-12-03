var $suppr_b; $actifInatictifAll_b : Boolean
var $personne_o; $caPersonnesScenario_es; $caPersonnesScenario_e : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		CONFIRM:C162("Cette action est irréversible, souhaitez-vous continuer ?"; "Oui"; "Non")
		
		If (OK=1)
			
			If (Form:C1466.PersonneCurrentElement=Null:C1517)
				CONFIRM:C162("Cette action rendra actif / inactif le scénario pour toutes les personnes de la liste, souhaitez-vous vraiment le rendre actif / inactif pour toutes ces personnes ?"; "Oui"; "Annuler")
				$actifInatictifAll_b:=(OK=1)
			End if 
			
			Case of 
				: (Form:C1466.entree=2)
					
					Case of 
						: ($actifInatictifAll_b=True:C214)
							
							For each ($personne_o; Form:C1466.personneCollection)
								$caPersonnesScenario_es:=$personne_o.AllCaPersonneScenario.query("scenarioID = :1"; Form:C1466.donnee.scenarioDetail.getKey())
								
								If ($caPersonnesScenario_es.length=1)
									$caPersonnesScenario_e:=$caPersonnesScenario_es.first()
									
									If ($caPersonnesScenario_e.actif=True:C214)
										$caPersonnesScenario_e.actif:=False:C215
									Else 
										$caPersonnesScenario_e.actif:=True:C214
									End if 
									
									$statut_o:=$caPersonnesScenario_e.save()
									
									// Gestion du statut d'activité qui peut avoir un traitement particulier suivant la base
									If (OB Is defined:C1231($caPersonnesScenario_e; "manageActif")=True:C214)
										$caPersonnesScenario_e.manageActif()
									End if 
									
									$caPersonnesScenario_e.reload()
								End if 
								
							End for each 
							
						: (Form:C1466.PersonneCurrentElement#Null:C1517)
							
							For each ($personne_o; Form:C1466.PersonneSelectedElement)
								$caPersonnesScenario_es:=$personne_o.AllCaPersonneScenario.query("scenarioID = :1"; Form:C1466.donnee.scenarioDetail.getKey())
								
								If ($caPersonnesScenario_es.length=1)
									$caPersonnesScenario_e:=$caPersonnesScenario_es.first()
									
									If ($caPersonnesScenario_e.actif=True:C214)
										$caPersonnesScenario_e.actif:=False:C215
									Else 
										$caPersonnesScenario_e.actif:=True:C214
									End if 
									
									$statut_o:=$caPersonnesScenario_e.save()
									
									// Gestion du statut d'activité qui peut avoir un traitement particulier suivant la base
									If (OB Is defined:C1231($caPersonnesScenario_e; "manageActif")=True:C214)
										$caPersonnesScenario_e.manageActif()
									End if 
									
									$personne_o.reload()
								End if 
								
							End for each 
							
					End case 
					
			End case 
			
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 