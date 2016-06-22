;;;; Hotkeys TODO
;; -[ ] help
;; -[ ] open/switch to terminal
;; -[ ] open/switch (ask before opening) arch VM
;; -[ ] firefox, chrome, emacs, vim

;;;; TODO
;; -[ ] Switch to specific windows
;; -[x] Resize list ~~~box based on the number of elements~~~
;; -[x] Filter this' script windows from the list of windows
;; -[ ] Make a function out of the "w" command.
;; -[ ] Use the keyword "local" as much as I can.
;; -[ ] Find a way to avoid the big if-else bloc. Maybe use the same scheme as the 
;;     gui event handlers (i.e. use prefixed subroutine)
;; -[ ] Use arrays (https://autohotkey.com/docs/misc/Arrays.htm)
;; -[ ] Document as f***

;;;; About AHK
;; How are we supposed to structure "projects" across multiple files?
;; What's up with all the implicit globals? (They reminds me of lisp's dynamic binding gone bad.)
;; What's up with the syntax in general?
;; See the #IfFocus at https://autohotkey.com/board/topic/89300-how-to-fill-a-listbox-with-entries-then-retrieve-them-gui/?p=565780

;;;; FAQ About this code
;; Q) Why?
;; A) Because I loved stumpwm and I wanted something alike on windows.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

escapeKey = AppsKey

;; The EscapeLabel subroutine will be called when the escapeKey is pressed.
Hotkey, %escapeKey%, EscapeLabel


;;; Seting up the WindowGui
Gui WindowGui:new, +HwndWindowGuiHandle ; The variable WindowGuiHandle now contains the handle to the gui named WindowGui
Gui WindowGui: -Caption +ToolWindow +AlwaysOnTop +LastFound ; TODOC
Gui WindowGui:Margin, 0, 0 ; No Margin
;; Create a list box
;; handle: ListBoxHandle
;; data: WindowGuiListBox
;; AltSubmit: WindowGuiListBox contains index instead of text
;; Choose1: Select the first element in the list.
Gui WindowGui:Add,ListBox,h256 w800 vWindowGuiListBox hwndListBoxHandle AltSubmit Choose1,|
GuiControl, Choose, List, 1
;; Create a hidden button so that we submit our selection when we press Enter (it will run the WindowGuiOK subroutine).
Gui WindowGui:Add, Button, default h0 w0 gWindowGuiOK,
;; Not showing the WindowGui yet

;; End of the script per se.
return


;; When the user press Enter
WindowGuiOK:
	Gui WindowGui:Submit
	;; local plist
	;; GuiControlGet, plist,, WindowGuiListBox
	StringSplit, winArr, windowList,|
	MsgBox % winArr%WindowGuiListBox%
	WinActivate,, winArr%WindowGuiListBox%
return

;;;; BUG If I call WindowGuiClose from WindowGuiGuiEscape (instead of WindowGuiGuiEscape from WindowGuiGuiEscape)
;;;;     AHK simply crash.
;; When the WindowGui is closed
WindowGuiClose() {
	WindowGuiGuiEscape()
	
}
;; When escape is pressed in the WindowGui
WindowGuiGuiEscape() {
	;; Gui, WindowGui:Destroy
	Gui WindowGui:Hide
}

;; Usage example: WinExistOwnedBy("firefox.exe")
;; Getting the list of window [title] "owned" by the specified executable.
;; TODO Add predicates and filters (e.g. to filter out currently active window or
;;      filter out this script's windows)
WinExistOwnedBy(proc) {
	local plist

	;; MsgBox WinExistOwnedBy %proc% ; Just print the argument.
	;; Get the list of process
	WinGet, plist, list, , , Program Manager ; TODOC I got this on internet, I don't know yet what exactly are the arguments.

	local result := ""
	;; For each process
	Loop %plist% {
		local window_id := plist%A_Index%
		local class
		local owner
		local title
		
		;; Get the class
		WinGetClass, class, ahk_id %window_id%		
		if (class != "tooltips_class32") {
			;; Get the process name
			WinGet, owner, processName, ahk_id %window_id% 
			;; Get the title
			WinGetTitle, title, ahk_id %window_id%
			
			if(title != "") {
				if (proc = "" or owner = proc) {
					StringReplace, title, title, "|" ; NOT TESTED Remove | character in window titles
					;; Build up a "list" of titles.
					;result .= "[" . class . "] " . title . "|" 
					result .= title . "|" 
				}
			}
		}
	}
	;; Return the list of title mathing the predicate.
	windowList := result
	return result
}





;; "Main" Label (called when the escape key is pressed).
EscapeLabel:

;; TODO Replace Hotkey to alt-tab (i.e. when the user press escapeKey two times, the script will send Alt-Tab {!Tab}).
;; Hotkey, %escapeKey%, EscapeLabel

;;;; Read a string from the user.
input:=""
ToolTip Input:
Loop {
	Input, in, L1, {Enter}.{Escape}.{Tab}.{Backspace}
	EL=%ErrorLevel%
	if (EL = "EndKey:Enter") or (EL = "EndKey:Escape") {
		break
	} else if (EL = "EndKey:Tab") {
		MsgBox "asdf"
	} else if (EL = "EndKey:Backspace") {
		input := SubStr(input, 1, StrLen(input) -1)
	}
	input.=in
	ToolTip, Input:  %input%
}

if(EL != "EndKey:Escape") {
	;;;; Firefox
	if (input = "f") {
		;; Get the list of firefox windows
		WinGet, firefoxArray,List,ahk_exe firefox.exe
		;; Get the current windows
		WinGet, currentWin,id,A
		
		;;; FIXME This would have worked, if WinGet return the windows in the same order each time.
		nextIndex = 1
		; MsgBox % firefoxArray
		Loop %firefoxArray% {
			; MsgBox % "Element number " . A_Index . " is " . firefoxArray%A_Index% . " (current = " . currentWin . ")"
			if (firefoxArray%A_Index% = currentWin) {
				nextIndex := A_Index + 1
			}
		}
		if(nextIndex > firefoxArray) {
			nextIndex := 1
			MsgBox nextIndex out of range
		}
		
		MsgBox % nextIndex " -> " firefoxArray%nextIndex%
		WinActivate, % "ahk_id " firefoxArray%nextIndex%
		ToolTip ;; Remove the tooltip

	
	;;;; List of windows
	} else if (input = "w") {		
		;; Get a list of process
		windowList := WinExistOwnedBy("")
		;; Replace the WindowGuiListBox's list
		GuiControl ,WindowGui:, WindowGuiListBox, |%windowList%
		;; Show the GUI
		Gui WindowGui:Show,AutoSize,No title		
		ToolTip
		
		
;;;;;;;; Special cases
	;;;; Self reload
	} else if (input = "r") {
		MsgBox, 4,, About to reload script. Would you like to continue? (press Yes or No)
		IfMsgBox Yes
			Reload
		else
			ToolTip
			
	;;;; Help
	} else if (input = "help") {
		MsgBox TODO Make a help thingy...
		
	;;;; Verbatim
	} else if (input = "" and EL = "EndKey:Enter") {
		Send {%escapeKey%}
		ToolTip
		
	;;;; Default case
	} else {
		if (input != "") {
			ToolTip Unrecognized command "%input%"
			SetTimer, RemoveToolTip, 2000
		
		;;;; If empty, just do nothing.
		} else {
			ToolTip
		}
	}
} else {
	;;;; Cancel
	ToolTip
}
return

;; Small Label used to make a deferred called to "ToolTip" (which, when called without args, remove the tooltip).
RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return






;;; Retrieves the height of the client area.
GetClientHeight(HWND) { 
   VarSetCapacity(RECT, 16, 0)
   DllCall("User32.dll\GetClientRect", "Ptr", HWND, "Ptr", &RECT)
   Return NumGet(RECT, 12, "Int")
}
;;; Retrieves the height of a single list box item.
LB_GetItemHeight(HLB) {
   ; LB_GETITEMHEIGHT = 0x01A1
   SendMessage, 0x01A1, 0, 0, , ahk_id %HLB%
   Return ErrorLevel
}
;;; Retrieves the number of items in the list box.
LB_GetCount(HLB) { 
   ; LB_GETCOUNT = 0x018B
   SendMessage, 0x018B, 0, 0, , ahk_id %HLB%
   Return ErrorLevel
} 





;;;;;;;;;;;;;;;;;;;;;; Dead code

;; From http://stackoverflow.com/a/7062439
;; When gui receive a key down event.
;; Activate with OnMessage(0x100, "OnKeyDown")
OnKeyDown(wParam) {
	;;MsgBox KeyPress %wParam%
    if (A_Gui = "WindowGui") {
		if (wParam = 13) {
			Gui WindowGui:Submit
			MsgBox %WindowGuiSelection% 
		}
    }
}
;; More OnMessage Things at https://autohotkey.com/board/topic/96440-listbox-how-to-detect-single-click-event-apart-from-lbn-selchange/






