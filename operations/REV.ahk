/*

REV() {
    revId := loadFx(2)
    if (revId) {
        randomizePlugin(revId)
        WinActivate, ahk_id %revId%
        setFreeverbDryValue(0.75)
        WinActivate, ahk_id %revId%
        setFreeverbWetValue(0.25)
        WinActivate, ahk_id %revId%
        setFreeverbDecValue()
        WinActivate, ahk_id %revId%
        MouseMove, 302, 60, 0
        Click                           ; delay tempo
        setKnobValue(485, 106, 0)       ; er
    }
}

setFreeverbDryValue(v) {
    MouseMove 450, 55
    MouseClick, Right
    MouseMove 461, 318
    MouseClick
    Send %v%{Enter}
    Sleep, 50
}

setFreeverbWetValue(v) {
    MouseMove, 514, 79
    MouseClick, Right
    MouseMove ,589, 335
    MouseClick
    Send %v%{Enter}
    Sleep, 50
}

setFreeverbDecValue() {
    r := RandomLog(0, 1, .03)
    MouseMove, 406, 49
    MouseClick, Right
    Send {Up}{Up}{Enter}
    Send %r%
    Send {Enter}
}
*/
