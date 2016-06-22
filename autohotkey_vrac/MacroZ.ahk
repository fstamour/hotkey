#EscapeChar \ ; Change the escape character to be backslash
			  ; instead of the default of accent (`).
			  

			  
DoubleCheck = true
Choices := "Sleep||Shutdown|Lock|Restart|Logout"


;------------------------------------------------------------------------------
;---------------------------- Main - Gui declaration --------------------------
;------------------------------------------------------------------------------

;Gui, Add, Text,, Please enter your name:
;Gui, Add, Edit, vName
;Gui, Add, DropDownList, vMyListBox, Sleep||Shutdown|Lock|Restart

Gui, Add, ListBox, vMyListBox w300 h150, %Choices%
Gui, Add, Button, Default, OK
Gui, Show, Center, MacroZ
return


;------------------------------------------------------------------------------
;-------------------------------- Events --------------------------------------
;------------------------------------------------------------------------------


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
	if(  !DoubleCheck || Ask( MyListBox ) ) {
		labelName = Action_%MyListBox%
		GoSub %labelName%
	}
	return			  

			  
;------------------------------------------------------------------------------
;----------------------------- Actions Sub routines ---------------------------
;------------------------------------------------------------------------------

Action_Sleep:
	Run rundll32.exe powrprof.dll\,SetSuspendState Standby
	return

Action_Shutdown:
	Run shutdown.exe -s
	return

Action_Restart:
	Run shutdonw -r
	return

Action_Lock:
	Run rundll32.exe user32.dll\, LockWorkStation
	return
	
Action_Logout:
	Run shutdown -l
	return
	
	
;------------------------------------------------------------------------------
;------------------------------- Functions ------------------------------------
;------------------------------------------------------------------------------


; Ask you if really want to perform the selected action.
Ask( action ) {
	
	;yes/No 			0x4
	;Icon Exclamation	0x30
	;Makes the 2nd		0x100
	;button the default 
	;---------------------------
	;Sum				0x134	
	
	MsgBox 0x134, O RLY?, Do you really want to perform action?: "%action%"
	IfMsgBox Yes
		return true
	else
		return false
}