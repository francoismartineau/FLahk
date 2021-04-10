global ctxMenuColors := [0xBBC3C8, 0xb7bfc4, 0x5d6b74, 0xbac1c0, 0xb8c0c5]
global ctxMenuSepCol := [0x939d9c]


scanColorDown(x, y, h, cols, colVar = 0, incr = 4, hint = "", debug = False, reverse = False)
{
    found := False
    maxY := y + h
    Loop, 1080
    {
        found := colorsMatch(x, y, cols, colVar, hint, debug, reverse)
        if (found)
            break
        y := y + incr
        if (y >= maxY)
            break
    }
    if (!found)
        y := ""
    return y
}

scanColorRight(x, y, w, cols, colVar = 0, incr = 4, hint = "", debug = False, reverse = False)
{
    found := False
    maxX := x + w
    Loop, 1920
    {
        found := colorsMatch(x, y, cols, colVar, hint, debug, reverse)
        if (found)
            break
        x := x + incr
        if (x >= maxX)
            break
    }
    if (!found)
        x := ""
    
    return x
}

global colorsMatchDebug := False
colorsMatch(x, y, cols, colVar = 0, hint = "", debug = False, reverse = False)
{
    success := False
    debug := colorsMatchDebug or debug

    PixelGetColor, resCol, %x%, %y% , RGB
    for i, col in cols
    {
        if (colVar > 0)
        {
            diff := hexColorVariation(decimal2hex(col), resCol)
            success := diff <= colVar
        }
        else
            success := col == resCol
        if (debug)
        {
            moveMouse(x, y, pixelCoordMode)
            ToolTipColor(resCol)
            col := decimal2hex(col)
            if (success)
                msg := "success"
            else
                msg := "no match"
            if (colVar == 0)
                diff := "-"
            msgTip("col:     " col "               res: " resCol "            diff: " diff "              (" x ", " y "):     " msg, 1000)
            ;clipboard := resCol
        }
        if (success)
            break
    }
    if (!cols.MaxIndex() and debug)
        msgTip("colorsMatch: no colours received.")

    if (reverse)
        success := !success    
    if (hint)
    {
        ToolTip, %hint%, %x%, %y%
        Sleep, 25
        ToolTip
    } 
    return success
}
