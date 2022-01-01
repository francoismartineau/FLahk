#If WinActive("ahk_exe FL64.exe") and isPatcherMap()
1 Up::
    if (mouseOverMidiKnot())
        freezeExecute("patcherLoadPatcherSampler")
    else if (mouseOverAudioKnot())
        freezeExecute("loadFxFromChoice", False, False, "room", "patcher")
    return

2 Up::
    if (mouseOverMidiKnot())
        freezeExecute("patcherLoadPatcherSampler")
    else if (mouseOverAudioKnot())
        freezeExecute("loadFxFromChoice", False, False, "mod", "patcher")
    return

3 Up::
    if (mouseOverMidiKnot())
        freezeExecute("patcherLoadSynth")
    else if (mouseOverAudioKnot())
        freezeExecute("loadFxFromChoice", False, False, "filter", "patcher")
    return

4 Up::
    if (mouseOverMidiKnot())
        freezeExecute("patcherLoadPiano")
    else if (mouseOverAudioKnot())
        freezeExecute("loadFxFromChoice", False, False, "patcher4", "patcher")
    return

5 Up::
    if (mouseOverMidiKnot())
        freezeExecute("patcherLoadEnvC")
    else ;if (mouseOverAudioKnot())
        freezeExecute("loadLfo", False, False, "patcher")
    return

6 Up::
    if (mouseOverMidiKnot())
        msg(" ")
    else ;if (mouseOverAudioKnot())
        freezeExecute("loadFormulaCtl", False, False, "patcher")
    return

7 Up::
    if (mouseOverMidiKnot())
        msg(" ")
    else if (mouseOverAudioKnot())
        freezeExecute("loadFxFromChoice", False, False, "pitch", "patcher")
    return

8 Up::
    if (mouseOverMidiKnot())
        freezeExecute("patcherLoadPlucked")
    else if (mouseOverAudioKnot())
        freezeExecute("loadFxFromChoice", False, False, "dyn", "patcher")
    return

9 Up::
    if (mouseOverMidiKnot())
        freezeExecute("patcherLoadVox")
    else if (mouseOverAudioKnot())
        freezeExecute("loadSpeaker", False, False, "patcher")
    return

0 Up::
    if (mouseOverMidiKnot())
        freezeExecute("patcherLoadChords")
    else if (mouseOverAudioKnot())
        freezeExecute("loadFxFromChoice", False, False, "seq")
    return

#If

#If WinActive("ahk_exe FL64.exe") and isPatcherMap() and !(mouseOverMidiKnot() or mouseOverCtlKnot() or mouseOverAudioKnot())
LButton Up::
    if (doubleclicked())
    {
        WinGet, patcherMapId, ID, A
        sendinput !{LButton Up}
        pluginId := waitNewWindowOfClass("TWrapperPluginForm", patcherMapId, 1000)
        AlwaysOnTop(pluginId)
    }
    else
        Send {LButton Up}
    return
/*
~LButton::
    toolTip("alt: don't open", 6)
    return

LButton Up::   
    toolTip("", 6)
    if (keyDown("Alt"))
        send {LButton}
    else
        sendinput !{LButton}        ; open patcher plugin
    return
*/
#If
