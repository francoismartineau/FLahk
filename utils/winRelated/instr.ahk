; -- Wrench Panel ------------------------------------------
scrollWrenchPanel()
{
    goNextKnob := InStr(A_ThisHotkey, "Down") > 0
    MouseGetPos, mX, mY
    ;            x1           x2               x3          x4              x5
    ;  y1     1 arp mode
    ;  y2     2 [arp time]                  4 feed                       6 [pitch]
    ;  y3                 3 [chords]                    5[echodes]

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

    Switch index
    {
    Case 1:
        mX := 96
        mY := 197
    Case 2:
        mX := 110
        mY := 230    
    Case 3:
        mX := 303
        mY := 284    
    Case 4:
        mX := 347
        mY := 231    
    Case 5:
        mX := 401
        mY := 284    
    Case 6:
        mX := 494
        mY := 230    
    }  
    MouseMove, %mX%, %mY%, 0
}


setInstrDelaySpeed()
{
    alreadyOpen := clickInstrWrench()
    if (!delayActivated())
    {
        feed := expRand(.1, .9, 3)
        setKnobValue(350, 230, feed)    
    }

    delX := 536
    y := 228
    static vals := [1, .75, .5, .375, .25, .166666, .125, .083333, .0625, .041666, .03125]
    static choices := ["2    ", "1.5  ", "1       ---------  beat", "3/4  ", "1/2        ----", "1/3  ", "1/4        ----", "1/6  ", "1/8  ", "1/12 ", "1/16 "]
    
    MouseMove, %delX%, %y%, 0
    knobVal := copyKnob(False)
    MouseMove, %delX%, %y%, 0

    toolTipChoiceIndex := indexOfClosestValue(knobVal, vals)
    res := toolTipChoice(choices)
    if (res == "accept")
    {
        val := vals[toolTipChoiceIndex]
        pasteKnob(False, val, "other")
    }
    if (!alreadyOpen)
        clickInstrMainPanel()
}

setInstrArpSpeed()
{
    alreadyOpen := clickInstrWrench()
    if (!arpActivated())
    {
        setKnobValue(96, 196, randInt(1,4)/5)               ; dir
        setKnobValue(225, 284, randomChoice([0, 0.02222]))  ; chord
    }

    arpX := 110
    y := 228
    static vals := [0.998996990732849, 0.910732196643949, 0.786359077319503, 0.663991975598037, 0.575727181509137, 0.464393179538616, 0.371113340370357, 0.27382146474, 0.176529589109123]
    static choices := ["1       ---------  beat", "3/4  ", "1/2        ----", "1/3  ", "1/4        ----", "1/6  ", "1/8  ", "1/12 ","1/16 "]

    MouseMove, %arpX%, %y%, 0
    knobVal := copyKnob(False)
    MouseMove, %arpX%, %y%, 0

    toolTipChoiceIndex := indexOfClosestValue(knobVal, vals)
    res := toolTipChoice(choices)
    if (res == "accept")
    {
        val := vals[toolTipChoiceIndex]
        pasteKnob(False, val, "timeRelated")
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
    return colorsMatch(344, 243, [0x49bfef], 100)
}

;;;; deadcode for the moment
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
        QuickClick(x, y)
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
        QuickClick(wX, wY)    
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
    ; 3xosc's mixer track boxer is slightly offset from patcher for ex
    ; not precise, but quick
    MouseGetPos, mX, mY
    WinGetPos,,, instrW,, ahk_id %winId%
    return mY <= 59 and mX >= instrW-53 and mY >= 36 and mX <= instrW-13
}
; ------------




; ------------
openInstrInPianoRoll()
{
    bringStepSeq(False)
    moveMouseToSelY()
    openChannelUnderMouseInPianoRoll()
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
    debug := False
    drakSectionCol := [0x191f23]
    darkSectionY := scanColorDown(instrW-30, 24, 5, drakSectionCol, 0, 1)
    darkSectionRightX := scanColorRight(instrW-3, 40, 5, drakSectionCol, 0, -1)
    threeLinesY := darkSectionY + 20

    ;threeLinesY := 47  ;;; rel to upper grey bar
    charCols := [0xBAC7B1, 0xE2E0B5]
    ;threeLinesY := 47
    colVar := 20
    res := colorsMatch(darkSectionRightX-33, threeLinesY, charCols, colVar, "", debug)            ; line 1
    if (res)
    {
        res :=  colorsMatch(darkSectionRightX-25, threeLinesY, charCols, colVar, "", debug)       ; line 3
        if (res)
        {
            redCol := [0x7C464D]
            colVar := 5
            upperY := 40
            res := colorsMatch(darkSectionRightX-32, upperY, redCol, colVar, "", debug)          ; up left red spot
            if (res)
            {
                res := colorsMatch(darkSectionRightX-21, upperY, redCol, colVar, "", debug)      ; up right red spot
                if (res)
                {
                    lowerY := 53
                    res := colorsMatch(darkSectionRightX-22, lowerY, redCol, colVar, "", debug)  ; down middle red spot
                }
            }
        }
    }
    return res
}