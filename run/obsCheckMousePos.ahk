global mouseCurrentMon := "Center"
obsCheckMousePosTick()
{
    prevMode := setMouseCoordMode("Screen")
    MouseGetPos, mX
    setMouseCoordMode(prevMode)
    if (mouseCurrentMon != "Left" and mX < Mon1Right)
    {
        ; toolTip("left")
        mouseCurrentMon := "Left"
        ControlSend,, {NumpadMult}, ahk_class Qt5152QWindowIcon
    }
    else if (mouseCurrentMon != "Center" and mX > Mon1Right and mX < Mon2Right)
    {
        ; toolTip("center")
        mouseCurrentMon := "Center"
        ControlSend,, {NumLock}, ahk_class Qt5152QWindowIcon
    }   
    else if (mouseCurrentMon != "Right" and mX > Mon2Right)
    {
        ; toolTip("right")
        mouseCurrentMon := "Right"
        ControlSend,, {NumpadSub}, ahk_class Qt5152QWindowIcon
    }
}


global obsClockRunning := False
startStopObsClock()
{
    if (!obsClockRunning and WinExist("ahk_exe obs64.exe"))
    {
        obsClockRunning := True
        startObsClock()
    }
    else if (obsClockRunning and !WinExist("ahk_exe obs64.exe"))
    {
        stopObsClock()
        obsClockRunning := False
    }
}