global patcherGrnlDirectWavePos := [[778, 151], [784, 289]]
global patcherGrnlLfoLpPos := [464, 150]
global patcherGrnlLfoPitchPos := [457, 226]

createPatcherGrnl(dragX, dragY, dragWin, inPatcher := False)
{
    name := "Grnl " randString(randInt(1, 4))
    samplerId := loadInstr(1, 3, name)
    if (!samplerId)
        return
    movedSampler := moveWinIfOverPos(dragX, dragY, samplerId)
    dragDropAnyPatcherSampler(dragX, dragY, dragWin, samplerId)
    if (movedSampler)
        WinMove, ahk_id %samplerId%,, 700, 200      
}

dragDropPatcherGrnl(patcherId, oriX, oriY, oriWin)
{
    WinActivate, ahk_id %patcherId%
    makeSureWinInMonitor(patcherId)

    mapSurfaceY := 88 - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    mapX := 71
    moveMouse(mapX, mapSurfaceY)
    Click

    for i, pos in patcherGrnlDirectWavePos
    {
        x := pos[1]
        y := pos[2] - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
        directwaveId := revealPatcherDirectWave(patcherId, x, y)
        alwaysOnTop(directwaveId)
        WinActivate, ahk_id %oriWin%

        CoordMode, Mouse, Screen
        MouseMove, %oriX%, %oriY%
        clearWayToMouse(oriWin, 400, 200)
        toolTip("Click down")
        Click, down                     
        CoordMode, Mouse, Client

        WinActivate, ahk_id %directwaveId%
        moveMouse(118, 464)            
        Sleep, 50 
        toolTip("Click up")
        Click, up
        Sleep, 50 

        midiRequest("toggle_play_pause_twice")
        
        directWaveActivateLoop()

        WinClose, ahk_id %directwaveId%
        WinActivate, ahk_id %patcherId%
    }
    surfaceX := 129
    moveMouse(surfaceX, mapSurfaceY)
    Click
}

directWaveActivateLoop(maximizeLoopEnd := False)
{
    moveMouse(456, 634)
    Click
    Send f
    if (maximizeLoopEnd)
    {
        moveMouse(383, 627)
        Click, down
        MouseMove, 0, -2200 , 10, R
        Click, up
    }
}