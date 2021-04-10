#If WinActive("ahk_exe audacity.exe")
F4::                                ; close
    SendInput !{F4}
    return

!t::                                ; truncate silence
    Send {CtrlDown}a{CtrlUp}
    MouseMove, 344, -10
    Click
    Send t{Enter}
    return

LWin & WheelDown::                  ; drag sound
    waitForModifierKeys()
    freezeExecute("dragSoundFromAudacity", False, False)
    return
#If