global patcherSamplerDirectWavePos := [[1021, 169], [1018, 275], [1022, 389], [1024, 489], [1023, 581]]
global patcherSamplerLfoOffsetPos := [[234, 419], [231, 512]]
global patcherSamplerLfoLpPos := [416, 144]
global patcherSamplerLfoPitchPos := [419, 238]
global patcherSamplerLfoVolPos := [1166, 430]

createPatcherSampler(dragX, dragY, dragWin, inPatcher := False)
{
    name := "PS " randString(randInt(1, 4))
    samplerId := loadInstr(1, 1, name)
    if (!samplerId)
        return
    movedSampler := moveWinIfOverPos(dragX, dragY, samplerId)
    dragDropPatcherSampler(samplerId, dragX, dragY, dragWin)
    if (movedSampler)
        WinMove, ahk_id %samplerID%,, 700, 200
}

global draggedDropPatcherSamplerWorkedOnce := False
dragDropPatcherSampler(patcherId, oriX, oriY, oriWin, _ := "")
{
    n := patcherSamplerAskDirectWaveNum()
    if (n == "")
        return

    makeSureWinInMonitor(patcherId)
    mapSurfaceY := patcherActivateMap(patcherId)

    if (n > 1)
    {
        WinActivate, ahk_id %oriWin%
        moveMouse(oriX, oriY, "Screen")
        clearWayToMouse(oriWin, 400, 200)
        masterEdisonId := dragSampleToEdison(oriX, oriY)
    }

    
    i := 1
    while (i <= n)
    {
        dwPos := patcherSamplerDirectWavePos[i]
        x := dwPos[1]
        y := dwPos[2] - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
        directwaveId := revealPatcherDirectWave(patcherId, x, y)
        alwaysOnTop(directwaveId)
        
        if (n > 1)
        {
            WinActivate, ahk_id %masterEdisonId%
            leftEdisonSelect := masterEdisonSoundLeftX + Floor((masterEdisonSoundWidth/n) * (i-1))
            rightEdisonSelect := leftEdisonSelect + Floor(masterEdisonSoundWidth/n)
            moveMouse(leftEdisonSelect, 270)
            msg("left")
            Send {Ctrl Down}{LButton Down}
            moveMouse(rightEdisonSelect, 270)
            msg("right")
            Send {LButton Up}{Ctrl Up}
            moveToMasterEdisonDrag(False)
        }
        else if (n == 1)
        {
            WinActivate, ahk_id %oriWin%
            moveMouse(oriX, oriY, "Screen")
            clearWayToMouse(oriWin, 700, 200)
        }
        toolTip("Click down")
        Click, down   
        Sleep, 300 

        WinActivate, ahk_id %directwaveId%
        moveMouse(118, 464) 
        if (!draggedDropPatcherSamplerWorkedOnce)
            draggedDropPatcherSamplerWorkedOnceLoadAttempt()
        Click, up 
        toolTip("Click up")
        if (!draggedDropPatcherSamplerWorkedOnce)
            if (!draggedDropPatcherSamplerWorkedOncePromptUser())
                continue
        midiRequest("toggle_play_pause_twice")
        WinClose, ahk_id %directwaveId%
        WinActivate, ahk_id %patcherId%
        i += 1
    }
    surfaceX := 129
    moveMouse(surfaceX, mapSurfaceY)
    Click
    patcherSamplerSetKnobN(n, patcherId)
}

patcherSamplerAskDirectWaveNum()
{
    choices := range(patcherSamplerDirectWavePos.MaxIndex())
    n := toolTipChoice(choices, "DW Split:", 1)
    return n
}

revealPatcherDirectWave(patcherId, x, y)
{
    WinActivate, ahk_id %patcherId%
    moveMouse(x, y)                 ;; msgTip("over dw", 1000)
    Click, 2
    directwaveId := waitNewWindowTitled("PatcherDirectWave", patcherId)
    alwaysOnTop(directwaveId)
    ;WinMove, ahk_id %directwaveId%,, %x%, %y%
    Sleep, 50
	MouseClick, Left, 22, 475	                                            ; Sample
    Sleep, 100
    return directwaveId
}

hideInternalSampler(internalPluginId, samplerID)
{
    WinClose, ahk_id %internalPluginId%
    WinActivate, ahk_id %samplerID%
    surfaceY := 88 - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    moveMouse(110, surfaceY)
    Click
    Sleep, 50
}

patcherSamplerSetKnobN(n, patcherId := "")
{
    y := 158 - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    moveMouse(430, y)
    pasteKnob(True, n/10, "patcherSurface")
}

; --- Mouse Pos -----------------------------------
mouseOverSamplerLfoSpeedSet()
{
    res := False
    MouseGetPos,,, winId
    WinGet, activeWinId, ID, A
    if (winId != activeWinId)
        WinActivate, ahk_id %winId%
    MouseGetPos, mX, mY
    if (colorsMatch(mX, mY, [0xA7E2D8]))
        res := "offset1"
    else if (colorsMatch(mX, mY, [0x2F5C5D]))
        res := "offset2"
    else if (colorsMatch(mX, mY, [0x453D3B]))
        res := "lp"
    else if (colorsMatch(mX, mY, [0xA67F96]))
        res := "pitch"
    else if (colorsMatch(473, 459, [0x3F4B35]))
        res := "vol"
    return res
}

samplerLfoSetTime(whichLfo, whichSampler)
{
    WinGet, samplerId, ID, A
    MouseGetPos, oriX, oriY
    moveMouse(oriX, oriY-30)
    currVal := copyKnob(False)
    mapX := 72
    mapSurfaceY := 92 - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    moveMouse(mapX, mapSurfaceY)
    Click

    Switch whichLfo
    {
    Case "offset1":
        x := patcherSamplerLfoOffsetPos[1][1]
        y := patcherSamplerLfoOffsetPos[1][2]
    Case "offset2":
        x := patcherSamplerLfoOffsetPos[2][1]
        y := patcherSamplerLfoOffsetPos[2][2]
    Case "lp":
        Switch whichSampler
        {
        Case "patcherSampler":
            x := patcherSamplerLfoLpPos[1]
            y := patcherSamplerLfoLpPos[2]
        Case "patcherGrnl":
            x := patcherGrnlLfoLpPos[1]
            y := patcherGrnlLfoLpPos[2]
        }
    Case "pitch":
        Switch whichSampler
        {
        Case "patcherSampler":
            x := patcherSamplerLfoPitchPos[1]
            y := patcherSamplerLfoPitchPos[2]
        Case "patcherGrnl":
            x := patcherGrnlLfoPitchPos[1]
            y := patcherGrnlLfoPitchPos[2]
        }
    Case "vol":
        x := patcherSamplerLfoVolPos[1]
        y := patcherSamplerLfoVolPos[2]
    }
    y := y - yOffsetWrapperPlugin*isWrapperPlugin(patcherId)
    moveMouse(x, y)
    Click, 2

    lfoId := waitNewWindowOfClass("TWrapperPluginForm", samplerId)
    WinMove, ahk_id %lfoId%,, 188, 222
    WinActivate, ahk_id %lfoId%
    newVal := lfoSetTime("", False, currVal)
    WinClose, ahk_id %lfoId%
    WinActivate, ahk_id %samplerId%
    surfaceX := 128
    moveMouse(surfaceX, mapSurfaceY)
    Click    
    setKnobValue(oriX, oriY-30, newVal, "patcherSurface") 
}

mouseOverSamplerPatcherArp()
{
    MouseGetPos,,, winId
    res := False
    WinGet, activeWinId, ID, A
    if (winId != activeWinId)
        WinActivate, ahk_id %winId%
    MouseGetPos, mX, mY
    res := colorsMatch(mX, mY, [0xE2BEA7], 0)
    return res
}

mouseOverSamplerPatcherDel()
{
    MouseGetPos,,, winId
    res := False
    WinGet, activeWinId, ID, A
    if (winId != activeWinId)
        WinActivate, ahk_id %winId%
    MouseGetPos, mX, mY
    res := colorsMatch(mX, mY, [0xCEC2BB])
    return res
}

mouseOverNsetter()
{
    res := False
    
    MouseGetPos,,, winId    
    WinGet, activeWinId, ID, A
    if (winId != activeWinId)
        WinActivate, ahk_id %winId%
    
    MouseGetPos, mX, mY
    if (mX > 392 and mX <415)
    {
        cols := [0x60204E, 0x7F2D66]
        if (colorsMatch(mX, mY, cols))
        {
            if (mY < 159)
                res := 1
            else if (mY < 176)
                res := 2
            else if (mY < 193)
                res := 3
            else if (mY < 211)
                res := 4
            else
                res := 5
        }
    }
    return res    
}
; --- 