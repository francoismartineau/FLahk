Autom()
{
    MouseGetPos, knobX, knobY, pluginId
    if (pluginId != WinExist("A"))
        WinActivate, ahk_id %pluginId%
    
    minMax := knobCopyMinMax()
    if (minMax.MaxIndex() != 2)
        return
        
    pluginName := copyName()

    bringPlaylist(False)
    waitForUserToMakeTimeSelection(automX, automY)
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
        moveMouse(automX-30, automY, "Screen")
        retrieveMouse = False
    }
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
    pluginName := StrSplit(oriPluginName, " ")[1]
    if (autoAutomationName)
    {
        autoAutomationName := StrSplit(autoAutomationName, " ")
        suffix := autoAutomationName[autoAutomationName.MaxIndex()]
    }
    return prefix " " pluginName " " suffix
}
