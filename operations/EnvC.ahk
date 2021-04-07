EnvC()
{
    minMax := newControllerCopyMinMax()
    Sleep, 20
    copyName()
    ecId := applyController(2, True, False)
    ;bringPianoRoll(False)
    adjustEC(ecId, minMax)
    pasteName("EnvC", False)
}

adjustEC(ecId, minMax)
{
    min := minMax[1]
    max := minMax[2]
    WinGetPos, winX, winY,,, ahk_id %ecId%
    moveMouse(winX, winY, "Screen")

    base := min
    setKnobValue(262, 110, base, "other")
    env := .5 + (max-min)*.5
    setKnobValue(301, 95, env, "other")
    toolTip()
}