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

LWin & WheelUp::                    ; load TransferSound
    waitForModifierKeys()
    freezeExecute("openTransferSoundInAudacity", False, False)
    return

LWin & WheelDown::                  ; save to TransferSound
    waitForModifierKeys()
    freezeExecute("dragSoundFromAudacity", False, False)
    return
#If


#If WinActive("ahk_exe Melodyne singletrack.exe")
F4::                                ; close
    Send {AltDown}{F4}{AltUp}
    return
    
LWin & WheelUp::                    ; load TransferSound
    waitForModifierKeys()
    WinGet, melodyneId, ID, A
    freezeExecute("melodyneLoadSound", False, False, melodyneId)
    return

LWin & WheelDown::                  ; save to TransferMidi
    waitForModifierKeys()
    WinGet, melodyneId, ID, A
    freezeExecute("melodyneExportMidi", False, False, melodyneId)
    return
#If