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
global abortPressed := True
global clickAlsoAccepts := False
global acceptAbortSpecialKey := ""
waitAcceptAbort(pressEnterOrEsc := False, hint := False, specialKey := "")
{
    if (!acceptPressed or !abortPressed)
        return
        
    res := ""
   
    if (hint == True)
        hint := "Enter / Esc"

    acceptAbortSpecialKey := specialKey
    
    acceptPressed := False
    abortPressed := False

    while (!(acceptPressed or abortPressed))
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

    acceptPressed := True
    abortPressed := True
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
    result := waitForColor(x, y, ctxMenuColors, 10, 1000, "")
    return result
}

/*
waitClipCtxMenu()
{
    MouseGetPos, x, y
    y := y + 140
    cols := [0xBDC2C6]
    result := waitForColor(x, y, cols, 0, 2, " ", False, True)
    return result    
}
*/

waitToolTip(msg := "")
{
    if (freezeExecuting)
        unfreezeMouse()
    res := "accept" == waitAcceptAbort(False, msg)
    if (freezeExecuting)
        freezeMouse()
    return res
}

waitForColor(x, y, cols, colVar := 0, timeout := 2000, hint := "", debug := False, reverse := False)
{
    t1 := A_TickCount
    if (debug)
        timeout = 10
    while (!matches and (t2 - t1 < timeout))
    {
        matches := colorsMatch(x, y, cols, colVar, hint, debug, reverse)
        t2 := A_TickCount
        Sleep, 20
    }
    return matches
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
    res := waitForColor(x, mY, ctxMenuCol, 100, 500)
    return res
}