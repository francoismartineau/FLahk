
createPatcherSlicex(dragX, dragY, dragWin, inPatcher := False)
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
        samplerId := patcherLoadPatcherSlicex()
        dragDropPatcherSampler(samplerId, dragX, dragY, dragWin)
        movedSampler := moveWinIfOverPos(dragX, dragY, samplerId)
    }
    else
    {
        samplerId := loadPatcherSlicex(False)
        WinMove, ahk_id %samplerId%,, 700, 200
        movedSampler := moveWinIfOverPos(dragX, dragY, samplerId)
        dragDropPatcherSlicex(samplerId, dragX, dragY, dragWin)
        randomizeName(True, False, False, "Slcx")
    }
    if (movedSampler)
        WinMove, ahk_id %samplerId%,, 700, 200    
}

global slicexMapX := 269
global slicexMapY := 156

revealInternalSlicex(samplerID)
{
    mapSurfaceY := 88 - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    mapX := 71
    moveMouse(mapX, mapSurfaceY)
    Click

    localSlicexMapY := slicexMapY - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    moveMouse(slicexMapX, localSlicexMapY)
    SendInput !{LButton}
    slicexId := waitNewWindowTitled("slicex", samplerID)
    alwaysOnTop(slicexId)
    WinMove, ahk_id %slicexId%,, 700, 200
    return slicexId
}

dragDropSlicexSample(oriX, oriY, oriWin, slicexId)
{
    WinActivate, ahk_id %oriWin%
    CoordMode, Mouse, Screen
    MouseMove, %oriX%, %oriY%
    toolTip("drag & drop")
    Click, down
    CoordMode, Mouse, Client    

    WinActivate, ahk_id %slicexId%
    WinMove, ahk_id %slicexId%,, 376, 184
    moveMouse(324, 472)
    msgTip("drop sample", 200)
    Click, up
    Sleep, 50
    midiRequest("toggle_play_pause_twice")
    QuickClick(618, 344)        ; auto slice
}

patcherSlicexRelDisable()
{
    patcherSlicexRel(True)
}

patcherSlicexRel(disable = False)
{
    WinGet, samplerID, ID, A
    slicexId := revealInternalSlicex(samplerID)
    if (!slicexId)
        return
    Sleep, 10
    MouseMove, 540, 337, 0
    Send {LButton}

    Sleep, 10
    Send {WheelUp}
    Sleep, 10
    Send {WheelUp}

    Sleep, 10
    Send {Enter}

    Sleep, 10
    Send {WheelDown}   
    Sleep, 10
    Send {WheelDown}

    Sleep, 10
    Send {Enter}

    dialogId := waitNewWindowOfClass("TScriptDialog", slicexId)
    Sleep, 10
    if (disable)
    {
        MouseMove, 181, 155, 0
        Send {WheelDown}
        Sleep, 50
    }
    QuickClick(421, 198)    ; run
    hideInternalSampler(slicexId, samplerID)
}

patcherSlicexFilterType()
{
    WinGet, samplerID, ID, A
    slicexId := revealInternalSlicex(samplerID)
    if (!slicexId)
        return
    MouseMove, 290, 221, 0
    toolTip("set filter type")
    waitAcceptAbort(False, False)
    toolTip()
    hideInternalSampler(slicexId, samplerID)
}

; -- Mouse pos ---------------------------------------
mouseOverPatcherSlicexArp()
{
    MouseGetPos,,, winId214
    res := False
    WinGet, activeWinId, ID, A
    if (winId != activeWinId)
        WinActivate, ahk_id %winId%
    MouseGetPos, mX, mY
    res := colorsMatch(mX, mY, [0xE2BFA7])
    return res
}

mouseOverPatcherSlicexDel()
{
    MouseGetPos,,, winId
    res := False
    WinGet, activeWinId, ID, A
    if (winId != activeWinId)
        WinActivate, ahk_id %winId%
    MouseGetPos, mX, mY
    res := colorsMatch(mX, mY, [0xCEC3BB])
    return res
}

mouseOverPatcherSlicexRel()
{
    MouseGetPos,,, winId
    res := False
    WinGet, activeWinId, ID, A
    if (winId != activeWinId)
        WinActivate, ahk_id %winId%
    MouseGetPos, mX, mY
    res := mx < 91 and colorsMatch(mX, mY, [0x7BBD8D])
    return res
}

mouseOverPatcherSlicexRelDisable()
{
    MouseGetPos,,, winId
    res := False
    WinGet, activeWinId, ID, A
    if (winId != activeWinId)
        WinActivate, ahk_id %winId%
    MouseGetPos, mX, mY
    res := mx > 91 and colorsMatch(mX, mY, [0x7BBD8D])
    return res
}

mouseOnpatcherSlicexFilterType()
{
    MouseGetPos,,, winId
    res := False
    WinGet, activeWinId, ID, A
    if (winId != activeWinId)
        WinActivate, ahk_id %winId%
    MouseGetPos, mX, mY
    res := colorsMatch(mX, mY, [0x743347])
    return res    
}