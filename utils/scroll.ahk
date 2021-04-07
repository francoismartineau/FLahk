scrollMouseHorizontal()
{
    MouseGetPos, mx, my
    if (isPianoRoll())
    {
        incr := 92
        MouseMove, %mx%, 821, 0
    }
    else if (isStepSeq())
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