global 5lfoLfo1pos := [322, 237]

mouseOver5lfoSetSpeed()
{
    winId := mouseGetPos(mX, mY)
    res := is5lfo(winId) and colorsMatch(mX, mY, [0x6E7FB7])
    return res
}

5lfoSetSpeed()
{
    patcherId := mouseGetPos(oriX, oriY)
    WinActivate, ahk_id %patcherId%
    patcherActivateMap(patcherId)
    mX := 5lfoLfo1pos[1]
    mY := 5lfoLfo1pos[2]
    lfoId := patcherActivatePlugin(mX, mY)
    WinActivate, ahk_id %lfoId%
    WinMove, ahk_id %lfoId%,, 188, 222
    toolTip("setTime")
    newVal := lfoSetTime("", False, currVal)
    toolTip("")
    WinClose, ahk_id %lfoId%
    WinActivate, ahk_id %patcherId%
    patcherActivateSurface(patcherId)
    Knob.setVal(oriX, oriY-40, newVal, "patcherSurface") 
}