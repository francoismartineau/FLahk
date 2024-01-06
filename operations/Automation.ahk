
Class Automation
{
    makeTimeSel(ByRef timeSelEndX, ByRef timeSelEndY)
    {
        success := False
        Playlist.bringWin(False)
        timelineStart := 541
        mouseGetPos(mX, _, "Screen")
        if (mX < timelineStart)
            mX := timelineStart
        moveMouse(mX, 137, "Screen")
        res := waitToolTip("Make a time selection and accept")
        if (res)
        {
            success := True
            mouseGetPos(timeSelEndX, timeSelEndY, "Screen")
        }
        return success
    }
    bringFreshWin()
    {
        ssId := StepSeq.bringWin(False, False)
        WinGetPos,,,, ssH, ahk_id %ssId%
        lastPluginY := ssH - 60
        Sleep, 100
        moveMouse(147, lastPluginY)
        autwinId := StepSeq.bringChanUnderMouse()
        registerWinToHistory(autwinId, "plugin")     ; to customize autom ( user can press tab to bring back autom)        
        Sleep, 500
        return autwinId 
    }
    set(values, pluginName)
    {
        pasteColor()
        min := values[1]
        max := values[2]
        Knob.setVal(384, 45, min, "normal")
        Knob.setVal(417, 45, max, "normal")

        autName := copyName()
        autName := makeControllerName("autom", pluginName, "", autName)
        rename(autName)        
    }
    moveMouseToTimeSel(timeSelEndX, timeSelEndY)  
    {
        Playlist.bringWin(False)
        moveMouse(timeSelEndX-30, timeSelEndY, "Screen")
        retrieveMouse := False
    }
    __bringBackKnob(knobX, knobY, pluginId)
    {
        success := False
        if (!winExists(pluginId))
        {
            res := waitToolTip("Bring back plugin and accept", True)
            if (!res)
            {
                msg("Can't continue creating automation")
                return success
            }
            WinGet, pluginId, ID, A
        }
        WinActivate, ahk_id %pluginId%
        moveMouse(knobX, knobY)
        success := True
        return success
    }
}