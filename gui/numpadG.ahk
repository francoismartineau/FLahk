global NumpadGId
global numpadGShown
global numpadGMousePos := []

global numpadGbuttW := 70
global numpadGbuttH := 50

global numpadGColQty := 4
global numpadGRowQty := 5

makeNumpadG()
{
    Gui, NumpadG:New   
    Gui, NumpadG:-Caption +E0x08000000 +E0x20 +AlwaysOnTop +LastFound +ToolWindow +HwndNumpadGId
    Gui, NumpadG:Color, %mainMenusColor%
    posX := 10
    posY := 10
    width := numpadGbuttW-5
    height := numpadGbuttH-5
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_1, c min max
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_2, c link
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_3, Main Events
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_4, note

    posX := 10
    posY += numpadGbuttH
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_5, EC
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_6, mIze
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_7, 
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_8, step edit

    posX := 10
    posY += numpadGbuttH
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_9, LFO
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_10, Make Unique
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_11, Sel Sim
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height%gNUMPAD_G_12,

    posX := 10
    posY += numpadGbuttH
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_13, Autom
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_14, Source
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_15, Reverse
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_16, Layer

    posX := 10
    posY += numpadGbuttH
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_17, Note len
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_18, Lock chan
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_19, Idea
    posX += numpadGbuttW
    Gui, NumpadG:Add, Button, x%posX% y%posY% w%width% h%height% gNUMPAD_G_20,
    return 

    NUMPAD_G_1:                                 ; c min max
    hideNumpadG()
    freezeExecute("Knob.linkApplyMinMax")
    return
    NUMPAD_G_2:                                 ; c link
    hideNumpadG()
    freezeExecute("Knob.pickLink") 
    return
    NUMPAD_G_3:                                 ; Main Events
    hideNumpadG()
    freezeExecute("toggleMainEvents")
    return
    NUMPAD_G_4:                                 ; note
    hideNumpadG()
    freezeExecute("loadScore", [2], True, True)
    return

    NUMPAD_G_5:                                 ; EC
    hideNumpadG()
    freezeExecute("EnvC.applyCtl")
    return
    NUMPAD_G_6:                                 ; mIze currChan
    hideNumpadG()
    freezeExecute("EnvC.mIzeCurrChan")
    return
    NUMPAD_G_7:
    hideNumpadG()
    return
    NUMPAD_G_8:                                 ; step edit
    hideNumpadG()
    freezeExecute("toggleStepEdit") 
    return    

    NUMPAD_G_9:                                 ; LFO
    hideNumpadG()
    freezeExecute("LFO")
    return
    NUMPAD_G_10:                                ; Make Unique
    hideNumpadG()
    freezeExecute("makeUnique")
    return
    NUMPAD_G_11:                                ; Select similar clips
    hideNumpadG()
    freezeExecute("selectSimilarClips")
    return
    NUMPAD_G_12:
    hideNumpadG()
    return


    NUMPAD_G_13:                                 ; Autom
    hideNumpadG()
    freezeExecute("Knob.createAutomation")
    return
    NUMPAD_G_14:                                ; source
    hideNumpadG()
    freezeExecute("selectSourceForAllSelectedClips")
    return
    NUMPAD_G_15:                                ; reverse sound
    hideNumpadG()
    freezeExecute("reverseSound")
    return
    NUMPAD_G_16:                                ; Layer
    hideNumpadG()
    freezeExecute("Layer")
    return    

    NUMPAD_G_17:                                ; Note length
    hideNumpadG()
    freezeExecute("toggleHoveredNoteLenght", [], True, True)       
    return    

    NUMPAD_G_18:                                ; Lock channel
    hideNumpadG()
    if (StepSeq.mouseOverInstr())
        freezeExecute("lockChan")
    else if (isInstr())
        freezeExecute("lockChanFromInstrWin")
    return    

    NUMPAD_G_19:                                ;
        displayRandomIdea()
    return

    NUMPAD_G_20:                                ;
    return
}

showNumpadG()
{
    if (!numpadGShown)
    {
        mouseGetPos(mX, mY, "Screen")
        numpadGMousePos := [mX, mY]
        numpadGShown := True
    }    
    else
    {
        mX := numpadGMousePos[1]
        mY := numpadGMousePos[2]
        moveMouse(mX, mY, "Screen")
    }
    Gui, NumpadG:Show, x%mX% y%mY% NoActivate, NumpadG
    placeNumpadG()
    showNumpadGToolTip()
    row := Floor(numpadGRowQty/2) ;randInt(1, numpadGRowQty)
    col := Floor(numpadGColQty/2) ;randInt(1, numpadGColQty)
    placeMouseOnNumpadG(row, col)
}

showNumpadGToolTip()
{
    WinGetPos, winX, winY,,, ahk_id %NumpadGId%
    tipX := winX
    tipY := winY - 20
    tipMsg := "+ vertical   +! horizontal        Rclick"
    setToolTipCoordMode("Screen")
    ToolTip, %tipMsg%, %tipX%, %tipY%, 2
}

placeNumpadG()
{
    WinGetPos, winX, winY, winW, winH, ahk_id %NumpadGId%
    if (winX < 0)
    {
        if (winY + winH > Mon1Bottom)
        {
            winY := Mon1Bottom - winH
            WinMove, ahk_id %NumpadGId%,, %winX%, %winY%
        }
        if (winX + winW > 0)
        {
            winX := -winW
            WinMove, ahk_id %NumpadGId%,, %winX%, %winY%
        }
    }
    else
    {
        if (winY + winH > Mon2Bottom)
        {
            winY := Mon2Bottom - winH
            WinMove, ahk_id %NumpadGId%,, %winX%, %winY%
        }      
        if (winX + winW > Mon2Right)
        {
            winX := Mon2Right - winW
            WinMove, ahk_id %NumpadGId%,, %winX%, %winY%
        }          
    }
}

hideNumpadG()
{
    setToolTipCoordMode("Client")
    ToolTip,,,, 2
    Gui, NumpadG:Hide
    numpadGShown := False
    moveMouse(numpadGMousePos[1], numpadGMousePos[2], "Screen")
    retrieveMouse := False
}

; -- scroll --------------------------
numpadGScroll(dir)
{
    WinGetPos, winX, winY, winW, winH, ahk_id %NumpadGId%
    leftButtLimit := winX + 10
    rightButtLimit := winX + winW - 10
    upButtLimit := winY + 10
    downButtLimit := winY + winH - 10

    res := numpadGFindCurrentPos(winX, winY, winW, winH, leftButtLimit, rightButtLimit, upButtLimit, downButtLimit)
    col := res[1]
    row := res[2]

    if (dir == "next")
    {
        col += 1
        if (col > numpadGColQty)
        {
            col := 1
            row += 1
            if (row > numpadGRowQty)
                row := 1
        }
    }
    else if (dir == "prev")
    {
        col -= 1
        if (col < 1)
        {
            col := numpadGColQty
            row -= 1
            if (row < 1)
                row := numpadGRowQty
        }
    }
    else if (dir == "left")
    {
        col -= 1
        if (col < 1)
            col := numpadGColQty
    }
    else if (dir == "right")
    {
        col += 1
        if (col > numpadGColQty)
            col := 1
    }
    else if (dir == "up")
    {
        row -= 1
        if (row < 1)
            row := numpadGRowQty
    }
    else if (dir == "down")
    {
        row += 1
        if (row > numpadGRowQty)
            row := 1
    }
    placeMouseOnNumpadG(row, col)
}

numpadGFindCurrentPos(winX, winY, winW, winH, leftButtLimit, rightButtLimit, upButtLimit, downButtLimit)
{
    mouseGetPos(mX, mY, "Screen")
    if (mX < leftButtLimit)
        col := 1
    else if (mx > rightButtLimit)
        col := numpadGColQty
    else
        col := Ceil((mX - winX) / (winW / numpadGColQty))

    if (mY < upButtLimit)
        row := 1
    else if (mY > downButtLimit)
        row := numpadGRowQty
    else
        row := Ceil((mY - winY)  / (winH / numpadGRowQty))
    
    return [col, row]
}

placeMouseOnNumpadG(row, col)
{
    WinGetPos, winX, winY,, winH, ahk_id %NumpadGId%
    mX := winX + 10 + numpadGbuttW/2 + (col-1)*numpadGbuttW
    mY := winY + 10 + numpadGbuttH/2 + (row-1)*numpadGbuttH
    moveMouse(mX, mY, "Screen")
}