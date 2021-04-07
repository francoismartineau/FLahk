global masterEdisonLastWindow = ""



bringMasterEdison(moveMouse = True)
{
    global masterEdisonLastWindow
    WinGet, currWinId, ID, A
    WinGet, edisonId, ID, Master Edison
    currentlyEdison := edisonId == currWinId
    if (!currentlyEdison)
    {
        if (!edisonId)
        {
            currTrack := getMixerTrack()
            bringMixer(False)
            Click, 83, 130, 1               ; Master Track
            Click, 1793, 73, 1              ; First Slot
            WinWaitActive, Master Edison,, 3
            WinGet, edisonId, ID, Master Edison
            if (currTrack > 0)
                setMixerTrack(currTrack)     
        }
        else
            WinActivate, ahk_id %edisonId%

        masterEdisonLastWindow := currWinId
        if (moveMouse)
            centerMouse(edisonId)
    }
    else if (masterEdisonLastWindow != "")
    {
        msgTip("bringMasterEdison situation bizarre?")
        WinActivate, ahk_id %masterEdisonLastWindow%
        if (moveMouse)
            centerMouse(masterEdisonLastWindow)
    }

    return edisonId
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

bringPianoRoll(focusNotes = True, moveMouse = True)
{
    WinGet, pianoRollId, ID, ahk_class TEventEditForm, Piano roll
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

bringPlaylist(moveMouse = True)
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



bringStepSeq(moveMouse = True)
{
    WinGet, stepSeqId, ID, ahk_class TStepSeqForm
    if (!stepSeqId or !isVisible(stepSeqId))
    {
        WinGet, currId, ID, A
        Send {F6}
        stepSeqId := waitNewWindowOfClass("TStepSeqForm", currId)
    }
    else
        WinActivate, ahk_id %stepSeqId%
    
    ;bringStepSeq(moveMouse)
    ;msgTip("est-ce que le win gui vole la classe de l'autre? c'est quoi le glitch?")
    if (moveMouse)
        centerMouse(stepSeqId)
        
    return stepSeqId
}

bringEventEditor(moveMouse = True)
{
    WinGet, eventEditorId, ID, Events -
    WinActivate, ahk_id %eventEditorId%
    if (moveMouse)
        centerMouse(eventEditorId)
    return eventEditorId
}

bringMainFLWindow()
{
    WinGet, id, ID, FL Studio 20 ahk_class TFruityLoopsMainForm
    WinActivate, ahk_id %id%
    return id    
}

bringFL()
{
    WinGet, exe, ProcessName, A
    if (exe != "FL64.exe")
        WinActivate, ahk_exe FL64.exe
}

isVisible(winId)
{
    WinGet, Style, Style, ahk_id %winId%
    Transform, res, BitAnd, %Style%, 0x10000000
    return res <> 0
}