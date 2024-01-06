global secondMouseMoveCounter := 0
global secondMouseMidiMode := False
global sencondMouseX
global sencondMouseY

secondMouseMove(diffX, diffY) 
{
    ;if (secondMouseY < 0 )
    ;{
    ;    mouseGetPos(mX, mY, "Screen")
    ;    secondMouseX := mX
    ;    secondMouseY := mY
    ;}
    
    if (!secondMouseMidiMode)
    {
        secondMouseX := secondMouseX + diffX/3
        secondMouseY := secondMouseY + diffY/3
        keepSecondMouseInBoundaries()
        showSecondMouse() 
    }
    else
        onMouseCtlMove(_, diffY)
}

keepSecondMouseInBoundaries()
{
    if (secondMouseX >= Mon2Left)
    {
        if (secondMouseX > Mon2Right - mouseCursorW)
            secondMouseX := Mon2Right - mouseCursorW
        if (secondMouseY < Mon2Top)
            secondMouseY := Mon2Top
        else if (secondMouseY > Mon2Bottom - mouseCursorH)
            secondMouseY := Mon2Bottom - mouseCursorH
    }
    else
    {
        if (secondMouseX < Mon1Left)
            secondMouseX := Mon1Left
        if (secondMouseY < Mon1Top)
            secondMouseY := Mon1Top
        else if (secondMouseY > Mon1Bottom - mouseCursorH)
            secondMouseY := Mon1Bottom - mouseCursorH

    }
}

showSecondMouse()
{
    Gui, MouseCursor:Show, x%secondMouseX% y%secondMouseY% w%mouseCursorW% h%mouseCursorH% NoActivate,
}

hideSecondMouse()
{
    ;Gui, MouseCursor:Show, x0 y100
    Gui, MouseCursor:Hide
}


secondMouseLButton(clickDown)
{
    if (clickDown)
    {
        if (!secondMouseMidiMode)
        {
            saveMousePos()
            secondMouseMidiMode := True
            Gui, MouseCursor:Color, 0xAA0000
            showSecondMouse()
            freezeExecute("secondMouseKnobSetMouseCtl")

        }
        else 
        {
            freezeExecute("secondMouseResetMouseCtl")
            Gui, MouseCursor:Color, 0x596267
            showSecondMouse()
            secondMouseMidiMode := False
        }
    }
}

secondMouseRButton(clickDown)
{
    secondMouseLButton(clickDown)
}

; -----
global secondMouseKnobWinId := ""
global secondMouseKnobWinTitle := ""
secondMouseKnobSetMouseCtl()
{
    WinGetPos, oriWinX, oriWinY,,, A
    winX := oriWinX
    winY := oriWinY
    knobX := secondMouseX - winX
    knobY := secondMouseY - winY
    WinGet, secondMouseKnobWinId, ID, A
    WinGetTitle, secondMouseKnobWinTitle, ahk_id %secondMouseKnobWinId%
    /*   moveWinIf became a private CtxMenu func
    movedWin := moveKnobWinIfNecessary(knobX, knobY, secondMouseKnobWinId)
    if (movedWin)
    {
        WinGetPos, winX, winY,,, ahk_id %secondMouseKnobWinId%
        mX := knobX + winX
        mY := knobY + winY
    }
    else
    {
        mX := secondMouseX-2
        mY := secondMouseY
    }
    */

    moveMouse(mX, mY, "Screen")
    CtxMenu.dontMoveWin := True
    Knob.openLinkWin()
    CtxMenu.dontMoveWin := False


    if (movedWin)
        WinMove, ahk_id %secondMouseKnobWinId%,, %oriWinX%, %oriWinY%
    onMouseCtlMove(0, 1)
}

secondMouseResetMouseCtl()
{
    if (WinExist("ahk_id " secondMouseKnobWinId))
    {
        WinActivate, %secondMouseKnobWinTitle%
        moveMouse(secondMouseX-2, secondMouseY, "Screen")
        Knob.resetLink()
        secondMouseKnobWinId := ""
        secondMouseKnobWinTitle := ""
    }
    else
        msg(secondMouseKnobWinTitle " is closed.")
}