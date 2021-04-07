; -- Randomize plugin -------------------------------
randomizePlugin(winId = "", rOnly = False, pluginName = "")
{
    if (winId == "")
        WinGet, winId, ID, A
    if (isPlugin(winId))
    {
        if (!rOnly)
        {
            GetKeyState, ks, r          ; r to rOnly
            cltrDown := ks == "D"
            if (cltrDown)
                Send {r up}
            rOnly := cltrDown
        }
        WinActivate, ahk_id %winId%
        if (is3xosc(winId))
            randomize3xosc()
        else if (isLfo(winId))
            randomizeLfo()
        else if (isRev(winId))
            randomizeRev()
        else if (isPatcherSampler())
            randomizePatcherSampler(winId)
        else if (isDelay(winId))
            randomizeDelay()
        else if (isRaveGen(winId))
            randomizeRaveGen()
        else if (isHarmless(winId))
            randomizeHarmless(winId, rOnly)
        else if (isSytrus(winId))
            randomizeSytrus(winId)
        else if (isFlex(winId))
            randomizeFlex(winId)
        else if (isPlucked(winId))
            randomizePlucked()
        else if (isPiano(winId))
            randomizePiano()
        else if (isAutogun(winId))
            randomizeAutogun()
        else if (isBeepMap(winId))
            randomizeBeepMap()
        else
        {
            toolTip("randomizing unknow plugin")
            WinGetPos,,, winW,, ahk_id %winId%
            presetButtX := winW-87
            moveMouse(presetButtX, 17)
            Click, Right
            Send r
            toolTip()
        }
    }
}
; --
randomizeSytrus(winId)
{
    WinGetPos,,, winW,, ahk_id %winId%
    presetButtX := winW - 55
    moveMouse(presetButtX, 17)
    Click, Right

    Random, n, 0, 29
    Loop, %n%
    {
        Send {Up}
    }
    Send {Right}
    
    Random, n, 0, 101
    Loop, %n%
    {
        Send {Up}
    }
    Send {Enter} 
}

randomizePlucked()
{
    presetButtX := 314
    ;MouseMove, %presetButtX%, 17, 0
    moveMouse(presetButtX, 17)
    Click, Right
    Send r 
}

randomizePiano()
{
    presetButtX := 436
    ;MouseMove, %presetButtX%, 17, 0
    moveMouse(presetButtX, 17)
    Click, Right
    if (oneChanceOver(2))
    {
        Random, n, 0, 5
        Loop, %n%
            Send {WheelUp}
    }
    else
    {
        Random, n, 0, 4
        Loop, %n%
            Send {WheelDown}        
    }
    Send {Enter}

    if (oneChanceOver(2))
    {
        ;MouseMove, %presetButtX%, 17, 0
        moveMouse(presetButtX, 17)
        Click, Right
        Send r
    }
}

randomizeBeepMap()
{
    presetButtX := 334
    ;MouseMove, %presetButtX%, 17, 0
    moveMouse(presetButtX, 17)
    Click, Right

    if (oneChanceOver(2))
    {
        wheel := "WheelUp"
    }
    else
    {
        wheel := "WheelDown"
    }
    Random, n, 0, 5
    Loop, %n%
        Send {%wheel%}
    Send {Enter}
    setEnvelopes(64)
}

randomizeAutogun()
{
    ;MouseMove, 55, 324, 0
    moveMouse(55, 324)
    Click
    Send {WheelDown}
    Click
    Random, n, 1, 675776362
    TypeText(n)
    Send {Enter}
}

randomizeFlex(winId)
{
    WinGetPos,,, winW,, ahk_id %winId%
    presetButtX := winW - 72   

    moveMouse(presetButtX, 17)
    Click, Right
    Random, n, 1, 66
    Loop, %n%
    {
        Sleep, 20
        Send {WheelDown}
    }
        Sleep, 20

    Send {Enter}
    if (oneChanceOver(4))
    {
        moveMouse(presetButtX, 17)
        Click, Right
        Send r
    }
}

randomizeRaveGen()
{
    moveMouse(761, 12)
    Sleep, 100
    Click, Right
    static numPresets := 24 + 52*2
    Random, n, 0, %numPresets%
    Loop, %n%
    {
        Send {WheelUp}
    }
    Send {Enter}
}

randomize3xosc()
{
    presetButtX := 499
    moveMouse(presetButtX, 17)
    Click, Right
    Send r

    set3xoscMainPanel()
    if (!stopExec)
        setEnvelopes()
    Click, 34, 48           ; main panel
}

randomizeLfo()
{
    presetButtX := 462
    moveMouse(presetButtX, 17)
    Click, Right
    Send rr{Enter}
}

randomizeRev()
{
    moveMouse(469, 17)
    Click, Right
    Send r
    setKnobValue(455, 97, 0.75) ;dry
    setKnobValue(483, 44, 0.25) ;er
    setKnobValue(511, 88, 0.25) ;wet
    dec := expRand(0, 1, 5)
    setKnobValue(402, 51, dec) ;dec
}

randomizeDelay()
{
    ;moveMouse(687, 11)                                 ; built-in randomization
    ;Click, Right
    ;Send rr{Enter}
    
    if (oneChanceOver(4, "invert"))                     ; tempo sync
        QuickClick(150, 68)     
    
    if (oneChanceOver(3))                               ; keep pitch
        QuickClick(150, 85)

    if (oneChanceOver(3))                               ; L R offset
        setKnobValue(229, 85, centeredExpRand(0, 1, 5))         

    if (oneChanceOver(3))                               ; mono stereo ping pong
        setKnobValue(270, 81, weightedRandomChoice([[0,1], [.3,3], [.6,2]]))         

    if (oneChanceOver(4))                               ; monoïze
        setKnobValue(355, 86, expRand(0, 1, .3))
    if (True)                                           ; FeedBack
        setKnobValue(418, 87, expRand(0, .75, 3))

    if (oneChanceOver(4))                               ; Mod
    {
        setKnobValue(90, 191, expRand(.1, 1, 3))        ; Rate
        if (oneChanceOver(2))
            setKnobValue(180, 198, expRand(0, 1, 3))    ; Time
        else
            setKnobValue(237, 197, expRand(0, 1, 3))    ; Cutoff
    }

    if (oneChanceOver(3))                               ; Filter
    {
        setKnobValue(481, 88, expRand(.1, 1, .6))       ; Cutoff
        setKnobValue(526, 85, expRand(0, .9, 3))        ; Res
    }
}

randomizeHarmless(winId, rOnly = False)
{
    presetButtX := 800
    ;MouseMove, %presetButtX%, 17, 0
    moveMouse(presetButtX, 17)
    Click, Right
    if (!rOnly)
    {
        Random, n, 3, 12
        if (n < 3 or n > 12)
            msgTip("randomizeHarmless error? " n)
        Loop, %n%
        {
            Send {WheelUp}
            Sleep, 5
        }
        Send {Right}
        Random, n, 1, 33
        Loop, %n%
        {
            Send {WheelDown}
            Sleep, 5
        }        
        Send {Enter}
    }

    if (rOnly or oneChanceOver(2))
    {
        ;MouseMove, %presetButtX%, 17, 0
        moveMouse(presetButtX, 17)
        Click, Right
        Send r
        Send {Enter}
    }
}

randomizePatcherSampler(winId)
{
    
    ; offset
    setKnobValue(132, 156, centeredExpRand(0, 1, 4, .15))         
                                                            ; lfo A 1 et 2
    ; lfo1                                                            
    if (oneChanceOver(2))                                            
        setKnobValue(196, 157, expRand(0, .5, 3))
    else
        setKnobValue(196, 157, 0)
    ; lfo2
    if (oneChanceOver(3))                                                
        setKnobValue(192, 216, expRand(0, .5, 3))                                                                     
    else
        setKnobValue(192, 216, 0)                                                                     
                                                            ; A R


}
; ------



; -- Other ------------------------------------
openPresetPlugin(n, pluginId = "")
{
    if (pluginId == "")
        pluginTitle := "ahk_class TPluginForm"
    else 
        pluginTitle := "ahk_id " pluginId
    if (WinActive(pluginTitle)) {
        Sleep, 100
        WinGetPos,,, winW,, A
        presetButtPosX := winW - 77
        MouseMove, %presetButtPosX%, 17, 0
        ;moveMouse(presetButtX, 17)
        MouseClick, Right
        Loop, %n%
        {
            Send, p
        }
        Send {Enter}
    }    
}

openPluginMainCtxMenu()
{
    global Mon1Top, Mon2Top
    WinGet, winID, ID, A
    WinGetPos, winX, winY,,, ahk_id %winID%
    if (winX >= 0)
        top := Mon2Top
    if (winX < 0)
        top := Mon1Top
    if (winY > 571 + top)
    {
        dist := winY - (571 + top)
        winY := winY - dist
        WinMove, ahk_id %winID%,, %winX%, %winY%
    }
    moveMouse(17, 16)
    Click
    ;MouseClick, Left, 17, 16
    Sleep, 50
}
; ----


; --- Master Edison ---------------------------------------------
masterEdisonTransport(mode)
{
    bringMasterEdison(False)
    Switch mode
    {
        ;142, 47     85, 47     173, 48     
    Case "stop":
        mX := 142
        mY := 47
    Case "playPause":
        mX := 85
        mY := 47
    Case "rec":
        mX := 173
        mY := 48
    }
    moveMouse(mX, mY)
    Click
}
; ----


; --- Delay -----------------------------------------------------
delaySetTime()
{
    if (!delayIsTempo())
        Click, 152, 69

    timeX := 103
    timeY := 85     
    vals := [1, 0.749674054794013, 0.499348109588027, 0.374185136519372, 0.249022164382041, 0.186440678313375, 0.123859191313386, 0.0821382012218237, 0.06127770524472, 0.0404172101989388, 0.0299869617447257, 0.0195567142218351, 0.0143415909260511]
    choices := ["4       --------- beats", "3    ", "2    ", "1.5  ", "1       ---------  beat", "3/4  ", "1/2  ", "1/3  ", "1/4  ", "1/6  ", "1/8  ", "1/12 ", "1/16 "]
    MouseMove, %timeX%, %timeY%, 0
    knobVal := copyKnob(False)
    MouseMove, %timeX%, %timeY%, 0

    toolTipChoiceIndex := indexOfClosestValue(knobVal, vals)
    res := toolTipChoice(choices)
    if (res == "accept")
    {
        val := vals[toolTipChoiceIndex]
        pasteKnob(False, val, "timeRelated")
    }
    return val
}

delayIsTempo()
{
    return colorsMatch(152, 69, [0xF3A682], 50, " ")
}
; ----

; --- LFO -------------------------------------------------------
lfoSetTime()
{
    phaseX := 494
    phaseY := 80 
    speedX := 448
    speedY := 79   
    vals := [0.899504101835191, 0.845200195908546, 0.79916125908494, 0.757591526955366, 0.699109219945967, 0.657692543230951 , 0.599608179181814, 0.55849761236459, 0.501255051232874, 0.46100159175694, 0.366000367328525, 0.405044691637158, 0.312890290282667, 0.276998898014426, 0.227852945216, 0.181997673586011, 0.154156973585486, 0.119995102286339, 0.0958583327010274, 0.0670074690133333, 0.0566762583330274]
    choices := ["4       --------- b4rs", "3      ", "2      ", "1.5      ", "4       --------- bars", "3      ", "2      ", "1.5", "4       --------- beats", "3    ", "2    ", "1.5", "1       ---------  beat", "3/4  ", "1/2        ----", "1/3  ", "1/4        ----", "1/6  ", "1/8  ", "1/12 ", "1/16 "]
    MouseMove, %speedX%, %speedY%, 0
    knobVal := copyKnob(False)
    MouseMove, %speedX%, %speedY%, 0
    toolTipChoiceIndex := indexOfClosestValue(knobVal, vals)
    res := toolTipChoice(choices)
    if (res == "accept")
    {
        val := vals[toolTipChoiceIndex]
        pasteKnob(False, val, "timeRelated")
        MouseMove, %phaseX%, %phaseY%, 0
        pasteKnob(False, 0, "other")
    }
    return val
}
; ----