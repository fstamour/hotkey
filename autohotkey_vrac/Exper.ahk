#EscapeChar \ ; Change teh escape character to be backslash
			  ; instead of the default of accent (`).
SetKeyDelay 0


;------------------------------------------------------------------------------
;-------------------------------- Todos ---------------------------------------
;------------------------------------------------------------------------------
;
; Ajouter l'auto-complétion
; Documentation (raccourci/lien/manpage)
; CommandLine / Shell
; 	path modification
			  
Choices := "struct|while|whileb|guard|if|ifb|ife|ifei|for|forb|ns|switch"


;------------------------------------------------------------------------------
;---------------------------- Main - Gui declaration --------------------------
;------------------------------------------------------------------------------

Gui, Add, Text,, Enter a command:
Gui, Add, Edit, vCommandLine


Gui, Add, ListBox, vMyListBox gOnMyListBoxClick w300 h150, %Choices%
Gui, Add, Button, Default, OK
Gui, Show, Center, MacroZ
return


;------------------------------------------------------------------------------
;-------------------------------- Events --------------------------------------
;------------------------------------------------------------------------------



^j::
	gosub ButtonOk
	return



; On escape key
Escape::
	Gui, Destroy
	ExitApp
	return

; On gui close (by user or "gui, destroy" command)
GuiClose:
	ExitApp

; Well... guess!!
ButtonOK:
	Gui, Submit, NoHide
	labelName = Action_%CommandLine%
	GoSub %labelName%
	return			  


OnMyListBoxClick:
	Gui, Submit, NoHide
	GuiControl ,, CommandLine, %MyListBox%
	return

			  
;------------------------------------------------------------------------------
;----------------------------- Actions Sub routines ---------------------------
;------------------------------------------------------------------------------

Action_struct:
	Send struct {Enter}{{}{Enter}{Tab}{Enter}{}};{up 3}{End}
return

Action_while:
	Send while (  ){Enter}{Tab};{up}{end}{left 2}
return

Action_whileb:
	Send while (  ){Enter}{{}{Enter}{Tab}{Enter}{}}{up 3}{end}{left 2}
return

Action_guard:  
	WinGet, ActiveWindowID, ID, A      
	InputBox, guardName, Guard, Chosse a name for the guard token.
	WinActivate ahk_id %ActiveWindowID%
	keystroke = {#}ifndef %guardName%{Enter}{#}define %guardName%{Enter}^{end}{#}endif // %guardName%
	Send %keystroke%
return

Action_if:
	Send 1
return

Action_ifb:
	Send 1
return

Action_ife:
	Send 1
return	

Action_ifei:
	Send 1
return	

Action_for:
	Send 1
return	

Action_forb:
	Send 1
return	

Action_ns:
	Send 1
return	


Action_switch:
	Send 1
return	

	
;------------------------------------------------------------------------------
;------------------------------- Functions ------------------------------------
;------------------------------------------------------------------------------
