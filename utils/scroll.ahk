scrollMouseHorizontal()
{
    MouseGetPos, mx, my
    if (PianoRoll.isWin())
    {
        incr := 92
        MouseMove, %mx%, 821, 0
    }
    else if (StepSeq.isWin())
    {
        incr := 63
        if (my)
        MouseMove, %mx%, -29, 0
    }
    else
        incr := 100
    if (A_ThisHotkey == "^!WheelUp")
        incr := -incr

    MouseMove, %incr%, 0, 0, R   
}