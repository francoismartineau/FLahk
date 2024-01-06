global HighlightId
global isHighlighting
global hilightMode

startHighlightClock()
{
    SetTimer, HIGHLIGHT_TICK, 100
    isHighlighting := True
    return

    HIGHLIGHT_TICK:
    highlightTick()
    return
}

stopHighlightClock()
{
    SetTimer, HIGHLIGHT_TICK, Off
    isHighlighting := False
}

makeHighlight()
{
    Gui, Highlight:New   
    Gui, Highlight:-Caption +E0x08000000 +E0x20 +AlwaysOnTop +LastFound +ToolWindow +HwndHighlightId
    Gui, Highlight:Color, %mainMenusColor%
}

highlightTick()
{
    if (mouseOverHighlight())
        setHighlightTint()
    Switch hilightMode
    {
    Case "browser":
        if (mouseOverBrowser() and !mouseOverFolder()) 
        {
            ;chanPresetH := 25
            ;folderH := 23
            fileH := 21
            x := 13
            w := 230 - x
            h := fileH
            CoordMode, Mouse, Screen
            MouseGetPos,, mY
            CoordMode, Mouse, Client
            y := mY - (h/2)
            showHighlight(x, y, w, h)
        }
        else
            hideHighlight()
    Case "edisonDrag":
        if (mouseOverEdisonDrag())
        {
            x := -107
            y := 652
            w := 40
            h := 32
            showHighlight(x, y, w, h)
        }
        else
            hideHighlight()
    Case "sampleClip":
        if (mouseOverSampleClipSound())
        {
            x := 11
            y := 326
            w := 556 - x
            h := 455 - y
            WinGetPos, winX, winY,,, A
            x := x + winX
            y := y + winY
            showHighlight(x, y, w, h)
        }
        else
            hideHighlight()        
    }
}

setHighlightTint(col := 0X34444e, transparency := 115)
{
    WinSet, TransColor, %col% %transparency%, ahk_id %HighlightId%
}


getHighlightCoords(ByRef x, ByRef y, ByRef w, ByRef h)
{
    x := lastHighlightX
    y := lastHighlightY
    w := lastHighlightW
    h := lastHighlightH
}

global lastHighlightX
global lastHighlightY
global lastHighlightW
global lastHighlightH
showHighlight(x, y, w, h)
{
    lastHighlightX := x
    lastHighlightY := y
    lastHighlightW := w
    lastHighlightH := h
    Gui, Highlight:Show, x%x% y%y% w%w% h%h% NoActivate, highlightWin
}

hideHighlight()
{
    Gui, Highlight:Hide
}

stopHighlight()
{
    Gui, Highlight:Destroy
    stopHighlightClock()
}

startHighlight(mode)
{
    hilightMode := mode
    makeHighlight()
    setHighlightTint()
    startHighlightClock()
}


mouseOverHighlight()
{
    MouseGetPos,,, winId
    return winId == HighlightId
}
