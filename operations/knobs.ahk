global knobValueSave


applyMinMaxLinkController(key = "")
{
    
    if (key == "")
        key := StrSplit(A_ThisHotkey, A_Space)[1]

    Tooltip, set min and press again
    unfreezeMouse()
    KeyWait, %key%, D 
    KeyWait, %key%
    freezeMouse()
    saveMousePos()
    min := copyKnob(False)
    retrieveMousePos()
    Tooltip


    Tooltip, set max and press again
    unfreezeMouse()
    KeyWait, %key%, D 
    KeyWait, %key%
    ToolTip
    freezeMouse()
    saveMousePos()
    max := copyKnob(False)
    retrieveMousePos()
    Tooltip

    mult := max - min
    mult := Round(mult, 4)
    function = %min% {Shift Down}={Shift Up} Input {Shift Down}8{Shift Up} %mult%
/*
link min max

.si pas crochet Link to controller, il faut dérouler le menu des controles
 et faire un choix. (accept abort, mouse frozen). Sinon, on skip le choix.
Accept Abort sur [Accept] pour pouvoir replacer la souris

*/    
    linkKnob(function, True, False, 0, False)
}

; ---------
resetKnob()
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

setKnobValue(x, y, val, ctxMenuLen = "")
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
    MouseGetPos, mouseX, mouseY, winId
    if (WinExist("A") != winId)
    {
        WinActivate, ahk_id %winId%
        MouseGetPos, mouseX, mouseY
    }
    WinGetPos, winX, winY,,, ahk_id %winID%
    res := openKnobCtxMenu(mouseX, mouseY, winX, winY, winID)
    movedWin := res[1]
    ctlWinId := clickLinkController()
    isLongCtlWin := checkIfLongControllerWindow()
    x := 64
    if (isLongCtlWin)
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

    MouseGetPos, mouseX, mouseY, winId
    WinGetPos, winX, winY,,, ahk_id %winID%
    res := openKnobCtxMenu(mouseX, mouseY, winX, winY, winID)
    movedWin := res[1]

    ctlWinId := clickLinkController()
    isLongCtlWin := checkIfLongControllerWindow()
    setCcInCtlWin(cc, isLongCtlWin)
    setChannelInCtlWin(mCtlChan, isLongCtlWin)
    setPortInCtlWin(1, isLongCtlWin)    
    acceptLink(isLongCtlWin, True)

    if (movedWin)
        WinMove, ahk_id %winID%,, %winX%, %winY%
    mouseCtlOutputMidi := True
}

knobSetExternalCtl(x, y, cc, chan, port, needToInitialize = True, ccConflictIncr = "")
{
    MouseMove, %x%, %y%, 0
    WinGet, winID, ID, A
    WinGetPos, winX, winY,,, ahk_id %winID%
    res := openKnobCtxMenu(x, y, winX, winY, winID)
    movedWin := res[1]

    ctlWinId := clickLinkController()
    isLongCtlWin := checkIfLongControllerWindow()
    setCcInCtlWin(cc, isLongCtlWin)
    setChannelInCtlWin(chan, isLongCtlWin, needToInitialize)
    setPortInCtlWin(port, isLongCtlWin, needToInitialize)
    
    if (ccConflictIncr)
    {
        while (ctlWinConflict(isLongCtlWin))
        {
            cc := cc + ccConflictIncr
            if (cc + ccConflictIncr > 127)
            {
                cc := 1
                chan := chan + 1
                setChannelInCtlWin(chan, isLongCtlWin, needToInitialize)
            }
            setCcInCtlWin(cc, isLongCtlWin)
        }
    }
    
    acceptLink(isLongCtlWin, True)               ; Accept
    if (movedWin)
        WinMove, ahk_id %winID%,, %winX%, %winY%
    return [cc, chan]
}

setCcInCtlWin(cc, isLongCtlWin)
{
    if (isLongCtlWin)
        y := 99
    else
        y := 72
    x := 241
    QuickClick(241, y, "Right")
    Loop, 5
        Send {Down}
    Send {Enter}
    MouseMove, %x%, %y%, 0
    Loop, %cc%
    {
        Send {WheelUp}
        Sleep, 2
    }
}

setChannelInCtlWin(channel, isLongCtlWin, needToInitialize = True)
{
    if (isLongCtlWin)
        y := 99
    else
        y := 72  
    x := 157
    MouseMove, %x%, %y%, 0
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

setPortInCtlWin(port, isLongCtlWin, needToInitialize = True)
{
    if (isLongCtlWin)
        y := 99
    else
        y := 72  
    x := 63
    MouseMove, %x%, %y%, 0
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

ctlWinConflict(isLongCtlWin)
{
    Sleep, 10
    if (isLongCtlWin)
        res := colorsMatch(230, 392, [0xBF3E35], 20)
    else
        res := colorsMatch(235, 359, [0xD03C22], 20)
    return res
}

; ---------
copyKnob(hint = True, cut = False)
{
    MouseGetPos, knobX, knobY, winId
    WinGetPos, winX, winY,,, ahk_id %winID%
    res := openKnobCtxMenu(knobX, knobY, winX, winY, winID)
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
        WinMove, ahk_id %winID%,, %winX%, %winY%

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
    WinGetPos, winX, winY,,, ahk_id %winID%
    clipboardSave := clipboard
    clipboard := knobValueSave
    res := openKnobCtxMenu(knobX, knobY, winX, winY, winID)
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
        WinMove, ahk_id %winID%,, %winX%, %winY%    
}


openKnobCtxMenu(knobX, knobY, winX, winY, winID)
{
    movedWin := moveKnobWinIfNecessary(knobX, knobY, winX, winY, winID)
    openedCtxMenu := False
    Click, Right
    if (waitCtxMenuUnderMouse())
    {
        activateKnobIfActivateCtxMenu(knobX, knobY)
        openedCtxMenu := True
    }
    return [movedWin, openedCtxMenu]
}

moveKnobWinIfNecessary(knobX, knobY, winX, winY, winID)
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
        WinMove, ahk_id %winID%,, %winX%, %newWinY%
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