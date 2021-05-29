<!-- Type your summary here -->
## Description

### Description
Class principale du composant cioMarketingAuto

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : createFolder](#fonction--createFolder)
* [Fonction : cronosAction](#fonction--cronosAction)
* [Fonction : cronosMessageDisplay](#fonction--cronosMessageDisplay)
* [Fonction : cronosUpdateCaMarketing](#fonction--cronosUpdateCaMarketing)
* [Fonction : cronosManageScenario](#fonction--cronosManageScenario)
* [Fonction : loadCronos](#fonction--loadCronos)
* [Fonction : loadCurrentPeople](#fonction--loadCurrentPeople)
* [Fonction : loadImage](#fonction--loadImage)
* [Fonction : loadPasserelle](#fonction--loadPasserelle)
* [Fonction : loadSceneConditionActionList](#fonction--loadSceneConditionActionList)
* [Fonction : loadSceneConditionSautList](#fonction--loadSceneConditionSautList)



------------------------------------------------------

## Fonction : constructor			
Initialisation du composant.
Si vous ne passez qu'un argument et que celui-ci à la valeur Vrai, c'est une initialisation complète c'est-à-dire que tout le Storage du composant est ré-initialisé.
Si vous passez deux arguments, en plus de l'intialisation complète vous indiquez le chemin du fichier de config qui servira pour la suite
Sinon s'il n'y a aucun argument c'est une simple initialisation pour pouvoir utiliser des fonctions de cette class

### Fonctionnement
```4d
cs.MarketingAutomation.new({$initialisation_b} {;$configChemin_t}) -> $instance_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $initialisation_b     | Booléen      | Entrée        | Initialisation complète ou pas [optionel] |
| $configChemin_t       | Texte      | Entrée        | Chemin du fichier de config [optionel] |
| $instance_o     | Objet      | Sortie        | Nouvelle instance |

### Example
```4d
$marketingAutomation_o := cmaToolGetClass("MarketingAutomation").new(Vrai)
```

------------------------------------------------------

## Fonction : createFolder
Créer un dossier en local suivant le chemin indiqué en paramètre


### Fonctionnement
```4d
MarketingAutomation.createFolder($chemin_t) -> Créer un dossier
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $chemin_t        | Texte      | Entrée        | Le chemin du dossier à créer |


### Example
```4d
$marketingAutomation_o.createFolder("C://Users/ScanuRemy/Desktop/monDossierACreer/")
```

------------------------------------------------------

## Fonction : cronosAction
Mise à jour de certaines propriétés de This suivant l'action mise en paramètre
Va de paire avec la fonction cronosMessageDisplay

### Fonctionnement
```4d
MarketingAutomation.cronosAction($action_t) -> Modifie this
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $action_t     | Texte      | Entrée        | Une action que fait à l'instant T |


### Example
```4d
$marketingAutomation_o.cronosAction("gestionScenario")
```

------------------------------------------------------

## Fonction : cronosMessageDisplay
Mise à jour visuel de cronos (message et image) et donne les instructions à suivre pour la méthode formulaire "cronos"

### Fonctionnement
```4d
MarketingAutomation.cronosMessageDisplay() -> Modifie this
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |


### Example
```4d
$marketingAutomation_o.cronosMessageDisplay()
```

------------------------------------------------------

## Fonction : cronosUpdateCaMarketing
Mise à jour depuis cronos des informations de la table [CaPersonneMarketing]

### Fonctionnement
```4d
MarketingAutomation.cronosUpdateCaMarketing($tsDebut_el;$tsFin_el;$eventMessageNumber1{;$eventMessageNumber[i]}) -> Modifie this
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $tsDebut_el     | Integer      | Entrée        | Timestamp de début |
| $tsFin_el     | Integer      | Entrée        | Timestamp de fin |
| $eventMessageNumber[i]     | Texte      | Entrée        | Numéro chez mailjet de l'eventMessage à mettre à jour exemple : 3 -> Opened, 4 -> Clicked etc |


### Example
```4d
$marketingAutomation_o.cronosUpdateCaMarketing(12322489349; 48549504568596; "3"; "4"; "7"; "8"; "10")
```

------------------------------------------------------

## Fonction : cronosManageScenario
Gestion depuis la méthode formulaire "cronos" des scénarios des personnes

### Fonctionnement
```4d
MarketingAutomation.cronosManageScenario() -> Exécute ce qui doit être éxécuter pour les scénarios des personnes
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |


### Example
```4d
$marketingAutomation_o.cronosManageScenario()
```

------------------------------------------------------

## Fonction : loadCronos
Initialisation des propriétés de This nécessaire au bon fonctionnement de cronos
Et lance le formulaire projet "cronos"

### Fonctionnement
```4d
MarketingAutomation.loadCronos() -> Modifie This
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |


### Example
```4d
$marketingAutomation_o.loadCronos()
```

------------------------------------------------------

## Fonction : loadCurrentPeople
Créer une entitySelection des enregistrements en cours de la table [personne] du client

### Fonctionnement
```4d
MarketingAutomation.loadCurrentPeople() -> $entitySelection_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $entitySelection_o     | Objet      | Sortie        | EntitySelection |


### Example
```4d
$marketingAutomation_o.loadCurrentPeople()
```

------------------------------------------------------

## Fonction : loadImage
Charge dans This, toutes les images mises dans le dossier /Resources/Images/ du composant

### Fonctionnement
```4d
MarketingAutomation.loadImage() -> Modifie This
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |


### Example
```4d
$marketingAutomation_o.loadImage()
```

------------------------------------------------------

## Fonction : loadPasserelle
Change suivant le besoin de passerelle "Personne OU Telecom" (voir fichier de config du composant)

### Fonctionnement
```4d
MarketingAutomation.loadPasserelle($passerelle_t) -> $marketingAutomation_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $marketingAutomation_o     | Objet      | Sortie        | Utilisation de la passerelle de fonctionnement pour l'instance |


### Example
```4d
$marketingAutomation_o.loadPasserelle("Personne")
```

------------------------------------------------------

## Fonction : loadSceneConditionActionList
Permet de charger dans le Storage du composant la liste des conditions d'actions sélectionnable pour une scène

### Fonctionnement
```4d
MarketingAutomation.loadSceneConditionActionList() -> Modifie Storage du composant
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |


### Example
```4d
$marketingAutomation_o.loadSceneConditionActionList()
```

------------------------------------------------------

## Fonction : loadSceneConditionSautList
Permet de charger dans le Storage du composant la liste des conditions d'actions sélectionnable pour une scène

### Fonctionnement
```4d
MarketingAutomation.loadSceneConditionSautList() -> Modifie Storage du composant
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |


### Example
```4d
$marketingAutomation_o.loadSceneConditionSautList()
```

------------------------------------------------------