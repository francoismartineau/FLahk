/*
activateChannel(n)
{
    freezeMouse()
    saveMousePos()
    WinGet, prevWinID, ID, A
    x := 183
    y := getChannelNtoY(n)
    bringStepSeq()
    MouseClick, Left, %x%, %y%
    instrWinID := waitNewWindowOfClass("TPluginForm", prevWinID)
    WinActivate, ahk_id %prevWinID%
    retrieveMousePos()
    unfreezeMouse()
    return instrWinID
}

getChannelNtoY(n)
{
    return 61 + (n-1) * 30
}

getCurrentChannel()
{
    stepSeqID := bringStepSeq()
    x := 273
    y := 52
    WinGetPos,,,, h, ahk_id %stepSeqID%
    h := h - 49
    pos := scanColorDownMax(x, y, h, [0xA8E44A], 10, 33, "") 
    n := getChannelYtoN(h, pos)
    return n
}

getChannelYtoN(h, y)
{
    if (y >= 52 and y < h) {
        y := y - 52
        n := Ceil( y / 52 ) + 1
    }
    return n
}

getFirstSelectedChannel(inOtherFunc = False)
{
    if (!inOtherFunc) {
        stopWinHistoryClock()
        WinGet, prevWinID, ID, A
    }
    ssID := bringStepSeq()
    WinGetPos,,,, ssH, A
    green := [0xA8E44A]
    firstChannY := 59
    x := 273
    h := ssH - firstChannY
    y := scanColorDownMax(x, firstChannY, h, green, 10, 30, "")
    if (!inOtherFunc) {
        startWinHistoryClock()
        WinActivate, ahk_id %prevWinID%
    }
    return getYtoChannelN(x, y, ssID)

}

hoveringChannel()
{
    MouseGetPos, x, y, winID
    WinGetClass, class, ahk_id %winID%
    if (class == "TStepSeqForm") {
        n := getYtoChannelN(x, y, winID)
    }
    return n
}

getYtoChannelN(x, y, ssID)
{
    WinGetPos,,, w, h, ahk_id %ssID%
    if (x > 0 and x < w) {
        start := 49
        size := 26
        next := 30
        end := h - 50
        n := 0
        while (y > start and y < end) {
            n := n + 1
            if (y <= start + size)
                break
            start := start + next
        }
    }
    return n
}

*/