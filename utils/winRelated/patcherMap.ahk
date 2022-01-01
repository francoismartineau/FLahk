; -- Load Instrs --------------------------------------
patcherLoadPatcherSampler()
{
    pluginId := patcherLoadPlugin("instr", "PS", 1, 1)
    return pluginId
}

patcherLoadPatcherSlicex()
{
    pluginId := patcherLoadPlugin("instr", "Slcx", 1, 8)
    return pluginId
}

patcherLoadPatcherGrnl()
{
    pluginId := patcherLoadPlugin("instr", "Grnl", 1, 3)
    return pluginId
}

patcherLoadSynth()
{
    patcherLoadPlugin("instr", "Synth", 1, 9)
}

patcherLoadPiano()
{
    patcherLoadPlugin("instr", "Piano", 14)
}

patcherLoadEnvC()
{
    patcherLoadPlugin("instr", "EnvC", 2)
}

patcherLoadPlucked()
{
    patcherLoadPlugin("instr", "plucked", 13)
}

patcherLoadVox()
{
    patcherLoadPlugin("instr", "vox", 23)
}

patcherLoadChords()
{
    patcherLoadPlugin("instr", "chords", 1, 2)
}
; ----


; ----
patcherLoadPlugin(mode, name := "", n := 1, preset := "", func := "")
{
    WinGet, patcherId, ID, A
    WinGetPos,,, winW, winH, ahk_id %patcherId%
    MouseGetPos, mX, mY

    loadAreaX := (winW - 100)/2
    loadAreaY := 100 + (winH - 100)/2 - 30
    if (patcherPluginInArea(loadAreaX, loadAreaY))
    {
        moveMouse(loadAreaX, loadAreaY)
        toolTip("Clear area and accept")
        unfreezeMouse()
        res := waitAcceptAbort()
        toolTip()
        if (res == "abort")
            return
        freezeMouse()
        moveMouse(mX, mY)
    }


    Send {RButton}{Down}{Down}{Right}
    Send {Down}
    pluginInSecondRow := mode == "fx" and !mouseOverAudioKnot()
    if (pluginInSecondRow)
        Send {Right}
    Send {Down}{Down}{Down}{Right}
    Switch mode
    {
    Case "instr":
        key := "i"
    Case "fx":
        key := "f"
    }
    Loop, %n%
        Send %key%
    Send {Enter}

    moveMouse(loadAreaX, loadAreaY)
    if (func == "")
        res := waitToolTip("Place plugin, leave mouse over")
    else
        res := %func%(patcherId)
    if (res == "abort")
        return

    if (name != "")
    {
        ;Sleep, 100
        ;clipboardSave := clipboard
        ;Sleep, 200
        ;clipboard := name
        ;Sleep, 200
        Click, R
        Send r
        toolTip("Waiting name editor")
        nameEditorId := waitNewWindowOfClass("TNameEditForm", patcherId, 0)
        toolTip()
        if (nameEditorId)
        {
            typeText(name)
            ;SendInput ^v
            Send {Enter}
            ;clipboard := clipboardSave
        }
    }
    
    Send {AltDown}
    toolTip("waiting plugin")
    Click
    pluginId := waitNewWindowOfClass("TWrapperPluginForm", patcherId, 50)
    if (!pluginId)
    {
        Click
        pluginId := waitNewWindowOfClass("TWrapperPluginForm", patcherId, 1000)
    }
    Send {AltUp}
    toolTip()

    if (pluginId)
    {
        alwaysOnTop(pluginId)
        if (preset)
            openPresetPlugin(preset, pluginId)
        centerMouse(pluginId)
    }
    retrieveMouse := False
    return pluginId
}

patcherPluginInArea(areaX, areaY)
{
    patcherCol := [0x3f484d]
    h := 30
    colVar := 0
    incr := 5
    reverse := True
    res := scanColorsDown(areaX, areaY, h, patcherCol, colVar, incr, "", False, reverse)
    return res != ""
}
; ----



; -- Utils -------------------------
global midiKnotCol := 0x40FFE0
mouseOverMidiKnot()
{
    MouseGetPos, mX, mY
    return colorsMatch(mX, mY, [midiKnotCol])
}

global ctlKnotCol := 0xFF5F7E
mouseOverCtlKnot()
{
    MouseGetPos, mX, mY
    return colorsMatch(mX, mY, [ctlKnotCol])
}

global audioKnotCol := 0xFFEC40
mouseOverAudioKnot()
{
    MouseGetPos, mX, mY
    return colorsMatch(mX, mY, [audioKnotCol])
}
; ----