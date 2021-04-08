#If WinActive("ahk_exe FL64.exe") and isPlaylist()
^b::
   Send {CtrlDown}b{CtrlUp}
   return   

s::
    freezeExecute("activateSlideTool")
    return

LWin & XButton1::
    freezeExecute("deleteNextPlaylist")
    return
#If