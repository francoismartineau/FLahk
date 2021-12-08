#If WinActive("ahk_exe FL64.exe") and isPlaylist()
^b::
   Send {CtrlDown}b{CtrlUp}
   return   

s::
    freezeExecute("activateSlideTool")
    return

/*
;;Keep playing when playlist loop modified


if Ctrl down Mouse down (x1) and mouse up (x2)

LButton::
    if (keyDown("LCtrl"))
	    mouseGetPos(timelineMouseDownX, _)
    return

LButton Up::
    if (!keyDown("LCtrl"))
        freezeExecute("playlistUnselectClips")
    return
*/




LWin & XButton1::
    freezeExecute("deleteNextPlaylist")
    return
#If

