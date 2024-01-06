#If WinActive("ahk_class TStepSeqForm")
~Up::
    Sleep, 100
    StepSeq.moveMouseToSelChan()
    return


~Down::
    Sleep, 100
    StepSeq.moveMouseToSelChan()
    return

XButton1::
    return

XButton2::
    return     

; -- Instr ---------------------------------
1::
2::
3::
4::
5::
6::
7::
8::
!1::
!2::
!3::
!4::
!5::
!6::
!7::
!8::
    if (InStr(A_ThisHotkey, "!"))
        num := SubStr(A_ThisHotkey, 2, 1) "_2"
    else
        num := SubStr(A_ThisHotkey, 1, 1) "_1"
    freezeExecute("StepSeq.loadInstr", [num])
    return
#If

#If WinActive("ahk_exe FL64.exe") and StepSeq.isWin() and StepSeq.mouseOnStepSeqMenu()
LButton Up::
    mousePosNum := StepSeq.mouseOnMenuSection()
    freezeExecute("StepSeq.loadInstr", [mousePosNum])
    return 
#If
; -------------------------------------------

#If WinActive("ahk_exe FL64.exe") and scrollingInstr and StepSeq.mouseOverInstr()
LButton::
    scrollInstrStop("instr")
    return
^LButton::
    scrollInstrStop("pianoRoll")
    return
#If

#If WinActive("ahk_exe FL64.exe") and !scrollingInstr and StepSeq.mouseOverInstr()
+RButton::
    return

; Dont set it to Up otherwise stopping to drag a knob over a channel triggers it
LButton::
    freezeExecute("StepSeq.bringChanUnderMouse")
    return

^LButton Up::
    freezeExecute("StepSeq.bringChanUnderMouseInPianoRoll")
    return

+^LButton Up::
    freezeExecute("StepSeq.selOnlyChanUnderMouse")
    return

+LButton Up::
    waitForModifierKeys()
    freezeExecute("StepSeq.selOnlyChanUnderMouse")
    return

+^RButton Up::
+RButton Up::
    freezeExecute("unselChannelUnderMouse")
    return
#If


#If WinActive("ahk_exe FL64.exe") and StepSeq.isWin("", True) and StepSeq.mouseOverInstr()
l::
    freezeExecute("toggleLockUnlockKeyboard")
    return
#If


; -- Clipboard -----------------------------
#If WinActive("ahk_exe FL64.exe") and !WinActive("ahk_class TNameEditForm") and StepSeq.mouseOverInstrOrNotes()
^c::
    freezeExecute("StepSeq.copyMouseChannelNotes", [], True, True)
    return

^x::
    freezeExecute("StepSeq.cutMouseChannelNotes", [], True, True)
    return

^v::
    freezeExecute("StepSeq.pasteMouseChannelNotes", [], True, True)
    return
#If