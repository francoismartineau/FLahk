#If WinActive("ahk_exe FL64.exe") and (isPatcherSampler("", True) or isPatcherGranular("", True))
~!LButton Up::
    waitForModifierKeys()
    overLfoSpeedSet := mouseOverSamplerLfoSpeedSet()
    if (overLfoSpeedSet)
        freezeExecute("samplerLfoSetTime", True, True, overLfoSpeedSet)
    else if (mouseOverSamplerPatcherArp())
        freezeExecute("randomizeArpParams")
    else if (mouseOverSamplerPatcherDel())
        freezeExecute("randomizeDelayParams")
    return
#If