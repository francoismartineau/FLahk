global browserPosCount := 40
global browserPos := Floor(browserPosCount / 2)
global browserLeft := 0
global browserRight := 239  
global browserTop := 24 ;130

;-121, 24     -135, 983     

browserMove(dir, n = 1)
{
    lastBrowserTime := A_Now
    WinActivate, ahk_class TFruityLoopsMainForm
    ;removeWinsFromBrowser()

    Switch dir
    {
    Case "up":
        posAfterLimitReached := 5
        wheel := "WheelUp"
        n := -n
    Case "down":
        posAfterLimitReached := 35
        wheel := "WheelDown"    
    }

    browserPos := browserPos + n
    if (browserPos > browserPosCount or browserPos < 1)
    {
        browserPos := posAfterLimitReached
        sendWheelWithoutShift(wheel)
    }

    x := 75
    y := getBrowserPosY(browserPos)
    MouseMove %x%, %y%
}

sendWheelWithoutShift(wheel)
{
    GetKeyState, shiftState, Shift
    if (shiftState == "D")
        Send {Shift up}        
    Send {%wheel%}
    if (shiftState == "D")
        Send {Shift down}  
}

getBrowserPosY(browserPos)
{
    return 142 + (browserPos-1) * 23
}

mouseOverBrowser()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY, winID
    CoordMode, Mouse, Client
    if (isMainFlWindow(winId))
    {
        WinGetPos, winX, winY, winW, winH, ahk_id %winID%
        mouseX := mouseX - winX
        mouseY := mouseY - winY  
        res :=  mouseX >= browserLeft and mouseX <= browserRight and mouseY >= browserTop   
    }
    return res     
}

clickBrowser()
{
    MouseGetPos,,, winId
    if (!isMainFlWindow(winId))
        WinMove, ahk_id %winId%,, %browserRight%
    Click
}
