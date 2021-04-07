distructorChangeFX(dir)
{
    pos := 0
    oriX := 205
    x := oriX
    y :=  52
    col := [0x555C5F]
    incr := 224
    i := 1
    while (!pos and i <= 4)
    {
        if (!colorsMatch(x, y, col, 0, ""))
            pos := i
        if (!pos)
            x := x + incr
        i := i + 1
    }
    if (pos)
    {
        MouseMove, %x%, %y%, 0
        Click
    }
    if (dir == "right")
    {
        if (pos)
        {
            pos := pos + 1
            if (pos == 5)
                pos := 1
        }
        else
            pos := 1
    }
    else if (dir == "left")
    {
        if (pos)
        {
            pos := pos - 1
            if (pos == 0)
                pos := 4
        }
        else
            pos := 4
    }
    x := oriX + (pos-1) * incr
    MouseMove, %x%, %y%, 0
    Click
}