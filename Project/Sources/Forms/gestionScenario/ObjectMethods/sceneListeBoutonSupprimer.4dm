var $scenarioID_t : Text
var $retour_o; $class_o : Object

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.scenarioDetail#Null:C1517) & (Form:C1466.SceneCurrentElement#Null:C1517)
			$scenarioID_t:=Form:C1466.sceneDetail.scenarioID
			$retour_o:=Form:C1466.sceneDetail.drop()
			
			If ($retour_o.success=False:C215)
				ALERT:C41("La scène sélectionnée n'a pas pu être supprimée, veuillez recommencer.")
			Else 
				$class_o:=cmaToolGetClass("MAScene").new()
				$class_o.reArrangeNumOrdre($scenarioID_t)
				
				Form:C1466.SceneSelectedElement:=Null:C1517
			End if 
			
			$retour_o:=Form:C1466.scenarioDetail.reload()
			
			Form:C1466.scene:=Form:C1466.scenarioDetail.AllCaScene.orderBy("numOrdre asc")
			Form:C1466.sceneDetail:=Null:C1517
		End if 
		
	: (Form event code:C388=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 