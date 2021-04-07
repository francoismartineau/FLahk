CoordMode, ToolTip, Client
;ToolTipColor(0x80898E)
pianoRollToolTipShown := False
eventEditorToolTipShown := False
playlistToolTipShown := False
CoordMode, Mouse, Client
SetTitleMatchMode, 2
SetDefaultMouseSpeed, 2
FileEncoding, UTF-16            ; necessary to save strange win name to file

savedMouseX := 
savedMouseY := 
currentWindow :=
prevWindow :=

global retrieveMouse :=
sendEnterKeyToFL := True
clickUpDisabled := False
clipboardSave :=

SysGet, Mon2, Monitor, 0           ; right mon
SysGet, Mon1, Monitor, 1        ; left mon
global Mon1Width := Mon1Right - Mon1Left
global Mon1Height := Mon1Bottom - Mon1Top
global Mon2Width := Mon2Right - Mon2Left
global Mon2Height := Mon2Bottom - Mon2Top
global doubleClickTime := DllCall("User32\GetDoubleClickTime")

global freezeExecuting := False
global stopExec := False            ; Esc while freezeExecute will turn True. Long functions should check this bool from time to time and quit if True.


;;;; params: en faire le 2e paramètre et doit être une liste
freezeExecute(f, retrPos = True, retrWin = False, params*)
{
    global retrieveMouse, freezeExecuting
    res := 
    if (!freezeExecuting) {
        freezeExecuting := True
        retrieveMouse := retrPos
        retrieveWin := retrWin
        stopWinHistoryClock()
        freezeMouse()
        if (retrWin != False and retrWin != True)
        {
            msgBox("retrWin: " retrWin)
            return
        }

        if (retrieveMouse)
            saveMousePos()
        if (retrieveWin)
            WinGet, id, ID, A

        CoordMode, Mouse, Client    
        res := execFunc(f, params*)
        
        if (retrieveMouse)  ; can be switched off by f
            retrieveMousePos() 
        if (retrieveWin)
            WinActivate, ahk_id %id%

        unfreezeMouse()
        startWinHistoryClock()
        freezeExecuting := False
        stopExec := False
    }
    return res
}



startstopWinHistoryClock(f, params*)
{
    stopWinHistoryClock()
    res := execFunc(f, params*)
    startWinHistoryClock() 
    return res
}

execFunc(f, params*)
{
    res := 
    if (params.Length())
        res := %f%(params*)
    else 
        res := %f%()
    return res
}

freezeUnfreezeMouse(f, params*)
{
    freezeMouse()
    res := execFunc(f, params*) 
    unfreezeMouse()
    return res
}

unfreezeMouse()
{
    BlockInput, MouseMoveOff
}

freezeMouse()
{
    BlockInput, MouseMove
}

saveMousePos()
{
    global savedMouseX, savedMouseY
    CoordMode, Mouse, Screen
    MouseGetPos, savedMouseX, savedMouseY
    CoordMode, Mouse, Client
}

retrieveMousePos()
{
    global savedMouseX, savedMouseY, p_window
    CoordMode, Mouse, Screen
    MouseMove, savedMouseX, savedMouseY
    CoordMode, Mouse, Client
}


hideShowFLahk()
{
    global FLahkGuiId1, FLahkGuiId2 ;, FLahkBackgroundGuiId
    global leftScreenWindowsShown

    if (!WinExist("ahk_exe FL64.exe"))
        ExitApp    

    usingFL := WinActive("ahk_exe FL64.exe") or WinActive("ahk_id "FLahkGuiId1) or WinActive("ahk_id "FLahkGuiId2) or WinActive("ahk_class #32770 ahk_exe ahk.exe")
    FLahkOpen := FLahkIsOpen()
    maxedWin := rightScreenMaximizedWin()

    if (usingFL and !FLahkOpen and !maxedWin)
    {
        WinShow, ahk_id %FLahkGuiId1%
        WinShow, ahk_id %FLahkGuiId2%
        ;if (leftScreenWindowsShown)
        ;    WinActivate, ahk_id %FLahkBackgroundGuiId%
        WinActivate, ahk_exe FL64.exe
        startWinMenusClock()
        startWinHistoryClock()
        startMouseCtlClock()
    }
    else if ((!usingFL or maxedWin) and FLahkOpen)
    {
        ;WinHide, ahk_id %FLahkBackgroundGuiId%
        WinHide, ahk_id %FLahkGuiId1%
        WinHide, ahk_id %FLahkGuiId2%
        stopWinMenusClock()
        stopWinHistoryClock()
        stopMouseCtlClock()
    }
}

rightScreenMaximizedWin()
{
    WinGet, winId, ID, A
    WinGetPos, winX, winY, winW, winH, ahk_id %winId%
    return winX == 0 and winY == 0 and !isMainFlWindow(winId) and winW == Mon2Width and winH == Mon2Height
}

FLahkIsOpen()
{
    WinGet, Style, Style, ahk_id %FLahkGuiId1%
    Transform, Result1, BitAnd, %Style%, 0x10000000 ; 0x10000000  = is WS_VISIBLE.
    WinGet, Style, Style, ahk_id %FLahkGuiId2%
    Transform, Result2, BitAnd, %Style%, 0x10000000
    return Result1 <> 0 and Result2 <> 0
}

/*
minimize()
{
    WinMinimizeAll, ahk_exe FL64.exe
    WinHide, FLahk
    WinHide, FLahk backgroundWindow
}
restoreMaximize()
{
    global FL_IS_MAXIMIZED
    if (FL_IS_MAXIMIZED)
    {
        WinRestore, ahk_class TFruityLoopsMainForm
        FL_IS_MAXIMIZED := false
        WinHide, FLahk backgroundWindow
    }
    else
    {
        WinMaximize, ahk_class TFruityLoopsMainForm
        FL_IS_MAXIMIZED := true
        WinShow, FLahk backgroundWindow
    }
}

quit() {
    freezeMouse()
    WinGet, id, ID, A
    WinClose, ahk_class TFruityLoopsMainForm
    Sleep, 100
    WinActivate, ahk_class TMsgForm
    MouseMove, 98, 153
    unfreezeMouse()
    ExitApp
}
*/

bringFLwindowUnderMouse() {
    MouseGetPos,,, WinUMid
    WinGet, exe, ProcessName, ahk_id %WinUMid%
    if (exe == "FL64.exe" and !isOneOfMainWindows(WinUMid)) {
        WinGetClass, class, ahk_id %WinUMid%
        if (class != "TFruityLoopsMainForm")
            WinActivate, ahk_id %WinUMid%
    }
}

keepNumLockOn() {
    if (!GetKeyState("NumLock", "T"))
        SetNumLockState, On
}
