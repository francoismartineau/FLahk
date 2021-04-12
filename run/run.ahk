CoordMode, ToolTip, Client
CoordMode, Mouse, Client
CoordMode, Pixel, Client
global pixelCoordMode := "Client"

SetTitleMatchMode, 2
SetDefaultMouseSpeed, 2
FileEncoding, UTF-16

global Mon1
global Mon2
SysGet, Mon2, Monitor, 0        ; Mon2: Right
SysGet, Mon1, Monitor, 1        ; Mon1: Left
global Mon1Width := Mon1Right - Mon1Left
global Mon1Height := Mon1Bottom - Mon1Top
global Mon2Width := Mon2Right - Mon2Left
global Mon2Height := Mon2Bottom - Mon2Top

global savedMouseX := 
global savedMouseY := 
global retrieveMouse :=
global doubleClickTime := DllCall("User32\GetDoubleClickTime")
global currentWindow :=
global clipboardSave :=

global freezeExecuting := False
global stopExec := False     ; Esc while freezeExecute will turn True. Long functions should check this bool from time to time and quit if True.


; ---- Run functions -------------------------------------------
freezeExecute(f, retrPos = True, retrWin = False, params*)  ; Change the signature: f, [params], pos, win)
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
; ----

; ---- Mouse ---------------------------------------
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
; ----