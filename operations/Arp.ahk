randomizeArpParams()
{
    alreadyOpen := clickInstrWrench()
    setKnobValue(96, 196, randInt(1,4)/5)       ; Arp dir


    if (oneChanceOver(6, "invert"))             ; Chord
    {
        if (oneChanceOver(2))                   
            v := 0.02222                    ; none
        else
            v := 0                          ; auto
    }
    else
        v := randint(4, 127) / 127          ; chords
    setKnobValue(225, 284, v)


                                                ; Time
    v := [1, 0.910732196643949, 0.786359077319503, 0.663991975598037, 0.575727181509137, 0.464393179538616, 0.371113340370357, 0.27382146474, 0.176529589109123]
    v := randomChoice(v)    
    setKnobValue(111, 228, v)

    if (!alreadyOpen)
        clickInstrMainPanel(False, False)
}


randomizeDelayParams()
{
    alreadyOpen := clickInstrWrench()
    
    ;QuickClick(96, 197 )               ; deactivate arp

    if (oneChanceOver(2))
        QuickClick(544, 271)                    ; ping pong
    

    feed := expRand(.1, .9, 3)                  ; feed
    setKnobValue(350, 230, feed)

    if (oneChanceOver(3))
    {
        pan := centeredExpRand(.1, .9, 3)       ; pan
        setKnobValue(380, 230, pan)
    }

    if (oneChanceOver(3))
    {
        modx := centeredExpRand(.1, .9, 3)      ; modx
        setKnobValue(420, 230, modx)
    }

    if (oneChanceOver(3))
    {
        mody := centeredExpRand(.1, .9, 3)      ; mody
        setKnobValue(450, 230, mody)
    }

    if (oneChanceOver(3))
    {
        pitch := centeredExpRand(.1, .9, 3)     ; pitch
        setKnobValue(494, 230, pitch)     
    }

                                                ; time
    time := [1, .75, .5, .375, .25, .166666, .125, .083333, .0625, .041666, .03125]
    time := randomChoice(time)    
    setKnobValue(533, 230, time)

    echoes := [[0, 5], [0.111111111007631, 5], [0.222222222015262, 4], [0.333333333022892,2], [0.444444444030523,2], [0.555555555969477, 1]]
    echoes := weightedRandomChoice(echoes)
    setKnobValue(398, 288, echoes)
       
    if (!alreadyOpen)
        clickInstrMainPanel(False, False)
}