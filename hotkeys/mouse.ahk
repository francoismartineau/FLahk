; This lets ahk detect double clicks
~LButton::
    return
; -------




;-- moveWin --------------------------------
#If !numpadGShown and (isPlugin() and !isMasterEdison()) or StepSeq.isWin()
+!XButton1::
    freezeExecute("MoveWin.switchMon", ["left"])
    return

+!XButton2::
    freezeExecute("MoveWin.switchMon", ["right"])
    return

!XButton1::
    freezeExecute("MoveWin.nudge", ["left"])
    return

!XButton2::
    freezeExecute("MoveWin.nudge", ["right"])
    return
#If
; ------- 

;-- MButton --------------------------------
#If WinActive("ahk_exe FL64.exe")
MButton::
    return
MButton Up::
    if (!acceptPressed)
        acceptPressed := True
    else if (isNameEditor() or isPianoRollTool())
        Send {Enter}
    else if (isInstr())
        return
    else
        Send {MButton}
    return

+MButton::
    return
+MButton Up::
    if (!acceptPressed)
        acceptPressed := True
    else
        SendInput +{MButton}
    return    
#If

#If WinActive("ahk_exe FL64.exe") or WinActive("ahk_exe ahk.exe") or WinActive("ahk_exe Code.exe")
MButton::
    return
MButton Up::
    Send {Enter}
    return
#If
; ------------------------------------------


;-- LButton --------------------------------
#If WinActive("ahk_exe FL64.exe") and PianoRoll.mouseOverChannChoice()
LButton::
    return
LButton Up::
    scrollInstrStart("pianoRoll")
    return
#If
#If WinActive("ahk_exe FL64.exe") and PianoRoll.mouseOverNoteCol()
LButton::
    return
LButton Up::
    freezeExecute("PianoRoll.setNoteCol", [1])
    return
#If
#If WinActive("ahk_exe FL64.exe") and mouseOverRecordButton()
LButton::
    return
LButton Up::
recordButtonMsg = 
(
Use upper razer buttons:
[X]
[ ]
[R]
)
    msg(recordButtonMsg)
    return
#If
#If WinActive("ahk_exe FL64.exe") and mouseOverMainFileMenu("new")
LButton::
    return
LButton Up::
    freezeExecute("createNewProject", [True], False)
    return
#If
#If WinActive("ahk_exe FL64.exe") and mouseOverPlayPauseButton()
~LButton::
    midiRequest("toggle_play_pause_external")
    return
#If
#If WinActive("ahk_exe FL64.exe") and mouseOverStopButton()
~LButton::
    midiRequest("stop_external")
    return
#If
#If WinActive("ahk_exe FL64.exe") and !acceptPressed and clickAlsoAccepts
LButton::
    return
LButton Up::
    acceptPressed := True
    return
#If
#If WinActive("ahk_exe FL64.exe") and !acceptPressed and mouseOverSavePromptSaveButton()
LButton::
    return
LButton Up::
    msg("Don't click save. Accept.")
    return
#If
#If WinActive("ahk_exe FL64.exe") and doubleClicked() and hoveringUpperMenuPattern()
LButton::
    waitKey("LButton")
    Send {ShiftDown}{CtrlDown}p{ShiftUp}{CtrlUp}
    return
#If 
#If WinActive("ahk_exe FL64.exe") and !acceptPressed and clickAlsoAccepts
+LButton::
    return
+LButton Up::
    acceptPressed := True
    return
#If
;------------------------------------------------




; XButton
#If True
^!XButton1 Up::
    waitForModifierKeys()
    Send {Delete}
    return
#If

; ---------
#If PreGenBrowser.running
RButton::
    PreGenBrowser.removeSound()
    return
#If
#If saveNewProjectRighClickGenName
RButton::
    generateProjectName()
    return
#If


; -- ^Click: pianoRoll
#If WinActive("ahk_exe FL64.exe") and ((isMixer("", True) or isMainFlWindow("", True) or (!isInstr("", True) and !isEdison("", True) and isPlugin("", True))))
^LButton::
    freezeExecute("PianoRoll.bringWin")
    return
#If
; --


; -- Razer Mouse Specifics --------
#If WinActive("ahk_exe FL64.exe") and whileRecordModeChoice
!F16::                                  ; 6
    acceptPressed := True
    return
!F13::                                  ; 3
    abortPressed := True
    freezeUnfreezeMouse("disableRecord")
    return
#If
#If WinActive("ahk_exe FL64.exe") and !whileRecordModeChoice
!F13::                                  ; 3
    freezeExecute("disableRecord")
    return

!F24::                                  ; 1
    freezeExecute("recordModeChoice")
    return
#If
#If WinActive("ahk_exe FL64.exe") and whileSetPyToFlFilter
!F17::                                  ; 7
    acceptPressed := True
    return
#If
#If WinActive("ahk_exe FL64.exe") 
!F17::                                  ; 7
    setPyToFlFilter()
    return
#If
#If True
!F20::                                  ; 10
    Send {Volume_Mute}
    return
#If
; --