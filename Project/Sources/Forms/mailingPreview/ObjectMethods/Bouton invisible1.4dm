var $x1_el; $y1_el; $x2_el; $y2_el : Integer
var $date_d : Date

OBJECT GET COORDINATES:C663(*; "Bouton invisible1"; $x1_el; $y1_el; $x2_el; $y2_el)
$date_d:=DatePicker Display Dialog($x1_el; $y1_el; Current date:C33)

If ($date_d#!00-00-00!)
	Form:C1466.date:=$date_d
End if 