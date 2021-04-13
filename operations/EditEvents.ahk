


;;;;;;;;;;;;;
;;;; si key pressed, edit in Main Events

knobEditEvents(centerMouse = True)
{
    MouseGetPos, knobX, knobY, winId
    WinGetPos, winX, winY,,, ahk_id %winID%
    movedWin := openKnobCtxMenu(knobX, knobY, winX, winY, winID)[1]
    eventWinId := clickEditEvents(knobX, knobY, winID)
    if (eventWinId)
    {
        ;bringPlaylist(False)
        ;bringStepSeq(False)
        moveWinRightScreen(winId)
        WinActivate, ahk_id %winId%
        moveEventEditor(eventWinId)
        centerMouse(eventWinId)
    }
    if (movedWin)
        WinMove, ahk_id %winID%,, %winX%, %winY%
}

insertEditEventsValue()
{
    MouseGetPos, knobX, knobY, pluginId
    val := copyKnob(False)
    moveMouse(knobX, knobY)
    knobEditEvents()

    toolTip("Place mouse and Accept / Abort")
    unfreezeMouse()
    waitAcceptAbort(False)
    freezeMouse()
    toolTip()
    
    MouseGetPos, mx
    MouseMove, %mx%, 57, 0
    Send {CtrlDown}{LButton Down}
    MouseMove, 100, 0, 0, R
    Send {CtrlUp}{LButton Up}

    WinActivate, ahk_id %pluginId%
    moveMouse(knobX, knobY)
    pasteKnob(False, val)
    WinActivate, Events -

    Sleep, 100
    insertCurrentControllerValue()
    Sleep, 100
    Send {CtrlDown}d{CtrlUp}
    Sleep, 400
    retrieveMouse := True
}



ctxMenuEditEventsActivated(yr)
{
    MouseGetPos, x, y
    x := x + 10
    y := y + yr
    cols := [0x000000]
    return colorsMatch(x, y, cols, 10)
}