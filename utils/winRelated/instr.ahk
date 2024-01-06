global instrFullScreenXoffset := -6
global instrFullScreenYoffset := -3

; -- Wrench Panel ------------------------------------------
global wrenchKnobPos := {}
wrenchKnobPos["arpDir"] := [96, 197]
wrenchKnobPos["arpTime"] := [110, 230]
wrenchKnobPos["arpChord"] := [303, 284]
wrenchKnobPos["echoFeed"] := [347, 231]
wrenchKnobPos["echoNum"] := [401, 284]
wrenchKnobPos["echoPitch"] := [494, 230]
wrenchKnobPos["echoTime"] := [535, 229]
scrollWrenchPanel()
{
    goNextKnob := InStr(A_ThisHotkey, "Down") > 0
    mouseGetPos(mX, mY)
    ;            x1           x2               x3          x4              x5
    ;  y1     1 arp dir 
    ;  y2     2 [arp time]                  4 feed                       6 [pitch]
    ;  y3                 3 [chord]                     5[echoes]
    indexKnob := {1: "arpDir", 2: "arpTime", 3: "arpChord", 4: "echoFeed", 5: "echoNum", 6: "echoPitch"}

    arp := arpActivated()
    del := delayActivated()
    if (mY< 208)
        y := 1
    else if (mY > 262)
        y := 3
    else 
        y := 2

    if (mX < 172)
        x := 1
    else if (mX < 315)
        x := 2
    else if (mX < 362)
        x := 3
    else if (mX < 441)
        x := 4
    else
        x := 5


    if (y == 1 and x == 1)
        index := 1
    else if (y == 2 and x == 1)
    {
        if (arp)
            index := 2
        else
            index := 1
    }
    else if (x == 2)
    {
        if (arp)
            index := 3
        else
            index := 4
    }
    else if (x == 3)
        index := 4
    else if (x == 4)
    {
        if (del)
            index := 5
        else
            index := 4
    }
    else if (x == 5)
    {
        if (del)
            index := 6
        else
            index := 4
    }

    if (goNextKnob)
        index := index + 1
    else
        index := index - 1
    
    if (index < 1)
        index := 6
    else if (index > 6)
        index := 1

    if (!arp and (index == 2 or index == 3))
    {
        if (goNextKnob)
            index := 4
        else
            index := 1
    }
    if (!del and (index == 5 or index == 6))
    {
        if (goNextKnob)
            index := 1
        else
            index := 4      
    }

    knob := indexKnob[index]
    moveMouseToWrenchPanelKnob(knob)
}

moveMouseToWrenchPanelKnob(knob)
{
    moveMouse(wrenchKnobPos[knob][1], wrenchKnobPos[knob][2])
}


setInstrDelaySpeed()
{
    alreadyOpen := clickInstrWrench()
    ;if (!delayActivated())
    ;{
    ;    feed := expRand(.1, .9, 3)
    ;    Knob.setVal(350, 230, feed)    
    ;}

    delX := 536
    y := 228
    static vals := [1, .75, .5, .375, .25, .166666, .125, .083333, .0625, .041666, .03125]
    static choices := ["2    ", "1.5  ", "1       ---------  beat", "3/4  ", "1/2        ----", "1/3  ", "1/4        ----", "1/6  ", "1/8  ", "1/12 ", "1/16 "]
    
    MouseMove, %delX%, %y%, 0
    knobVal := Knob.copy(False)
    MouseMove, %delX%, %y%, 0

    index := indexOfClosestValue(knobVal, vals)
    val := toolTipChoice(choices, "", index)
    if (val != "")
    {
        val := vals[toolTipChoiceIndex]
        Knob.paste(False, val, "normal")
    }
    if (!alreadyOpen)
        clickInstrMainPanel()
}

setInstrDelayPitch()
{
    alreadyOpen := clickInstrWrench()

    pitchX := 490
    y := 228
    static vals := [1, 0.958333333022892, 0.916666666977108, 0.875, 0.833333333022892, 0.791666666977108, 0.75, 0.708333333022892, 0.666666666977108, 0.625, 0.583333333022892, 0.541666666977108, 0.5, 0.458333333022892, 0.416666666977108, 0.375, 0.333333333022892, 0.291666666977108, 0.25, 0.208333333022892, 0.166666666977108, 0.125, 0.0833333330228925, 0.0416666669771075, 0]
    static choices := ["12 ----", "11", "10", "9", "8", "7 --", "6", "5", "4", "3", "2", "1", "0 ----", "-1", "-2", "-3", "-4", "-5", "-6", "-7 --", "-8", "-9", "-10", "-11", "-12 ----"]
    
    MouseMove, %pitchX%, %y%, 0
    knobVal := Knob.copy(False)
    MouseMove, %pitchX%, %y%, 0

    index := indexOfClosestValue(knobVal, vals)
    val := toolTipChoice(choices, "", index)
    if (val != "")
    {
        val := vals[toolTipChoiceIndex]
        Knob.paste(False, val, "normal")
    }
    if (!alreadyOpen)
        clickInstrMainPanel()    
}

setInstrArpSpeed()
{
    alreadyOpen := clickInstrWrench()
    if (!arpActivated())
    {
        Knob.setVal(96, 196, randInt(1,4)/5)               ; dir
        Knob.setVal(225, 284, randomChoice([0, 0.02222]))  ; chord
    }

    arpX := 110
    y := 228
    static vals := [0.998996990732849, 0.910732196643949, 0.786359077319503, 0.663991975598037, 0.575727181509137, 0.464393179538616, 0.371113340370357, 0.27382146474, 0.176529589109123]
    static choices := ["1       ---------  beat", "3/4  ", "1/2        ----", "1/3  ", "1/4        ----", "1/6  ", "1/8  ", "1/12 ","1/16 "]

    MouseMove, %arpX%, %y%, 0
    knobVal := Knob.copy(False)
    MouseMove, %arpX%, %y%, 0

    index := indexOfClosestValue(knobVal, vals)
    val := toolTipChoice(choices, "", index)
    if (val != "")
    {
        val := vals[toolTipChoiceIndex]
        Knob.paste(False, val, "time")
    }
    if (!alreadyOpen)
        clickInstrMainPanel()
}

arpActivated()
{
    return !colorsMatch(103, 192, [0x21272B])
}

delayActivated()
{
    return !colorsMatch(344, 241, [0x31373b])   ; check if grey at THE pixel
}

placeMouseOnArpOrDelay()
{
    if (arpActivated())
        mode := "arp"
    else if (delayActivated())
            mode := "delay"
    else if (oneChanceOver(2))
        mode := "arp"
    else
        mode := "delay"    

    static arpX := 110
    static delX := 536 
    if (mode == "arp")
        MouseMove,%arpX%, 230, 0
    else if (mode == "delay")
        MouseMove,%delX%, 230, 0
    retrieveMouse := False      
}
; ------------

; -- Scroll Instruments ----------------------------------------
global scrollingInstr := False
global scrollInstrData := []
scrollInstrStart(initMode := "pianoRoll")
{
    scrollingInstr := True
    stopWinHistoryClock()
    MouseGetPos, mX, mY
    WinGet, prevWinId, ID, A
    ssId := StepSeq.bringWin(False)
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
    Sleep, 200
    WinMove, ahk_id %ssId%,, %newSsX%, %newSsY%,, %ssH%
    StepSeq.moveMouseToSelChan()
    scrollInstrData := [ssId, ssX, ssY, mX, mY, initMode, prevWinId]
    freezeMouse()

    msgX := 3
    msgY := 30     
    msg := "Click: chan  ^Click: pianoRoll   Esc: quit"
    toolTip(msg, toolTipIndex["scrollInstrToolTip"], msgX, msgY)
    unfreezeMouse()
}

scrollInstr(dir)
{
    if (StepSeq.isWin())
        StepSeq.scrollChannels(dir) 
    else
        scrollInstrQuit()    
}

scrollInstrStop(openTo := "pianoRoll")
{
    if (!StepSeq.mouseOverInstr())
    {
        scrollInstrQuit()
        return
    }    

    toolTip("", toolTipIndex["scrollInstrToolTip"])
    mX := scrollInstrData[4]
    mY := scrollInstrData[5]    
    freezeMouse()
    initMode := scrollInstrData[6]
    Switch openTo
    {
    Case "instr":
        StepSeq.bringChanUnderMouse()

    Case "pianoRoll":
        centerM := initMode != "pianoRoll"
        StepSeq.bringChanUnderMouseInPianoRoll(centerM)
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

scrollInstrQuit()
{
    toolTip("", toolTipIndex["scrollInstrToolTip"])
    mX := scrollInstrData[4]
    mY := scrollInstrData[5] 
    prevWinId := scrollInstrData[7]
    WinActivate, ahk_id %prevWinId%
    moveMouse(mX, mY)    
    scrollingInstr := False
    scrollInstrData := []
    startWinHistoryClock()
}
; -------------

; -- Panels -----------------------------------------------
cyclePanels()
{
    currPanel := getActivePanel()
    if (currPanel == 1)
    {
        coords := getWrenchCoords()
        wrenchX := coords[1]
        wrenchY := coords[2]
        quickClick(wrenchX, wrenchY)
        placeMouseOnArpOrDelay()
    }
    else
        quickClick(27, 50)    
}

getActivePanel()
{
    activeGrey := [0x31373B]
    if (colorsMatch(27, 31, activeGrey))
        panel := 1
    else if (colorsMatch(70, 31, activeGrey))
        panel := 2
    else if (colorsMatch(109, 30, activeGrey))
        panel := 3
    else if (colorsMatch(159, 31, activeGrey))
        panel := 4
    return panel
}

clickInstrMainPanel(checkIfOpen = True, centerM = True)
{
    x := 26
    y := 47
    if (checkIfOpen)
        alreadyOpen := colorsMatch(x, y, [0x8DFF7D], 40)
    if (!alreadyOpen or !checkIfOpen)
        quickClick(x, y)
    if (centerM)
        centerMouse()
}

clickInstrWrench()
{
    wrenchCoords := getWrenchCoords()
    wX := wrenchCoords[1]
    wY := wrenchCoords[2]     
    alreadyOpen := instrWrenchActivated(wX, wY)
    if (!alreadyOpen)
        quickClick(wX, wY)    
    return alreadyOpen
}

instrWrenchActivated(wX = "", wY = "")
{
    if (wX == "" or wY == "")
    {
        wrenchCoords := getWrenchCoords()
        wX := wrenchCoords[1]
        wY := wrenchCoords[2] 
    }
    green := [0x8DFF7D]
    return colorsMatch(wX, wY, green, 40)
}

getWrenchCoords()
{
    black := [0x21272B]
    y := 48
    x4 := 158
    x3 := 114
    x2 := 72
    if (!colorsMatch(x4, y, black))
        x := x4
    else if (!colorsMatch(x3, y, black))
        x := x3
    else if (!colorsMatch(x2, y, black))
        x := x2
    return [x, y]
}
; ------------




; -- Mouse Pos ----------------------------------------
mouseOnLeftWindowSide()
{
    MouseGetPos, mX, mY
    WinGet, id, ID, A
    WinGetPos,,, winW,, ahk_id %id%
    return mX < (winW/2)
}

mouseOnRightWindowSide()
{
    return !mouseOnLeftWindowSide()
}

mouseOverInstrMixerInsert()
{
    ; 3xosc's mixer track box is slightly offset from patcher for ex
    ; not precise, but quick
    winId := mouseGetPos(mX, mY)
    WinGetPos,,, instrW,, ahk_id %winId%
    return mY <= 59 and mX >= instrW-53 and mY >= 36 and mX <= instrW-13
}
; ------------


; ------------
openInstrInPianoRoll()
{
    WinGet, wasOpen, ID, ahk_class TStepSeqForm
    StepSeq.bringWin(False)
    StepSeq.moveMouseToSelChan()
    StepSeq.bringChanUnderMouseInPianoRoll()
    if (!wasOpen)
        WinClose, ahk_class TStepSeqForm
}

openInstrInMixer()
{
    if (instrHasNoMixerChannel())
        assignMixerTrack()
    else
        bringMixer()
}

instrHasNoMixerChannel()
{
    WinGetPos,,, instrW,, A
    drakSectionCol := [0x191f23]
    darkSectionY := scanColorsDown(instrW-30, 24, 5, drakSectionCol, 0, 1)
    darkSectionRightX := scanColorsRight(instrW-3, 40, 5, drakSectionCol, 0, -1)
    threeLinesY := darkSectionY + 20

    ;threeLinesY := 47  ;;; rel to upper grey bar
    charCols := [0xBAC7B1, 0xE2E0B5]
    ;threeLinesY := 47
    colVar := 20
    res := colorsMatch(darkSectionRightX-33, threeLinesY, charCols, colVar)            ; line 1
    if (res)
    {
        res :=  colorsMatch(darkSectionRightX-25, threeLinesY, charCols, colVar)       ; line 3
        if (res)
        {
            redCol := [0x7C464D]
            colVar := 5
            upperY := 40
            res := colorsMatch(darkSectionRightX-32, upperY, redCol, colVar)          ; up left red spot
            if (res)
            {
                res := colorsMatch(darkSectionRightX-21, upperY, redCol, colVar)      ; up right red spot
                if (res)
                {
                    lowerY := 53
                    res := colorsMatch(darkSectionRightX-22, lowerY, redCol, colVar)  ; down middle red spot
                }
            }
        }
    }
    return res
}
; ----


; -- patcher synth --------
mouseOnSynthUseShapesButtons()
{
    
    res := False
    winId := mouseGetPos(mX, mY)
    if (isWrapperPlugin(winId))
        offs := yOffsetWrapperPlugin
    else
        offs := 0
    if (mX > 253 and mx < 283 and mY < 228-offs and mY > 213-offs and isPlugin(winId))
        res := colorsMatch(mX, mY, [0x29632F])
    return res
}

synthUseShapes()
{
    buttonX := [173, 219, 270, 324, 381]
    buttonY := 253
    if (isWrapperPlugin("", True))
        buttonY -= yOffsetWrapperPlugin
    for _, x in buttonX
    {
        moveMouse(x, buttonY)
        Click, 2
    }
}
; ----
