#If !isMixer()  ; hotkey is used in mixer
!F3 Up::    
    if (bringWinAtMouseToggle)
        stopBringWinAtMouseClock()
    else
        startBringWinAtMouseClock()
    return
#If

#If WinActive("ahk_exe FL64.exe")
+^!F1::
    getCursor()
    return

F5::
    return
F5 UP::
    Test()
    return

^F5 UP::
    Test2()
    return  
#If

#If WinActive("ahk_exe FL64.exe") or WinActive("ahk_exe Melodyne singletrack.exe")
F3::
    freezeExecute("moveWindows") 
    return

+F3::
    Send {F12}
    freezeExecute("moveWindows")
    return  

c & F2::
    freezeExecute("copyName")
    return

v & F2::
    freezeExecute("pasteColor")
    return

b & F2::
    freezeExecute("pasteName", ["", True], True, True)
    return

~v::
    return
#If

#If WinActive("ahk_exe FL64.exe") and !WinActive("ahk_class TNameEditForm") and !WinActive("ahk_class #32770")
F2::
    freezeExecute("rename")
    return

+F2::
    freezeExecute("startRandomizeNameLoop")
    return

+F2 Up::
    randomizingNameLoop := False
    toolTip()
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPlugin()
+F2::
    WinGet, pluginId, ID, A
    Playlist.bringWin(False)
    freezeExecute("rename")
    WinActivate, ahk_id %pluginId%
    return
#If

#If WinActive("ahk_exe FL64.exe")
F4::
    if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        deletePattern()
    else if ((isPlugin() or StepSeq.isWin()))
        freezeExecute("deletePlugin", [], False)
    else if (isMixer())
        freezeExecute("resetMixerTrack")
    else if (isWrapperPlugin())
        Send {Esc}
    return
#If

#If True
+^!F4::
    msg("prevented from opening keepass")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPlugin()
F12 Up::
    freezeExecute("randomizePlugin")
    return
#If