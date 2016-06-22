^j::
;send ^j
;return

Send ^+{left}
Send ^c
pos :=  RegExMatch( clipboard, "[\w]+", arr )
;Loop, % arr.len()
;   Msgbox, % arr[A_Index]

MsgBox "%clipboard%"   "%arr%"
return 