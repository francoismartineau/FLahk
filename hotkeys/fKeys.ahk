#If WinActive("ahk_exe FL64.exe") or WinActive("ahk_exe Melodyne singletrack.exe")
;F1::
;    freezeExecute("newPatt")
;    return

F3::
    freezeExecute("moveWindows") ;, True, True, False)
    return

+F3::
    Send {F12}
    freezeExecute("moveWindows")
    return

F5 UP::
    Test()
    return

^F5 UP::
    Test2()
    return    

c & F2::
    freezeExecute("copyName")
    return

v & F2::
    freezeExecute("pasteColor")
    return

b & F2::
    freezeExecute("pasteName", True, True, "", True)
    return

~v::
    return
#If

#If WinActive("ahk_exe FL64.exe") and !WinActive("ahk_class TNameEditForm") and !WinActive("ahk_class #32770")
F2::
    freezeExecute("rename")
    return

+F2::
    freezeExecute("startRandomizeNameLoop", True)
    return

+F2 Up::
    randomizingNameLoop := False
    toolTip()
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPlugin()
+F2::
    WinGet, pluginId, ID, A
    bringPlaylist(False)
    freezeExecute("rename")
    WinActivate, ahk_id %pluginId%
    return
#If

#If WinActive("ahk_exe FL64.exe")
F4::
    if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        deletePattern()
    else if ((isPlugin() or isStepSeq()))
        freezeExecute("deletePlugin", False)
    else if (isMixer())
        freezeExecute("resetMixerTrack")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPlugin()
F12 Up::
    freezeExecute("randomizePlugin")
    return
#If

/*
; toggle pat / song
#If WinActive("ahk_exe FL64.exe")
F3 UP::
    freezeExecute("togglePatternSong")
    return

; toggle record
#If WinActive("ahk_exe FL64.exe")
F4 UP::
    freezeExecute("toggleRecord")
    return





; playlist
#If WinActive("ahk_exe FL64.exe")
F5 UP::
    startstopWinHistoryClock("bringPlaylist")
    return

; step seq
#If WinActive("ahk_exe FL64.exe")
F6 UP::
    bringStepSeq(True)
    return

; piano roll
#If WinActive("ahk_exe FL64.exe")
F7 UP::
    freezeExecute("bringPianoRoll")
    return

; mixer
#If WinActive("ahk_exe FL64.exe")
F8 UP::
    startstopWinHistoryClock("bringMixer")
    return





; Assign free mixer track to channel
#If WinActive("ahk_exe FL64.exe")
F9 UP::
    Send {Ctrl Down}
    Send l
    Send {Ctrl Up}
    return

; Edison
#If WinActive("ahk_exe FL64.exe")
F10 UP::
    startstopWinHistoryClock("bringMasterEdison")
    return
*/