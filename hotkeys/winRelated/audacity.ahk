#If WinActive("ahk_exe audacity.exe")
F4::
    SendInput !{F4}
    return

;;;; truncate silence
!t::
    Send {CtrlDown}a{CtrlUp}
    MouseMove, 344, -10
    Click
    Send t{Enter}
    Return

#If