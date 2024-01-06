; -- Record ------------------------------
global recordButtonX := 459
global recordButtonY := 20
global recordCtxMenuAutomY := 31
global recordCtxMenuNoteY := 50

global recordMode
global whileRecordModeChoice := False
recordModeChoice()
{
    whileRecordModeChoice := True
    title := "-- Record Mode ----"
    choices := ["autom, note", "notes", "autom"]
    initIndex := hasVal(choices, recordMode)
    if (!initIndex)
        initIndex := 1
    recordMode := toolTipChoice(choices, title, initIndex)
    if (recordMode != "")
        enableRecord(recordMode)
    whileRecordModeChoice := False
}

enableRecord(mode := "autom, note")
{
    if (!recordEnabled())
        clickRecord()
    setRecordMode(mode)
    updateRecordModeGui()
    startRecordEnabledClock()
}

setRecordMode(desiredMode)
{
    modes := ["note", "autom"]
    for i, mode in modes
    {
        moveMouse(recordButtonX, recordButtonY, "Screen")
        Click, R
        Sleep, 10
        modeEnabled := recordModeEnabled(mode)
        if ((modeEnabled and !InStr(desiredMode, mode)) or (!modeEnabled and InStr(desiredMode, mode)))
        {
            varName := "recordCtxMenu" mode "Y"
            y := %varName%
            MouseMove, 10, %y%, 0, R
            Click
        }
        else
        {
            MouseMove, 0, -1 , 0, R
            Click            
        }
    }
    moveMouse(recordButtonX, recordButtonY, "Screen")
    Click, R
    Sleep, 500
    MouseMove, 0, -1 , 0, R
    Click
    global recordMode
    recordMode := desiredMode
}

disableRecord()
{
    if (recordEnabled())
        clickRecord()
    stopRecordEnabledClock()
    hideRecordEnabledGui()
}

clickRecord()
{
    moveMouse(recordButtonX, recordButtonY, "Screen")
    winId := mouseGetPos(_, _)
    if (isMainFlWindow(winId))
        Click
    else
        msg("Can't click record")
}

recordEnabled()
{
    CoordMode, Pixel, Screen
    res := colorsMatch(459, 13, [0xFF978A])
    CoordMode, Pixel, Client
    return res
}
; ----

; -- Pattern / song -------------------------
togglePatternSong()
{
    if (isPianoRollTool())
        togglePatternSongFromPianoRollToolWin()
    else
        togglePatternSongClick()
}

togglePatternSongClick()
{
    prevMode := setMouseCoordMode("Screen")
    MouseGetPos, mx
    if (mx < 0)
        MouseMove, 0, 781, 0
    MouseMove, 355, 16, 0
    Click
    setMouseCoordMode(prevMode)
}

togglePatternSongFromPianoRollToolWin()
{
    WinGet, toolWinId, ID, A
    typingKeyEnabled := typingKeyboardEnabled()
    if (typingKeyEnabled)
    {
        bringMainFLWindow()
        SendInput ^t
    }    
    ;bringTouchKeyboard()
    Send l
    if (typingKeyEnabled)
    {
        bringMainFLWindow()
        SendInput ^t
    }       
    WinActivate, ahk_id %toolWinId%    
}
; ----

; -- Vision --------------
songEnabled()
{
    CoordMode, Pixel, Screen
    res := colorsMatch(357, 26, [0xCDFD87], 40)
    CoordMode, Pixel, Client
    return res
}

/*
toggleRecord()
{
    winId := WinActive("A")
    Playlist.bringWin(False)
    Send {Alt down}r{Alt up}
    bringHistoryWins()
    WinActivate, ahk_id %winId%
}
*/

songPlaying()
{
    CoordMode, Pixel, Screen
    res := !colorsMatch(392, 16, [0xB29C78])
    CoordMode, Pixel, Client
    return res    
}
; ----

; -- Typing keyboard ---------------------------
enableTypingKeyboard()
{
    if (!typingKeyboardEnabled())
        toggleTypingKeyboard()
}

disableTypingKeyboard()
{
    if (typingKeyboardEnabled())
        toggleTypingKeyboard()
}

turnOnTypingKeyboard()
{
    result := False
    if (!typingKeyboardEnabled())
    {
        toggleTypingKeyboard()
        result := True
    }
    return result
}

turnOffTypingKeyboard()
{
    wasOn := False
    if (typingKeyboardEnabled()) {
        toggleTypingKeyboard()
        wasOn := True
    }
    return wasOn
}

toggleTypingKeyboard()
{
    winId := WinActive("A")
    WinActivate, ahk_class TFruityLoopsMainForm
    Send {Ctrl down}t{Ctrl up}
    WinActivate, ahk_id %winId%
}

typingKeyboardEnabled()
{
    prevMode := setPixelCoordMode("Screen")
    x := 490
    y := 52
    cols := [0xFFE294]
    isEnabled := colorsMatch(x, y, cols, 20)
    setPixelCoordMode(prevMode)
    return isEnabled
}

randomizeTypingKeyboard()
{
    WinActivate, ahk_class TFruityLoopsMainForm
    quickClick(488, 62, "Right")
    Random, octave, 1, 3
    Loop, %octave%
        Send {WheelDown}
    Send {LButton}
    quickClick(488, 62, "Right")
    Random, layout, 4, 34
    Loop, %layout%
        Send {WheelDown}    
    Send {LButton}
}
; ----

; -- Step Edit ---------------------------
toggleStepEdit()
{
    ;winId := WinActive("A")
    moveMouse(913, 16, "Screen")
    Click
    ;Send {Ctrl down}e{Ctrl up}
    ;WinActivate, ahk_id %winId%
}
; ----

; -- Patterns ---------------------
scrollPatternUp()
{
    Send {NumpadSub}
}

scrollPatternDown()
{
    Send {NumpadAdd}
}

deletePattern()
{
    Send {CtrlDown}{ShiftDown}{Delete}{ShiftUp}{CtrlUp}
}
; ----

; -- Loop recording ---------------------------
loopRecordingEnabled()
{
    winId := WinActive("A")
    WinActivate, ahk_class TFruityLoopsMainForm
    x := 491
    y := 54
    cols := [0xFFEC9E]
    enabled := colorsMatch(x, y, cols, 20)
    WinActivate, ahk_id %winId%
    return enabled    
}

toggleLoopRecording()
{
    winId := WinActive("A")
    WinActivate, ahk_class TFruityLoopsMainForm
    x := 491
    y := 54
    MouseClick, Left, %x%, %y%,,1
    WinActivate, ahk_id %winId%
    return enabled        
}
; ----

; -- Snap ---------------------------
checkIfSnap()
{
    CoordMode, Pixel, Screen
    x := 553
    y := 59
    cols := [0x383F44]
    result := colorsMatch(x, y, cols, 10)
    CoordMode, Pixel, Client
    return result        
}

toggleSnap()
{
    CoordMode, Mouse, Screen
    Click, 551, 62
    CoordMode, Mouse, Client
    msgTip("toggleSnap():   faire par midi avec midi.FPT_Snap")
}
; ----

; -- Mouse ---------------------------
mouseOverPlayPauseButton()
{
    res := False
    winId := mouseGetPos(mX, mY, "Screen")
    if (isMainFlWindow(winId))
        res := mY <= 36 and mX <= 407 and mX >= 377 and mY >=  5
    return res
}

mouseOverStopButton()
{
    res := False
    winId := mouseGetPos(mX, mY, "Screen")
    if (isMainFlWindow(winId))
        res := mY <= 36 and mX <= 442 and mX >= 409 and mY >=  5
    return res   
}


hoveringUpperMenuPattern()
{
    CoordMode, Mouse , Screen
    MouseGetPos, x, y, winId
    CoordMode, Mouse , Client
    WinGetClass, class, ahk_id %winId%
    res:= class == "TFruityLoopsMainForm" and 650 < x and x < 745 and 50 < y and y < 75
    ;msgTip("hovering: " res)
    return res
}

mouseOverRecordButton()
{
    res := False
    winId := mouseGetPos(mX, mY, "Screen")
    if (isMainFlWindow(winId))
    {
        res := mY < 36 and mY > 5 and mX < 474 and mX > 445
    }
    return res
}
; ----

