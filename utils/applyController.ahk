applyController(n, isInstr = False, autoChooseCtl = False, nRowsUnderWord = 0)
{
    ctlID := 
    MouseGetPos knobX, knobY, currWinID
    if (!WinActive(currWinID))
        WinActivate, ahk_id %currWinID%
    copyKnob(False)
    if (isInstr)
        ctlID := loadInstr(n)
    else
        ctlID := loadFx(n)

    if (ctlID)
    {
        WinActivate, ahk_id %currWinID%
        moveMouse(knobX, knobY)
        linkKnob(False, True, autoChooseCtl, nRowsUnderWord)
        WinActivate, ahk_id %ctlID%
    }
    return ctlID
}

linkControllerOnly()
{
    linkKnob()
}


;;;; fonction utilisée seuelement par les deux boutons c c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; faire des mod ici

linkKnob(function = False, autoClickAccept = True, autoChooseCtl = False, nRowsUnderWord = 0, chooseCtl = True)
{
    MouseGetPos, mouseX, mouseY, winId
    WinGetPos, winX, winY,,, ahk_id %winID%
    res := openKnobCtxMenu(mouseX, mouseY, winX, winY, winID)
    movedWin := res[1]
    openedCtxMenu := res[2]
    if (openedCtxMenu)
    {
        if (!linkControllerChecked())
            chooseCtl := True

        ctlWinId := clickLinkController()
        unfreezeMouse()
        if (WinActive("ahk_class TMIDIInputForm"))
        {
            isLongCtlWin := checkIfLongControllerWindow()
            if (chooseCtl)
            {
                clickControllerChoice(isLongCtlWin)
                chooseController(autoChooseCtl, nRowsUnderWord)
            }
            if (function)
                setLinkFunction(function, isLongCtlWin)
            ;WinActivate, ahk_class TMIDIInputForm
            ;Sleep, 50
            acceptLink(isLongCtlWin, autoClickAccept)
        }
    }
    if (movedWin)
        WinMove, ahk_id %winID%,, %winX%, %winY%
}

setLinkFunction(function, isLongCtlWin)
{
    if (isLongCtlWin)
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


;---------------------------------------------------------------------------------------------------------------
chooseController(autoChooseCtl = False, nRowsUnderWord = 0)
{
    if (!autoChooseCtl)
    {
        Send {WheelDown}{WheelUp}
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
        WinGetPos, winX, winY,,, ahk_class TMIDIInputForm
        Sleep, 500

        zoneX := 15
        zoneY := 159
        zoneW := 238
        zoneH := 600
        word := "AUTOLINK"

        toolTip("Reading the screen...")
        cmd := Format("python screen_reader.py {} {} {} {} {}", zoneX + winX, zoneY + winY, zoneW, zoneH, word)
        coords := SysCommand(cmd)
        toolTip()
        if (coords)
        {
            coords := StrSplit(coords, " ")
            x := coords[1]
            y := coords[2]
    
            newX := zoneX + x
            dropMenuRowH := 20
            newY := zoneY + y + dropMenuRowH * nRowsUnderWord
            MouseMove, %newX%, %newY%
            ;msgTip("word: " word, 5000)
            Click
        }      
    }
}


checkIfLongControllerWindow()
{
    cols:= [0x292E32]                         ; regarder si la box Link 1 existe
    x := 183
    y := 35
    colVar := 15
    hint := ""
    return colorsMatch(x,y,cols,colVar,hint)
}

clickControllerChoice(isLong)
{
    if (isLong)
        y := 200
    else
        y := 170
    ;MouseClick, Left, 200, %y%
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

