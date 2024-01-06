;;;;;;;;;;; All wait functions using A_Now count only full seconds
;;;;;;;;;;; To have miliseconds, use A_TickCount


waitForUserToMakeTimeSelection(ByRef automX, ByRef automY)
{
    mouseGetPos(mX, _, "Screen")
    timelineStart := 541
    if (mX < timelineStart)
        mX := timelineStart
    moveMouse(mX, 137, "Screen")
    playlistToolTip("Make a time selection and accept")
    unfreezeMouse()
    waitAcceptAbort()
    freezeMouse()
    ToolTip
    mouseGetPos(automX, automY, "Screen")
}

global acceptPressed := True
global alternativeChoicePressed := True
global abortPressed := True
global clickAlsoAccepts := False
global acceptAbortSpecialKey := ""
waitAcceptAbort(pressEnterOrEsc := False, hint := False, specialKey := "", alternativeChoice := False)
{
    if (alternativeChoice)
        alternativeChoicePressed := False
    if (!acceptPressed or !abortPressed)
        return
        
    res := ""
   
    if (hint == True)
        hint := "Enter / Esc"

    acceptAbortSpecialKey := specialKey
    
    acceptPressed := False
    abortPressed := False

    while (!(acceptPressed or abortPressed or (alternativeChoice and alternativeChoicePressed)))
    {
        if (hint)
            toolTip(hint, toolTipIndex["acceptAbort"])
        if (acceptAbortSpecialKey != "")
        {
            acceptPressed := acceptPressed or GetKeyState(acceptAbortSpecialKey)
            Sleep, 100
        }
        else
            Sleep, 200
    }

    if (abortPressed)
    {
        res := "abort"
        if (pressEnterOrEsc)
            Send {Esc}
    }
    else if (acceptPressed)
    {
        res := "accept"
        if (pressEnterOrEsc)
            Send {Enter}
    }
    else if (alternativeChoicePressed)
        res := "alternative"

    acceptPressed := True
    abortPressed := True
    alternativeChoicePressed := True
    clickAlsoAccepts := False
    acceptAbortSpecialKey := ""
    if (hint)
        toolTip("", toolTipIndex["acceptAbort"])

    return res
}

; -- vision ----------------------------
waitCtxMenuUnderMouse()
{
    MouseGetPos, x, y
    y := y + 5
    x := x + 10
    result := waitForColor([x], [y], ctxMenuColors, 10, 1000)
    return result
}

/*
waitClipCtxMenu()
{
    MouseGetPos, x, y
    y := y + 140
    cols := [0xBDC2C6]
    result := waitForColor([x], [y], cols, 0, 2, False, True)
    return result    
}
*/

waitToolTip(msg := "", unfreezeExecuting := False)
{
    wasFreezeExecuting := freezeExecuting
    if (wasFreezeExecuting)
        unfreezeMouse()
    if (unfreezeExecuting)
        freezeExecuting := False
    res := "accept" == waitAcceptAbort(False, msg)
    if (unfreezeExecuting and wasFreezeExecuting)
        freezeExecuting := True
    if (wasFreezeExecuting)
        freezeMouse()
    return res
}

waitForColor(xList, yList, cols, colVar := 0, timeout := 2000, debug := False, reverse := False)
{
    t1 := A_TickCount
    if (debug)
        timeout = 10
    while (t2 - t1 < timeout)
    {
        for _, x in xList
        {
            for _, y in yList
            {
                matches := colorsMatch(x, y, cols, colVar, reverse)
                if (matches)
                    return True
            }
        }
        t2 := A_TickCount
        Sleep, 20
    }
    return False
}

waitforBrowserCtxMenu(isFolder)
{
    ctxMenuCol := [0xbdc6cb]
    Sleep, 10
    mouseGetPos(mX, mY)
    if (isFolder)
        xIncr := 159
    else
        xIncr := 249
    x := mX + xIncr
    yList := [mY+1, mY-1]
    res := waitForColor([x], yList, ctxMenuCol, 30, 750)
    return res
}

waitForWindowsCtxMenu()
{
    ctxMenuCol := [0Xf0f0f0]
    Sleep, 10
    mouseGetPos(mX, mY)
    x := mX + 5
    yList := [mY+2, mY-2]
    res := waitForColor([x], yList, ctxMenuCol, 30, 750)
    return res
}