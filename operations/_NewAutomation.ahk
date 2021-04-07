newAutomation()
{
    MouseGetPos, mouseX, mouseY, winId
    if (WinExist("A") != winId)
        WinActivate, ahk_id %winId%
    
    minMax := newControllerCopyMinMax()
    copyName()
    
    
    bringPlaylist(True)
    waitForUserToMakeTimeSelection()
    freezeMouse()


    WinActivate, ahk_id %winId%
    MouseMove, %mouseX%, %mouseY%
    WinGetPos, winX, winY,,, ahk_id %winID%
    res := openKnobCtxMenu(mouseX, mouseY, winX, winY, winID)
    movedWin := res[1]
    waitCtxMenuUnderMouse()
    ctxMenuLen := getKnobCtxMenuLength()
    Switch ctxMenuLen
    {
    Case "patcherTimeRelated":
        y := 197
    Case "patcher":
        y := 178
    Case "timeRelated":
        y := 169
    Case "other":
        y := 149
    }
    MouseMove, 28, %y% ,, R                                         ; Create new Automation
    Click

    autWinID := bringAutomationWindow()
    ;msgTip("automation window in front? id: " autWinID, 3000)
    Sleep, 500
    adjustAutomation(autWinID, minMax)
    return
    pasteName("autom", False)
    waitAcceptAbort(True)
    bringPlaylist(True)
    retrieveMouse = False
    if (movedWin)
        WinMove, ahk_id %winID%,, %winX%, %winY%    
}

newControllerCopyMinMax()
{
    key := StrSplit(A_ThisHotkey, A_Space)[1]
    Tooltip, set max and press again
    saveMousePos()
    unfreezeMouse()
    KeyWait, %key%, D 
    KeyWait, %key%
    ToolTip
    freezeMouse()
    max := copyKnob(False)
    retrieveMousePos()
    Tooltip

    Tooltip, set min and press again
    saveMousePos()
    unfreezeMouse()
    KeyWait, %key%, D 
    KeyWait, %key%
    ToolTip
    freezeMouse()
    min := copyKnob(False)
    retrieveMousePos()
    Tooltip

    return [min, max]
}

bringAutomationWindow()
{
    WinActivate, ahk_class TStepSeqForm
    WinGetPos,,,, h, ahk_class TStepSeqForm
    WinGet, stepSeqID, ID, A
    moveWinLeftScreen(stepSeqID)
    y := h - 60
    Sleep, 100
    MouseClick, Left, 147, %y%
    id := waitNewWindowOfClass("TPluginForm", stepSeqID)
    return id
}

adjustAutomation(autWinID, minMax)
{
    min := minMax[1]
    max := minMax[2]
    ;pasteName()

    WinGetPos, winX, winY,,, ahk_id %autWinID%
    moveMouse(winX, winY, "Screen")
    ;msgTip("Mouse at aut window    X: " winX "  Y: " winY)
    setKnobValue(384, 45, min, "other")
    ;MouseMove,                  ; Min
    ;pasteKnob(False)
    setKnobValue(417, 45, max, "other")
    
    
    ;MouseMove, 417, 45                  ; Max
    ;pasteKnob(False)
    ;MouseClick, Left, 20, 88            ; LFO
}

