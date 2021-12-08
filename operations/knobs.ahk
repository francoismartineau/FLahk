global knobValueSave

; -- Main -------
knobEditEvents(centerMouse = True)
{
    MouseGetPos, mX, mY, winId
    WinGetPos, winX, winY,,, ahk_id %winId%
    ctxMenuLen := openKnobCtxMenu(mX, mY)
    eventWinId := clickEditEvents(ctxMenuLen)
    if (eventWinId)
    {
        ;bringPlaylist(False)
        ;bringStepSeq(False)
        moveWinRightScreen(winId)
        WinActivate, ahk_id %winId%
        moveEventEditor(eventWinId)
        centerMouse(eventWinId)
    }
    retrieveWinPos(winX, winY, winId)
}

knobCreateAutomation(knobX, knobY, pluginId)
{
    WinActivate, ahk_id %pluginId%
    WinGetPos, pluginX, pluginY,,, ahk_id %pluginId%
    MouseMove, %knobX%, %knobY%    
    ctxMenuLen := openKnobCtxMenu(knobX, knobY)
    if (ctxMenuLen)
        clickCreateAutomation(ctxMenuLen)
    retrieveWinPos(winX, winY, winId)
    return ctxMenuLen != ""
}

linkKnob(function := False, autoClickAccept := True, autoChooseLink := False, nRowsUnderWord := 0, chooseCtl := True, ctlDropDown := True, removeConflicts := False)
{
    MouseGetPos, mX, mY, pluginId
    WinGetPos, winX, winY,,, ahk_id %pluginId%
    ctxMenuLen := openKnobCtxMenu(mX, mY)

    if (ctxMenuLen)
    {
        saveKnobPos(mX, mY, pluginId)
        if (!linkControllerChecked(ctxMenuLen))
        {
            msg("No ctl active, choose one for min max")
            chooseCtl := True
        }

        linkWinId := clickLinkController(ctxMenuLen)
        if (linkWinId)
        {
            isLongLinkWin := checkIfLongLinkWindow()
            if (chooseCtl and ctlDropDown)
            {
                clickLinkChoice(isLongLinkWin)
                res := chooseLink(autoChooseLink, nRowsUnderWord)
                if (res == "abort")
                    return

            }
            if (function)
                setLinkFunction(function, isLongLinkWin)

            if (removeConflicts)
                activateRemoveConflicts()
            acceptLink(isLongLinkWin, autoClickAccept)
        }
    }
    retrieveWinPos(winX, winY, winId)
}

copyKnob(hint = True, cut = False)
{
    ;colorsMatchDebug := True
    MouseGetPos, knobX, knobY, winId
    WinGetPos, winX, winY,,, ahk_id %winId%
    ctxMenuLen := openKnobCtxMenu(knobX, knobY) ;, winX, winY, winId)
    if (ctxMenuLen)
    {
        clipboardSave := clipboard
        clickCopy(ctxMenuLen)
        Sleep, 100
        knobValueSave := clipboard
        clipboard := clipboardSave

        if (cut)
        {
            moveMouse(knobX, knobY)
            Click, Right
            Send r                           ; reset knob
            ;Send {Up}{Up}{Enter}0{Enter}    ; "type in" 0
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

    retrieveWinPos(winX, winY, winId)
    colorsMatchDebug := False

    return knobValueSave    
}

cutKnob(hint = True)
{
    copyKnob(hint, True)
}

pasteKnob(hint := True, val := "", ctxMenuLen := "")
{
    if (val != "")
        knobValueSave := val
    MouseGetPos, mX, mY, winId
    WinGetPos, winX, winY,,, ahk_id %winId%
    clipboardSave := clipboard
    clipboard := knobValueSave
    ctxMenuLen := openKnobCtxMenu(mX, mY)
    if (ctxMenuLen)
    {
        if (val != "")
            knobValueSave := val
        res := clickPaste(ctxMenuLen)
        if (!res)
            msg("couldn't paste")
        if (hint)
        {
            moveMouse(mX, mY)
            val := Round(knobValueSave, 2)
            ToolTip, %val%, %mX%, %mY%
            Sleep, 400
            ToolTip
        }   
    }
    clipboard := clipboardSave

    retrieveWinPos(winX, winY, winId)   
    return res
}

knobResetVal()
{
    ; wont work if activate ctx menu
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
; ----

; -- Link transfer functions ----
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
; ----



; -- set midi knob ------------------------
knobNextMidiKeyboardCcCtl()
{
    linkKnob(False, False, False, 0, False, False, True)
}

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
    ctxMenuLen := openKnobCtxMenu(mX, mY) ;, winX, winY, winId)
    ctlWinId := clickLinkController(ctxMenuLen)
    isLongLinkWin := checkIfLongLinkWindow()
    x := 64
    if (isLongLinkWin)
        y := 437
    else
        y := 389
    QuickClick(x, y)
    x := 249
    QuickClick(x, y)
    retrieveWinPos(winX, winY, winId)    
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
    ctxMenuLen := openKnobCtxMenu(mX, mY) ;, winX, winY, winID)

    if (ctxMenuLen != "")
    {
        ctlWinId := clickLinkController(ctxMenuLen)
        isLongLinkWin := checkIfLongLinkWindow()
        setCcInCtlWin(cc, isLongLinkWin)
        setChannelInCtlWin(mCtlChan, isLongLinkWin)
        setPortInCtlWin(1, isLongLinkWin)    
        acceptLink(isLongLinkWin, True)
    }

    retrieveWinPos(winX, winY, winId)
    mouseCtlOutputMidi := True
}

knobSetExternalCtl(knobX, knobY, cc, chan, port, needToInitialize := True, ccConflictIncr := "")
{
    moveMouse(knobX, knobY)
    WinGet, winId, ID, A
    WinGetPos, winX, winY,,, ahk_id %winId%
    ctxMenuLen := openKnobCtxMenu(knobX, knobY) ;, winX, winY, winId)
    if (ctxMenuLen != "")
    {
        ctlWinId := clickLinkController(ctxMenuLen)
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
        acceptLink(isLongLinkWin, True) 
    }

    retrieveWinPos(winX, winY, winId)
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
; ----