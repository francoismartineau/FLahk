Class Knob
{
; -- Set -----
    resetVal()
    {
        Click, Right
        Send r
    }    
    setVal(x, y, val, ctxMenuLen := "")
    {
        moveMouse(x, y)
        Sleep, 20
        Knob.paste(False, val, ctxMenuLen)
        Sleep, 20
    }  
; --    
; -- Automation -----
    createAutomation()
    {
        Knob.__getPos(pluginId, knobX, knobY)
        saveWinPos(pluginId)
        pluginName := copyName(pluginId)

        values := Knob.copyMinMax()
        if (!values)
            return

        Automation.makeTimeSel(timeSelEndX, timeSelEndY)
        Knob.__retrievePos(pluginId, knobX, knobY)

        res := CtxMenu.createAutomation()
        if (!res)
            return

        res := Automation.bringFreshWin()
        if (!res)
            return
        Automation.set(values, pluginName)
        Automation.moveMouseToTimeSel(timeSelEndX, timeSelEndY)
    }
    editEvents()
    {
        activateWinUnderMouse()
        winId := mouseGetPos(mX, mY)
        saveWinPos(winId)
        eventWinId := CtxMenu.editEvents()
        if (eventWinId)
        {
            ;Playlist.bringWin(False)
            ;StepSeq.bringWin(False)
            MoveWin.switchMon("right", winId)
            moveEventEditor(eventWinId)
            centerMouse(eventWinId)
            registerWinToHistory(eventWinId, "mainWin")
        }
        retrieveWinPos(winId)
    }
; --
; -- Min Max -----
    copyMinMax()
    {
        values := ""
        choices := ["max", "min"]
        choice := toolTipChoice(choices, "Set and accept:", randInt(1,2))
        if (choice != "")
        {
            saveMousePos()
            initVal := Knob.__copyMinMaxGetInitVal()
            if (initVal == "")
                return

            retrieveMousePos(True)
            notChoice := choices[1+(2-toolTipChoiceIndex)]
            secVal := Knob.__copyMinMaxGetSecVal(notChoice)
            if (secVal == "")
                return     

            values := Knob.__copyMinMaxGetValues(choice, initVal, secVal)
            retrieveMousePos()
        }
        return values
    }
    __copyMinMaxGetInitVal()
    {
        initVal := ""
        res := waitToolTip("accept")
        if (res)
        {
            retrieveMousePos(True)
            initVal := Knob.copy(False)
        }
        return initVal
    }
    __copyMinMaxGetSecVal(notChoice)
    {
        secVal := ""
        res := waitToolTip("Set " notChoice " and accept")
        if (res)
        {
            retrieveMousePos(True)
            secVal := Knob.copy(False)
        }
        return secVal
    }
    __copyMinMaxGetValues(choice, initVal, secVal)
    {
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
; --
; -- Clipboard -----
    static savedValue := ""
    copy(hint := True, cut := False)
    {
        activateWinUnderMouse()
        winId := mouseGetPos(knobX, knobY)
        saveWinPos(winId)

        clipboard := ""
        Sleep, 10
        success := CtxMenu.copy()
        if (!success)
        {
            msg("Couldn't click copy")
            return            
        }
        Sleep, 10
        ClipWait, 2
        if ErrorLevel
        {
            msg("couldn't copy val to clipboard")
            return
        }
        Knob.savedValue := clipboard
        if (cut)
        {
            moveMouse(knobX, knobY)
            Knob.resetVal()
        }
        if (success and hint)
            Knob.__clipboardHint(knobX, knobY)

        retrieveWinPos(winId)
        return Knob.savedValue    
    }
    cut(hint := True)
    {
        Knob.copy(hint, True)
    }   
    paste(hint := True, val := "", ctxMenuLen := "")
    {
        if (val != "")
            Knob.savedValue := val
        activateWinUnderMouse()
        winId := mouseGetPos(mX, mY)
        saveWinPos(winId)
        clipboard := Knob.savedValue
        success := CtxMenu.paste(ctxMenuLen)
        if (success and hint)
            Knob.__clipboardHint(mX, mY)
        retrieveWinPos(winId)   
        return success
    }     
    __clipboardHint(mX, mY)
    {
        moveMouse(mX, mY)
        val := Round(Knob.savedValue, 2)
        msg(val, 400)
    }
; --
; -- Link -----
    pickLink()
    {
        params := {"autoAccept": True, "pickCtl": True, "rmConflict": False}
        Knob.link(params)
    }
    linkApplyMinMax()
    {
        
        values := Knob.copyMinMax()
        min := values[1]
        max := values[2]
        mult := max - min
        mult := Round(mult, 4)
        function := min " + Input * " mult
        params := {"function": function, "autoAccept": True}
        Knob.link(params)
    }    
    linkSideChain()
    {
        chooseLinkInitScrolls := -10
        function := "1-Input"
        params := {"pickCtl": True, "function": function, "autoAccept": True}
        Knob.link(params)
    }    
    openLinkWin()
    {
        activateWinUnderMouse()
        pluginId := mouseGetPos(knobX, knobY)
        saveWinPos(pluginId)
        linkWinId := CtxMenu.linkToController()
        if (linkWinId)
        {
            moveMouse(46, 424)
            retrieveMouse := False
        }
        retrieveWinPos(pluginId)
    }
    resetLink()
    {
        mouseCtlOutputMidi := False
        activateWinUnderMouse()
        winId := mouseGetPos(mX, mY)
        saveWinPos(winId)
        linkWinId := CtxMenu.linkToController()
        if (linkWinId)
            LinkWin.reset()
        retrieveWinPos(winId)    
        mouseCtlOutputMidi := True
    }      
    link(params := "")
    {
        success := False
        Knob.__linkParseParams(params, ctxMenuLen, pickCtl, visionPickCtl, rmConflict, autoAccept, pickCtlMsg, relToPrevPickCtl)
        saveMousePos()
        linkWinId := CtxMenu.linkToController(linkChecked, ctxMenuLen)
        centerMouse(linkWinId)
        if (!linkWinId)
            return Knob.__linkQuit(success)
        if (!linkChecked and pickCtl == "")
        {
            msg("No ctl active, you will be asked to choose one")
            pickCtl := True
        }
        if (pickCtl)
        {
            res := LinkWin.pickCtl(visionPickCtl, relToPrevPickCtl, winLen, pickCtlMsg)
            if (!res)
                return Knob.__linkQuit(success)
        }
        if (function)
        {
            res := LinkWin.setFunction(function, winLen)
            if (!res)
                return Knob.__linkQuit(success)
        }
        if (removeConflicts)
            LinkWin.activateRemoveConflicts(winLen)
        success := LinkWin.accept(autoAccept, winLen)
        return Knob.__linkQuit(success)
    }
    __linkQuit(success)
    {
        retrieveMousePos()
        return success
    }
; -- params
    __linkParseParams(params, ByRef ctxMenuLen, ByRef pickCtl, ByRef visionPickCtl, ByRef rmConflict, ByRef autoAccept, ByRef pickCtlMsg, ByRef relToPrevPickCtl)
    {
        if IsObject(params)
        {
            ctxMenuLen := params["ctxMenuLen"]          
            pickCtl := params["pickCtl"]                                            ; open the ctl ctx menu
            visionPickCtl := params["visionPickCtl"]                                ; int: num ctl after the ■■■■■■■■■■■■■■■■■■■■ title
            relToPrevPickCtl := params["relToPrevPickCtl"]                          ; int: num ctl rel to last picked ctl pos
            rmConflict := params["rmConflict"]      
            autoAccept := params["autoAccept"]
            pickCtlMsg := params["pickCtlMsg"]                                      ; message during manual ctl pick
            if (visionPickCtl or relToPrevPickCtl)
                pickCtl := True
        }
    }
; --
; -- Utils -----
    __getPos(ByRef pluginId := "", ByRef knobX := "", ByRef knobY := "")
    {
        activateWinUnderMouse()
        pluginId := mouseGetPos(knobX, knobY)
        if (pluginId != WinExist("A"))
            WinActivate, ahk_id %pluginId%
    }
    __retrievePos(pluginId, knobX, knobY)
    {
        WinActivate, ahk_id %pluginId%
        moveMouse(knobX, knobY)
    }
; --
}

Class LinkWin
{
; -- General -----
    setFunction(function, ByRef length := "")
    {
        success := False
        if (length == "")
            length := LinkWin.__winLength()
        mY := {"long": 281, "short": 251}[length]
        if (mY)
        {
            quickClick(111, mY)
            SendInput ^a
            Send {Backspace}
            typeText(function)
            Send {Enter}
            Sleep, 200
            success := True
        }
        else
            msg("LinkWin.setFunction() Couldn't get link win length")
        return success
    }
    activateRemoveConflicts(ByRef length := "")
    {
        success := False
        if (length == "")
            length := LinkWin.__winLength()        
        mY := {"long": 392, "short": 362}[length]
        if (mY)
        {
            activated := colorsMatch(254, mY, [0xF4AB87])
            if (!activated)
                quickClick(252, mY)
            success := True
        }
        else
            msg("LinkWin.activateRemoveConflicts() Couldn't get link win length")
        return success
    }
    accept(auto, ByRef length := "")
    {
        success := False
        if (!LinkWin.__isWin())
        {
            success := True
            return success
        }
        if (length == "")
            length := LinkWin.__winLength()        
        mY := {"long": 430, "short": 400}[length]
        if (mY)
        {
            moveMouse(225, mY)
            if (auto)
            {
                Click
                success := True
            }
            else
            {
                success := waitToolTip("Accept")
                if (success)
                    Click
                else
                    WinClose, A
            }
        }
        else
            msg("LinkWin.accept() Couldn't get link win length")
        return success
    }  
    reset(ByRef length := "")
    {
        success := False
        if (length == "")
            length := LinkWin.__winLength()        
        mY := {"long": 425, "short": 395}[length]
        if (mY)
        {
            quickClick(64, mY)
            success := LinkWin.accept(True, length)
        }
        return success
    }
; --
; -- Pick Ctl -----
    pickCtl(visionPickCtl := 0, relToPrevPickCtl := 0, ByRef winLen := "", message := "")
    {
        success := False
        res := LinkWin.__clickCtlChoice(winLen)
        if (!res)
            return success

        if (visionPickCtl)
            success := LinkWin.__pickCtlVision(visionPickCtl)
        else
            success := LinkWin.__pickCtl(relToPrevPickCtl, message)
        return success
    }
    __clickCtlChoice(ByRef winLen)
    {
        success := False
        if (winLen == "")
            winLen := LinkWin.__winLength()
        mY := {"long": 200, "short": 170}[winLen]
        if (mY)
        {
            quickClick(200, mY)
            success := True
        }
        return success
    } 
    __pickCtl(relToPrevPickCtl, message := "")  
    {
        LinkWin.__pickCtlMoveMouse(relToPrevPickCtl)
        clickAlsoAccepts := True
        if (message == "")
            message := "pick ctl"
        success := waitToolTip(message)
        if (success)
        {
            LinkWin.__savePickedCtlPos()
            Click
        }
        else
            WinClose, A
        Sleep, 100
        return success
    }
    static __lastPickedCtlPos := ["", ""]
    __pickCtlMoveMouse(relToPrevPickCtl)
    {
        mX := LinkWin.__lastPickedCtlPos[1]
        mY := LinkWin.__lastPickedCtlPos[2]
        if (mX and mY)
            moveMouse(mX, mY)

        if (relToPrevPickCtl)
        {
            dir := {1: "down", 0: "up"}[relToPrevPickCtl >= 0]
            relToPrevPickCtl := Abs(relToPrevPickCtl)
            Loop %relToPrevPickCtl%
            {
                Send {Wheel%dir%}
                Sleep, 5
            }
        }

    }
    __savePickedCtlPos()
    {
        mouseGetPos(mX, mY)
        LinkWin.__lastPickedCtlPos[1] := mX
        LinkWin.__lastPickedCtlPos[2] := mY

    }
    /*   
    static initScrolls := 0
    __pickCtlInitScrolls()
    {
        MouseMove, 0, 20, 0, R
        MouseMove, 0, -20, 0, R
        if (LinkWin.initScrolls < 0)
            dir := "down"
        else if (LinkWin.initScrolls > 0)
            wheel := "up"
        scrolls := Abs(LinkWin.initScrolls) 
        Loop %scrolls%
        {
            Sleep, 1
            Send {Wheel%dir%}
        }
        LinkWin.initScrolls := 0
    }
    */
    __pickCtlVision(nthCtl)
    {
        mouseGetPos(mX, _)
        scanX := 273    ; last square of "f04_PEAK LFO ■■■■■■■■■■■■■■■■■■■■"
        scanY := 564    ; after template controllers --------------- Might change!!
        incr := 7       ; size of rows
        scanHeight := LinkWin.__pickCtlVisionGetScanHeight(scanY)
        cols := [0xc0c5c9, 0x94999d]
        colVar := 0
        mY := scanColorsDown(scanX, scanY, scanHeight, cols, incr)
        if (mY != "")
        {
            success := True
            moveMouse(mX, mY)
        }
        else
            success := waitToolTip("Place mouse on title ■■■■■■■■■■■■■■■■■■■■")
        if (success)
        {
            Loop, %nthCtl%
                Send {WheelDown}
            LinkWin.__savePickedCtlPos()
            Send {Enter}  
        }
        return success
    }
    __pickCtlVisionGetScanHeight(scanY)
    {
        linkWinId := mouseGetPos(mX, _)
        if (mx >= 0)
            monBottom := Mon2Bottom
        else
            monBottom := Mon1Bottom
        WinGetPos,, winY,,, ahk_id %linkWinId%
        scanHeigth := monBottom - winY - scanY
        return scanHeigth
    }
; --
; -- Window -----
    __isWin()
    {
        WinGetClass, resClass, A
        return resClass == "TMIDIInputForm"
    }
    __winLength()
    {
        ; premier pixel ^< du drop down en haut (couleur background du drop down) si longWin
        ; si shortWin, c'est une couleur différente
        x := 9
        y := 31
        i := 0
        while (!(isLongLinkWin or isShortLinkWin))
        {
            isLongLinkWin := colorsMatch(x, y, [0x2d3236])
            isShortLinkWin := colorsMatch(x, y, [0x363f45])
            Sleep, 10
            i += 1
            if (i > 10)
            {
                msg("LinkWin.__winLength() can't get length")
                break
            }
        }
        if (isLongLinkWin)
            res := "long"
        else if (isShortLinkWin)
            res := "short"
        else
            res := ""
        return res
    }     
; --
}





; -- set midi knob ------------------------


/*
knobSetMouseCtl(whichCtl = "L")
{
    mouseCtlOutputMidi := False
    Switch whichCtl
    {
    Case "L":
        cc := mCtlCcL
    Case "R":
        cc := mCtlCcR
    }

    MouseGetPos, mX, mY, winId
    WinGetPos, winX, winY,,, ahk_id %winID%
    ctxMenuLen := openKnobCtxMenu(mX, mY) ;, winX, winY, winID)

    if (ctxMenuLen != "")
    {
        ctlWinId := clickLinkController(ctxMenuLen)
        isLongLinkWin := LinkWin.isLong()
        setCcInCtlWin(cc, isLongLinkWin)
        setChannelInCtlWin(mCtlChan, isLongLinkWin)
        setPortInCtlWin(1, isLongLinkWin)    
        LinkWin.accept(True, )
        acceptLink(isLongLinkWin, True)
    }

    retrieveWinPos(winX, winY, winId)
    mouseCtlOutputMidi := True
}
*/

/*
knobSetExternalCtl(knobX, knobY, cc, chan, port, needToInitialize := True, ccConflictIncr := "")
{
    moveMouse(knobX, knobY)
    WinGet, winId, ID, A
    WinGetPos, winX, winY,,, ahk_id %winId%
    ctxMenuLen := openKnobCtxMenu(knobX, knobY) ;, winX, winY, winId)
    if (ctxMenuLen != "")
    {
        ctlWinId := clickLinkController(ctxMenuLen)
        isLongLinkWin := LinkWin.isLong()
        setCcInCtlWin(cc, isLongLinkWin)
        setChannelInCtlWin(chan, isLongLinkWin, needToInitialize)
        setPortInCtlWin(port, isLongLinkWin, needToInitialize)
        if (ccConflictIncr)
        {
            while (ctlWinConflict(isLongLinkWin))
            {
                cc := cc + ccConflictIncr
                if (cc + ccConflictIncr > 127)
                {
                    cc := 1
                    chan := chan + 1
                    setChannelInCtlWin(chan, isLongLinkWin, needToInitialize)
                }
                setCcInCtlWin(cc, isLongLinkWin)
            }
        }
        acceptLink(isLongLinkWin, True) 
    }

    retrieveWinPos(winX, winY, winId)
    return [cc, chan]
}
setCcInCtlWin(cc, isLongLinkWin)
{
    if (isLongLinkWin)
        y := 99
    else
        y := 72
    x := 241
    quickClick(241, y, "Right")
    Loop, 5
        Send {Down}
    Send {Enter}
    moveMouse(x, y)
    ;MouseMove, %x%, %y%, 0
    Loop, %cc%
    {
        Send {WheelUp}
        Sleep, 2
    }
}

setChannelInCtlWin(channel, isLongLinkWin, needToInitialize = True)
{
    if (isLongLinkWin)
        y := 99
    else
        y := 72  
    x := 157
    moveMouse(x, y)
    if (needToInitialize)
    {
        Loop, 16
            Send {WheelDown}
        Sleep, 20
    }

    n := channel - 1
    Loop, %n%
    {
        Send {WheelUp}
    }
}

setPortInCtlWin(port, isLongLinkWin, needToInitialize = True)
{
    if (isLongLinkWin)
        y := 99
    else
        y := 72  
    x := 63
    moveMouse(x, y)
    if (needToInitialize)
    {
        Loop, 10
        {
            Send {WheelDown}
        }
        Sleep, 20
    }

    n := port + 1
    Loop, %n%
    {
        Send {WheelUp}
        Sleep, 10
    }    
}

ctlWinConflict(isLongLinkWin)
{
    Sleep, 10
    if (isLongLinkWin)
        res := colorsMatch(230, 392, [0xBF3E35], 20)
    else
        res := colorsMatch(235, 359, [0xD03C22], 20)
    return res
}
*/

; ----