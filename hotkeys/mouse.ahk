; This lets ahk detect double clicks
~LButton::
    return




; -------




;-- moveWin --------------------------------
#If WinActive("ahk_class TStepSeqForm") or (WinActive("ahk_class TPluginForm") and !isMasterEdison())
+!XButton1::
    moveWinLeftScreen()
    return

+!XButton2::
    moveWinRightScreen()
    return

~!XButton1::
    moveWinLeft("XButton1")
    return

~!XButton2::
    moveWinRight("XButton2")
    return
 #If
; -------



#If WinActive("ahk_exe FL64.exe") and !acceptPressed
MButton Up::
    acceptPressed := True
    return

+MButton  Up::      ; with shift also for selectSourceForAllSelectedClips()
    acceptPressed := True
    return
#If

#If WinActive("ahk_exe FL64.exe") and !acceptPressed and clickAlsoAccepts
LButton Up::
    acceptedWithClick := True
    acceptPressed := True
    return

+LButton::      ; with shift also for selectSourceForAllSelectedClips()
    acceptPressed := True
    return    
#If

#If hoveringUpperMenuPattern() and doubleClicked()
LButton::
    Send {ShiftDown}{CtrlDown}p{ShiftUp}{CtrlUp}
    return
#If


; -- Delb --------------------------------------------------
#If WinActive("ahk_exe FL64.exe") and isPlugin() and mouseOverDelBTurnOffWetVols()
~!LButton Up::
    freezeExecute("delBTurnOffWetVols")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPlugin() and mouseOverDelBSetTime()
~!LButton Up::
    freezeExecute("delBSetTime")
    return


; -- XButton ---------------------------
#If WinActive("ahk_exe FL64.exe") or WinActive("ahk_exe Code.exe")
^!XButton1 Up::
    freezeExecute("sendDelete")
    return


XButton1::
    xbutton1Released := False
    advanceInSong(False)
    return

XButton2::
    xbutton2Released := False
    advanceInSong(True)   
    return 

XButton1 Up::
    xbutton1Released := True
    return

^XButton1 Up::
    xbutton1Released := True
    return

XButton2 Up::
    xbutton2Released := True
    return

^XButton2 Up::
    xbutton2Released := True
    return    
;--
#If