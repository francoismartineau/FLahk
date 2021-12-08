global mouseInRightMon := True
obsCheckMousePosTick()
{
    prevMode := setMouseCoordMode("Screen")
    MouseGetPos, mX
    setMouseCoordMode(prevMode)
    if (mouseInRightMon and mX < 0)
    {
        ;toolTip("left")
        mouseInRightMon := False
        ControlSend,, {NumpadMult}, ahk_class Qt5152QWindowIcon
    }
    else if (!mouseInRightMon and mX >= 0)
    {
        ;toolTip("right")
        mouseInRightMon := True
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