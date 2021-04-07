createPatcherSampler(oriX, oriY, oriWin)
{
    samplerId := loadInstr(1)
    WinMove, ahk_id %samplerId%,, 700, 200
    openPresetPlugin(1, samplerId)
    movedSampler := moveWinIfOverPos(oriX, oriY, samplerId)
    dragDropPatcherSampler(samplerId, oriX, oriY, oriWin)

    if (movedSampler)
        WinMove, ahk_id %samplerID%,, 700, 200
    randomizeName(True, False, False, "Sp")
}

revealPatcherDirectWave(samplerID)
{
    Click, 71, 92 	                                                        ; Map
	Click, 589, 216, 2                                                      ; open DirectWave
    directwaveId := waitNewWindowTitled("PatcherDirectWave", samplerID)
    WinMove, ahk_id %directwaveId%,, 700, 200
    Sleep, 50
	MouseClick, Left, 22, 475	                                            ; Sample
    Sleep, 100
    return directwaveId
}

dragDropPatcherDirectWaveSample(oriX, oriY, oriWin, directwaveId)
{
    WinActivate, ahk_id %oriWin%
    CoordMode, Mouse, Screen
    MouseMove, %oriX%, %oriY%
    toolTip("Click down")
    Click, down                     ;msgTip("click down", 3000)
    CoordMode, Mouse, Client

    WinActivate, ahk_id %directwaveId%
    moveMouse(118, 464)             ;;msgTip("over internal sample", 3000)
    toolTip("Click down")
    
    Sleep, 30 
    toolTip("Click up")
    Click, up                       ; msgTip("click up", 3000)
    midiRequest("toggle_play_pause_twice")
}

hideInternalSampler(internalPluginId, samplerID)
{
    WinClose, ahk_id %internalPluginId%
    WinActivate, ahk_id %samplerID%
    Sleep, 50
	MouseClick, Left, 129, 88	    ; Surface
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
    MouseMove, 72, 92, 0                    ; Map
    Click

    Switch whichLfo
    {
    Case "offset1":
        MouseMove, 395, 704, 0
    Case "offset2":
        MouseMove, 417, 792, 0
    Case "lp":
        MouseMove, 452, 470, 0
    Case "pitch":
        MouseMove, 437, 573, 0
    }
    Click, 2

    lfoId := waitNewWindowOfClass("TWrapperPluginForm", samplerId)
    WinMove, ahk_id %lfoId%,, 188, 222
    WinActivate, ahk_id %lfoId%
    knobVal := lfoSetTime()
    WinClose, ahk_id %lfoId%
    WinActivate, ahk_id %samplerId%
    MouseMove, 128, 89                      ; Surface
    Click    
    setKnobValue(oriX, oriY-30, knobVal, "patcher") 
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