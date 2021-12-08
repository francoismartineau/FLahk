;p01_SamplerPatcher_compakt
global patcherSamplerDirectWavePos := [[786, 168], [780, 310]]
global patcherSamplerLfoOffset1Pos := [396, 430]
global patcherSamplerLfoOffset2Pos := [410, 506]
global patcherSamplerLfoLpPos := [465, 158]
global patcherSamplerLfoPitchPos := [467, 251]

createPatcherSampler(dragX, dragY, dragWin, inPatcher := False)
{
    if (inPatcher)
    {
        WinActivate, ahk_class TPluginForm
        mouseOverKnot := False
        unfreezeMouse()
        while (!mouseOverKnot)
        {
            toolTip("PatcherMap: place mouse on knot")        
            res := waitAcceptAbort()
            toolTip()
            if (res == "abort")
                return
            mouseOverKnot := mouseOverMidiKnot()
        }
        freezeMouse()
        MouseGetPos,,, patcherId
        if (!WinActive("ahk_id " patcherId))
            WinActivate, ahk_id %patcherId%        
        samplerId := patcherLoadPatcherSampler()
        movedSampler := moveWinIfOverPos(dragX, dragY, samplerId)
        dragDropPatcherSampler(samplerId, dragX, dragY, dragWin)
    }
    else
    {
        samplerId := loadInstr(1)
        WinMove, ahk_id %samplerId%,, 700, 200
        openPresetPlugin(1, samplerId)
        movedSampler := moveWinIfOverPos(dragX, dragY, samplerId)
        dragDropPatcherSampler(samplerId, dragX, dragY, dragWin)
        randomizeName(True, False, False, "Ps")
    }
    if (movedSampler)
        WinMove, ahk_id %samplerID%,, 700, 200
}

revealPatcherDirectWave(patcherId, samplerID, x, y)
{
    WinActivate, ahk_id %patcherId%
    moveMouse(x, y)                 ;; msgTip("over dw", 1000)
    Click, 2
    directwaveId := waitNewWindowTitled("PatcherDirectWave", samplerID)
    alwaysOnTop(directwaveId)
    ;WinMove, ahk_id %directwaveId%,, %x%, %y%
    Sleep, 50
	MouseClick, Left, 22, 475	                                            ; Sample
    Sleep, 100
    return directwaveId
}

dragDropPatcherDirectWaveSample(oriX, oriY, oriWin, patcherId, activateLoop = False)
{
    WinActivate, ahk_id %patcherId%

    mapSurfaceY := 88 - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    mapX := 71
    moveMouse(mapX, mapSurfaceY)
    Click

    for i, pos in patcherSamplerDirectWavePos {
        x := pos[1]
        y := pos[2] - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
        directwaveId := revealPatcherDirectWave(patcherId, samplerID, x, y)
        alwaysOnTop(directwaveId)
        WinActivate, ahk_id %oriWin%
        CoordMode, Mouse, Screen
        MouseMove, %oriX%, %oriY%
        
        toolTip("Click down")
        Click, down                     ;msgTip("click down", 1000)
        CoordMode, Mouse, Client

        WinActivate, ahk_id %directwaveId%
        moveMouse(118, 464)             ;;msgTip("over internal sample", 1000)
        Sleep, 50 
        toolTip("Click up")
        Click, up                       ; msgTip("click up", 1000)
        Sleep, 50 

        midiRequest("toggle_play_pause_twice")
        
        if (activateLoop)
        {
            moveMouse(456, 634)
            Click
            Send f
        }       
        WinClose, ahk_id %directwaveId%
        WinActivate, ahk_id %patcherId%
    }
    surfaceX := 129
    moveMouse(surfaceX, mapSurfaceY)
    Click
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
    return res
}

samplerLfoSetTime(whichLfo)
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
        x := patcherSamplerLfoOffset1Pos[1]
        y := patcherSamplerLfoOffset1Pos[2]
    Case "offset2":
        x := patcherSamplerLfoOffset2Pos[1]
        y := patcherSamplerLfoOffset2Pos[2]
    Case "lp":
        x := patcherSamplerLfoLpPos[1]
        y := patcherSamplerLfoLpPos[2]
    Case "pitch":
        x := patcherSamplerLfoPitchPos[1]
        y := patcherSamplerLfoPitchPos[2]
    }
    y := y - yOffsetWrapperPlugin*isWrapperPlugin(patcherId)
    moveMouse(x, y)
    msg("over?")
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
    setKnobValue(oriX, oriY-30, newVal, "patcher") 
}

/*
openSamplerLFOs()
{
    WinGet, samplerId, ID, A
    MouseMove, 72, 92, 0            ; Map
    Click               

    Send {AltDown}

    MouseMove, 395, 704, 0
    Click               
    offsetId := waitNewWindowOfClass("TWrapperPluginForm", samplerId)
    WinMove, ahk_id %offsetId%,, 188, 222
    WinActivate, ahk_id %samplerId%

    MouseMove, 377, 465, 0
    Click               
    lpId := waitNewWindowOfClass("TWrapperPluginForm", samplerId)
    WinMove, ahk_id %lpId%,, 188, 470
    WinActivate, ahk_id %samplerId%

    MouseMove, 390, 570, 0
    Click               
    pitchId := waitNewWindowOfClass("TWrapperPluginForm", samplerId)
    WinMove, ahk_id %pitchId%,, 188, 714
    WinActivate, ahk_id %samplerId%

    Send {AltUp}

    MouseMove, 128, 89              ; Surface
    Click            
    WinActivate, ahk_id %offsetId%
    centerMouse(offsetId)
}
*/

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
; --- 