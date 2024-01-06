LFO()
{
    oriId := mouseGetPos(knobX, knobY)
    oriName := copyName()
    values := Knob.copyMinMax()
    if (!values)
        return
    lfoID := loadFx(4)
    if (!lfoID)
        return

    WinActivate, ahk_id %oriId%
    moveMouse(knobX, knobY)
    params := {"autoAccept": True, "visionPickCtl": 2}
    res := Knob.link(params)
    if (!res)
        return

    WinActivate, ahk_id %lfoID%
    lfoName := makeControllerName("LFO", pluginName, randString(1))
    rename(lfoName)
    adjustLfo(values)
    centerMouse(lfoID)
}

adjustLfo(values := "")
{
    randomizeLfo(True)

    if (IsObject(values))
    {
        min := values[1]
        max := values[2]

        lfoBaseX := 235 
        lfoBaseY := 81
        base := min
        Knob.setVal(lfoBaseX, lfoBaseY, base)  

        lfoVolX := 281
        lfoVolY := 79    
        vol := .5 + (max-min)*.5
        Knob.setVal(lfoVolX, lfoVolY, vol)  
    }
}
