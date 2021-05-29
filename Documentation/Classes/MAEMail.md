<!-- Type your summary here -->
## Description

### Description
Gestion des emails

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : send](#fonction--send)
* [Fonction : sendModel](#fonction--sendModel)



------------------------------------------------------

## Fonction : constructor			
Instanciation de la class avec le nom du transporter à utiliser en paramètre (voir fichier de config)

### Fonctionnement
```4d
cs.MAEMail.new({$transporter_t} {;$parametre_o}) -> $instance_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $transporter_t     | Texte      | Entrée        | Nom du transporter à utiliser |
| $parametre_o       | Objet      | Entrée        | Paramètre à fusionner avec le transporter [optionel] |
| $instance_o     | Objet      | Sortie        | Nouvelle instance |

### Example
```4d
$email_o := cmaToolGetClass("MAEMail").new("Informatique")
```

------------------------------------------------------

## Fonction : send
Envoie simple d'un e-mail


### Fonctionnement
```4d
MAEMail.send() -> $statutEnvoiEmail_o
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $statutEnvoiEmail_o        | Objet      | Sortie        | Objet de retour suite à l'envoi d'un email |


### Example
```4d
$email_o.send()
```

------------------------------------------------------

## Fonction : sendModel
Envoi d'un e-mail depuis un modèle du composant


### Fonctionnement
```4d
MAEMail.sendModel($model_t{;$parametre_o}) -> $statutEnvoiEmail_o
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $transporter_t     | Texte      | Entrée        | Nom du transporter à utiliser |
| $parametre_o       | Objet      | Entrée        | Paramètre à fusionner avec This [optionel] |
| $statutEnvoiEmail_o        | Objet      | Sortie        | Objet de retour suite à l'envoi d'un email |


### Example
```4d
$email_o.sendModel("test")
```

------------------------------------------------------