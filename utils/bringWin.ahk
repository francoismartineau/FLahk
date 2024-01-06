bringMainWin(winId)
{
    if (StepSeq.isWin(winId))
        StepSeq.bringWin(True, True, winId)
    else if (PianoRoll.isWin(winId))
        PianoRoll.bringWin(True, True, winId)
    else if (Playlist.isWin(winId))
        Playlist.bringWin(True, winId)
    else if isEventEditor(winId)
        bringEventEditor(True, winId)
    else if isMasterEdison(winId)
        bringMasterEdison(True, winId)
    else if isMixer(winId)
        bringMixer(True)
    else
        WinActivate, ahk_id %winId%
}

global masterEdisonId = ""
bringMasterEdison(moveMouse := True, winId := "")
{
    WinGet, currWinId, ID, A
    if (winId == "")
        WinGet, freshMasterEdisonId, ID, Master Edison
    else 
        freshMasterEdisonId := winId

    if (currWinId != freshMasterEdisonId)
    {
        if (!freshMasterEdisonId)
        {
            mixerId := bringMixer(False)
            setMixerTrack(0)                    ; Master track
            quickClick(1793, 73)                ; First Slot
            freshMasterEdisonId := waitNewWindowTitled("Master Edison", mixerId, 0, "waiting for Master Edison")
        }
        else
            WinActivate, ahk_id %freshMasterEdisonId%

        moveMasterEdison()

        masterEdisonId := freshMasterEdisonId
        if (moveMouse)
            centerMouse(masterEdisonId)
    }
    else if (masterEdisonId != "")
    {
        WinActivate, ahk_id %masterEdisonId%
        if (moveMouse)
            centerMouse(masterEdisonId)
    }
    return masterEdisonId
}

bringMixer(moveMouse := True, winId := "")
{
    if (winId == "")
        WinGet, mixerId, ID, ahk_class TFXForm
    else
        mixerId := winId
    if (!mixerId or !isVisible(mixerId))
    {
        Send {F9}
        WinGet, mixerId, ID, ahk_class TFXForm
    }
    else
        WinActivate, ahk_id %mixerId%

    if (moveMouse)
        centerMouse(mixerId)
        ;moveMouseOnMixerSlot("down")

    return mixerId
}

bringControlSurface(moveMouse := True)
{
    WinGet, controlSurfaceId, ID, Control Surface (knobs)
    if (controlSurfaceId)
    {
        WinActivate, ahk_id %controlSurfaceId%
        if (moveMouse)
            centerMouse(controlSurfaceId)
    }
    return controlSurfaceId
}


bringEventEditor(moveMouse := True, winId := "")
{
    if (winId == "")
        WinGet, eventEditorId, ID, Events -
    if (eventEditorId != "")
    {
        WinActivate, ahk_id %eventEditorId%
        if (moveMouse)
            centerMouse(eventEditorId)
    }
    else
        msg("No event editor active. ^over knob")
    return eventEditorId
}

bringMainFLWindow()
{
    WinGet, id, ID, ahk_class TFruityLoopsMainForm
    WinActivate, ahk_id %id%
    return id    
}

bringTouchKeyboard()
{
    WinActivate, ahk_class TTouchKeybForm
}

bringFL()
{
    WinGet, exe, ProcessName, A
    if (exe != "FL64.exe")
        WinActivate, ahk_exe FL64.exe
}

bringPercEnv()
{
    if (winExists(PercEnv.winId))
    {
        percEnvId := PercEnv.winId
        WinActivate, ahk_id %percEnvId%
        if (PercEnv.confirmWin(PercEnv.winId))
        {
            centerMouse(PercEnv.winId)
            return
        }
    }

    stepSeqId := StepSeq.bringWin(False)
    x := 180
    StepSeq.changeGroup(StepSeq.knownChannels["percEnv"]["group"])
    y := StepSeq.channelIndexToY(StepSeq.knownChannels["percEnv"]["index"])
    moveMouse(x, y)
    percEnvId := StepSeq.bringChanUnderMouse(False)
    if (PercEnv.confirmWin(percEnvId))
        centerMouse(PercEnv.winId)
    return PercEnv.winId
}


bringLoopMidi()
{
    loopMidiId := WinExist("loopMIDI ahk_exe loopMIDI.exe")
    isOpen := isVisible(loopMidiId)
    if (!isOpen)
    {
        WinGet, currWinId, ID, A
        loopMidiPath := Paths.loopMidi
        run, %loopMidiPath%
        loopMidiId := waitNewWindowOfProcess("loopMIDI.exe", currWinId)
    }
    winX := 956
    winY := 87
    WinMove, ahk_id %loopMidiId%,, %winX%, %winY%
    WinActivate, ahk_id %loopMidiId%    
    return loopMidiId
}