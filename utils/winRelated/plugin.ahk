﻿; -- Randomize plugin -------------------------------
randomizePlugin(winId := "", rOnly := False)
{
    bringFl()
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
    if (isWrapperPlugin(winId))
        return
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
    if (isWrapperPlugin(winId))
        return    
    presetButtX := 314
    ;MouseMove, %presetButtX%, 17, 0
    moveMouse(presetButtX, 17)
    Click, Right
    Send r 
}

randomizePiano()
{
    if (isWrapperPlugin(winId))
        return    
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
    if (isWrapperPlugin(winId))
        return    
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
    if (isWrapperPlugin(winId))
        return    
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
    if (isWrapperPlugin(winId))
        return    
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

randomizeLfo(deactPeak := False)
{
    if (!isWrapperPlugin())
    {
        presetButtX := 462
        moveMouse(presetButtX, 17)
        Click, Right
        Send rr{Enter}

        if (deactPeak)
        {
            peakBaseX := 40
            peakBaseY := 80
            Knob.setVal(peakBaseX, peakBaseY, 0)
            peakVolX := 86
            peakVolY := 81
            Knob.setVal(peakVolX, peakVolY, .5)
        }
    }
    ; probability of every choices in the speed possibilities
    valIndex := weightedRandomChoiceIndexOnly([1,1,1,1,2,3,5,7,10,7,8,7,10,7,10,6,7,3,3,1,1])
    lfoSetTime(valIndex, True)
}

randomizeRev()
{
    if (isWrapperPlugin(winId))
        return  
    moveMouse(469, 17)
    Click, Right
    Send r
    Knob.setVal(455, 97, 0.75) ;dry
    Knob.setVal(483, 44, 0.25) ;er
    Knob.setVal(511, 88, 0.25) ;wet
    dec := expRand(0, 1, 5)
    Knob.setVal(402, 51, dec) ;dec
}

randomizeDelay()
{
    ;moveMouse(687, 11)                                 ; built-in randomization
    ;Click, Right
    ;Send rr{Enter}
    
    if (oneChanceOver(4, "invert"))                     ; tempo sync
        quickClick(150, 68)     
    
    if (oneChanceOver(3))                               ; keep pitch
        quickClick(150, 85)

    if (oneChanceOver(3))                               ; L R offset
        Knob.setVal(229, 85, centeredExpRand(0, 1, 5))         

    if (oneChanceOver(3))                               ; mono stereo ping pong
        Knob.setVal(270, 81, weightedRandomChoice([[0,1], [.3,3], [.6,2]]))         

    if (oneChanceOver(4))                               ; monoïze
        Knob.setVal(355, 86, expRand(0, 1, .3))
    if (True)                                           ; FeedBack
        Knob.setVal(418, 87, expRand(0, .75, 3))

    if (oneChanceOver(4))                               ; Mod
    {
        Knob.setVal(90, 191, expRand(.1, 1, 3))        ; Rate
        if (oneChanceOver(2))
            Knob.setVal(180, 198, expRand(0, 1, 3))    ; Time
        else
            Knob.setVal(237, 197, expRand(0, 1, 3))    ; Cutoff
    }

    if (oneChanceOver(3))                               ; Filter
    {
        Knob.setVal(481, 88, expRand(.1, 1, .6))       ; Cutoff
        Knob.setVal(526, 85, expRand(0, .9, 3))        ; Res
    }
}

randomizeHarmless(winId, rOnly = False)
{
    if (isWrapperPlugin(winId))
        return
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

randomizePatcherSampler(winId)  ; deprecated
{
    ; offset
    Knob.setVal(132, 156, centeredExpRand(0, 1, 4, .15))         
                                                            ; lfo A 1 et 2
    ; lfo1                                                            
    if (oneChanceOver(2))                                            
        Knob.setVal(196, 157, expRand(0, .5, 3))
    else
        Knob.setVal(196, 157, 0)
    ; lfo2
    if (oneChanceOver(3))                                                
        Knob.setVal(192, 216, expRand(0, .5, 3))                                                                     
    else
        Knob.setVal(192, 216, 0)                                                                     
                                                            ; A R
}
; ------



; -- Window -----
moveInstrRightScreen(winId)
{
    MoveWin.switchMon("right", winId)
    MoveWin.centerInMon(winId) 
}
moveFxLeftScreen(winId)
{
    MoveWin.switchMon("left", winId)
    MoveWin.centerInMon(winId) 
}
; --

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
        moveMouse(presetButtPosX, 17)
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

deactivateNewTimeToneKeyInput(winId)
{
    WinGetPos,,, winW,, ahk_id %winId%
    x := winW - 72
    MouseMove, %x%, 12, 0
    Click
    Sleep, 500
}

closePluginsNotInHistory()
{
    stopWinHistoryClock()
    WinGet, currWinId, ID, A
    WinGet, pluginIds, List, ahk_class TPluginForm
    i := 1
    while (i <= pluginIds)
    {
        name = pluginIds%i%
        id := %name%
        if (!inWinHistory(id, "plugin") and !isMasterEdison(id) and !isControlSurface(id))
        {
            WinActivate, ahk_id %id%
            Sleep, 50
            Send {Esc}
        }
        i ++
    }
    WinActivate, ahk_id %currWinId%
    startWinHistoryClock()
}

closeWrapperPlugin(winId := "")
{
    if (winId == "")
        WinGet, winId, ID, A
    if (!WinActive("ahk_id " winId))
        WinActivate, ahk_id %winId%
    removeWinFromHistoryById(winId, "plugin")
    WinClose, ahk_id %winId%
}

filterPluginTitle(title := "")
{
    if (title == "")
        WinGetTitle, title, A
    title := StrSplit(title, " ")[1]
    title := StrReplace(title, " ", "") ; espace insécable obtenu par ahk fournissant le titre au clipboard
    return title
}

inPluginTitle(pluginId, title)
{
    WinGetTitle, pluginTitle, ahk_id %pluginId%
    return InStr(pluginTitle, title)
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
    knobVal := Knob.copy(False)
    MouseMove, %timeX%, %timeY%, 0

    index := indexOfClosestValue(knobVal, vals)
    val := toolTipChoice(choices, "", index)
    if (val != "")
    {
        val := vals[toolTipChoiceIndex]
        Knob.paste(False, val, "time")
    }
    return val
}

delayIsTempo()
{
    return colorsMatch(152, 69, [0xF3A682], 50)
}
; ----

; --- Rev -------------------------------------------------------
revSetTime()
{
    revActivateTempo() 
    delayX := 254
    delayY := 51
    vals := [1, 0.75, .5, 0.375, 0.25, 0.125, 0]
    choices := ["2 beats", "1.5", "1 beat", "3/4", "1/2", "1/4", "0"]
    moveMouse(delayX, delayY)
    currVal := Knob.copy(False)
    moveMouse(delayX, delayY)
    initIndex := indexOfClosestValue(currVal, vals)
    if (toolTipChoice(choices, "", initIndex))
        val := vals[toolTipChoiceIndex]    
    if (val != "")
        Knob.setVal(delayX, delayY, val)
}

revActivateTempo()
{
    if (!revTempoActivated())
        quickClick(300, 61)
}

revTempoActivated()
{
    return colorsMatch(300, 61, [0xc8a398])
}
; ----

; --- LFO -------------------------------------------------------
lfoSetTime(valIndex := "", displayRes := False, currVal := "")
{
    phaseX := 494
    phaseY := 80 
    speedX := 448
    speedY := 79   
    vals := [0.899504101835191, 0.845200195908546, 0.79916125908494, 0.757591526955366, 0.699109219945967, 0.657692543230951 , 0.599608179181814, 0.55849761236459, 0.501255051232874, 0.46100159175694, 0.405044691637158, 0.366000367328525 , 0.312890290282667, 0.276998898014426, 0.227852945216, 0.181997673586011, 0.154156973585486, 0.119995102286339, 0.0958583327010274, 0.0670074690133333, 0.0566762583330274]
    choices := ["4       --------- b4rs", "3      ", "2      ", "1.5      ", "4       --------- bars", "3      ", "2      ", "1.5", "4       --------- beats", "3    ", "2    ", "1.5", "1       ---------  beat", "3/4  ", "1/2        ----", "1/3  ", "1/4        ----", "1/6  ", "1/8  ", "1/12 ", "1/16 "]
    moveMouse(speedX, speedY)
    if (valIndex == "")
    {
        currVal := Knob.copy(False)
        moveMouse(speedX, speedY)
        initIndex := indexOfClosestValue(currVal, vals)
        if (toolTipChoice(choices, "", initIndex))
            val := vals[toolTipChoiceIndex]
    }
    else if (currVal != "")
    {
        initIndex := indexOfClosestValue(currVal, vals)
        if (toolTipChoice(choices, "", initIndex))
            val := vals[toolTipChoiceIndex]
    }
    else
    {
        val := vals[toolTipChoiceIndex]
        if (displayRes)
            msgTip(val, 500)
    }

    if (val != "")
    {
        Knob.paste(False, val, "time")
        moveMouse(phaseX, phaseY)
        MouseMove, %phaseX%, %phaseY%, 0
        Knob.paste(False, 0, "normal")
    }
    return val
}
; ----

; --- Sample Clip -----------------------------------------------
getReadyToDragFromSampleClip()
{
    readyToDrag := True
    startHighlight("sampleClip")
    moveMouse(275, 388)
}

mouseOverSampleClipSound()
{
    res := False
    MouseGetPos, mX, mY
    if (isSampleClip())
        res := mY > 326 and mY < 455 and mX > 11 and mX < 556
    return res
}
; ----


; --- 3xGross ---------------------------------------------------
mouseOn3xGrossReveal()
{
    res := False
    MouseGetPos, mX, mY, winId
    if (is3xGross(winId))
        res := colorsMatch(mX, mY, [0x335A74])
    return res
}

reveal3xGross()
{
    static 3xGrossGrossX := 537
    static 3xGrossGrossY := [99, 200, 292]
    static 3xGrossSquaresTopY := ["", 230, 320]
    MouseGetPos, mX, mY, gross3xId
    WinGetPos, winX, winY,,, ahk_id %gross3xId%
    quickClick(68, 45)              ; Map
    Send {AltDown}
    if (mY < 3xGrossSquaresTopY[2])
        quickClick(3xGrossGrossX, 3xGrossGrossY[1])
    else if (my < 3xGrossSquaresTopY[3])
        quickClick(3xGrossGrossX, 3xGrossGrossY[2])
    else
        quickClick(3xGrossGrossX, 3xGrossGrossY[3])
    Send {AltUp}

    toolTip("waiting Gross")
    grossId := waitNewWindowOfClass("TWrapperPluginForm", gross3xId, 100)
    if (!grossId)
    {
        SendInput !{LButton}
        grossId := waitNewWindowOfClass("TWrapperPluginForm", gross3xId, 100)
    }
    toolTip("")
    WinActivate, ahk_id %gross3xId%
    patcherActivateSurface(gross3xId)
    WinActivate, ahk_id %grossId%
    winX += 100
    winY += 100
    WinMove, ahk_id %grossId%,, %winX%, %winY%
}
; ----

; -- patcherMod ------------------
mouseOverPatcherModChorusSpeed()
{
    res := False
    MouseGetPos, mX, mY, winId
    if (isPatcherMod(winId))
        res := colorsMatch(mX, mY, [0x80785C])
    return res    
}

patcherModChorusSpeed()
{
    WinGet, patcherModId, ID, A
    MouseGetPos, mX, mY
    MouseMove, 72, 45, 0                    ; Map
    Click
    MouseMove, 397, 353, 0
    Click, 2

    lfoId := waitNewWindowOfClass("TWrapperPluginForm", patcherModId)
    WinMove, ahk_id %lfoId%,, 188, 222
    WinActivate, ahk_id %lfoId%
    newVal := lfoSetTime("", False, currVal)
    WinClose, ahk_id %lfoId%
    WinActivate, ahk_id %patcherModId%
    MouseMove, 128, 45                      ; Surface
    Click   
}
; ----

; -- EnvC ------------------
envcActivateArticulator(n)
{
    if (n < 5)
        x := 150
    else
        x := 170
    
    n -= 1
    y := {0: 45, 1: 70, 2: 90, 3: 115}[Mod(n, 4)]
    y += (!isWrapperPlugin())*yOffsetWrapperPlugin
    moveMouse(x, y)
    Click
}
; ----