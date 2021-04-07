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

moveWinIfOverPos(posX, posY, winID)
{
    global Mon1Left, Mon2Right
    WinGetPos, winX, winY, winW, winH, ahk_id %winID%
    movedWin := False
    winHoversOriPos := posX > winX and posX < winX+winW and posY > winY and posY < winY+winH
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