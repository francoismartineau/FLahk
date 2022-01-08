#If WinActive("ahk_exe FL64.exe") and PreGenBrowser.running
Left::
    return
Left Up::
    PreGenBrowser.useBackup("prev")
    return

Right::
    return
Right Up::
    PreGenBrowser.useBackup("next")
    return

Up::
    return
Up Up::
    PreGenBrowser.useBackup("last")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPatcher4()
Left::
    freezeExecute("patcher4ChangeFx")
    return
    
Right::
    freezeExecute("patcher4ChangeFx")
    return    
#If

#If WinActive("ahk_exe FL64.exe") and isDistructor()
Left::
    distructorChangeFX("left")
    return

Right::
    distructorChangeFX("right")
    return
#If




#If WinActive("ahk_exe FL64.exe") and (isPianoRoll() or isPlaylist())
^!Left::
    Send {CtrlDown}{Left}{CtrlUp}
    return

^!Right::
    Send {CtrlDown}{Right}{CtrlUp}
    return
#If

#If WinActive("ahk_exe FL64.exe") and isEventEditor()
Up::
    freezeExecute("eventEditorCycleParam", ["up"])
    return

Down::
    freezeExecute("eventEditorCycleParam", ["down"])
    return    
#If