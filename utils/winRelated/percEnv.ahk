


Class PercEnv
{
; -- Win -----
    static winId := 
    confirmWin(winId)
    {
        Sleep, 300
        restoreWin(winId)
        if (isPatcherMap(winId))
        {
            patcherActivateSurface(winId)
            Sleep, 300
        }
        if (isPercEnv(winId))
            PercEnv.winId := winId
        return PercEnv.winId
    }   
; --
; -- Samples ----- 
    static directWavePos := [[500, 501], [500, 586], [500, 698]]
    static envCpos := [[600, 199], [600, 295], [600, 385]]
    dragDrop(dragX, dragY, dragWin)
    {
        percEnvId := StepSeq.bringKnownChannel("PercEnv")
        if (!PercEnv.confirmWin(percEnvId))
        {
            msg("Couldn't bring PercEnv")
            return
        }
        WinMove, ahk_id %percEnvId%,, 700, 200
        movedSampler := moveWinIfOverPos(dragX, dragY, samplerId)
        n := PercEnv.__askN()
        if (n == "")
            return
        patcherActivateMap(percEnvId)

        dwX := PercEnv.directWavePos[n][1]
        dwY := PercEnv.directWavePos[n][2] ;- isWrapperPlugin(percEnvId)*yOffsetWrapperPlugin
        dwId := revealPatcherDirectWave(percEnvId, dwX, dwY)

        WinActivate, ahk_id %dragWin%
        moveMouse(dragX, dragY, "Screen")
        Click, down
        Sleep, 300
        WinActivate, ahk_id %dwId%
        moveMouse(118, 464)
        if (!draggedDropPatcherSamplerWorkedOnce)
            draggedDropPatcherSamplerWorkedOnceLoadAttempt()
        Click, up 
        toolTip("Click up")

        midiRequest("toggle_play_pause_twice")
        directWaveActivateLoop(True)
        WinClose, ahk_id %dwId%
        WinActivate, ahk_id %percEnvId%
        patcherActivateSurface(percEnvId)

        if (movedSampler)
            WinMove, ahk_id %percEnvId%,, 700, 200    
    }   
    __askN()
    {
        choices := range(PercEnv.directWavePos.MaxIndex())
        n := toolTipChoice(choices, "DW n:", 1)
        return n    
    }     
; -- Plugins -----
    static lfoPos := [348, 672]
    mouseOverShowEnvC()
    {
        success := False
        winId := mouseGetPos(mX, mY)
        if (isPercEnv(winId))
            success := colorsMatch(mX, mY, [0xB449B6])
        return success
    }
    showEnvC()
    {
        pervEncId := mouseGetPos(mX, mY)
        ctlType := PercEnv.__isEnvCTypeX(mX)
        if (ctlType == "")
        {
            msg("Cannot determine PercEnv ctl type. Wrong mouse X?")
            return
        }
        articulator := {"amp": 1, "lp": 2}[ctlType]

        pad := PercEnv.__isEnvCTypeY(mY)
        if (pad == "")
        {
            msg("Cannot determine PercEnv ctl type. Wrong mouse Y?")
            return
        }

        patcherActivateMap(pervEncId)
        envcX := PercEnv.envCpos[pad][1]
        envcY := PercEnv.envCpos[pad][2]
        moveMouse(envcX, envcY)
        SendInput !{LButton}
        envcId := waitNewWindowOfClass("TWrapperPluginForm", pervEncId)
        WinActivate, ahk_id %pervEncId%
        patcherActivateSurface(pervEncId)
        WinMove, ahk_id %envcId%,, 188, 222
        WinActivate, ahk_id %envcId%
        envcActivateArticulator(articulator)
        centerMouse(envcId)
    }
    __isEnvCTypeX(x)
    {
        res := ""
        if (x > 120 and x < 155)
            res := "amp"
        else if (x > 194 and x < 259)
            res := "lp"
        return res
    }
    __isEnvCTypeY(y)
    {
        res := ""
        if (y > 241 and y < 269)
            res := 1
        else if (y > 309 and y < 336)
            res := 2
        else if (y > 377 and y < 403)
            res := 3
        return res
    }
    mouseOverLfoSpeedSet()
    {
        success := False
        winId := mouseGetPos(mX, mY)
        if (isPercEnv(winId))
            success := colorsMatch(mX, mY, [0xD92628])
        return success        
    }    
    lfoSetSpeed()
    {
        percEnvId := PercEnv.winId
        currVal := PercEnv.__lfoCopyCurrKnobVal()
        patcherActivateMap(percEnvId)
        newVal := PercEnv.__lfoSetLfo(currVal)
        patcherActivateSurface(percEnvId)
        PercEnv.__lfoPasteNewKnobVal(newVal)
    }
    __lfoSetLfo(currVal)
    {
        lfoX := PercEnv.lfoPos[1]
        lfoY := PercEnv.lfoPos[2]
        moveMouse(lfoX, lfoY)
        SendInput !{LButton}
        lfoId := waitNewWindowOfClass("TWrapperPluginForm", percEnvId)
        WinMove, ahk_id %lfoId%,, 188, 222
        WinActivate, ahk_id %lfoId%
        newVal := lfoSetTime("", False, currVal)
        WinClose, ahk_id %lfoId%
        return newVal
    }
    __lfoCopyCurrKnobVal()
    {
        MouseMove, 0, -30, 0, R
        saveMousePos()
        currVal := Knob.copy(False)
        return currVal
    }
    __lfoPasteNewKnobVal(newVal)
    {
        retrieveMousePos()
        Knob.paste(False, newVal, "patcherSurface")

    }
; -- 
}





; -----------------------------------
;envcActivateArticulator(n)

; -- Show plugins -------------------








; ----
