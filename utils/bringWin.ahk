global masterEdisonId = ""
bringMasterEdison(moveMouse := True)
{
    WinGet, currWinId, ID, A
    WinGet, freshMasterEdisonId, ID, Master Edison
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

bringMixer(moveMouse = True)
{
    WinGet, mixerId, ID, ahk_class TFXForm
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

bringPianoRoll(focusNotes := True, moveMouse := True)
{
    WinGet, pianoRollId, ID, ahk_class TEventEditForm, Piano roll
    if (isPianoRoll())
        return  

    if (!pianoRollId)
    {
        WinGet, currId, ID, A
        Send {F7}
        pianoRollId := waitNewWindowTitled("Piano roll", currId)
    }
    else
        WinActivate, ahk_id %pianoRollId%
    
    movePianoRoll(pianoRollId)

    if (focusNotes)
    {
        MouseMove, 767, 356, 0
        Send, {Ctrl Down}{Wheelup}{Ctrl Up}
        Send, {Ctrl Down}{RButton}{Ctrl Up}
    }

    if (moveMouse)
        centerMouse(pianoRollId)

    
    return pianoRollId
}

bringPlaylist(moveMouse := True)
{
    WinGet, playlistId, ID, ahk_class TEventEditForm, Playlist
    if (!playlistId or !isVisible(playlistId))
    {
        WinGet, currId, ID, A
        Send {F5}
        playlistId := waitNewWindowTitled("Playlist", currId)
    }
    else
        WinActivate, ahk_id %playlistId%

    if (moveMouse)
        centerMouse(playlistId)
    
    return playlistId
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


bringStepSeq(moveMouse := True)
{
    WinGet, stepSeqId, ID, ahk_class TStepSeqForm
    if (!stepSeqId or !isVisible(stepSeqId))
    {
        WinGet, currId, ID, A
        Send {F6}
        stepSeqId := waitNewWindowOfClass("TStepSeqForm", currId)
        if (!stepSeqId)
            return
    }
    else
        WinActivate, ahk_id %stepSeqId%
    

    if (!stepSeqMaximized(stepSeqId))
        maximizeStepSeq(stepSeqId)

    if (moveMouse)
        centerMouse(stepSeqId)
        
    return stepSeqId
}

bringEventEditor(moveMouse := True)
{
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