newAutomation()
{
    MouseGetPos, knobX, knobY, pluginId
    if (WinExist("A") != winId)
        WinActivate, ahk_id %winId%
    
    minMax := knobCopyMinMax()
    pluginName := copyName()
    
    bringPlaylist(False)
    timeSelEndX := waitForUserToMakeTimeSelection()
    if (knobCreateAutomation(knobX, knobY, pluginId))
    {
        saveKnobPos(knobX, knobY, pluginId)
        autwinId := bringAutomationWindow()
        registerWinToHistory(autwinId, "plugin")     ; to customize autom ( user can press tab to bring back autom)
        pasteColor()
        adjustAutomation(autwinId, minMax)
        autName := copyName()
        autName := makeControllerName("autom", pluginName, "", autName)
        rename(autName)
        bringPlaylist(False)
        moveMouse(timeSelEndX-30, 60)
        retrieveMouse = False
    }
}

knobCreateAutomation(knobX, knobY, pluginId)
{
    WinActivate, ahk_id %pluginId%
    WinGetPos, pluginX, pluginY,,, ahk_id %pluginId%
    MouseMove, %knobX%, %knobY%    
    res := openKnobCtxMenu(knobX, knobY, pluginX, pluginY, pluginId)
    movedWin := res[1]
    openedCtxMenu := res[2]
    if (openedCtxMenu)
    {    
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
        MouseMove, 28, %y% ,, R                                       
        Click
    }
    if (movedWin)
        WinMove, ahk_id %pluginId%,, %pluginX%, %pluginY%       
    return openedCtxMenu
}

bringAutomationWindow()
{
    ssId := bringStepSeq(False)
    WinGetPos,,,, h, ahk_id %ssId%
    lastPluginY := h - 60
    Sleep, 100
    moveMouse(147, lastPluginY)
    autwinId := openChannelUnderMouse()
    Sleep, 500
    return autwinId
}

adjustAutomation(autwinId, minMax)
{
    min := minMax[1]
    max := minMax[2]
    ;pasteName()

    WinGetPos, winX, winY,,, ahk_id %autwinId%
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

makeControllerName(prefix, oriPluginName, suffix = "", autoAutomationName = "")
{
    pluginName := StrSplit(oriPluginName, " ")[1]
    if (autoAutomationName)
    {
        autoAutomationName := StrSplit(autoAutomationName, " ")
        suffix := autoAutomationName[autoAutomationName.MaxIndex()]
    }
    return prefix " " pluginName " " suffix
}
