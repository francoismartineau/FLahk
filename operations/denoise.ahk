denoise()
{
    WinGetClass, class, A
    if (class == "TPluginForm")
    {
        playlistToolTip("Should be used while a sample is open in edison")
        Tooltip, Click drag a silence section
        unfreezeMouse()
        Sleep, 300
        ;Send {Ctrl Down}
        KeyWait, LButton, D
        KeyWait, LButton
        ;Send {Ctrl Up}
        freezeMouse()

        ;msgTip("done clicking")
        ;return

        Send {Alt Down}u{Alt Up}
        Tooltip

        Sleep, 500
        Send {Ctrl Down}a{Ctrl Up}
        Sleep, 500
        Send {Ctrl Down}u{Ctrl Up}

        WinGet, edisonID, ID, A
        waitNewWindowOfClass("TMEDenoiseToolForm", id)
        Sleep, 500
        Click, 565, 440             ; accept
        Sleep, 500
        WinActivate, ahk_id %edisonID%
        centerMouse(edisonID)
    }
}