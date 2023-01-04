/* -----------------------------------------------------------------------------
Class : cs.MAPersonneSelectionDisplay

Class de gestion du marketing automation pour le formulaire liste [Personne]

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAPersonneSelectionDisplay.constructor
	
Instanciation de la class MAPersonneSelectionDisplay pour le marketing automotion
	
Historique
27/01/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	
Function manageFilter()->$collectionFiltered_v : Variant
/*-----------------------------------------------------------------------------
Fonction : MAPersonneSelection.manageFilter
	
Gestion des filtres dans le mode liste [Personne]
	
Historique
27/01/21 - RémyScanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $propriete_t; $proprieteToFilter_t; $type_t : Text
	var $verif_o; $passerelle_o : Object
	var $collectionToFilter_c : Variant
	
	$collectionToFilter_v:=Form:C1466.personneCollectionInit
	$verif_o:=cwToolProprieteExisteDansObjet(Form:C1466; New collection:C1472("filtre@"); -1)
	
	If (Bool:C1537($verif_o["filtre@"].exist)=True:C214)
		$passerelle_o:=Storage:C1525.automation.config.passerelle.query("tableComposant = :1"; "Personne")[0]
		
		For each ($propriete_t; $verif_o["filtre@"].propriete)
			$proprieteToFilter_t:=Replace string:C233($propriete_t; "filtre"; "")
			$proprieteToFilter_t:=cmaToolMinuscFirstChar($proprieteToFilter_t)
			
			$type_t:=$passerelle_o.champ.query("lib = :1"; $proprieteToFilter_t)[0].type
			
			If (Value type:C1509(Form:C1466.personneCollectionInit)=Est un objet:K8:27)
				$proprieteToFilter_t:=Storage:C1525.automation.formule.getFieldName(Storage:C1525.automation.passerelle.champ; $proprieteToFilter_t)
			End if 
			
			Case of 
				: ($type_t="text")
					$collectionToFilter_v:=$collectionToFilter_v.query($proprieteToFilter_t+" = :1"; "@"+$verif_o["filtre@"].value[$verif_o["filtre@"].propriete.indexOf($propriete_t)]+"@")
				: ($type_t="int")
					$collectionToFilter_v:=$collectionToFilter_v.query($proprieteToFilter_t+" = :1"; Num:C11($verif_o["filtre@"].value[$verif_o["filtre@"].propriete.indexOf($propriete_t)]))
				: ($type_t="date")
					$collectionToFilter_v:=$collectionToFilter_v.query($proprieteToFilter_t+" = :1"; Date:C102($verif_o["filtre@"].value[$verif_o["filtre@"].propriete.indexOf($propriete_t)]))
				: ($type_t="bool")
					$collectionToFilter_v:=$collectionToFilter_v.query($proprieteToFilter_t+" = :1"; Bool:C1537($verif_o["filtre@"].value[$verif_o["filtre@"].propriete.indexOf($propriete_t)]))
			End case 
			
		End for each 
		
	End if 
	
	$collectionFiltered_v:=$collectionToFilter_v.copy()
	
Function manageSort($objectClicked_t : Text; $sort_b : Boolean)->$collectionOrdered_v : Variant
/*-----------------------------------------------------------------------------
Fonction : MAPersonneSelection.manageSort
	
Gestion des tri dans le mode liste [Personne]
	
Historique
27/01/21 - RémyScanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $propriete_t; $proprieteToOrder_t; $allProprieteToOrder_t; $lib_t : Text
	var $keepSort_b : Boolean
	var $verif_o : Object
	
	If (Count parameters:C259=2)
		$keepSort_b:=$sort_b
	End if 
	
	$verif_o:=cwToolProprieteExisteDansObjet(Form:C1466; New collection:C1472("imageSort@"); -1)
	
	For each ($propriete_t; $verif_o["imageSort@"].propriete)
		$proprieteToOrder_t:=Replace string:C233($propriete_t; "imageSort"; "")
		$proprieteToOrder_t:=cmaToolMinuscFirstChar($proprieteToOrder_t)
		
		Case of 
			: (Picture size:C356(Form:C1466[$propriete_t])=Picture size:C356(Storage:C1525.automation.image["sort"]))
				
				If ($propriete_t=("@"+$objectClicked_t+"@")) & ($objectClicked_t#"") & ($keepSort_b=False:C215)  // La colonne a été cliqué et avait le statut du tri neutre on le passe à croissant
					Form:C1466[$propriete_t]:=Storage:C1525.automation.image["sort-asc"]
					$allProprieteToOrder_t:=$allProprieteToOrder_t+$proprieteToOrder_t+" asc"+","
				End if 
				
				If (Picture size:C356(Form:C1466[$propriete_t])=Picture size:C356(Storage:C1525.automation.image["sort-desc"]))  // La colonne n'a pas été cliqué mais avait le statut du tri décroissant on le maitient
					$allProprieteToOrder_t:=$allProprieteToOrder_t+$proprieteToOrder_t+" desc"+","
				End if 
				
			: (Picture size:C356(Form:C1466[$propriete_t])=Picture size:C356(Storage:C1525.automation.image["sort-asc"]))
				
				If ($propriete_t=("@"+$objectClicked_t+"@")) & ($objectClicked_t#"") & ($keepSort_b=False:C215)  // La colonne a été cliqué et avait le statut du tri croissant on le passe à décroissant
					Form:C1466[$propriete_t]:=Storage:C1525.automation.image["sort-desc"]
					$allProprieteToOrder_t:=$allProprieteToOrder_t+$proprieteToOrder_t+" desc"+","
				Else   // La colonne n'a pas été cliqué mais avait le statut du tri croissant on le maitient
					$allProprieteToOrder_t:=$allProprieteToOrder_t+$proprieteToOrder_t+" asc"+","
				End if 
				
			Else 
				
				If ($propriete_t=("@"+$objectClicked_t+"@")) & ($objectClicked_t#"") & ($keepSort_b=False:C215)  // La colonne a été cliqué et avait le statut du tri décroissant on le passe à neutre
					Form:C1466[$propriete_t]:=Storage:C1525.automation.image["sort"]
				End if 
				
				If ((Picture size:C356(Form:C1466[$propriete_t])=Picture size:C356(Storage:C1525.automation.image["sort-desc"])))  // La colonne n'a pas été cliqué mais avait le statut du tri décroissant on le maitient
					$allProprieteToOrder_t:=$allProprieteToOrder_t+$proprieteToOrder_t+" desc"+","
				End if 
				
		End case 
		
	End for each 
	
	If ($allProprieteToOrder_t#"")
		$allProprieteToOrder_t:=Substring:C12($allProprieteToOrder_t; 0; Length:C16($allProprieteToOrder_t)-1)  // J'enlève le dernier ","
		$allProprieteToOrder_t:=Replace string:C233($allProprieteToOrder_t; ","; ", ")
		
		$collectionOrdered_v:=Form:C1466.personneCollection.orderBy($allProprieteToOrder_t)
	Else 
		$collectionOrdered_v:=Form:C1466.personneCollection.orderBy("UID")  // Aucune colonne n'a de tri on tri par défaut par UID
	End if 
	
Function reloadPerson($personneUID_v : Variant)
/*-----------------------------------------------------------------------------
Fonction : MAPersonneSelection.reloadPerson
	
Permet de rafraichir la ligne qui a été modifié quand on fait une modif dans le mode détail [Personne]
	
Historique
27/01/21 - RémyScanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $propriete_t : Text
	var $class_o : Object
	var $collection_c : Collection
	
	$class_o:=cmaToolGetClass("MAPersonne").new()
	$class_o.loadByPrimaryKey(Form:C1466.PersonneCurrentElement.UID)
	
	// S'il y a eu une mise à jour il faut modifier l'entité dans la liste
	$collection_c:=OB Keys:C1719(Form:C1466.personneCollection[Form:C1466.PersonneCurrentPosition-1])
	
	For each ($propriete_t; $collection_c)
		Form:C1466.personneCollection[Form:C1466.PersonneCurrentPosition-1][$propriete_t]:=$class_o[$propriete_t]
	End for each 