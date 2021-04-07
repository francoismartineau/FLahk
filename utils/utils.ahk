removeBreakLines(text)
{
    return RegExReplace(text,"\.? *(\n|\r)+","")
}

centerMouse(winId = "", speed = 1.5)
{
    if (winId == "")
        WinGet, winId, ID, A

    CoordMode, Mouse, Screen
    WinGetPos, winX, winY, winW, winH, ahk_id %winId%
    MouseGetPos, currMouseX

    if (isMixer(winId))
    {
        mX := 1747
        mY := mixerSlotIndexToY(mixerSlotIndex)
    }
    else if (isStepSeq(winId))
    {
        mX := 220
        mY := getFirstSelChannelY() + 10      
    }
    else if (isPianoRoll(winId))
    {
        loop := [98, 12]
        notes := [261, 464]
        menu := [302, 823 ]
        loc := weightedRandomChoice([[loop,2], [notes,4], [menu, 1]])
        mX := loc[1]
        mY := loc[2]
    }
    else if (isRev())
    {
        mX := 506
        mY := 67        
    }
    else if (isPatcherSlicex(winId))
    {
        mX := 165
        mY := 419
    }
    else if (isPatcherSampler(winId))
    {
        mX := 126
        mY := 153        
    }
    else if (isDistructor(winId))
    {
        mX := 878
        mY := 55           
    }
    else
    {
        mX := winW/2
        mY := winH/2
    }
    mX := mX + winX
    mY := mY + winY
    moveMouse(mX, mY, "Screen", speed)
    CoordMode, Mouse, Client

    global retrieveMouse
    retrieveMouse := False
}

playlistToolTip(msg)
{
    Tooltip, %msg%, 240, 60
}


doubleClicked()
{
    global doubleClickTime
    return A_PriorHotkey == "~LButton" and A_TimeSincePriorHotkey <= doubleClickTime
}

winCoordsToScreenCoords(x, y)
{
    WinGetPos, winX, winY,,, A
    return [winX+x, winY+y]
}

QuickClick(x, y, param = "")
{
    MouseMove, %x%, %y%, 0
    Click, %param%
}

keyIsDown(key) {
    GetKeyState, ks, %key%
    return ks == "D"
}

mouseOverKnobsWin()
{
    MouseGetPos,,, winId
    return isPlugin(winId) or isMixer(winId) or isWrapperPlugin(winId) ;or isStepSeq(winId) non parce que copy score
}

insertPattern(copyName = False)
{
    WinGet, winId, ID, A
    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY
    pluginOpen := isPlugin(winId)
    if (pluginOpen)
        bringPlaylist(False)
    copyName("")
    moveMouse(mX, mY)
    CoordMode, Mouse, Client
    Send {ShiftDown}{F4}{ShiftUp}
    nameEditorId := waitNewWindowOfClass("TNameEditForm", winId)
    if (copyName)
    {
        pasteName("", False)
        Send {F2}
    }
    else
        pasteColor(nameEditorId, False)
    if (pluginOpen)
        bringHistoryWins()

    WinGetPos,,, neW, neH, ahk_id %nameEditorId%
    neX := mX - Floor(neW/2)
    neY := mY - Floor(neH/2)
    WinMove, ahk_id %nameEditorId%,, %neX%, %neY%
    WinActivate, ahk_id %nameEditorId%
    if (!copyName)
    {
        typeText(randString(3))
        ;Send {CtrlDown}a{CtrlUp}
    }
    centerMouse(nameEditorId)
}


renderInPlace()
{
    mixerId := bringMixer(False)
    diskRecX := 83
    diskRecY := 423
    if (colorsMatch(82, 418, [0xB0B7BA], 20))      ; not armed ?
    {
        moveMouse(diskRecX, diskRecY)
        Sleep, 100
        Click         
    }
    SendInput !r
    exportWinId := waitNewWindow(mixerId)
    moveMouse(244, 68)
    waitAcceptAbort(True, True)
    toolTip("rendering")
    waitNewWindow(exportWinId, 10000)
    toolTip()
    bringMixer(False)
    moveMouse(diskRecX, diskRecY)
    Sleep, 100
    Click     
}


moveMouse(x, y, mode = "Client", speed = 0)
{
    CoordMode, Mouse, Screen
    static := betweenScreensX := 0
    static := betweenScreensY := 870

    if (mode == "Client")
    {
        WinGetPos, winX, winY,,, A
        x := winX + x
        y := winY + y
    }

    MouseGetPos, mx
    crossScreen := (mx < 0 and x > 0) or (x < 0 and mx > 0)
    if (crossScreen)
    {
        MouseMove, %betweenScreensX%, %betweenScreensY%, %speed%
        MouseMove, %x%, %betweenScreensY%, %speed%
    }

    MouseMove, %x%, %y%, %speed%

    CoordMode, Mouse, Client
}


mouseOverEventEditorZoomSection()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mx, my, winId
    CoordMode, Mouse, Client

    if (isEventEditForm(winId))
    {
        WinGetPos, winX, winY,,, ahk_id %winId%
        mx := mx - winX
        my := my - winY
        if (isPlaylist(winId))
        {
            res := 278 < mx and 48 < my
        }
        else if (isPianoRoll(winId))
        {
            res := 72 < mx and 44 < my and mx < 1897 and my < 810     

        }
        else if (isEventEditor(winId))
        {
            res := mx < 1910 and 49 < my
        }
    }
    return res
}

openAudacity()
{
    Run, "C:\Program Files (x86)\Audacity\audacity.exe"
    WinGet, id, ID, A
    waitNewWindowOfClass(id, "wxWindowNR")
    audacityId := WinExist("Audacity ahk_exe audacity.exe ahk_class wxWindowNR")
    WinClose, Master Edison
    WinRestore, ahk_id %audacityId%
    WinActivate, ahk_id %audacityId%
    WinMove, ahk_id %audacityId%,, -1928, 565, 1936, 469
    centerMouse(audacityId)   
}

sendDelete()
{
    waitForModifierKeys()
    isMEd := isMasterEdison()
    if (isMEd)
    {
        MouseGetPos, mX, mY
        moveMouse(1761, 20)
        Click
    }
    Send {Delete}
    if (isMEd)
    {
        moveMouse(1761, 20)
        Click
        moveMouse(mX, mY)
    }
}