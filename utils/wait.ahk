;;;;;;;;;;; All wait functions using A_Now count only full seconds
;;;;;;;;;;; To have miliseconds, use A_TickCount


waitForUserToMakeTimeSelection()
{
    MouseGetPos, mX
    moveMouse(mX, 60)
    playlistToolTip("Make a time selection and accept")
    unfreezeMouse()
    waitAcceptAbort()
    freezeMouse()
    ToolTip
    MouseGetPos, timeSelEndX
    return timeSelEndX
}

waitForModifierKeys()
{
    if (getKeyState("Ctrl", "D"))
        KeyWait, Ctrl
    if (getKeyState("Alt", "D"))
        KeyWait, Alt
    if (getKeyState("Shift", "D"))
        KeyWait, Shift
    if (getKeyState("LWin", "D"))
        KeyWait, LWin
}

waitKey(key)
{
    if (getKeyState(key, "D"))
        KeyWait, %key%    
}

global acceptPressed := True
global abortPressed := True
global clickAlsoAccepts := False
global acceptedWithClick := False
global winAlsoAccepts := False
global acceptAbortSpecialKey := ""
waitAcceptAbort(pressEnterOrEsc = False, hint = False, specialKey = "")
{
    acceptedWithClick := False    
    res := ""
   
    if (hint)
        toolTip("Enter / Esc")   

    acceptAbortSpecialKey := specialKey
    
    acceptPressed := False
    abortPressed := False

    while (!(acceptPressed or abortPressed))
    {
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
    winAlsoAccepts := False
    acceptAbortSpecialKey := ""
    if (hint)
        toolTip("")

    return res
}

; -- windows ---------------------------
waitNewWindow(currWinId, timeout = 3000)
{
    WinGet, id , ID, A
    t1 := A_TickCount
    t2 := A_TickCount
    while (id == currWinId and (t2 - t1 <= timeout))
    {
        Sleep, 10
        WinGet, id , ID, A
        t2 := A_TickCount
    }
    if (currWinId == id)
        id := ""
    return id
}

waitNewWindowTitled(title, currWinId, timeout = 3000)
{
    t1 := A_TickCount
    t2 := t1
    while ((!InStr(resTitle, title) or id == currWinId) and (t2 - t1 <= timeout))
    {
        Sleep, 10        
        WinGetTitle, resTitle, A
        WinGet, id , ID, A
        t2 := A_TickCount
    }
    if (InStr(resTitle, title))
        WinGet, id , ID, A
    else
        id := ""
    return id
}

waitWindowNotOfClass(class, timeout = 3000)
{
    t1 := A_TickCount
    t2 := t1
    while (InStr(resClass, class) and (t2 - t1 <= timeout))
    {
        toolTip("InStr(" resClass ", " class ") == " True)
        Sleep, 10        
        WinGetClass, resClass, A
        WinGet, id , ID, A
        t2 := A_TickCount
    }
    if (resClass != class)
        WinGet, id , ID, A
    else
        id := ""
    return id    
}

waitNewWindowOfClass(class, currWinId, timeout = 3000)
{
    t1 := A_TickCount
    t2 := t1
    while ((!InStr(resClass, class) or id == currWinId) and (t2 - t1 <= timeout))
    {
        Sleep, 10        
        WinGetClass, resClass, A
        WinGet, id , ID, A
        t2 := A_TickCount
    }
    if (resClass == class)
        WinGet, id , ID, A
    else
        id := ""
    return id
}

waitNewWindowOfProcess(exe, currWinId, timeout = 3000)
{
    t1 := A_TickCount
    t2 := t1
    while ((!InStr(resExe, exe) or id == currWinId) and (t2 - t1 <= timeout))
    {
        Sleep, 10   
        WinGet, resExe, ProcessName, A
        WinGet, id , ID, A
        t2 := A_TickCount
    }
    if (resExe == exe)
        WinGet, id , ID, A
    else
        id := ""
    return id
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

waitForColor(x, y, cols, colVar = 0, timeout = 2000, hint = " ", debug = False, reverse = False) {
    t1 := A_TickCount
    if (debug)
        timeout = 10
    while (!matches and (t2 - t1 < timeout)) {
        matches := colorsMatch(x, y, cols, colVar, hint, debug, reverse)
        t2 := A_TickCount
        Sleep, 20
    }
    return matches
}

