#If WinActive("ahk_exe FL64.exe")
^!LButton::
    return
^!LButton Up::
    waitForModifierKeys()
    if (isPianoRollLfo())
        freezeExecute("pianoRollLfoSetTime")
    else if (isEnvClfo())
        freezeExecute("envCsetLfoTime")
    else if (isInstr())
    {
        if (mouseOnLeftWindowSide())
            freezeExecute("setInstrArpSpeed")
        else
            freezeExecute("setInstrDelayPitch")
    }
    else if (isLfo())
        freezeExecute("lfoSetTime")
    else if (isDelay())
        freezeExecute("delaySetTime")
    else if (isRev())
        freezeExecute("revSetTime")
    return

^!RButton::
    return
^!RButton Up::
    waitForModifierKeys()
    if (isInstr())
        if (!mouseOnLeftWindowSide())
            freezeExecute("setInstrDelaySpeed")
    return

~!LButton Up::
    waitForModifierKeys()
    if (mouseOnSynthUseShapesButtons())
        freezeExecute("synthUseShapes")
    else if (mouseOverPatcherModChorusSpeed())
        freezeExecute("patcherModChorusSpeed")
    else if (mouseOver5lfoSetSpeed())
        freezeExecute("5lfoSetSpeed")
    else if (mouseOverDelBTurnOffWetVols())
        freezeExecute("delBTurnOffWetVols")
    else if (mouseOverDelBSetTime())
        freezeExecute("delBSetTime")
    else if (mouseOn3xGrossReveal())
        freezeExecute("reveal3xGross", True, True)
    else if (isPatcher4())
        freezeExecute("patcher4ShowPlugin", False, False)
    else if (mouseOverPercEnvShowPlugin())
        freezeExecute("percEnvShowPlugin")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isInstr()
/::
    freezeExecute("cyclePanels")
    return
#If
#If WinActive("ahk_exe FL64.exe") and isInstr("", True)
^LButton::
    freezeExecute("openInstrInPianoRoll")
    return

+LButton::
    freezeExecute("openInstrInMixer")
    return
#If


#If WinActive("ahk_exe FL64.exe") and mouseOverKnobsWin()
^c::
    freezeExecute("copyKnob")
    return
    
^x::
    freezeExecute("cutKnob")
    return

^v::
    freezeExecute("pasteKnob")
    return

;+^LButton::
;    freezeUnfreezeMouse("knobResetVal")
;    return 

+MButton::
    return
+MButton Up::
    waitForModifierKeys()
    freezeExecute("knobSideChain")
    return

^!MButton::
    return
^!MButton Up::
    waitForModifierKeys()
    freezeExecute("knobResetCtl")
    return

^MButton::
    return
^MButton Up::
    waitForModifierKeys()    
    freezeExecute("knobSetMouseCtl", True, False, mCtlActive)
    return
#If