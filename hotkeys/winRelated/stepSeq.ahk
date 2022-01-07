#If WinActive("ahk_class TStepSeqForm")
~Up::
    Sleep, 100
    moveMouseToSelY()
    return


~Down::
    Sleep, 100
    moveMouseToSelY()
    return

XButton1::
    return

XButton2::
    return     

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
    if (hasVal(A_ThisHotkey, "!"))
        num := SubStr(A_ThisHotkey, 2, 1) "_2"
    else
        num := SubStr(A_ThisHotkey, 1, 1) "_1"
    freezeExecute("loadStepSeq" num)
    return
#If


#If WinActive("ahk_exe FL64.exe") and !scrollingInstr and mouseOverStepSeqInstruments()
+RButton::
    return

; Dont set it to Up otherwise stopping to drag a knob over a channel triggers it
LButton::
    freezeExecute("openChannelUnderMouse")
    return

^LButton Up::
    freezeExecute("openChannelUnderMouseInPianoRoll")
    return

+^LButton Up::
    freezeExecute("selectChannelUnderMouse")
    return

+LButton Up::
    freezeExecute("selectOnlyChannelUnderMouse")
    return

+^RButton Up::
+RButton Up::
    freezeExecute("unselChannelUnderMouse")
    return
#If


#If WinActive("ahk_exe FL64.exe") and isStepSeq() and mouseOverStepSeqInstruments()
l::
    freezeExecute("toggleLockKeyboardUnlock")
    return
#If


; -- Menu ---------------------------------
#If WinActive("ahk_exe FL64.exe") and isStepSeq() and mouseOnStepSeqMenu()
LButton Up::
    pos := mouseOnStepSeqMenuSection()
    freezeExecute("loadStepSeq" pos)
    return 
#If

; -- Clipboard -----------------------------
#If WinActive("ahk_exe FL64.exe") and mouseOverStepSeqInstrOrScore()
^c::
    freezeExecute("copyMouseChannelNotes", True, True)
    return

^x::
    freezeExecute("cutMouseChannelNotes", True, True)
    return

^v::
    freezeExecute("pasteMouseChannelNotes", True, True)
    return
#If