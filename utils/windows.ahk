getFlWindows()
{
   flWins := []
   WinGet, wins, List
   Loop, %wins%
   {
      id := wins%A_Index%
      WinGet, exe, ProcessName, ahk_id %id%
      if (exe == "FL64.exe")
         flWins.Push(id)
   }
   return flWins
}

/*
closeAllWrapperPlugins()
{
   WinGet, wins, List
   Loop, %wins%
   {
      id := wins%A_Index%
      if (isWrapperPlugin(id))
        WinClose, ahk_id %id%
   }    
}
*/

moveWinIfOverPos(posX, posY, winID)
{
    global Mon1Left, Mon2Right
    WinGetPos, winX, winY, winW, winH, ahk_id %winID%
    movedWin := False
    winHoversOriPos := posX >= winX and posX <= winX+winW and posY >= winY and posY <= winY+winH
    if (winHoversOriPos)
    {
        if (posX + 10 + winW > Mon2Right)
            tempX := Mon1Left
        else
            tempX := posX + 10
        WinMove, ahk_id %winID%,, %tempX%, %winY%
        movedWin := True
    }
    return movedWin
}

isVisible(winId)
{
    WinGet, Style, Style, ahk_id %winId%
    Transform, res, BitAnd, %Style%, 0x10000000
    return res <> 0
}

makeSureWinInMonitor(winId)
{
    WinGetPos, winX, winY, winW, winH, ahk_id %winId%
    if (winX >= Mon2Left)
    {
        if (winX+winW > Mon2Right or winY < Mon2Top or winY+winH > Mon2Bottom)
        {
            winX := Mon2Width/2 - winW/2
            winY := Mon2Height/2 - winH/2
            WinMove, ahk_id %winId%,, %winX%, %winY%, %winW%, %winH%
        }
    }
    else if (winX >= Mon1Left)
    {
        if (winX+winW > Mon1Right or winY < Mon1Top or winY+winH > Mon1Bottom)
        {
            winX := Mon1Width/2 - winW/2
            winY := Mon1Height/2 - winH/2
            WinMove, ahk_id %winId%,, %winX%, %winY%, %winW%, %winH%
        }
    }    
}

restoreWin(winId := "")
{
    if (winId == "")
        WinGet, winId, ID, A

    if (!isFLWindow(winId))
        return

    WinGet, WinState, MinMax, ahk_id %winId%
    ;if (isMainFlWindow(winId) or isPianoRoll(winId) and WinState != 1)
    ;{
    ;    WinMaximize, ahk_id %winId%
    ;    return
    ;}

    WinGetPos,,, winW, winH, ahk_id %winId%
    if (WinState == 1)  ; maximized
        WinRestore, ahk_id %winId%
    else if (winH < 40) ; FL minimized
    {
        moveMouse(winW-50, 20)
        Click           ; click bar button
    }
}

moveWinAtMouse(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    prevMode := setMouseCoordMode("Screen")
    MouseGetPos, mX, mY
    setMouseCoordMode(prevMode)
    WinGetPos,,, winW, winH, ahk_id %id%
    winX := mX - winW/2
    winY := mY - winH/2
    WinMove, ahk_id %id%,, winX, winY
}

; -- left screen -----------------------------------
toggleLeftScreenWindows()
{
    stopWinHistoryClock()
    global leftScreenWindowsShown
    if (leftScreenWindowsShown)
        turnOffLeftScreenWindows()
    else
        freezeExecute("turnOnLeftScreenWindows")
    startWinHistoryClock()
}

turnOffLeftScreenWindows()
{
    global leftScreenWindowsShown ;, BackgroundWindow
    ;Gui, BackgroundWindow:Hide    
    flWins := getFlWindows()
    for i, winId in flWins
    {
        WinGetPos, x,,,, ahk_id %winId%
        if (x < 0)
            WinClose, ahk_id %winId%
    }
    leftScreenWindowsShown := False
    bringFL()
}

turnOnLeftScreenWindows()
{
    global leftScreenWindowsShown
    leftScreenWindowsShown := True
    ;;;;;showBackgroundWindow()
    bringMixer(False)
    bringMasterEdison(False)
}