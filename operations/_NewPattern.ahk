
; if [e Down], crée une note
newPatt() {    
    global acceptPressed
    wDown := checkIfWdown()
    closeAllWinHistory(False)
    Send {F4}{Enter}                    ; create pattern
    ssID := bringStepSeq()
    if (ssID) {
        renameNewPattern()
        Send {NumpadDiv}                ; bring playhead to start
        if (wDown)
        {
            setPatternLenght()
            activateChannelLoops(ssID)
            insertNote()
        }
        letUserPlacePattern()
        bringHistoryWins()
        bringPianoRoll(True)
    }
}

checkIfWdown() {
    GetKeyState, ks, w
    return ks == "D"
}

renameNewPattern() {
    Send {F2}                       ; rename
    waitNewWindow(id)
    Send {F2}                       ; randomize color
    unfreezeMouse()
    waitAcceptAbort(True)
    freezeMouse()
    Sleep, 100
}

setPatternLenght() {
    bringStepSeq(False)
    WinGetPos,,, w,, A
    x := w - 100
    MouseClick, Right, %x%, 17          ; longueur pattern {enter}
    Send {Down}                         ; select Auto
    waitAcceptAbort(True)
}

activateChannelLoops(id) {
    WinActivate, ahk_id %id%
    ;ToolTip, Activating channel loops., 0, 0
    MouseClick, Left, 40, 14
    WinGetPos,,, w, h, A
    x := w - 47
    y := 62
    Loop {
        MouseMove, %x%, %y%
        MouseClick, Right
        Send {Down}{Enter}
        Sleep, 100
        Loop, 16 {
            Send {WheelUp}
            Sleep, 25
        }
        y := y + 30
        if not (y < h - 60)
            break
    }
    ToolTip, Press Enter to confirm channel loops., 0, 0
    waitAcceptAbort()
    ToolTip
}

letUserPlacePattern() {
    bringPlaylist(False)
    unfreezeMouse()
    ToolTip, Place the pattern and press Enter, 279, 51
    waitAcceptAbort()
    ToolTip
    freezeMouse()
}

insertNote() {
    tkEnabled := typingKeyboardEnabled()
    if (!tkEnabled) {
        toggleTypingKeyboard() 
    }
    Sleep, 100
    toggleStepEdit()                ; step edit
    Sleep, 100
    Send d                          ; random letter
    toggleStepEdit()
    if (!tkEnabled) {
        toggleTypingKeyboard() 
    }
}


