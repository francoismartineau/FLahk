; -- Pattern / song -------------------------
togglePatternSong()
{
    if (isPianoRollTool())
        togglePatternSongActivateWin()
    else
        togglePatternSongClick()
}

togglePatternSongClick()
{
    CoordMode, Mouse, Screen
    MouseGetPos, mx
    if (mx < 0)
        MouseMove, 0, 781, 0
    MouseMove, 355, 16, 0
    Click
    CoordMode, Mouse, Client
}

togglePatternSongActivateWin()
{
    winId := WinActive("A")
    typingKeyEnabled := typingKeyboardEnabled()
    if (typingKeyEnabled)
    {
        bringMainFLWindow()
        Send {Ctrl down}t{Ctrl up}
    }
    bringPlaylist(False)
    Send l
    if (typingKeyEnabled)
    {
        bringMainFLWindow()
        Send {Ctrl down}t{Ctrl up}
    }    
    bringHistoryWins()
    WinActivate, ahk_id %winId%
}

songEnabled()
{
    CoordMode, Pixel, Screen
    res := colorsMatch(357, 26, [0xCDFD87], 40)
    CoordMode, Pixel, Client
    return res
}

toggleRecord()
{
    winId := WinActive("A")
    bringPlaylist(False)
    Send {Alt down}r{Alt up}
    bringHistoryWins()
    WinActivate, ahk_id %winId%
}

recordEnabled()
{
    CoordMode, Pixel, Screen
    res := colorsMatch(459, 13, [0xFF978A])
    CoordMode, Pixel, Client
    return res
}

songPlaying()
{
    CoordMode, Pixel, Screen
    res := !colorsMatch(392, 16, [0xB29C78])
    CoordMode, Pixel, Client
    return res    
}

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
    WinActivate, FL Studio 20 ahk_class TFruityLoopsMainForm
    Send {Ctrl down}t{Ctrl up}
    WinActivate, ahk_id %winId%
}

typingKeyboardEnabled()
{
    winId := WinActive("A")
    WinActivate, FL Studio 20 ahk_class TFruityLoopsMainForm
    x := 457
    y := 52
    cols := [0xFFE294]
    isEnabled := colorsMatch(x, y, cols, 20)
    WinActivate, ahk_id %winId%
    return isEnabled
}

randomizeTypingKeyboard()
{
    WinActivate, FL Studio 20 ahk_class TFruityLoopsMainForm
    QuickClick(488, 62, "Right")
    Random, octave, 1, 3
    Loop, %octave%
        Send {WheelDown}
    Send {LButton}
    QuickClick(488, 62, "Right")
    Random, layout, 4, 34
    Loop, %layout%
        Send {WheelDown}    
    Send {LButton}
}
; -----------------------------
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

; -----------------------------
toggleStepEdit()
{
    ;winId := WinActive("A")
    moveMouse(913, 16, "Screen")
    Click
    ;Send {Ctrl down}e{Ctrl up}
    ;WinActivate, ahk_id %winId%
}

; -----------------------
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

; -- Loop recording ---------------------------
loopRecordingEnabled()
{
    winId := WinActive("A")
    WinActivate, FL Studio 20 ahk_class TFruityLoopsMainForm
    x := 491
    y := 54
    cols := [0xFFEC9E]
    enabled := colorsMatch(x, y, cols, 20, "")
    WinActivate, ahk_id %winId%
    return enabled    
}

toggleLoopRecording()
{
    winId := WinActive("A")
    WinActivate, FL Studio 20 ahk_class TFruityLoopsMainForm
    x := 491
    y := 54
    MouseClick, Left, %x%, %y%,,1
    WinActivate, ahk_id %winId%
    return enabled        
}

; -- Snap ---------------------------
checkIfSnap()
{
    CoordMode, Pixel, Screen
    x := 553
    y := 59
    cols := [0x383F44]
    result := colorsMatch(x, y, cols, 10, "")
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

