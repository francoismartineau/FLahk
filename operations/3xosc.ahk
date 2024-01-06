set3xoscMainPanel()
{
    MouseMove, 28, 51, 0    ; main panel
    Click
    Knob.setVal(344, 118, getRandomInPitch())
    if (stopExec)
        return    
    Knob.setVal(344, 229, getRandomInPitch())
    Knob.setVal(344, 338, getRandomInPitch())
}

setEnvelopes(envPanelX = 117)
{
    Click, %envPanelX%, 53          ; env panel

    setVolEnvelope()

    if (stopExec)
        return

    if (oneChanceOver())
        setModXEnvelope()
    else
        disableModXEnvelope()

    if (stopExec)
        return

    if (oneChanceOver(4))
        setPitchEnvelope()
    else if (oneChanceOver(3))
        setPitchLFO()

    if (stopExec)
        return
   
    setFilter()

}

setVolEnvelope()
{
    Click, 84, 91           
    if (stopExec)
        return
    switchEnvelope("on")
    Knob.setVal(71, 243, expRand(0, 1, 5))             ; a
    Knob.setVal(105, 243, 0)                           ; h
    Knob.setVal(136, 243, 0)                           ; d
    Knob.setVal(169, 243, 1)                           ; s
    Knob.setVal(201, 243, expRand(0, 1, 2))            ; r
}

setModXEnvelope()
{
    Click, 133, 95          
    if (stopExec)
        return
    switchEnvelope("on")
    Knob.setVal(71, 243, expRand(0, 1, 4))             ; a
    Knob.setVal(105, 243, 0)                           ; h
    Knob.setVal(136, 243, expRand(0, 1, 2))            ; d
    Knob.setVal(169, 243, 0)                           ; s
    Knob.setVal(201, 243, expRand(0, 1, 2))            ; r
    Knob.setVal(280, 253, expRand(0, 1, 2))            ; amt
}

disableModXEnvelope()
{
    Click, 133, 95          
    switchEnvelope("off")
}

setPitchEnvelope()
{
    Click, 212, 92   
    if (stopExec)
        return           
    switchEnvelope("on")
    Knob.setVal(71, 243, expRand(0, 1, 6))             ; a
    Knob.setVal(105, 243, 0)                           ; h
    Knob.setVal(136, 243, expRand(0, 1, 4))            ; d
    Knob.setVal(169, 243, 0)                           ; s
    Knob.setVal(201, 243, expRand(0, 1, 2))            ; r
    Knob.setVal(280, 253, expRand(0, 1, 2))            ; amt
    Knob.setVal(396, 249, .5)                          ; turn off lfo amt
}

disablePitchEnvelope()
{
    Click, 212, 92          
    switchEnvelope("off")
}

setPitchLFO()
{
    Click, 212, 92      
    if (stopExec)
        return         
    switchEnvelope("off")
    Knob.setVal(396, 249, expRand(.5, 0.04, 4))            ; amt
    Knob.setVal(429, 242, expRand(.16, 0.42, 2))           ; speed
}

setFilter()
{
    if (stopExec)
        return     
    Knob.setVal(493, 173, expRand(0, 1, .6))  ; Filter X
    Knob.setVal(518, 234, expRand(0, 1, 3)) ; Filter Y
    Click, 509, 292
    Random, filterType, 0, 7
    Loop, %filterType%
        Send {WheelDown}
    Send {Enter}
}

switchEnvelope(mode = "on")
{
    x := 21
    y := 122
    while (!(isOn or isOff))
    {
        isOn := colorsMatch(x, y, [0xEE835D], 10)
        isOff := colorsMatch(20, 122, [0x565D60])
    }
    switch mode
    {
    Case "on":
        if (!isOn)
            Click, %x%, %y%
    Case "off":
        if (isOn)
            Click, %x%, %y%
    }
}

getRandomInPitch()
{
    Random, p, 0, 4
    p := p / 4
    return p
}