var $pointeur_p : Pointer
var $class_o; $autreClass_o : Object
//cwToolWindowsForm("configScenarioCondition"; "center"; Form)

// Modifié par : Rémy Scanu (08/06/2021)
$pointeur_p:=Formula from string:C1601("->["+Storage:C1525.automation.passerelle.tableHote+"]").call()
cwToolWindowsForm("dialRecherche3"; "center"; New object:C1471("entree"; 1; "UIDCollection"; Form:C1466.scenarioDetail.condition.UIDCollection); $pointeur_p)

$class_o:=cmaToolGetClass("MarketingAutomation").new()

$autreClass_o:=cmaToolGetClass("MAPersonneSelection").new()
$autreClass_o.personneSelection:=$class_o.loadCurrentPeople()

$autreClass_o.toCollectionAndExtractField(New collection:C1472("UID"))

Form:C1466.scenarioDetail.condition.UIDCollection:=$autreClass_o.personneCollection.extract("UID")

Form:C1466.updateStringScenarioForm(3)