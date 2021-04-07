global stepSeqSepX := 281
global channelHeight := 30
global selectedChanColors := [0xA8E44A, 0xFFBC40]


; -- wheel -----------------
global timeSinceScrollStepSeq
moveMouseToSelY()
{
    y := getFirstSelChannelY() + 10
    MouseMove, 220, %y%
}

getFirstSelChannelY(firstChannY = 50)
{
    WinGetPos,,,, ssH, A
    x := 283
    h := ssH - firstChannY
    return scanColorDown(x, firstChannY, h, selectedChanColors, 30, channelHeight, "")
}

channelAtYIsSelected(y)
{
    x := 280
    res := colorsMatch(x, y, selectedChanColors, 30)
    return res
}

changeInstrGroup(dir)
{
    if (dir == "left")
        Send {PgUp}
    else if (dir == "right")
        Send {PgDn}
}

; -- mouse pos --------------
selectOnlyChannelUnderMouse()
{
    toolTip("Release shift")
    waitForModifierKeys()
    toolTip()
    MouseGetPos,, y
    isAlreadySel := colorsMatch(stepSeqSepX-1, y, selectedChanColors, 0, "")
    MouseMove, stepSeqSepX, %y%, 0

    if (keyIsDown("Shift"))
        Send {ShiftUp}

    Send {CtrlDown}
    if (isAlreadySel)
        Click, Right
    Click
    Send {CtrlUp}
}

selectChannelUnderMouse()
{
    bringStepSeq(False)
    MouseGetPos,, y
    isAlreadySel := colorsMatch(stepSeqSepX-1, y, selectedChanColors, 0, "")
    MouseMove, stepSeqSepX, %y%, 0
    if (isAlreadySel)
        Click, Right    
    Click
}

unselChannelUnderMouse()
{
    bringStepSeq(False)
    MouseGetPos,, y
    isAlreadySel := colorsMatch(stepSeqSepX-1, y, selectedChanColors, 0, "")
    MouseMove, stepSeqSepX, %y%, 0
    if (isAlreadySel)
        Click, Right    
}

mouseOverStepSeqInstrOrScore()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY, winID
    CoordMode, Mouse, Client
    if (isStepSeq(winId))
    {
        WinGetPos, winX, winY, winW, winH, ahk_id %winID%
        mouseX := mouseX - winX
        mouseY := mouseY - winY  
        res :=  100 < mouseX and mouseX < winW and 50 < mouseY and mouseY < winH - 45    
    }
    return res 
}

mouseOverStepSeqInstruments()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY, winID
    CoordMode, Mouse, Client
    WinGetTitle, title, ahk_id %winID%
    if (isStepSeq(winID))
    {
        WinGetPos, winX, winY,,winH, ahk_id %winID%
        mouseX := mouseX - winX
        mouseY := mouseY - winY    
        res := 105 < mouseX and mouseX < stepSeqSepX-11 and 50 < mouseY and mouseY < winH-45
    }
    return res
}

mouseOverStepSeqMixerInserts()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mx, my, winID
    CoordMode, Mouse, Client
    if (isStepSeq(winID))
    {
        WinGetPos, winX, winY,,winH, ahk_id %winID%
        mx := mx - winX
        my := my - winY
        res := mx < 98 and 68 < mx and my < winH-51 and 53 < my
    }
    return res
}

mouseOverStepSeqLoop()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mx, my, winID
    CoordMode, Mouse, Client
    if (isStepSeq(winID))
    {
        WinGetPos, winX, winY, winW ,winH, ahk_id %winID%
        mx := mx - winX
        my := my - winY
        res := winW-66 < mx and mx < winW-28 and my < winH-51 and 53 < my
    }    
    return res
}

; -- Separator -------------
adjustStepSeqSep(stepSeqId = "")
{
    if (!stepSeqId)
        stepSeqId := bringStepSeq(False)
    else
        WinActivate, ahk_id %stepSeqId%
    Sleep, 500  ; step seq activation color fondue

    y := 13                     ; si pas sel, si mouse over
    currSepX := locateStepSeqSep(y)
    if (currSepX and currSepX != stepSeqSepX)
    {
        MouseMove, %currSepX%, %y%
        Click, Down
        MouseMove, %stepSeqSepX%, %y%
        Click, Up
    }
}

locateStepSeqSep(y)
{
    cols := [0x837E75]
    colVar := 0
    if (!colorsMatch(stepSeqSepX+3, y, cols, colVar, ""))
    {
        startX := 178
        w := 200
        incr := 1
        x := scanColorRight(startX, y, w, cols, colVar, incr, "searching separator")
        if (!x)
            msgTip("fail")
    }
    else
    {
        msgTip("Step Seq separator is fine.")
    }
    return x
}

; -- Clipboard -------------
copyChannelNotes()
{
    selectChannelUnderMouse()
    Send {CtrlDown}c{CtrlUp}
}

cutChannelNotes()
{
    selectChannelUnderMouse()
    Send {CtrlDown}x{CtrlUp}
}

pasteChannelNotes()
{
    selectChannelUnderMouse()
    Send {CtrlDown}v{CtrlUp}
}


; -- Channels ----------------
openChannelUnderMouse()
{
    WinGet, id, ID, A
    closeFirst := channelUnderMouseAlreadyOpen()
    if (closeFirst)
        Send {LButton}
    SendInput {AltDown}{LButton}{AltUp}
    pluginId := waitNewWindowOfClass("TPluginForm", id)
    centerMouse(pluginId)
}

channelUnderMouseAlreadyOpen()
{
    CoordMode, Mouse, Screen
    CoordMode, Pixel, Screen
    MouseGetPos,, mY
    WinGetPos, winX, winY,,, ahk_class TStepSeqForm
    mY := mY - winY
    channH := 30
    firstChannelPixel := 51
    
    channelUnderMousePixel := winY + (Floor((my - firstChannelPixel) / channH) * 30) + firstChannelPixel
    channelUnderMousePixel2 := channelUnderMousePixel + 2
    xPixel := winX + 115

    PixelGetColor, col1, %xPixel%, %channelUnderMousePixel% , RGB
    PixelGetColor, col2, %xPixel%, %channelUnderMousePixel2% , RGB
    CoordMode, Pixel, Relative
    CoordMode, Mouse, Relative
    return col1 < col2
}

lockWithTypingKeyboard()
{
    Click, Right
    Send {Up}{Up}{Up}{Right}{Down}{Enter}
}

scrollChannels(dir)
{
    MouseGetPos,, mY
    WinGet, stepSeqId, ID, ahk_class TStepSeqForm
    WinGetPos,,,, winH, ahk_id %stepSeqId%
    firstChannY := 77
    lastChannY := winH - 63
    chanH := 30
    numChannels := Floor(winH-126) / chanH + 1
    nth := findClosestChannel(mY, numChannels, firstChannY, lastChannY)

    if (dir == "up")
        nth := nth - 1
    else if (dir == "down")
        nth := nth + 1


    if (nth < 1)
        nth := numChannels
    else if (nth > numChannels)
        nth := 1

    y := (nth-1) * 30 + 62
    MouseMove, 190, %y%, 0



    ;;;; selectChannelUnderMouse() ?
    ;isAlreadySel := channelAtYIsSelected(y)
    ;if (isAlreadySel)
    ;    Send {ShiftDown}{LButton}{ShiftUp}
    ;Send {LButton}
}


findClosestChannel(mY, numChannels, firstChannY, lastChannY)
{
    nth := 1
    chanH := 30
    if (mY > lastChannY)
        nth := numChannels
    else                        
    {
        y := firstChannY
        while (mY > y)              ; in between
        {
            y := y + chanH
            nth := nth + 1
        }
    }
    return nth
}

/*
openSelectedChannel(stepSeqId = "")
{
    if (!stepSeqId)
        WinGet, stepSeqId, ID, A
    closeAllWinHistory(False)

    y := getFirstSelChannelY()
    x := 185

    WinActivate, ahk_id %stepSeqId%
    Click, %x%, %y%
    pluginId := waitNewWindowOfClass("TPluginForm", stepSeqId, 100)
    if (!pluginId)
    {
        Click, %x%, %y%
        pluginId := waitNewWindowOfClass("TPluginForm", stepSeqId, 1000)
    }    
    registerWinToHistory(pluginId)
    toolTip()
    centerMouse(pluginId)
}
*/

openChannelUnderMouseInPianoRoll(centerM = True)
{
    WinClose, Piano roll - ahk_class TEventEditForm
    WinGet, id, ID, A
    Send {RButton}{WheelDown}{LButton}
    pianoRollId := waitNewWindowOfClass("TEventEditForm", id, 100)
    if (centerM)
        centerMouse(pianoRollId)
}

openMixerInsert()
{
    mixerId := bringMixer(False)
    centerMouse(mixerId)
}

; -- Split Pattern -------
splitPattern()
{
    Send {CtrlDown}x{CtrlUp}
    insertPattern(True)
    res := waitAcceptAbort(True, True)
    if (res == "abort")
    {
        WinGet, id, ID, A
        deletePattern()
        waitNewWindowOfClass("TMsgForm", id)
        Send {Enter}
        bringStepSeq(False)
    }
    Send {CtrlDown}v{CtrlUp}
    ;trouver les channels sélectionnés
    ;selChannelsY := findSelectedChannelsY()

    ;for i, y in selChannelsY
    ;{
    ;    MouseMove, 280, %y%
    ;    msgTip("sel?")
    ;}
    ;copy first     copyChannelNotes()
    ;insert pattern (wait for name)
    ;paste first
    ; Loop, n-1
    ;   prev pattern
    ;   copy i
    ;   next pattern
    ;   paste i
}

findSelectedChannelsY()
{
    selChannelsY := []
    y := getFirstSelChannelY()
    while (y != "")
    {
        selChannelsY.Push(y)
        y := getFirstSelChannelY(y+channelHeight)
    }
    return selChannelsY
}