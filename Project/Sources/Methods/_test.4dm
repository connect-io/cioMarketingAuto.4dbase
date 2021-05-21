//%attributes = {}
var $corps_t : Text
var $toto_o; $courrier_o : Object

$toto_o:=New object:C1471("tata"; "lolo")
Formula from string:C1601("dfd(this)").call($toto_o)

$courrier_o:=ds:C1482.WRI_Modèles.query("UID is :1"; 41)

$corps_t:=WP Get text:C1575($courrier_o[0].Modèle4DWP_; wk expressions as value:K81:255)