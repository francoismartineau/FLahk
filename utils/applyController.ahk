applyController(n, isInstr := False, autoChooseLink := False, nRowsUnderWord = 0)
{
    ctlID := 
    MouseGetPos knobX, knobY, currWinID
    if (!WinActive(currWinID))
        WinActivate, ahk_id %currWinID%
    if (isInstr)
        ctlID := loadInstr(n)
    else
        ctlID := loadFx(n)

    if (ctlID)
    {
        WinActivate, ahk_id %currWinID%
        moveMouse(knobX, knobY)
        setChooseLinkInitScrolls(n, isInstr)
        linkKnob(False, True, autoChooseLink, nRowsUnderWord)
        WinActivate, ahk_id %ctlID%
    }
    return ctlID
}

linkControllerOnly()
{
    linkKnob()
}

knobCopyMinMax()
{
    choices := ["max", "min"]
    choice := toolTipChoice(choices, "Set and accept:", randInt(1,2))
    if (choice != "")
    {
        saveMousePos()
        unfreezeMouse()
        toolTip("accept")
        res := waitAcceptAbort()
        if (res == "abort")
            return
        freezeMouse()
        initVal := copyKnob(False)
    
        retrieveMousePos()
        toolTip("Set " choices[1+(2-toolTipChoiceIndex)] " and accept")
        unfreezeMouse()
        res := waitAcceptAbort()
        if (res == "abort")
            return
        freezeMouse()

        retrieveMousePos()        
        secVal := copyKnob(False)
        retrieveMousePos()
        toolTip()
        Switch choice
        {
        Case "max":
            max := initVal
            min := secVal        
        Case "min":
            min := initVal
            max := secVal        
        }           

        return [min, max]      
    }
}

openLinkKnobWindow()
{
    MouseGetPos, knobX, knobY, pluginId
    WinGetPos, pluginX, pluginY,,, ahk_id %pluginId%
    ctxMenuLen := openKnobCtxMenu(knobX, knobY)
    if (ctxMenuLen != "")
    {
        linkWinId := clickLinkController(ctxMenuLen)
        moveMouse(46, 424)
    }
}

activateRemoveConflicts()
{
    activated := colorsMatch(254, 392, [0xF4AB87])
    if (!activated)
        QuickClick(252, 390)
}

setLinkFunction(function, isLongLinkWin)
{
    if (isLongLinkWin)
        y := 281
    else
        y := 251
    MouseClick, Left, 111, %y%
    Send {Ctrl Down}a{Ctrl Up}
    Send {Backspace}
    Send %function%{Enter}
    Sleep, 200
}

movePluginWindowIfNecessary(knobY, title)
{
    if (knobY > 670)
    {
        knobY := 670
        WinGetPos, winX, winY,,, title
        toMove := knobY - 670
        newWinY := winY - toMove
        WinMove, title,,, newWinY
    }
    return knobY
}

linkKnobToNextMidiInput()
{
    MouseGetPos, knobX, knobY, pluginId
    WinGetPos, pluginX, pluginY,,, ahk_id %pluginId%
    ctxMenuLen := openKnobCtxMenu(knobX, knobY)
    if (ctxMenuLen != "")
        clickLinkController(ctxMenuLen)
    retrieveWinPos(winX, winY, winId)
}

;---------------------------------------------------------------------------------------------------------------
global chooseLinkInitScrolls := 0
setChooseLinkInitScrolls(n, isInstr = False)
{
    Switch n . isInstr
    {
    Case "21":          ; enVC
        chooseLinkInitScrolls := 8
    Case "40":          ; lfo
        chooseLinkInitScrolls := 1
    Default:
        chooseLinkInitScrolls := 0
    }
}

chooseLink(autoChooseLink := False, nRowsUnderWord := 0)
{
    res := ""
    if (!autoChooseLink)
    {
        MouseMove, 0, 20, 0, R
        MouseMove, 0, -20, 0, R
        if (chooseLinkInitScrolls < 0)
            wheel := "WheelDown"
        else if (chooseLinkInitScrolls > 0)
            wheel := "WheelUp"
        chooseLinkInitScrolls :=  Abs(chooseLinkInitScrolls) 
        Loop %chooseLinkInitScrolls%
        {
            Sleep, 1
            Send {%wheel%}
        }
        chooseLinkInitScrolls := 0
        clickAlsoAccepts := True
        res := waitAcceptAbort(False)
        if (res == "accept")
            Click
        else
            WinClose, A
        Sleep, 100
    }
    else
    {
        MouseGetPos, mX,, winId
        WinGetPos,, winY,,, ahk_id %winId%
        x := 273    ; rel to window, last square of name
        y := 564    ; rel to window, after template controllers
        if (mx >= 0)
            bottom := Mon2Bottom
        else
            bottom := Mon1Bottom
        h := bottom - winY - y
        incr := 7
        cols := [0xc0c5c9, 0x94999d]
        colVar := 0
        mY := scanColorsDown(x, y, h, cols, incr)
        moveMouse(mX, mY)
        Loop, %nRowsUnderWord%
            Send {Down}
        Send {Enter}   
    }
    return res
}


checkIfLongLinkWindow()
{
    ; premier pixel ^< du drop down en haut (couleur background du drop down) si longWin
    ; si shortWin, c'est une couleur différente
    x := 9
    y := 31
    i := 0
    while (!(isLongLinkWin or isShortLinkWin))
    {
        isLongLinkWin := colorsMatch(x, y, [0x2d3236])
        isShortLinkWin := colorsMatch(x, y, [0x363f45])
        Sleep, 10
        i += 1
        if (i > 10)
            msg("can't know linkWin length. You might want to reset")
    }
    return isLongLinkWin
}

clickLinkChoice(isLong)
{
    if (isLong)
        y := 200
    else
        y := 170
    moveMouse(200, y)
    Click
}

acceptLink(isLong, autoClickAccept = True)
{
    if (isLong)
        y := 430
    else
        y := 400
    moveMouse(230, y)
    if (autoClickAccept)
        Click
    else
    {
        clickAlsoAccepts := True
        res := waitAcceptAbort(False)
        if (res == "accept")
            Click
        else
            WinClose, A
    }
}

