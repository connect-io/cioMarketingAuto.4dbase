singleton Class constructor()
	
/*
Utilisation du singleton : $singleton:=cs.MADate.me.function()
*/
	
	
Function cleanText($date_t : Text) : Text
/*------------------------------------------------------------------------------
Methode projet : cs.MADate.me.cleanText()
	
Nettoyage d'une date textuel. (exemple : mardi 3 octobre 2026 (à midi))
Remplace la méthode : convertDateToString
	
Historique
07/11/24 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	// Si le champ est vide, on ne va pas plus loin...
	If ($date_t="")
		return ""
	End if 
	
	// La date est déjà propre.
	If (Date:C102($date_t)#!00-00-00!)
		return $date_t
	End if 
	
	
	If ($date_t="@lundi@")
		$date_t:=Replace string:C233($date_t; "lundi"; "")
	End if 
	If ($date_t="@mardi@")
		$date_t:=Replace string:C233($date_t; "mardi"; "")
	End if 
	If ($date_t="@mercredi@")
		$date_t:=Replace string:C233($date_t; "mercredi"; "")
	End if 
	If ($date_t="@jeudi@")
		$date_t:=Replace string:C233($date_t; "jeudi"; "")
	End if 
	If ($date_t="@vendredi@")
		$date_t:=Replace string:C233($date_t; "vendredi"; "")
	End if 
	If ($date_t="@samedi@")
		$date_t:=Replace string:C233($date_t; "samedi"; "")
	End if 
	If ($date_t="@dimanche@")
		$date_t:=Replace string:C233($date_t; "dimanche"; "")
	End if 
	
	Case of 
		: ($date_t="@janvier@")
			$date_t:=Replace string:C233($date_t; "janvier"; "/01/")
		: ($date_t="@février@")
			$date_t:=Replace string:C233($date_t; "février"; "/02/")
		: ($date_t="@mars@")
			$date_t:=Replace string:C233($date_t; "mars"; "/03/")
		: ($date_t="@avril@")
			$date_t:=Replace string:C233($date_t; "avril"; "/04/")
		: ($date_t="@mai@")
			$date_t:=Replace string:C233($date_t; "mai"; "/05/")
		: ($date_t="@juin@")
			$date_t:=Replace string:C233($date_t; "juin"; "/06/")
		: ($date_t="@juillet@")
			$date_t:=Replace string:C233($date_t; "juillet"; "/07/")
		: ($date_t="@aout@")
			$date_t:=Replace string:C233($date_t; "aout"; "/08/")
		: ($date_t="@septembre@")
			$date_t:=Replace string:C233($date_t; "septembre"; "/09/")
		: ($date_t="@octobre@")
			$date_t:=Replace string:C233($date_t; "octobre"; "/10/")
		: ($date_t="@novembre@")
			$date_t:=Replace string:C233($date_t; "novembre"; "/11/")
		: ($date_t="@decembre@")
			$date_t:=Replace string:C233($date_t; "decembre"; "/12/")
	End case 
	
	var $posParenthese_i : Integer:=Position:C15("("; $date_t)
	If ($posParenthese_i#0)
		// il y surement un commentaire du client genre : 01/01/01 (avant 10h)
		var $posParentheseEnd_i : Integer:=Position:C15(")"; $date_t)
		var $comment_t : Text:=Substring:C12($date_t; $posParenthese_i; $posParentheseEnd_i-$posParenthese_i+1)
		$date_t:=Replace string:C233($date_t; $comment_t; "")
	End if 
	
	$yearBefore_t:=String:C10((Year of:C25(Current date:C33)-1)%100)
	$year_t:=String:C10(Year of:C25(Current date:C33)%100)
	If ($date_t=("@"+$yearBefore_t))
		$date_t:=Substring:C12($date_t; 1; Length:C16($date_t)-2)+$yearBefore_t
	End if 
	
	
	If ($date_t#("@"+$year_t))
		$date_t:=$date_t+" "+$year_t
	End if 
	
	If ($date_t#"@/@") & ($date_t#"@ @") & ($date_t#"@,@") & ($date_t#"@.@") & ($date_t#"@-@")
		$date_t:=Insert string:C231($date_t; "/"; 5)
		$date_t:=Insert string:C231($date_t; "/"; 3)
	End if 
	
	If (Date:C102($date_t)#!00-00-00!)
		return String:C10(Date:C102($date_t))
	End if 
	
	return $date_t
	
	
	
Function firstOfMonth($date_d : Date) : Date
/*------------------------------------------------------------------------------
Methode projet : cs.MADate.me.firstOfMonth()
	
Retourne une date du 1er du mois passé en paramêtre.
Remplace la méthode : premierdumois
	
Historique
07/11/24 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	If (Count parameters:C259=0)
		$date_d:=Current date:C33()
	End if 
	
	return Date:C102("1/"+String:C10(Month of:C24($date_d))+"/"+String:C10(Year of:C25($date_d)))
	
	
Function monthText($date_d : Date) : Text
/*------------------------------------------------------------------------------
Methode projet : cs.MADate.me.monthText()
	
Retourne le mois en français
	
Historique
18/03/25 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $monthText_c : Collection:=New collection:C1472("Janvier"; "Février"; "Mars"; "Avril"; "Mai"; "Juin"; "Juillet"; "Aout"; "Septembre"; "Octobre"; "Novembre"; "Décembre")
	
	return $monthText_c[Month of:C24($date_d)-1]
	
	
	
Function formText($date_t : Text) : Date
/*------------------------------------------------------------------------------
Methode projet : cs.MADate.me.formText()
	
Retourne une date en fonction d'une chaine de caractère.
Remplace la méthode : outilDateStringToDate
	
Historique
07/11/24 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $month_t : Text
	var $dateString_c : Collection:=Split string:C1554($date_t; " ")
	
	Case of 
		: ($dateString_c[1]="janvier")
			$month_t:="01"
		: ($dateString_c[1]="février")
			$month_t:="02"
		: ($dateString_c[1]="mars")
			$month_t:="03"
		: ($dateString_c[1]="avril")
			$month_t:="04"
		: ($dateString_c[1]="mai")
			$month_t:="05"
		: ($dateString_c[1]="juin")
			$month_t:="06"
		: ($dateString_c[1]="juillet")
			$month_t:="07"
		: ($dateString_c[1]="août")
			$month_t:="08"
		: ($dateString_c[1]="septembre")
			$month_t:="09"
		: ($dateString_c[1]="octobre")
			$month_t:="10"
		: ($dateString_c[1]="novembre")
			$month_t:="11"
		: ($dateString_c[1]="décembre")
			$month_t:="12"
	End case 
	
	return Date:C102($dateString_c[0]+"/"+$month_t+"/"+$dateString_c[2])
	
	
	
Function formatTextEnToFr($dateEn_t : Text) : Text
/*------------------------------------------------------------------------------
Methode projet : cs.MADate.me.formatTextEnToFr()
	
Retourne une date du format anglais vers français en texte.
Tranformer une date du format AAAA-MM-JJ au format JJ/MM/AAAA
Remplace la méthode : outilsDateToJJMMAAAA
	
Historique
07/11/24 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $date_c : Collection:=Split string:C1554($dateEn_t; "-")
	
	If ($date_c.length=0)
		return String:C10(Current date:C33)
	End if 
	
	$0:=$date_c[2]+"/"+$date_c[1]+"/"+$date_c[0]
	
	
	
Function JJMMAA($format_t : Text; $date_d : Date) : Text
/*------------------------------------------------------------------------------
Methode projet : cs.MADate.me.JJMMAA()
	
Retourne une date au format texte suivant un schéma...
JJ-MM-AA, AAAA_MM_JJ, MM/JJ,...
	
Historique
08/11/24 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	If (Count parameters:C259=1)
		$date_d:=Current date:C33()
	End if 
	
	$format_t:=Replace string:C233($format_t; "AAAA"; String:C10(Year of:C25($date_d); "0000"))
	$format_t:=Replace string:C233($format_t; "AA"; String:C10(Mod:C98(Year of:C25($date_d); 100); "00"))
	$format_t:=Replace string:C233($format_t; "MM"; String:C10(Month of:C24($date_d); "00"))
	return Replace string:C233($format_t; "JJ"; String:C10(Day of:C23($date_d); "00"))
	
	