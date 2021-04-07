relMouseX1 :=
relMouseY1 :=

relMouseX2 :=
relMouseY2 :=


clipboardUtilities()
{
    MouseGetPos, x, y, hoveredWin
    WinGetClass, hoveredWinClass, ahk_id %hoveredWin%
    WinGetClass, activeWinClass, A
    PixelGetColor, col, %x%, %y%, RGB
    WinGetPos, winX, winY, winW, winH, ahk_id %hoveredWin%
    clipboard = %x%, %y%   %col%    Win: A: ahk_class %activeWinClass%   Mouse: ahk_class %hoveredWinClass% ahk_id %hoveredWin%  winXYWH:  %winX%, %winY%, %winW%, %winH%
    msgTip(clipboard)
}

clipboardMultipleXY()
{
    MouseGetPos, x, y
    clipboard := clipboard x ", " y "     "
    msgTip(clipboard)
}

clipboardColorMatches()
{
    MouseGetPos, x, y
    PixelGetColor, col, %x%, %y%, RGB
    clipboard = colorsMatch(%x%, %y%, [%col%])
    msgTip(clipboard)
}


clipboardRelativeMouse()
{
    global relMouseX1, relMouseX2, relMouseY1, relMouseY2
    
    relMouseX1 := relMouseX2
    relMouseY1 := relMouseY2
    
    MouseGetPos, x, y
    relMouseX2 := x
    relMouseY2 := y

    rx := relMouseX2 - relMouseX1
    ry := relMouseY2 - relMouseY1
    clipboard = MouseMove, %rx%, %ry% ,, R
    msgTip(clipboard)
}
