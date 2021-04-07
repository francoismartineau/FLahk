/*
#If WinActive("ahk_exe FL64.exe") and mouseOverPlaylistSong()
+WheelUp::
    toolTip("up")
    Send {AltDown}{WheelUp}{AltUp}
    ;SendInput !{Blind}{WheelUp}
    return

+WheelDown::
    toolTip("dwon")
    Send {AltDown}{WheelDown}{AltUp}
    ;SendInput !{Blind}{WheelDown}
    return
#If
*/


#If WinActive("ahk_exe FL64.exe") and isPlaylist()
q::
    freezeExecute("setPlaylistLoop", True, False, "start")
    return

w::
    freezeExecute("setPlaylistLoop", True, False, "end")
    return

e::
    freezeExecute("deleteNextPlaylistTab")
    return
;^LButton Up::   ; semble nécessaire pour set playlist loop
;    return
#If

#If WinActive("ahk_exe FL64.exe") and isPlaylist()
^b::
   Send {CtrlDown}b{CtrlUp}
   return   

s::
    freezeExecute("activateSlideTool")
    return
#If