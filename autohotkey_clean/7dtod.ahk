;; Usefull for a lost of Firt-Person games.

;; Reload
^r::Reload

;; Show mouse position
^RButton::
MouseGetPos, xpos, ypos 
ToolTip, The cursor is at X%xpos% Y%ypos%. 
Return

;; Hold down shift to run.	
*Capslock::Send {Shift down}

;; Hold down w to go forward
*Q::Send {w down}

