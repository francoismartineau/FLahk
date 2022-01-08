
SetTitleMatchMode, 2
SetDefaultMouseSpeed, 2

global Mon1Right
global Mon2Right
global Mon1Left
global Mon2Left
global Mon1Top
global Mon2Top
global Mon1Bottom
global Mon2Bottom
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

global toolTipIndex := {}
toolTipIndex["msgRefresh"] := 9
toolTipIndex["toolTipChoice"] := 10
toolTipIndex["pianoRollTempMsg"] := 11
toolTipIndex["acceptAbort"] := 12
toolTipIndex["debug"] := 13
toolTipIndex["pianoRollChordMsg"] := 14
toolTipIndex["pianoRollModeMsg"] := 15


; ---- Run functions -------------------------------------------
freezeExecute(f, params := "", retrPos := True, retrWin := False)
{
    res := 
    if (!freezeExecuting)
    {
        freezeExecuting := True
        retrieveMouse := retrPos
        retrieveWin := retrWin

        Send {LWinUp}

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
        res := execFunc(f, params)
        
        if (retrieveMouse)  ; can be switched off by f
            retrieveMousePos() 
        if (retrieveWin)
            WinActivate, ahk_id %id%

        unfreezeMouse()
        startWinHistoryClock()
        toolTip()
        freezeExecuting := False
        stopExec := False
    }
    return res
}

unfreezeWhileExec(msg)
{
    unfreezeMouse()
    toolTip(msg)
    res := waitAcceptAbort()
    freezeMouse()
    toolTip()
    return res
}

freezeUnfreezeMouse(f, params := "")
{
    freezeMouse()
    res := execFunc(f, params) 
    unfreezeMouse()
    return res
}
; ----