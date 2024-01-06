#If WinActive("ahk_exe FL64.exe")
^!LButton::
    return
^!LButton Up::
    waitForModifierKeys()
    if (isPianoRollLfo())
        freezeExecute("PianoRoll.lfoSetTime")
    else if (EnvC.isLfo())
        freezeExecute("EnvC.setLfoTime")
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
        freezeExecute("reveal3xGross")
    else if (isPatcher4())
        freezeExecute("patcher4ShowPlugin", [], False)
    else if (PercEnv.mouseOverShowEnvC())
        freezeExecute("PercEnv.showEnvC")
    else if (PercEnv.mouseOverLfoSpeedSet())
        freezeExecute("PercEnv.lfoSetSpeed")
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


#If WinActive("ahk_exe FL64.exe") and !WinActive("ahk_class TNameEditForm") and mouseOverKnobsWin()
^c::
    freezeExecute("Knob.copy")
    return
    
^x::
    freezeExecute("Knob.cut")
    return

^v::
    freezeExecute("Knob.paste")
    return

;+^LButton::
;    freezeUnfreezeMouse("knobResetVal")
;    return 

+MButton::
    return
+MButton Up::
    waitForModifierKeys()
    freezeExecute("Knob.linkSideChain")
    return

^!MButton::
    return
^!MButton Up::
    waitForModifierKeys()
    freezeExecute("Knob.resetLink")
    return

^MButton::
    return
^MButton Up::
    waitForModifierKeys()    
    freezeExecute("knobSetMouseCtl", [mCtlActive])
    return
#If