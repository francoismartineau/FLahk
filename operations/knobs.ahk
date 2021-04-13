global knobValueSave


applyMinMaxLinkController()
{
    
    minMax := knobCopyMinMax()
    min := minMax[1]
    max := minMax[2]
    mult := max - min
    mult := Round(mult, 4)
    function = %min% {Shift Down}={Shift Up} Input {Shift Down}8{Shift Up} %mult%  
    linkKnob(function, True, False, 0, False)
}

knobSideChain()
{
    chooseLinkInitScrolls := -10
    function = 1-Input
    linkKnob(function, True, False, 0, True)
}

; ---------
knobResetVal()
{
    Click, Right
    Send {Down}{Enter}
}

knobSetSpeed()
{
    Click, Right
    Send {WheelDown}{WheelDown}{LButton}
    Random, n, 1, 10
    Loop, %n%
        Send {WheelDown}
}

setKnobValue(x, y, val, ctxMenuLen := "")
{
    MouseMove, %x%, %y%, 0
    Sleep, 20
    pasteKnob(False, val, ctxMenuLen)
    Sleep, 20
}


; -- set midi knob ------------------------
knobResetCtl()
{
    mouseCtlOutputMidi := False
    MouseGetPos, mX, mY, winId
    if (WinExist("A") != winId)
    {
        WinActivate, ahk_id %winId%
        MouseGetPos, mX, mY
    }
    WinGetPos, winX, winY,,, ahk_id %winId%
    res := openKnobCtxMenu(mX, mY, winX, winY, winId)
    movedWin := res[1]
    ctlWinId := clickLinkController()
    isLongLinkWin := checkIfLongLinkWindow()
    x := 64
    if (isLongLinkWin)
        y := 437
    else
        y := 389
    QuickClick(x, y)
    x := 249
    QuickClick(x, y)
    if (movedWin)
        WinMove, ahk_id %winID%,, %winX%, %winY%    
    mouseCtlOutputMidi := True
}

knobSetMouseCtl(whichCtl = "L")
{
    mouseCtlOutputMidi := False
    Switch whichCtl
    {
    Case "L":
        cc := mCtlCcL
    Case "R":
        cc := mCtlCcR
    }

    MouseGetPos, mX, mY, winId
    WinGetPos, winX, winY,,, ahk_id %winID%
    res := openKnobCtxMenu(mX, mY, winX, winY, winID)
    movedWin := res[1]
    openedCtxMenu := res[2]

    if (openedCtxMenu)
    {
        ctlWinId := clickLinkController()
        isLongLinkWin := checkIfLongLinkWindow()
        setCcInCtlWin(cc, isLongLinkWin)
        setChannelInCtlWin(mCtlChan, isLongLinkWin)
        setPortInCtlWin(1, isLongLinkWin)    
        acceptLink(isLongLinkWin, True)
    }

    if (movedWin)
        WinMove, ahk_id %winId%,, %winX%, %winY%
    mouseCtlOutputMidi := True
}

knobSetExternalCtl(knobX, knobY, cc, chan, port, needToInitialize := True, ccConflictIncr := "")
{
    moveMouse(knobX, knobY)
    WinGet, winId, ID, A
    WinGetPos, winX, winY,,, ahk_id %winId%
    res := openKnobCtxMenu(knobX, knobY, winX, winY, winId)
    movedWin := res[1]

    ctlWinId := clickLinkController()
    isLongLinkWin := checkIfLongLinkWindow()
    setCcInCtlWin(cc, isLongLinkWin)
    setChannelInCtlWin(chan, isLongLinkWin, needToInitialize)
    setPortInCtlWin(port, isLongLinkWin, needToInitialize)
    
    if (ccConflictIncr)
    {
        while (ctlWinConflict(isLongLinkWin))
        {
            cc := cc + ccConflictIncr
            if (cc + ccConflictIncr > 127)
            {
                cc := 1
                chan := chan + 1
                setChannelInCtlWin(chan, isLongLinkWin, needToInitialize)
            }
            setCcInCtlWin(cc, isLongLinkWin)
        }
    }
    
    acceptLink(isLongLinkWin, True)               ; Accept
    if (movedWin)
        WinMove, ahk_id %winID%,, %winX%, %winY%
    return [cc, chan]
}

setCcInCtlWin(cc, isLongLinkWin)
{
    if (isLongLinkWin)
        y := 99
    else
        y := 72
    x := 241
    QuickClick(241, y, "Right")
    Loop, 5
        Send {Down}
    Send {Enter}
    moveMouse(x, y)
    ;MouseMove, %x%, %y%, 0
    Loop, %cc%
    {
        Send {WheelUp}
        Sleep, 2
    }
}

setChannelInCtlWin(channel, isLongLinkWin, needToInitialize = True)
{
    if (isLongLinkWin)
        y := 99
    else
        y := 72  
    x := 157
    moveMouse(x, y)
    if (needToInitialize)
    {
        Loop, 16
            Send {WheelDown}
        Sleep, 20
    }

    n := channel - 1
    Loop, %n%
    {
        Send {WheelUp}
    }
}

setPortInCtlWin(port, isLongLinkWin, needToInitialize = True)
{
    if (isLongLinkWin)
        y := 99
    else
        y := 72  
    x := 63
    moveMouse(x, y)
    if (needToInitialize)
    {
        Loop, 10
        {
            Send {WheelDown}
        }
        Sleep, 20
    }

    n := port + 1
    Loop, %n%
    {
        Send {WheelUp}
        Sleep, 10
    }    
}

ctlWinConflict(isLongLinkWin)
{
    Sleep, 10
    if (isLongLinkWin)
        res := colorsMatch(230, 392, [0xBF3E35], 20)
    else
        res := colorsMatch(235, 359, [0xD03C22], 20)
    return res
}

; ---------
copyKnob(hint = True, cut = False)
{
    MouseGetPos, knobX, knobY, winId
    WinGetPos, winX, winY,,, ahk_id %winId%
    res := openKnobCtxMenu(knobX, knobY, winX, winY, winId)
    movedWin := res[1]
    openedCtxMenu := res[2]
    if (openedCtxMenu)
    {
        clipboardSave := clipboard
        clickCopy()
        knobValueSave := clipboard
        clipboard := clipboardSave

        if (cut)
        {
            moveMouse(knobX, knobY)
            Click, Right
            Send {Up}{Up}{Enter}0{Enter}
        }

        if (hint)
        {
            moveMouse(knobX, knobY)
            val := Round(knobValueSave, 2)
            ToolTip, %val%, %knobX%, %knobY%
            Sleep, 400
            ToolTip
        }
    }

    if (movedWin)
        WinMove, ahk_id %winId%,, %winX%, %winY%

    return knobValueSave    
}

cutKnob(hint = True)
{
    copyKnob(hint, True)
}

pasteKnob(hint = True, val = "", ctxMenuLen = "")
{
    if (val != "")
        knobValueSave := val
    MouseGetPos, knobX, knobY, winId
    WinGetPos, winX, winY,,, ahk_id %winId%
    clipboardSave := clipboard
    clipboard := knobValueSave
    res := openKnobCtxMenu(knobX, knobY, winX, winY, winId)
    movedWin := res[1]
    openedCtxMenu := res[2]
    if (openedCtxMenu)
    {
        if (val != "")
            knobValueSave := val
        clickPaste(ctxMenuLen)
        if (hint)
        {
            moveMouse(knobX, knobY)
            val := Round(knobValueSave, 2)
            ToolTip, %val%, %knobX%, %knobY%
            Sleep, 400
            ToolTip
        }   
    }
    clipboard := clipboardSave

    if (movedWin)
        WinMove, ahk_id %winId%,, %winX%, %winY%    
}


openKnobCtxMenu(knobX, knobY, winX, winY, winId)
{
    movedWin := moveKnobWinIfNecessary(knobX, knobY, winX, winY, winId)
    openedCtxMenu := False
    Click, Right
    if (waitCtxMenuUnderMouse())
    {
        activateKnobIfActivateCtxMenu(knobX, knobY)
        openedCtxMenu := True
    }
    return [movedWin, openedCtxMenu]
}

moveKnobWinIfNecessary(knobX, knobY, winX, winY, winId)
{
    global Mon1Top, Mon2Top
    movedWin := False
    x := knobX + winX
    y := knobY + winY
    if (x >= 0)
        top := Mon2Top
    if (x < 0)
        top := Mon1Top
    if (y > 680 + top)
    {
        dist := y - (680 + top)
        newWinY := winY - dist
        WinMove, ahk_id %winId%,, %winX%, %newWinY%
        moveMouse(knobX, knobY)
        movedWin := True
    }    
    return movedWin
}

activateKnobIfActivateCtxMenu(knobX, knobY)
{
    needToActivate := False
    cols := ctxMenuColors
    cols.Push(ctxMenuSepCol*)

    if (!colorsMatch(knobX+9, knobY+100, cols, 10))
        needToActivate := "smallMenu"
    else if (!colorsMatch(knobX+9, knobY+113, cols, 10))
        needToActivate := "longMenu"

    if (needToActivate)
    {
        Send {Down}{Down}
        if (needToActivate == "longMenu")
            Send {Down}
        Send {Enter}
        ;MouseMove, %knobX%, %knobY%, 0
        moveMouse(knobX, knobY)
        Click, Right
        waitCtxMenuUnderMouse()
    }
    return needToActivate
}

getRandomKnobVal()
{
    Random, val, 0, 127
    return val / 127
}