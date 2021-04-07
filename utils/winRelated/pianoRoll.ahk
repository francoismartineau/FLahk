global pianoRollSepY := 885

global noteModifierClasses := ["TPRRandomForm", "TPRScoreCreatorForm", "TPRLegatoForm", "TPRQuantizeForm", "TPRSliceForm", "TPRArpForm", "TPRStrumForm", "TPRFlamForm", "TPRTripletForm", "TPRKeyLimitForm", "TPRFlipForm", "TPRLevelScaleForm", "TPRLFOForm"]


; -- Scroll Instruments ----------------------------------------
global pianoRollScrollingInstr := False
global pianoRollScrollInstrData := []
pianoRollScrollInstr()
{
    pianoRollScrollingInstr := True
    WinGet, pianoRollId, ID, A
    MouseGetPos, mX, mY
    ssId := bringStepSeq(False)
    WinGetPos, ssX, ssY,, ssH, ahk_id %ssId%
    WinMove, ahk_id %ssId%,, -850, 750
    moveMouseToSelY()
    pianoRollScrollInstrData := [ssId, ssX, ssY, mX, mY]
    freezeMouse()
    msg := "Release Shift over choice.`r`n[Ctrl] open instr"
    msgX := 3
    msgY := 30     
    ToolTip, %msg%, %msgX%, %msgY%
}

pianoRollScrollInstrStop()
{
    toolTip()
    ssId := pianoRollScrollInstrData[1]
    ctrlPressed := keyIsDown("Ctrl")
    if (ctrlPressed)
        openChannelUnderMouse()
    else
        openChannelUnderMouseInPianoRoll(False)

    ssX := pianoRollScrollInstrData[2]
    ssY := pianoRollScrollInstrData[3]
    WinMove, ahk_id %ssId%,, %ssX%, %ssY%
    
    if (!ctrlPressed)
    {
        mX := pianoRollScrollInstrData[4]
        mY := pianoRollScrollInstrData[5]    
        moveMouse(mX, mY)
    }

    pianoRollScrollingInstr := False
    pianoRollScrollInstrData := []
    unfreezeMouse()
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
    res := toolTipChoice(choices)
    if (res == "accept")
    {
        n := choices[toolTipChoiceIndex]
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


adjustPianoRollSep(pianoRollId = "")
{
    stopWinMenusClock()
    Gui, PianoRollMenu:Hide
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
    Gui, PianoRollMenu:Show
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
        y := scanColorDown(x, startY, h, cols, colVar, incr, "searching separator")
        if (!y)
            msgTip("fail")
    }
    else
    {
        msgTip("Piano roll separator is fine.")
    }
    return y
}

; -- Loop -------------------------------------------
mouseOnLoopButton()
{
    MouseGetPos, mx, my
    return mx < 108 and my < 22 and my > 1 and mx > 87
}

mouseOnPianoRollTimeline()
{
    MouseGetPos, mx, my
    return my < 82 and my > 65 and mx > 71 and mx < 1897
}

mouseOnPianoRollMarker()
{
    MouseGetPos, mx, my
    return !colorsMatch(mx, my, [0x1E2A31], 30)
}

activatePianoRollLoop(activate = True)
{
    markerY := 79
    makeSureLoopArrowHasTheRightState(activate)

    markerX := findLoopMarker()
    if (markerX)
    {
        Sleep, 500
        if (activate == True)
        {
            moveMouse(markerX, markerY)
            activateLoopMarkerUnderMouse()
        }
        else 
        {
            moveMouse(95, 10)
            Click
            moveMouse(markerX, markerY)
            deactivateLoopMarkerUnderMouse()
        }
        markerX := findLoopMarker()
        if (activate == True)
            moveMouse(markerX-15, markerY)
    }
    else
        moveMouse(1115, markerY)
}


makeSureLoopArrowHasTheRightState(activate)
{
    ;MouseMove, 0, 100 , 0, R
    ;Sleep, 30
    loopActivated := colorsMatch(100, 11, [0x9BEF7D], 20)
    ;debug("loopActivated: " loopActivated)
    if ((activate == False and loopActivated) or (activate == True and !loopActivated))
    {
        MouseMove, 96, 10, 0
        Click
    }
}

findLoopMarker()
{

    timelineCol := [0x1B272E, 0xA25B5D]
    incr := 40
    x := 123
    y := 75
    timelineW := 1820
    colVar := 10
    markerX := scanColorRight(x, y, timelineW, timelineCol, colVar, incr, "", False, True)
    return markerX
}


activateLoopMarkerUnderMouse()
{
    Click, Right
    Send {WheelUp}{WheelUp}{WheelUp}{WheelUp}
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
    updatePianoRollMenuStampMode()
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
    updatePianoRollMenuStampMode()
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
    updatePianoRollMenuStampMode()
}

; -- Tool windows ------------------------------
quantize()
{
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
    Send {AltDown}r{AltUp}
    randId := waitNewWindowOfClass("TPRRandomForm", id)
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
    WinGet, id, ID, A
    rec := recordEnabled()
    Send {AltDown}k{AltUp}    
    mapId := waitNewWindowOfClass("TPRKeyLimitForm", id)
    if (rec)
        midiRequest("toggle_rec")      
    movePianorollToolWindow(mapId)
    MouseMove, 147, 68, 0
    retrieveMouse := False      
}

pianorollStrum()
{
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

pianorollScale()
{
    WinGet, id, ID, A
    rec := recordEnabled()
    Send {AltDown}x{AltUp}    
    scaleId := waitNewWindowOfClass("TPRLevelScaleForm", id)
    if (rec)
        midiRequest("toggle_rec")      
    movePianorollToolWindow(scaleId)
    MouseMove, 85, 100, 0
    retrieveMouse := False       
}

pianorollLfo()
{
    WinGet, id, ID, A
    rec := recordEnabled()
    Send {AltDown}o{AltUp}    
    lfoId := waitNewWindowOfClass("TPRLFOForm", id)
    if (rec)
        midiRequest("toggle_rec")      
    movePianorollToolWindow(lfoId)
    MouseMove, 85, 100, 0
    retrieveMouse := False
}

movePianorollToolWindow(id)
{
    WinMove, ahk_id %id%,, -621, 761
}
; ---------------
toogleNoteSlide()
{
    QuickClick(60, 73)
}

pianorollDisableLenghts()
{
    Send {ShiftDown}d{ShiftUp}
}

pianoRollDelTimeSel()
{
    Send {CtrlDown}{Delete}{CtrlUp}
    Send {CtrlDown}d{CtrlUp}
}

pianoRollCropTimeSel()
{
    QuickClick(12, 13)
    Send {Down}{Down}{Right}
    QuickClick(257, 479)
}

transpose(dir)
{
    if (dir == "up")
        Send {ShiftDown}{Up}{ShiftUp}
    else if (dir == "down")
        Send {ShiftDown}{Down}{ShiftUp}
}

