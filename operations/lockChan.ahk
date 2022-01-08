lockChanFromInstrWin()
{
    bringStepSeq(False)
    moveMouseToSelY()
    lockChan()
}

; -------------------------------
lockChan(device := "")
{
    if (device == "")
    {
        device := getLockDevice()
        if (device == "")
            return
    }

    lockChanGoToDeviceCtxMenu()

    MouseGetPos, mX, mY
    isLocked := colorsMatch(mX+71, mY, [0x302d75], 30)


    if (device == "----")
        lockChanUnlockDevice(isLocked)
    else if (device == "keyboard")
    {
        if (!typingKeyboardEnabled())
            SendInput ^t
        if (isLocked)
            Send {Down}            
        Send {Down}{Enter}
    }
    else if (InStr(device, "PY"))
    {
        Send p
        Send {Down}         ; All channels
        chan := StrSplit(device, " ")[2]
        if chan is integer
            Loop, %chan%
                Send {Down}
        Send {Enter}
        ;maximizePattLen()
    }
    ;if (!songEnabled())
    ;    togglePatternSong()
}

getLockDevice()
{
    choices := ["----", "PY", "PY 10", "PY 11", "PY 12", "keyboard"]
    return toolTipChoice(choices, "", 1)
}

lockChanGoToDeviceCtxMenu()
{
    Click, Right
    Loop, 3
    {
        Sleep, 10
        Send {WheelUp}
    }
    Click
}

lockChanUnlockDevice(isLocked)
{
    if (isLocked)
    {
        MouseMove, 71, 0, 0, R
        Click
    }
    else
    {
        Send {Escape}
        Sleep, 2
        Send {Escape}
    }
}

; -------------------------------
toggleLockKeyboardUnlock()
{
    Click, Right
    Send {Up}{Up}{Up}{Right}{Down}{Enter}
    
}

maximizePattLen()
{
    WinGetPos,,, ssW,, A
    QuickClick(ssW-93, 14, "Right")
    Send {Up}
    Send {Enter}
}