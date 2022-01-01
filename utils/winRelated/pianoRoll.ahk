global pianoRollSepY := 885
global timelineCol := [0x1d2830, 0x9b5356]
global noteModifierClasses := ["TPRRandomForm", "TPRScoreCreatorForm", "TPRLegatoForm", "TPRQuantizeForm", "TPRSliceForm", "TPRArpForm", "TPRStrumForm", "TPRFlamForm", "TPRTripletForm", "TPRKeyLimitForm", "TPRFlipForm", "TPRLevelScaleForm", "TPRLFOForm"]


; -- Transpose -------------------------------------------------
transposeNotes()
{
    toolTip("Select notes to transpose")
    unfreezeMouse()
    res := waitAcceptAbort()
    toolTip()
    if (res == "abort")
        return
    freezeMouse()

    SendInput ^x
    insertTempPattern()
    SendInput ^v
    
    toolTip("")
    
    
    scrollPatternDown()
}

insertTempPattern()
{
    msg("currPatt: " currPatt)
    WinGet, winId, ID, A
    SendInput +^{Insert}
    nameEditorId := waitNewWindowOfClass("TNameEditForm", winId)
    Send temp{Space}patt{Enter}
}

; ----

; -- Scroll Instruments ----------------------------------------
global scrollingInstr := False
global scrollInstrData := []
scrollInstr(initMode := "pianoRoll")
{
    scrollingInstr := True
    stopWinHistoryClock()
    MouseGetPos, mX, mY
    WinGet, prevWinId, ID, A
    ssId := bringStepSeq(False)
    WinGetPos, ssX, ssY,, ssH, ahk_id %ssId%
    
    Switch initMode
    {
    Case "pianoRoll":
        newSsX := -850
        newSsY := 750
    Case "playlist":
        newSsX := 1080
        newSsY := 255        
    Case "plugin":
        newSsX := 1080
        newSsY := 255   
    Case "stepSeq":
        newSsX := ssX
        newSsY := ssY   
    }
    WinMove, ahk_id %ssId%,, %newSsX%, %newSsY%

    moveMouseToSelY()
    scrollInstrData := [ssId, ssX, ssY, mX, mY, initMode, prevWinId]
    freezeMouse()

    msgX := 3
    msgY := 30     
    msg := "Release Shift: instr`r`n[Ctrl] piano roll"
    ToolTip, %msg%, %msgX%, %msgY%
    unfreezeMouse()
}

scrollInstrStop(openTo := "pianoRoll")
{
    toolTip()
    mX := scrollInstrData[4]
    mY := scrollInstrData[5]    
    if (!mouseOverStepSeqInstruments())
    {
        prevWinId := scrollInstrData[7]
        WinActivate, ahk_id %prevWinId%
        moveMouse(mX, mY)
        return
    }
    freezeMouse()

    initMode := scrollInstrData[6]
    Switch openTo
    {
    Case "instr":
        openChannelUnderMouse()

    Case "pianoRoll":
        centerM := initMode != "pianoRoll"
        openChannelUnderMouseInPianoRoll(centerM)
    }    

    ssId := scrollInstrData[1]
    ssX := scrollInstrData[2]
    ssY := scrollInstrData[3]
    WinMove, ahk_id %ssId%,, %ssX%, %ssY%
    
    if (initMode == "pianoRoll" and openTo == "pianoRoll")
        moveMouse(mX, mY)

    scrollingInstr := False
    scrollInstrData := []
    unfreezeMouse()
    startWinHistoryClock()
}
; -------------



; --------------------------------------------------------------
pianoRollSepInPos()
{
    global pianoRollSepPos
    global pianoRollSepPosLo, pianoRollSepPosMid, pianoRollSepPosHi
    global pianoRollSepColor
    
    result := False
    cols := [pianoRollSepColor]
    colVar := 10
    x:= 314
    Switch pianoRollSepPos
    {
    Case "lo":
        result := colorsMatch(x, pianoRollSepPosLo, cols, colVar)
    Case "mid":
        result := colorsMatch(x, pianoRollSepPosMid, cols, colVar)
    Case "hi":
        result := colorsMatch(x, pianoRollSepPosHi, cols, colVar)
    }
    return result
}

pianorollActivate2()
{
    
    MouseMove, 427, 14, 0
    choices := [2, 3, 4]
    toolTipChoiceIndex := 1
    n := toolTipChoice(choices)
    if (n != "")
    {
        Send {LButton}
        Send %n%{Enter}
    }
}

cycleInstrPianoRoll(dir, withNotesOnly = False)
{
    MouseMove, 427, 14, 0
    if (!withNotesOnly)
        Click
    if (dir == "up")
        dir := "WheelUp"
    if (dir == "down")
        dir := "WheelDown"
    Send {%dir%}
    if (!withNotesOnly)
        Click
}

cyclePianoRollControl(dir)
{
    MouseMove, 51, 903
    Switch dir
    {
    Case "right":
        dir := "WheelDown"
    Case "left":
        dir := "WheelUp"
    }
    Send {%dir%}
}


adjustPianoRollSep(pianoRollId := "")
{
    stopWinMenusClock()
    Gui, PianoRollMenu1:Hide
    if (!pianoRollId)
        pianoRollId := bringPianoRoll(False, False)
    else
        WinActivate, ahk_id %pianoRollId%
    
    x:= 400
    currSepY := locatePianoRollSep(x)
    if (currSepY and currSepY != pianoRollSepY)
    {
        MouseMove, %x%, %currSepY%, 0
        Click, down
        MouseMove, %x%, %pianoRollSepY%, 0
        Click, up
    }
    Gui, PianoRollMenu1:Show
    startWinMenusClock()
}

locatePianoRollSep(x)
{
    cols := [0x3F484D]
    colVar := 0
    if (!colorsMatch(x, pianoRollSepY, cols, colVar))
    {
        startY := 1070
        h := 1020
        incr := -6
        y := scanColorsDown(x, startY, h, cols, colVar, incr, "searching separator")
        if (!y)
            msgTip("fail")
    }
    else
    {
        msgTip("Piano roll separator is fine.")
    }
    return y
}

global pianoRollScrollingColors := False
global pianoRollScrollingColorsMousePos := []
pianoRollScrollColors(dir)
{
    if (!pianoRollScrollingColors)
    {
        MouseGetPos, mX, mY
        moveMouse(37, 43)
        Click
        pianoRollScrollingColors := True
        pianoRollScrollingColorsMousePos := [mX, mY]
    }
    if (dir == "up")
        Send {WheelUp}
    else if (dir == "down")
        Send {WheelDown}
}

pianoRollStopScrollingColors()
{
    pianoRollScrollingColors := False
    Click
    mX := pianoRollScrollingColorsMousePos[1]
    mY := pianoRollScrollingColorsMousePos[2]
    moveMouse(mX, mY)
}

pianoRollSetColor()
{
    sendinput !c
}

pianoRollSelColor()
{
    sendinput +c
}
; ----

; -- Loop -------------------------------------------
mouseOnLoopButton()
{
    MouseGetPos, mx, my
    return mx < 108 and my < 22 and my > 1 and mx > 87
}

mouseOnPianoRollTimeline()
{
    MouseGetPos, mx, my
    return my < getPianoRollMarkerY()+10 and my > 65 and mx > 71 and mx < 1897
}

mouseOnPianoRollMarker()
{
    MouseGetPos, mx, my
    return !colorsMatch(mx, my, timelineCol, 30)
}

activatePianoRollLoop(activate := True)
{
    toolTip((activate? "Activating":!activate? "Deactivating":) " loop")
    activateLoopArrow()
    zoomOut()
    
    ;colorsMatchDebug := True
    ;colorsMatchDebugTime := 300
    markerX := findLoopMarker(activate)
    colorsMatchDebug := False
    if (markerX)
    {
        markerY := getPianoRollMarkerY()
        moveMouse(markerX, markerY)
        if (activate)
            activateLoopMarkerUnderMouse()
        else
            deactivateLoopMarkerUnderMouse()
        ;markerX := findLoopMarker(activate)
        ;if (activate)
        ;    moveMouse(markerX-15, markerY)
    }
    zoomRetrieve()
    toolTip()
    if (!activate)  
        deactivateLoopArrow()
    if (!markerX)
        msg("Loop marker not found")
}

getPianoRollMarkerY()
{
    if (pianoRollTimeLineIsThick())
        y := 72
    else
        y := 58
    return y
}

pianoRollTimeLineIsThick()
{
    ; check border between note color and vertical keyboard
    x := 1
    y := 64
    col := [0x1d262b]
    return !colorsMatch(x, y, col)
}

zoomOut()
{
    moveMouse(75, 88)
    Send {Ctrl Down}{RButton Down}
    moveMouse(1890, 811)    
    Send {RButton Up}{Ctrl Up}
    moveMouse(426, 105)
    Send {CtrlDown}{Rbutton}{CtrlUp} 
    Sleep, 40
}

zoomRetrieve()
{
    moveMouse(426, 105)
    Send {CtrlDown}{Rbutton}{CtrlUp} 
}

activateLoopArrow()
{
    loopActivated := colorsMatch(100, 11, [0x9BEF7D], 20)
    if (!loopActivated)
    {
        MouseMove, 96, 10, 0
        Click        
    }
}

deactivateLoopArrow()
{
    loopActivated := colorsMatch(100, 11, [0x9BEF7D], 20)
    if (loopActivated)
    {
        MouseMove, 96, 10, 0
        Click        
    }    
}

findLoopMarker(activate)
{
    ; could use getPianoRollMarkerY() ?     and other more global stuff ?
    colVar := 3
    incr := 40
    timeLineStart := 75
    x := timeLineStart
    y := 71
    timelineEnd := 1895
    w := timelineEnd - x

    if (!colorsMatch(78, y, timelineCol, colVar))
    {
        toolTip("findLoopMarker(): est-ce que le marker est au début?")
        moveMouse(78, y)
        Sleep, 1000
        Send {LButton Down}
        Sleep, 1000
        toolTip("Click down")
        Sleep, 1000
        MouseMove, 100, 0 , 0, R
        Send {LButton Up}
        toolTip("Click up")
        Sleep, 1000
        msg("what was it?", 2000)
    }
    
    doneSearching := False
    while (!doneSearching and w > incr)
    {
        debug := False
        if (debug)
            msg("searching marker", 500)
        markerX := scanColorsRight(x, y, w, timelineCol, colVar, incr, "", debug, True)
        if (markerX)    ; found a marker, check if it's a loop one by looking at its arrow
        {
            if (debug)
                msg("found markerX", 500)
            arrowGreen := 0x4AE4A8
            arrowColVar := 50
            if (colorComparison(lastColorMatchResCol, arrowGreen, arrowColVar))
                doneSearching := True
            else
            {
                incr := 5
                x := Max(markerX - 55, timeLineStart)
                w := 55
                arrowX := scanColorsRight(x, y, w, [arrowGreen], arrowColVar, incr, "", debug) ; dead-> , "", False, False, "isTimeLinePixel")
                if (arrowX)
                    doneSearching := True
            }
        }
        if (!doneSearching)
        {
            incr := 40
            x := markerX + 56
            w := timelineEnd - x
        }
    }
    return markerX
}

/*
Was used for the loop arrow scan. Which clearly is a mistake. Dead code?
isTimeLinePixel(resCol)
{
    timelineCol := [0x1d2830, 0x9b5356]
    colVar := 3
    res := colorComparison(timelineCol[1], resCol, colVar) or colorComparison(timelineCol[2], resCol, colVar)
    return res
}
*/

activateLoopMarkerUnderMouse()
{
    Click, Right
    Loop, 5
    {
        Sleep, 3
        Send {WheelDown}
        Sleep, 3
    }
    Click
}


deactivateLoopMarkerUnderMouse()
{
    Click, Right
    Send {WheelDown}
    Click
}

burnLoopButton()
{
    Click, Right
    QuickClick(152, 104)
}

burnLoopMarker()
{
    Click, Right
    MouseMove, 23, 172 , 0, R
    Click
}
; ----

; -- Stamps -----------------------------------------
global stampState := False
global stampMode := "min"
global stampRand

toggleStampState()
{
    global stampState, stampMode
    stampState := !stampState
    if (stampState)
    {
        Switch stampMode
        {
        Case "min":
            activateMinStamp()
        Case "maj":
            activateMajStamp()
        Case  "rand":
            randomizeStamp()
        }
    }
    else
        deactivateStamp()
    updatePianoRollMenu1StampMode()
}

minMajStamp()
{
    global stampState, stampMode
    if (!stampState)
        stampState := True
    if (stampMode == "min")
    {
        stampMode := "maj"
        activateMajStamp()
    }
    else
    {
        stampMode := "min"
        activateMinStamp()
    }
    updatePianoRollMenu1StampMode()
}

activateMajStamp()
{
    Click, 76, 13
    Click, 116, 220
}

activateMinStamp()
{
    Click, 76, 13
    Click, 126, 276
}

deactivateStamp()
{
    Send {ShiftDown}n{ShiftUp}
}

randomizeStamp()
{
    stampState := True
    stampMode := "rand"
    Click, 76, 13
    /*
    advanced := oneChanceOver(2)
    if (advanced)
    {
        MouseMove, 109, 87, 0
        MouseMove, 150, 0, 0, R
        minY := 39
        row2 := oneChanceOver(6)
        if (row2)
        {
            x := 382
            maxY := 256                
        }
        else
        {
            x := 274
            maxY := 1048
        }

        Random, y, %minY%, %maxY%
        MouseMove, %x%, %y%, 0
    }
    else
    {
        x := 112 
        minY := 105
        maxY := 1050
        while (!y or yOnSeparator)
        {
            Random, y, %minY%, %maxY%
            yOnSeparator := (343 < y and 360 < y) or (778 < y and 794 < y)
        }
        MouseMove, %x%, %y%, 0
    }
    */

    ;;;;; juste des chords normales
    x := 112
    minY := 105
    maxY := 340
    Random, y, %minY%, %maxY%
    stampRand := y
    MouseMove, %x%, %y%, 0
    Sleep, 300
    Click
    updatePianoRollMenu1StampMode()
}
; ----

; -- Tool windows ------------------------------
proposePianoRollSel(prefix := "", mode := "time")
{
    Switch mode
    {
    Case "time":
        txt := "sel TIME         accept / abort"
        moveMouse(73, 54)
    Case "notes":
        txt := "sel NOTES        accept / abort"
    }
    if (prefix != "")
        txt := prefix "`r`n" txt
    pianoRollTempMsg(txt)
    unfreezeMouse()
    res := waitAcceptAbort()
    freezeMouse()
    return res
}

quantize()
{
    if (proposePianoRollSel("note lfo", "notes") == "abort")
        return      
    WinGet, id, ID, A
    Send {AltDown}q{AltUp}
    qId := waitNewWindowOfClass("TPRQuantizeForm", id)
    movePianorollToolWindow(qId)
    MouseMove, 93, 107, 0
    retrieveMouse := False
}

pianorollGen()
{
    WinGet, id, ID, A
    rec := recordEnabled()
    play := songPlaying()
    Send {AltDown}e{AltUp}
    genId := waitNewWindowOfClass("TPRScoreCreatorForm", id)
    if (rec)
        midiRequest("toggle_rec")
    if (!play) 
        Send {Space}
     movePianorollToolWindow(genId)
    moveMouseOnToggle()
    retrieveMouse := False
}

pianorollRand()
{ 
    WinGet, id, ID, A
    rec := recordEnabled()
    proposePianoRollSel("Rand:", "time")
    Send {AltDown}r{AltUp}
    randId := waitNewWindowOfClass("TPRRandomForm", id)
    pianoRollTempMsg("1: Seed")
    if (rec)
        midiRequest("toggle_rec")       
    movePianorollToolWindow(randId)
    MouseMove, 92, 188, 0
    retrieveMouse := False    
}

pianorollArp()
{ 
    WinGet, id, ID, A
    rec := recordEnabled()
    proposePianoRollSel("Arp:", "notes")
    Send {AltDown}a{AltUp}
    arpId := waitNewWindowOfClass("TPRArpForm", id)
    if (rec)
        midiRequest("toggle_rec")       
    movePianorollToolWindow(arpId)
    MouseMove, 93, 107, 0
    retrieveMouse := False    
}

pianorollLen()
{
    WinGet, id, ID, A
    rec := recordEnabled()
    Send {AltDown}l{AltUp}       
    lenId := waitNewWindowOfClass("TPRLegatoForm", id)
    if (rec)
        midiRequest("toggle_rec")      
    movePianorollToolWindow(lenId)
    MouseMove, 84, 70, 0
    retrieveMouse := False    
}

pianorollMap()
{
    if (proposePianoRollSel("note lfo", "notes") == "abort")
        return      
    WinGet, id, ID, A
    rec := recordEnabled()
    Send {AltDown}k{AltUp}    
    mapId := waitNewWindowOfClass("TPRKeyLimitForm", id)
    if (rec)
        midiRequest("toggle_rec")      
    movePianorollToolWindow(mapId)
    MouseMove, 147, 68, 0
    retrieveMouse := False 
    return mapId     
}

pianoRollDismissPitches()
{
    mapId := pianorollMap()
    y := 179
    moveMouse(10, y)
    Send {LButton Down}
    moveMouse(195, y)
    Send {LButton Up}

    moveMouse(418, y)
    Send {LButton Down}
    moveMouse(195, y)
    Send {LButton Up}
    Send {Enter}

    sendinput +d  ; disable lenghts
    sendinput ^g  ; remove overlaps

    retrieveMouse := True      
}

pianorollStrum()
{
    if (proposePianoRollSel("note lfo", "notes") == "abort")
        return       
    WinGet, id, ID, A
    rec := recordEnabled()
    Send {AltDown}s{AltUp}    
    strumId := waitNewWindowOfClass("TPRStrumForm", id)
    if (rec)
        midiRequest("toggle_rec")      
    movePianorollToolWindow(strumId)
    MouseMove, 78, 85, 0
    retrieveMouse := False     
}

pianorollTwins()
{
    if (proposePianoRollSel("note lfo", "notes") == "abort")
        return     
    WinGet, id, ID, A
    rec := recordEnabled()
    Send {AltDown}f{AltUp}    
    twinsId := waitNewWindowOfClass("TPRFlamForm", id)
    if (rec)
        midiRequest("toggle_rec")      
    movePianorollToolWindow(twinsId)
    MouseMove, 78, 85, 0
    retrieveMouse := False       
}

pianorollChop()
{
    if (proposePianoRollSel("note lfo", "notes") == "abort")
        return 
    WinGet, id, ID, A
    rec := recordEnabled()
    Send {AltDown}u{AltUp}    
    chopId := waitNewWindowOfClass("TPRSliceForm", id)
    if (rec)
        midiRequest("toggle_rec")      
    movePianorollToolWindow(chopId)
    MouseMove, 88, 110, 0
    retrieveMouse := False       
}

pianorollFlip()
{
    if (proposePianoRollSel("note lfo", "notes") == "accept")
    {       
        WinGet, id, ID, A
        rec := recordEnabled()
        Send {AltDown}y{AltUp}    
        flipId := waitNewWindowOfClass("TPRFlipForm", id)
        if (rec)
            midiRequest("toggle_rec")      
        movePianorollToolWindow(flipId)
        MouseMove, 19, 45, 0
        retrieveMouse := False       
    }
}

pianorollScale()
{
    if (proposePianoRollSel("note lfo", "notes") == "accept")
    {    
        WinGet, id, ID, A
        rec := recordEnabled()
        Send {AltDown}x{AltUp}    
        scaleId := waitNewWindowOfClass("TPRLevelScaleForm", id)
        if (rec)
            midiRequest("toggle_rec")      
        movePianorollToolWindow(scaleId)
        QuickClick(44, 249) ; Reset scaling
        MouseMove, 85, 100, 0
        retrieveMouse := False       
    }
}

pianorollLfo()
{
    if (proposePianoRollSel("note lfo", "notes") == "accept")
    {
        WinGet, id, ID, A
        rec := recordEnabled()
        Send {AltDown}o{AltUp}    
        lfoId := waitNewWindowOfClass("TPRLFOForm", id)
        if (rec)
            midiRequest("toggle_rec")      
        movePianorollToolWindow(lfoId)
        pianoRollLfoSetTime()
        retrieveMouse := False
    }
}

movePianorollToolWindow(id)
{
    WinMove, ahk_id %id%,, -621, 761
}
; ---------------
toogleNoteSlide()
{
    if (pianoRollTimeLineIsThick())
        y := 71
    else
        y := 55     
    QuickClick(60, y)
}

pianoRollAddSpace()
{
    if (proposePianoRollSel("+space", "time") == "accept")
        Send {CtrlDown}{AltDown}{Insert}{CtrlUp}{AltUp}
}

pianorollDisableLenghts()
{
    if (proposePianoRollSel("!len", "notes") == "accept")
        Send {ShiftDown}d{ShiftUp}
}

pianoRollDelTimeSel()
{
    if (proposePianoRollSel("del time", "time") == "accept")
    {
        Send {CtrlDown}{Delete}{CtrlUp}
        Send {CtrlDown}d{CtrlUp}
    }
}

pianoRollCropTimeSel()
{
    if (proposePianoRollSel("crop", "time") == "accept")
    {
        QuickClick(12, 13)
        Send {Down}{Down}{Right}
        QuickClick(257, 479)
    }
}

/*
transpose(dir)
{
    if (dir == "up")
        Send {ShiftDown}{Up}{ShiftUp}
    else if (dir == "down")
        Send {ShiftDown}{Down}{ShiftUp}
}
*/
; ----

; -- Note params -----------------
activateParamX()
{
    activatePianoRollParam(4)
}

activateParamY()
{
    activatePianoRollParam(5)
}

activateParamVel()
{
    activatePianoRollParam(2)
}

activatePianoRollParam(n)
{
    moveMouse(34, 896)
    Click
    y := 35 + (n-1) * 19
    MouseMove, 0, y, 0, R
    Click
    retrieveMouse := False
}

pianoRollLfoSetTime()
{
    moveMouse(74, 169)

    choices := ["1/4", "1/2", "1 beat", "2", "1 bar", "2", "4 bars", "8", "4 -----", "8 -----"]
    initIndex := randInt(1, choices.MaxIndex())
    toolTipChoice(choices, "", initIndex)
    n := toolTipChoiceIndex
    if (n == "")
        return

    Click, R
    Loop %n%
    {
        Sleep, 20
        Send {WheelDown}
    }
    Sleep, 20
    Click
}
; ----

; -- util ------------------------
pianoRollTempMsg(txt := "")
{
    if (isPianoRoll())
    {
        prevMode := setToolTipCoordMode("Client")
        tempMsg(txt, 1000, 74, 47, toolTipIndex["pianoRollTempMsg"])
        setToolTipCoordMode(prevMode)
    }
}
; ----
