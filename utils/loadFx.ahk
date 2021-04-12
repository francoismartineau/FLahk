loadFxFromChoice(choice)
{
    Switch choice
    {
    Case "mod":
        choices := ["Chorus+3F", "ringmod", "chorus", "phaser"]
    Case "filter":
        choices := ["EQ", "Equo", "3xFilter", "bass"]
    Case "pitch":
        choices := ["Vibrato", "Pitch shift"]
    Case "edit":
        choices := ["New Tone", "New Time", "Scratch"]
    Case "dyn":
        choices := ["gate", "compressor", "transient"]
    }
    Switch toolTipChoice(choices, "", randInt(1, choices.MaxIndex()), A_ThisHotkey)
    {
    Case "Chorus+3F":
        loadModulation()
    Case "ringmod":
        loadRingMod()
    Case "chorus":
        loadChorus()
    Case "phaser":
        loadPhaser()

    Case "EQ":
        loadEq()
    Case "Equo":
        loadEquo()
    Case "3xFilter":
        load3xFilter()
    Case "bass":
        loadBass()

    Case "Vibrato":
        loadVibrato()
    Case "Pitch shift":
        loadPitchShifter()

    Case "New Tone":
        loadNewTone()
    Case "New Time":
        loadNewTime()
    Case "Scratch":
        loadScratch()

    Case "gate":
        loadGate()
    Case "compressor":
        loadComp()
    Case "transient":
        loadTransient()

    }        
}


;-- Specific FX ----------------------------------------------------
loadRev()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(2)
    rename(mixerChannName " Rev", False, True)
    randomizeRev()
    moveMouse(512, 90)
    retrieveMouse := False
}

loadLfo()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(4)
    randomizeLfo()
    rename(mixerChannName " Peak", False, True)
    centerMouse(winId)
}

loadEq()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(9, 1)
    rename(mixerChannName " Eq", False, True)
    MouseMove, 606, 295, 0
    retrieveMouse := False
}

loadEquo()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(3)
    rename(mixerChannName " Equo", False, True)
    MouseMove, 432, 71, 0
    retrieveMouse := False
}

loadModulation()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(11)
    rename(mixerChannName " Mod", False, True)
    centerMouse(winId)
}

loadDelB()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(1, 1)
    Sleep, 300
    rename(mixerChannName " DelB", False, True)
    randomizePlugin(winId)
    centerMouse(winId)
}

loadDelay()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(25)
    Sleep, 300
    randomizeDelay()
    rename(mixerChannName " Delay", False, True)
    centerMouse(winId)   
}

loadStereos()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(1, 7)
    rename(mixerChannName " Stereos", False, True)
    centerMouse(winId)
}

loadDist()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(10)
    rename(mixerChannName " Dist", False, True)
    centerMouse(winId)
}

loadGate()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(23)
    rename(mixerChannName " Gate", False, True)
    centerMouse(winId)
}

loadAutoPan()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(20)
    rename(mixerChannName " AutoPan", False, True)
    centerMouse(winId)
}

loadSpeaker()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(12)
    rename(mixerChannName " Speaker", False, True)
    centerMouse(winId)
}

loadRingMod()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(1, 5)
    rename(mixerChannName " RingMod", False, True)
    centerMouse(winId)
}

load3xFilter()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(1, 2)
    rename(mixerChannName " 3xFilter", False, True)
    centerMouse(winId)
}

loadVibrato()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(1, 3)
    rename(mixerChannName " Vibrato", False, True)
    centerMouse(winId)
}

loadChorus()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(21)
    rename(mixerChannName " Chorus", False, True)
    centerMouse(winId)
}

loadPhaser()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(24)
    rename(mixerChannName " Phaser", False, True)
    centerMouse(winId)
}

loadConv()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(31)
    rename(mixerChannName " Conv", False, True)
    centerMouse(winId)
}

loadTransient()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(38, False, "trialVersion")
    rename(mixerChannName " Transient", False, True)
    centerMouse(winId)
}

loadScratch()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(37)
    rename(mixerChannName " Scratch", False, True)
    centerMouse(winId)
}

loadComp()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(22)
    rename(mixerChannName " Comp", False, True)
    centerMouse(winId)
}

loadNewTime()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(33)
    deactivateNewTimeToneKeyInput(winId)
    rename(mixerChannName " NewTime", False, True)
    centerMouse(winId)
}

loadNewTone()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(34, False, "bpmInfo")
    deactivateNewTimeToneKeyInput(winId)
    rename(mixerChannName " NewTone", False, True)
    centerMouse(winId)
}

loadBass()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(30)
    rename(mixerChannName " Bass", False, True)
    centerMouse(winId)
}

load3xGross()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(1, 9)
    Sleep, 300
    rename(mixerChannName " Gross", False, True)
    centerMouse(winId)
}

loadPitchShifter()
{
    mixerChannName := getMixerChanNameAndColor()
    winId := loadFx(1, 8)
    rename(mixerChannName " Pitch shift", False, True)
    centerMouse(winId)
}
; ----


; -- Utils -------------------------------------
loadFx(n, preset = False, prompt = "")
{
    pluginId :=
    bringMixer(False)
    WinGet, mixerID, ID, A
    if (findEmptySlot())
    {
        Click
        Send 1
        Loop % n
        {
            Send f
        }
        Send {Enter}
        Switch prompt
        {
        Case "trialVersion":
            waitNewWindowOfClass("TMsgForm", mixerID)
            Send {Esc}
            Click
        }
        pluginId := waitNewWindowOfClass("TPluginForm", mixerID)
        adjustFxPosition(pluginId)
        if (!leftScreenWindowsShown) 
            WinClose, ahk_id TFXForm
        moveWinLeftScreen(pluginId)
        if (preset)
            openPresetPlugin(preset, pluginId)
    }
    return pluginId
}

getFX1Y(x)
{
    col := [0x929DA4]                                               ; couleur bande séparatrice
    y := scanColorDown(x, -409  , 100, col, 10, 4, "")              ; à partir d'en haut du menu effets
    return y + 25
}


findEmptySlot()
{
    result := true
    moveMouseToFirstSlot()
    i := 1
    while (!mouseOverEmptySlot() && i <= 10)
    {
        moveMouseToNextSlot()
    i++
    }
    if (i > 10)
        result = false
    return result
}

moveMouseToFirstSlot()
{
    MouseMove 1763, 72
}

mouseOverEmptySlot()
{
    emptySlotColor := "0x566065"
    MouseGetPos X, Y 
    PixelGetColor Color, %X%, %Y%, RGB
    return Color == emptySlotColor
}

moveMouseToNextSlot()
{
    MouseMove 0, 29,, R
}

adjustFxPosition(pluginId)
{
    global Mon1Top, Mon2Top
    WinGetPos, winX, winY,,, ahk_id %pluginId%
    if (winX >= 0)
        top := Mon2Top
    else 
        top := Mon1Top

    if (winY> 571 + top)
    {
        winY := top + 1080 / 2
        WinMove, ahk_id %pluginId%,, %winX%, %winY%
    }
}

getMixerChanNameAndColor()
{
    ; Color is accessed simply by opening the name edit form
    if (isMixer())
    {

        Send {F2}
        clipboardSave := clipboard
        Send {CtrlDown}c{CtrlUp}{Esc}
        name := clipboard
        clipboard := clipboardSave
    }
    return name    
}

; ----