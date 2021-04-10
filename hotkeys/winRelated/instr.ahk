#If WinActive("ahk_exe FL64.exe")
~^!LButton Up::
    waitForModifierKeys()
    if (isInstr())
    {
        if (mouseOnLeftWindowSide())
            freezeExecute("setInstrArpSpeed")
        else
            freezeExecute("setInstrDelaySpeed")
    }
    else if (isLfo())
        freezeExecute("lfoSetTime")
    else if (isDelay())
        freezeExecute("delaySetTime")
    return

#If WinActive("ahk_exe FL64.exe") and isInstr()
/::
    freezeExecute("cyclePanels")
    return

^LButton::
    freezeExecute("openInstrInPianoRoll")
    return

+LButton::
    freezeExecute("openInstrInMixer")
    return
#If


#If WinActive("ahk_exe FL64.exe") and mouseOverKnobsWin()
^c::
    freezeUnfreezeMouse("copyKnob")
    return
    
^x::
    freezeUnfreezeMouse("cutKnob")
    return

^v::
    freezeUnfreezeMouse("pasteKnob")
    return

+^LButton::
    freezeUnfreezeMouse("resetKnob")
    return 

+^MButton::
    waitForModifierKeys()
    freezeExecute("knobResetCtl")
    return

^MButton::
    waitForModifierKeys()    
    freezeExecute("knobSetMouseCtl", True, False, mCtlActive)
    return
#If