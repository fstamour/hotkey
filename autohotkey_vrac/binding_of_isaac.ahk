;;; Note: I abandoned that script because it was working like a fish in a puddle of sand.

#Persistent  ; Keep this script running until the user explicitly exits it.
SetTimer, WatchPOV, 5
;SetTimer, WatchAxisX, 10
;SetTimer, WatchAxisY, 10
;SetTimer, WatchAxisR, 10
;SetTimer, WatchAxisU, 10

^r:: ; press control+r to reload
  Reload
  return
  
return

;;;;;;;;;;;; Functions here:

AxisDir(x)
{
	if x < 40
		return -1
	else if x <= 60
		return 0
	else
		return 1
}

PressJoy(byref lastKey, dir, keyNeg, keyPos)
{
	if dir = -1
		newKey := keyNeg
	else if dir = 1
		newKey := keyPos

	if newKey
	{
		Send {%newKey% down}
		lastKey := newKey
	}
}

ReleaseJoy(byref lastKey)
{
	if lastKey
	{
		Send {%lastKey% up}
	}
	lastKey =
}

;;;;;;;;;;;; Labels here:

WatchAxisX:
GetKeyState, JoyX, JoyX
lastKeyX =
PressJoy(lastKeyX, AxisDir(JoyX), "a", "d")
sleep, 5
ReleaseJoy(lastKeyX)
return

WatchAxisY:
GetKeyState, JoyY, JoyY
lastKeyY =
PressJoy(lastKeyY, AxisDir(JoyY), "w", "s")
sleep, 5
ReleaseJoy(lastKeyY)
return

WatchAxisR:
GetKeyState, JoyR, JoyR
lastKeyR =
PressJoy(lastKeyR, AxisDir(JoyR), "Up", "Down")
sleep, 5
ReleaseJoy(lastKeyR)
return

WatchAxisU:
GetKeyState, JoyU, JoyU
lastKeyU =
PressJoy(lastKeyU, AxisDir(JoyU), "Right", "Left")
sleep, 5
ReleaseJoy(lastKeyU)
return



WatchPOV:

;; Get position of the POV control.
GetKeyState, POV, JoyPOV

;; Remember the keys that was down before (if any).
KeyToHoldDownPrev = %KeyToHoldDown%
KeyToHoldDownPrev2 = %KeyToHoldDown2%



if POV >= 0
{
	;; Up // Down
	if (POV > 29250) or (POV < 6750)
	{
		KeyToHoldDown =	Up
	} else if POV between 11250 and 24750
	{
		KeyToHoldDown =	Down
	} else 
	{
		KeyToHoldDown =
	}

	;; Left // Right
	if POV between 2250 and 15750
	{
		KeyToHoldDown2 = Right
	} else if POV between 20250 and 33750
	{
		KeyToHoldDown2 = Left
	} else 
	{
		KeyToHoldDown2 =
	}
} else
{
	KeyToHoldDown =
	KeyToHoldDown2 =
}

;; Useful for debugging:
;; ToolTip POV: %POV% %KeyToHoldDown% + %KeyToHoldDown2%


; if KeyToHoldDown = %KeyToHoldDownPrev%  ; The correct key is already down (or no key is needed).
;	return  ; Do nothing.
; Otherwise, release the previous key and press down the new key:

; Avoid delays between keystrokes.
SetKeyDelay -1

;;; If there is a previous key to release.
if KeyToHoldDownPrev and (KeyToHoldDown != %KeyToHoldDownPrev%)
    Send, {%KeyToHoldDownPrev% up}  ; Release it.
if KeyToHoldDownPrev2 and (KeyToHoldDown2 != %KeyToHoldDownPrev%)
    Send, {%KeyToHoldDownPrev2% up}  ; Release it.

;;; If there is a key to press down.
if KeyToHoldDown
    Send, {%KeyToHoldDown% down}

if KeyToHoldDown2
    Send, {%KeyToHoldDown2% down}
	
return


