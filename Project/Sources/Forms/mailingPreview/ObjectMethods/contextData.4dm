var $formule_f : Object

$formule_f:=Formula from string:C1601(String:C10(Form:C1466.wpFormula))
WP SET DATA CONTEXT:C1786(WParea; $formule_f.call({value: Form:C1466.contextValue}))

WP COMPUTE FORMULAS:C1707(WParea)