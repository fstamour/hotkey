SetTimer Click, 100

F8::Toggle := !Toggle

Click:
    If (!Toggle)
        Return
    Click
    Send a