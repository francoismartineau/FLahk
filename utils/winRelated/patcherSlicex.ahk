
 createPatcherSlicex(oriX, oriY, oriWin)
{
    samplerId := loadPatcherSlicex(False)
    WinMove, ahk_id %samplerId%,, 700, 200
    movedSampler := moveWinIfOverPos(oriX, oriY, samplerId)
    dragDropPatcherSlicex(samplerId, oriX, oriY, oriWin)

    if (movedSampler)
        WinMove, ahk_id %samplerId%,, 700, 200
    randomizeName(True, False, False, "Slcx")
}


revealInternalSlicex(samplerID)
{
    Click, 71, 92 	                                                        ; Map
    Click, 341, 139, 2                                                      ; open Slicex   
    slicexId := waitNewWindowTitled("slicex", samplerID)
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
    moveMouse(303, 461)
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