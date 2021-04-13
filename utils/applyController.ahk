applyController(n, isInstr = False, autoChooseLink = False, nRowsUnderWord = 0)
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
    operationHotKey := StrSplit(A_ThisHotkey, A_Space)[1]
    choices := ["max", "min"]
    choice := toolTipChoice(choices, "Curr value is:", randInt(1,2))
    if (choice != "")
    {
        saveMousePos()
        initVal := copyKnob(False)
        retrieveMousePos()
        
        toolTip("Set " choices[1+(2-toolTipChoiceIndex)] " and press hotkey again")
        unfreezeMouse()

        KeyWait, %operationHotKey%, D
        KeyWait, %operationHotKey%

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

linkKnob(function = False, autoClickAccept = True, autoChooseLink = False, nRowsUnderWord = 0, chooseCtl = True)
{
    MouseGetPos, knobX, knobY, pluginId
    WinGetPos, pluginX, pluginY,,, ahk_id %pluginId%
    res := openKnobCtxMenu(knobX, knobY, pluginX, pluginY, pluginId)
    movedWin := res[1]
    openedCtxMenu := res[2]
    if (openedCtxMenu)
    {
        saveKnobPos(knobX, knobY, pluginId)
        if (!linkControllerChecked())
            chooseCtl := True

        clickLinkController()
        unfreezeMouse()
        if (WinActive("ahk_class TMIDIInputForm"))
        {
            isLongLinkWin := checkIfLongLinkWindow()
            if (chooseCtl)
            {
                clickLinkChoice(isLongLinkWin)
                chooseLink(autoChooseLink, nRowsUnderWord)
            }
            if (function)
                setLinkFunction(function, isLongLinkWin)
            ;WinActivate, ahk_class TMIDIInputForm
            ;Sleep, 50
            acceptLink(isLongLinkWin, autoClickAccept)
        }
    }
    if (movedWin)
        WinMove, ahk_id %pluginId%,, %winX%, %winY%
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

chooseLink(autoChooseLink = False, nRowsUnderWord = 0)
{
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


checkIfLongLinkWindow()
{
    cols:= [0x292E32]                         ; regarder si la box Link 1 existe
    x := 183
    y := 35
    colVar := 15
    hint := ""
    return colorsMatch(x,y,cols,colVar,hint)
}

clickLinkChoice(isLong)
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

