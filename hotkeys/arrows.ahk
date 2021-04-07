#If WinActive("ahk_class TStepSeqForm") or (WinActive("ahk_class TPluginForm") and !isMasterEdison())
; Switch screen windows



#If WinActive("ahk_exe FL64.exe") and isPatcher4()
Left::
    patcher4ChangeFx()
    return
    
Right::
    patcher4ChangeFx()
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
    freezeExecute("eventEditorCycleParam", True, False, "up")
    return

Down::
    freezeExecute("eventEditorCycleParam", True, False, "down")
    return    
#If