<!-- Type your summary here -->
## Description

### Description
Gestion des options d'envoi pour un emailing

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : sendGetType](#fonction--sendGetType)
* [Fonction : sendGetConfig](#fonction--sendGetConfig)



------------------------------------------------------

## Fonction : constructor			
Instanciation de la class pour permettre d'envoyer un mailing depuis le composant directement

### Fonctionnement
```4d
cs.MAMailing.new() -> $instance_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $instance_o     | Objet      | Sortie        | Nouvelle instance |

### Example
```4d
$class_o := cmaToolGetClass("MAMailing").new()
```

------------------------------------------------------

## Fonction : sendGetType
Permet à l'utilisateur de sélectionner le canal d'envoi du mailing

### Fonctionnement
```4d
MAMailing.sendGetType() -> $canalEnvoi_t
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $canalEnvoi_t     | Text      | Sortie        | Type d'envoi |


### Example
```4d
$canalEnvoi_t:=$class_o.sendGetType()
```

------------------------------------------------------

## Fonction : sendGetConfig
Permet à l'utilisateur de sélectionner le canal d'envoi du mailing

### Fonctionnement
```4d
MAMailing.sendGetConfig($type_t) -> $config_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $type_t     | Text      | Entrée        | Type d'envoi |
| $config_o     | Objet      | Sortie        | Config générale |


### Example
```4d
$config_o:=$class_o.sendGetConfig("Email")
```

------------------------------------------------------