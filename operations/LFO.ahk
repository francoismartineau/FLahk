LFO()
{
    WinGetClass, class, A
    WinGetClass, class, A
    if (isPlugin())
    {
        minMax := knobCopyMinMax()
        Sleep, 20
        pluginName := copyName()
        lfoID := applyController(4, False, True, 2)
        lfoName := makeControllerName("LFO", pluginName, randString(1))
        rename(lfoName)
        adjustLfo(minMax)
    }
    else 
    {
        lfoID := loadFx(4)
        adjustLfo()
        rename("LFO " randString(1), True)
    }
    centerMouse(lfoID)
}

adjustLfo(minMax = "")
{
    randomizeLfo(True)

    if (IsObject(minMax))
    {
        min := minMax[1]
        max := minMax[2]

        lfoBaseX := 235 
        lfoBaseY := 81
        base := min
        setKnobValue(lfoBaseX, lfoBaseY, base)  

        lfoVolX := 281
        lfoVolY := 79    
        vol := .5 + (max-min)*.5
        setKnobValue(lfoVolX, lfoVolY, vol)  
    }
}
