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

adjustEC(minMax = "")
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