mouseOverDelBTurnOffWetVols()
{
    MouseGetPos, mx, mY, winId
    return isDelB(winId) and colorsMatch(mx, mY, [0xDBADD6])
}

delBTurnOffWetVols()
{
    Knob.setVal(268, 152, 0)
    Knob.setVal(279, 246, 0)
    Knob.setVal(278, 352, 0)
    Knob.setVal(278, 449, 0)
    Knob.setVal(277, 532, 0)
}

; ----------------------------
mouseOverDelBSetTime()
{
    MouseGetPos, mx, mY, winId
    return isDelB(winId) and colorsMatch(mx, mY, [0x3F2A7D])
}

delBSetTime()
{
    MouseGetPos, mX, mY, delbId
    if (113 < mY and mY < 202)
        pos := "1"
    else if (202 < mY and mY < 300)
        pos := "2"
    else if (300 < mY and mY < 403)
        pos := "3"
    else if (403 < mY and mY < 491)
        pos := "4"
    else if (491 < mY)
        pos := "5"

    quickClick(68, 45)       ; Map

    Send {AltDown}
    Switch pos
    {
    Case "1":
        quickClick(312, 144)
    Case "2":
        quickClick(309, 209)
    Case "3":
        quickClick(309, 265)
    Case "4":
        quickClick(318, 329)
    Case "5":
        quickClick(314, 381)
    }
    Send {AltUp}

    delayId := waitNewWindowOfClass("TWrapperPluginForm", delbId)
    knobVal := delaySetTime()
    /*
    WinMove, ahk_id %delayId%,, -1781, 770
    quickClick(104, 87, "Right")
    Send {Down}{Down}{Right}
    Random, n, 1, 13
    Loop, %n%
        Send {Down}

    unfreezeMouse()
    toolTip("set speed and accept/abort")
    clickAlsoAccepts := True
    res := waitAcceptAbort(True)
    if (res == "accept")
    */
        WinClose, ahk_id %delayId%
    ;toolTip()
    ;freezeMouse()

    WinActivate, ahk_id %delbId%
    quickClick(130, 43)       ; Surface
    MouseMove, %mX%, %mY%, 0
    Knob.paste(False, knobVal)
}