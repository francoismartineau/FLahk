#If WinActive("ahk_exe FL64.exe") and isPatcherSlicex("", True)
~!LButton Up::
    waitForModifierKeys()
    if (mouseOverPatcherSlicexArp())
        freezeExecute("randomizeArpParams")
    else if (mouseOverPatcherSlicexDel())
        freezeExecute("randomizeDelayParams")
    else if (mouseOverPatcherSlicexRel())
        freezeExecute("patcherSlicexRel")
    else if (mouseOverPatcherSlicexRelDisable())
        freezeExecute("patcherSlicexRelDisable")
    else if (mouseOnpatcherSlicexFilterType())
        freezeExecute("patcherSlicexFilterType")
    return
#If