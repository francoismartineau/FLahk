assign2()
{
    res := getAssign2Chan()
    if (res[1] == "abort")
        return
    chan := res[2]

    Click, Right

    Loop, 3
    {
        Sleep, 10
        Send {WheelUp}
    }

    Click
    if (chan == "----")
    {
        if (!colorsMatch(682, 274, [0x8BB6CC]))
        {
            MouseMove, 682, 274 , 0
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
    toolTipChoiceIndex := 1
    res := toolTipChoice(choices)
    return [res, choices[toolTipChoiceIndex]]
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