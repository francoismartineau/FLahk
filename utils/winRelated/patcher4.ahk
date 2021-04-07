patcher4ChangeFx()
{
    static buttonX := [96, 241, 377, 524]
    static buttonY := [237, 234, 234, 234]
    if (colorsMatch(buttonX[1], buttonY[1], [0xBCE68A]))
        pos := 1
    else if (colorsMatch(buttonX[2], buttonY[2], [0xB8E286]))
        pos := 2
    else if (colorsMatch(buttonX[3], buttonY[3], [0xBCE68A]))
        pos := 3
    else if (colorsMatch(buttonX[4], buttonY[4], [0xBCE68A]))
        pos := 4

    if (pos)
    {
        MouseMove, buttonX[pos], buttonY[pos], 0
        Click
    }

    Switch A_ThisHotkey
    {
    Case "Left":
        pos := pos - 1
        if (pos < 1)
            pos := 4
    Case "Right":
        pos := pos + 1
        if (pos > 4)
            pos := 1
    Default:
        pos := A_ThisHotkey
    }
    MouseMove, buttonX[pos], buttonY[pos], 0
    Click
}