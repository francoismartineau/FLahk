


;;;;;;;;;;;;;
;;;; si key pressed, edit in Main Events



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