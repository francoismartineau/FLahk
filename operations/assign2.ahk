assign2()
{
    chan := getAssign2Chan()
    if (chan == "")
        return

    Click, Right

    Loop, 3
    {
        Sleep, 10
        Send {WheelUp}
    }

    Click
    if (chan == "----")
    {
        MouseGetPos, mX, mY
        isLocked := colorsMatch(mX+71, mY, [0x302d75], 30)
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
    else
    {
        if (chan == "keyboard")
        {
            Loop, 4
                Send {Up}
        }
        else
        {
            Send {Up}
            Send {Right}

            n := chan + 1
            Loop, %n%
                Send {Down}
        }
        Send {Enter}
        maximizePattLen()
    }
    
    if (!songEnabled())
        togglePatternSong()

}

getAssign2Chan()
{
    choices := ["----", 2, 3, 4, "keyboard"]
    return toolTipChoice(choices, "", 1)
}

unassign2()
{
    Click, Right

    Loop, 3
        Send {Up}

    Send {Right}u
}

maximizePattLen()
{
    WinGetPos,,, ssW,, A
    QuickClick(ssW-93, 14, "Right")
    Send {Up}
    Send {Enter}
}