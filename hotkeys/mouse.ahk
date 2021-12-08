; This lets ahk detect double clicks
~LButton::
    return




; -------




;-- moveWin --------------------------------
#If !numpadGShown and (WinActive("ahk_class TStepSeqForm") or (WinActive("ahk_class TPluginForm") and !isMasterEdison()))
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



#If !acceptPressed
MButton Up::
    acceptPressed := True
    return

+MButton  Up::      ; with shift also for selectSourceForAllSelectedClips()
    acceptPressed := True
    return
#If

#If WinActive("ahk_exe FL64.exe") and !acceptPressed and winAlsoAccepts
~LWin Up::
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


; -- patcherMod ------------------
#If WinActive("ahk_exe FL64.exe") and isPlugin() and mouseOverPatcherModChorusSpeed()
~!LButton Up::
    freezeExecute("patcherModChorusSpeed")
    return
#If
; ----

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
; ----

; -- 3xGross -----------------------------------------------
#If WinActive("ahk_exe FL64.exe") and isPlugin() and mouseOn3xGrossReveal()
~!LButton Up::
    freezeExecute("reveal3xGross", True, True)
    return
#If
; ----

; -- Patcher4 -----------------------------------------------
#If WinActive("ahk_exe FL64.exe") and isPlugin() and isPatcher4()
~!LButton Up::
    freezeExecute("patcher4ShowPlugin", False, False)
    return
#If
; ----


; XButton
#If True
^!XButton1 Up::
    waitForModifierKeys()
    Send {Delete}
    return
#If

; ---------
#If preGenBrowsing
RButton::
    removePreGenSound()
    return
#If


; -- ^Click: pianoRoll
#If WinActive("ahk_exe FL64.exe") and (isMixer("", True) or isMainFlWindow("", True) or (!isInstr() and isPlugin("", True)))
^LButton::
    bringPianoRoll()
    return
#If
; --