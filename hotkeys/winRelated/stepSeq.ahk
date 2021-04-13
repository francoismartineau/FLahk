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
    freezeExecute("load3xosc")
    return

2::
    freezeExecute("loadLongSynth")
    return

3::
    freezeExecute("loadChords")
    return

4::
    freezeExecute("loadVox")
    return

5::
    freezeExecute("loadRaveGen")
    return

6::
    freezeExecute("loadSpeech")
    return

7::
    freezeExecute("loadGranular")
    return

8::
    return

9::
    return

0::
    return

!1::
    freezeExecute("loadRandomFlSynth")
    return

!2::
    freezeExecute("loadPlucked")
    return

!3::
    freezeExecute("loadBeepMap")
    return

!4::
    freezeExecute("loadAutogun")
    return

!5::
    freezeExecute("loadBooBass")
    return

!6::
    freezeExecute("loadPiano")
    return

!7::
    freezeExecute("loadPatcherSlicex")
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
    freezeExecute("lockWithTypingKeyboard")
    return
#If


; -- Menu ---------------------------------
#If WinActive("ahk_exe FL64.exe") and isStepSeq() and mouseOnStepSeqMenu()
LButton Up::
    pos := mouseOnStepSeqMenuSection()
    Switch pos
    {
    Case "1_1":
        freezeExecute("load3xosc")
    Case "2_1":
        freezeExecute("loadLongSynth")
    Case "3_1":
        freezeExecute("loadChords")
    Case "4_1":
        freezeExecute("loadVox")
    Case "5_1":
        freezeExecute("loadRaveGen")
    Case "6_1":
        freezeExecute("loadSpeech")
    Case "7_1":
        freezeExecute("loadGranular")
    Case "8_1":
    Case "9_1":
    Case "0_1":
    Case "1_2":
        freezeExecute("loadRandomFlSynth")
    Case "2_2":
        freezeExecute("loadPlucked")
    Case "3_2":
        freezeExecute("loadBeepMap")
    Case "4_2":
        freezeExecute("loadAutogun")
    Case "5_2":
        freezeExecute("loadBooBass")
    Case "6_2":
        freezeExecute("loadPiano")
    Case "7_2":
        freezeExecute("loadPatcherSlicex")
    }
    return 
#If

; -- Clipboard -----------------------------
#If WinActive("ahk_exe FL64.exe") and mouseOverStepSeqInstrOrScore()
^c::
    freezeExecute("copyChannelNotes", True, True)
    return

^x::
    freezeExecute("cutChannelNotes", True, True)
    return

^v::
    freezeExecute("pasteChannelNotes", True, True)
    return
#If