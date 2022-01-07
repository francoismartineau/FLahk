EnvC()
{
    WinGetClass, class, A
    if (isPlugin())
    {
        minMax := knobCopyMinMax()
        Sleep, 20
        pluginName := copyName()
        ecId := applyController(2, True, False)
        envCname := makeControllerName("EC", pluginName, randString(1))
        rename(envCname)
        adjustEC(minMax)
    }
    else 
    {
        ecId := loadInstr(4)
        adjustEC()
        rename("EC " randString(1), True)
    }
}

adjustEC(minMax := "")
{
    if (IsObject(minMax))
    {
        min := minMax[1]
        max := minMax[2]
        base := min
        setKnobValue(262, 110, base, "other")
        env := .5 + (max-min)*.5
        setKnobValue(301, 95, env, "other")
    }
}

; -- LFO -----------------------------------------
envCsetLfoTime()
{
    envCactivateTempo()
    timeX := 35
    timeY := 448  - isWrapperPlugin(id)*yOffsetWrapperPlugin

    vals := [0.252168430015445, 0.281080831773579, 0.322803887538612, 0.352946604602039, 0.395961491391063, 0.426796260289848, 0.470441683195531, 0.501568651758134, 0.545598547905684, 0.57680241111666, 0.62109375, 0.652405265718698, 0.696773499250412, 0.728208046406508, 0.741034079343081, 0.772530143149197, 0.81700602825731, 0.848332922905683, 0.892701156437397, 0.924750860780478, 0.968503937125206, 1]
    choices := ["4       --------- b4rs", "3      ", "2      ", "1.5      " , "4 bars ----", "3", "2", "1.5", "4 beats ------", "3", "2", "1.5", "1 beat ------", "3/4", "2/3", "1/2 --", "1/3", "1/4 --", "1/6", "1/8", "1/12", "1/16"]
    moveMouse(timeX, timeY)
    currVal := copyKnob(False)
    moveMouse(timeX, timeY)
    initIndex := indexOfClosestValue(currVal, vals, "asc")
    if (toolTipChoice(choices, "", initIndex))
        val := vals[toolTipChoiceIndex]    
    if (val != "")
        setKnobValue(timeX, timeY, val)
}

isEnvClfo(id := "")
{
    res := False
    if (id == "")
        WinGet, id, ID, A
    if (isEnvC(id))    
    {
        y := 156 - isWrapperPlugin(id)*yOffsetWrapperPlugin
        res := colorsMatch(204, y, [0x90a1a8]) and colorsMatch(197, y, [0xa2a8a4]) and colorsMatch(191, y, [0x94a89b])
    }
    return res
}

envCtempoActivated()
{
    return colorsMatch(124, 428, [0xb6bdcd])
}

envCactivateTempo()
{
    if (!envCtempoActivated())
        QuickClick(124, 428)
}
; ----