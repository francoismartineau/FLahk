global percEnvDirectWavePos := [[225, 501], [223, 586], [224, 698]]
global percEnvEnvcPos := [[605, 220], [609, 303], [606, 385]]

makeSureWinIsPercEnv(winId)
{
    Sleep, 300
    restoreWin(winId)
    if (isPatcherMap(winId))
    {
        patcherActivateSurface(winId)
        Sleep, 300
    }
    if (isPercEnv(winId))
        percEnvId := winId
    else
        percEnvId := ""
    return percEnvId
}

dragDropPercEnv(dragX, dragY, dragWin)
{
    percEnvId := bringPercEnv()
    if (!percEnvId)
    {
        msg("Couldn't bring PercEnv")
        return
    }
    WinMove, ahk_id %percEnvId%,, 700, 200
    movedSampler := moveWinIfOverPos(dragX, dragY, samplerId)
    n := percEnvAskN()
    if (n == "")
        return
    patcherActivateMap(percEnvId)

    dwX := percEnvDirectWavePos[n][1]
    dwY := percEnvDirectWavePos[n][2] ;- isWrapperPlugin(percEnvId)*yOffsetWrapperPlugin
    dwId := revealPatcherDirectWave(percEnvId, dwX, dwY)

    WinActivate, ahk_id %dragWin%
    moveMouse(dragX, dragY, "Screen")
    Click, down
    Sleep, 300
    WinActivate, ahk_id %dwId%
    moveMouse(118, 464)
    if (!draggedDropPatcherSamplerWorkedOnce)
        draggedDropPatcherSamplerWorkedOnceLoadAttempt()
    Click, up 
    toolTip("Click up")

    midiRequest("toggle_play_pause_twice")
    directWaveActivateLoop(True)
    WinClose, ahk_id %dwId%
    WinActivate, ahk_id %percEnvId%
    patcherActivateSurface(percEnvId)

    if (movedSampler)
        WinMove, ahk_id %percEnvId%,, 700, 200    
}

percEnvAskN()
{
    choices := range(percEnvDirectWavePos.MaxIndex())
    n := toolTipChoice(choices, "DW n:", 1)
    return n    
}
; -----------------------------------
;envcActivateArticulator(n)

; -- Show plugins -------------------
mouseOverPercEnvShowPlugin()
{
    res := False
    winId := mouseGetPos(mX, mY)
    if (isPercEnv(winId))
        res := colorsMatch(mX, mY, [0xB449B6])
    return res
}

percEnvShowPlugin()
{
    pervEncId := mouseGetPos(mX, mY)
    ctlType := percEnvIsSurfaceShowControllerX(mX)
    if (ctlType == "")
    {
        msg("Cannot determine PercEnv ctl type. Wrong mouse X?")
        return
    }
    articulator := {"amp": 1, "lp": 2}[ctlType]

    pad := percEnvIsSurfaceShowControllerY(mY)
    if (pad == "")
    {
        msg("Cannot determine PercEnv ctl type. Wrong mouse Y?")
        return
    }

    patcherActivateMap(pervEncId)
    envcX := percEnvEnvcPos[pad][1]
    envcY := percEnvEnvcPos[pad][2]
    moveMouse(envcX, envcY)
    Click, 2
    envcId := waitNewWindowOfClass("TWrapperPluginForm", pervEncId)
    WinActivate, ahk_id %pervEncId%
    patcherActivateSurface(pervEncId)
    WinMove, ahk_id %envcId%,, 188, 222
    WinActivate, ahk_id %envcId%
    envcActivateArticulator(articulator)
    centerMouse(envcId)
}

percEnvIsSurfaceShowControllerX(x)
{
    res := ""
    if (x > 120 and x < 155)
        res := "amp"
    else if (x > 194 and x < 259)
        res := "lp"
    return res
}

percEnvIsSurfaceShowControllerY(y)
{
    res := ""
    if (y > 241 and y < 269)
        res := 1
    else if (y > 309 and y < 336)
        res := 2
    else if (y > 377 and y < 403)
        res := 3
    return res
}


; ----
