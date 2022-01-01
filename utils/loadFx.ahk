loadFxFromChoice(choice, mode := "mixer")        ; Drop menu for fx within a CATEGORY (in caps in gui)
{
    Switch choice
    {
    Case "mod":
        choices := ["Chorus+3F", "ringmod", "chorus", "phaser", "ModMidi"]
    Case "filter":
        choices := ["EQ", "Equo", "3xFilter", "bass"]
    Case "pitch":
        choices := ["Vibrato", "Pitch shift"]
    Case "edit":
        choices := ["New Tone", "New Time", "Scratch"]
    Case "dyn":
        choices := ["gate", "compressor", "transient"]
    Case "patcher4":
        choices := ["stereos", "equos", "mod+lfos", "phasers"]
    Case "room":
        choices := ["rev", "delay", "conv", "delB"]
    Case "seq":
        choices := ["3xGross", "EnvFx", "3xGrossKnobs"]
    }
    Switch toolTipChoice(choices, "", randInt(1, choices.MaxIndex()), A_ThisHotkey)
    {
    Case "Chorus+3F":
        loadModulation(mode)
    Case "ringmod":
        loadRingMod(mode)
    Case "chorus":
        loadChorus(mode)
    Case "phaser":
        loadPhaser(mode)

    Case "EQ":
        loadEq(mode)
    Case "Equo":
        loadEquo(mode)
    Case "3xFilter":
        load3xFilter(mode)
    Case "bass":
        loadBass(mode)

    Case "Vibrato":
        loadVibrato(mode)
    Case "Pitch shift":
        loadPitchShifter(mode)

    Case "New Tone":
        loadNewTone(mode)
    Case "New Time":
        loadNewTime(mode)
    Case "Scratch":
        loadScratch(mode)

    Case "gate":
        loadGate(mode)
    Case "compressor":
        loadComp(mode)
    Case "transient":
        loadTransient(mode)
    Case "stereos":
        loadStereos(mode)
    Case "equos":
        loadEquos(mode)
    Case "mod+lfos":
        loadModLfos(mode)
    Case "phasers":
        loadPhasers(mode)
    Case "rev":
        loadRev(mode)
    Case "delay":
        loadDelay(mode)
    Case "conv":
        loadConv(mode)
    Case "delB":
        loadDelB(mode)
    Case "3xGrossKnobs":
        load3xGross(mode, "classic")
    Case "3xGross":
        load3xGross(mode, "midi")
    Case "ModMidi":
        loadModMidi(mode)
    Case "EnvFx":
        loadEnvFx(mode)
    }        
}


;-- Specific FX ----------------------------------------------------
loadRev(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(2)
        rename(mixerChannName " Rev", False, True)
        randomizeRev()
        moveMouse(512, 90)
        retrieveMouse := False
    }
    else if (mode == "patcher")
    {
        patcherLoadPlugin("fx", "rev", 2)
    }
}

loadLfo(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(4)
        randomizeLfo()
        rename(mixerChannName " Peak", False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
        patcherId := patcherLoadPlugin("fx", "LFO " randString(2), 4, "", "loadLfoPromptFunc")
}

loadLfoPromptFunc()
{
    onAudioKnot := False
    while (!onAudioKnot)
    {
        res := waitToolTip("Place LFO, Leave mouse over left knot")
        if (!res)
            return
        onAudioKnot := mouseOverAudioKnot()   
    }
    
    ; for some reason, the plugin opens during those operations.
    ; when performed slower, it doesn't open...
    Click, R
    Send {Down}{Enter}
    Sleep, 100

    MouseMove, 103, 0, 0, R
    Click, R
    Send {Down}{Enter}

    MouseMove, -50, 0, 0, R
    Click, R
    Send o{Right}{Down}{Down}{Right}{Up}{Enter}
    Click, R
    Send o{Right}{Down}{Down}{Right}{Up}{Up}{Enter}  
    Sleep, 200
}

loadFormulaCtl(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(28)
        randomizeLfo()
        rename(mixerChannName " Peak", False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
        winId := patcherLoadPlugin("fx", "ctl", 28, "", "loadFormulaCtlPromptFunc")    
}

loadFormulaCtlPromptFunc()
{
    res := waitToolTip("Place Formula Ctl, leave mouse over")
    if (!res)
        return
    Click, R
    Sleep, 100
    Send i
    Send {Down}
    Sleep, 100
    Send {Right}
    Sleep, 100
    Send {Down}
    Sleep, 100
    Send {Enter}
    Sleep, 100
    
    Click, R
    Sleep, 100
    Send o
    Sleep, 100
    Send {Down}
    Sleep, 100
    Send {Right}
    Sleep, 100
    Send {Up}
    Sleep, 100
    Send {Enter}
    Sleep, 100
}

loadEq(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(9, 1)
        rename(mixerChannName " Eq", False, True)
        MouseMove, 606, 295, 0
        retrieveMouse := False        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "eq", 9, 1)
}

loadEquo(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(3)
        rename(mixerChannName " Equo", False, True)
        MouseMove, 432, 71, 0
        retrieveMouse := False        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "equo", 3)
}

loadModulation(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(11)
        rename(mixerChannName " Mod", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "mod", 11)
}

loadDelB(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, 1)
        Sleep, 300
        rename(mixerChannName " DelB", False, True)
        randomizePlugin(winId)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "delb", 1, 1)
}

loadDelay(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(25)
        Sleep, 300
        randomizeDelay()
        rename(mixerChannName " Delay", False, True)
        centerMouse(winId)          
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "delay", 25)
}

loadStereos(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, 7)
        rename(mixerChannName " Stereos", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "stereos", 1, 7)
}

loadEquos(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, 11)
        rename(mixerChannName " Equos", False, True)
        centerMouse(winId)          
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "equos", 1, 11)
}


loadModLfos(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, 12)
        rename(mixerChannName " Mod+Lfos", False, True)
        centerMouse(winId)           
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "mod+lfos", 1, 12)
}

loadPhasers(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, 13)
        rename(mixerChannName " Phasers", False, True)
        centerMouse(winId)            
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "phasers", 13)
}

loadDist(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(10)
        rename(mixerChannName " Dist", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "dist", 10)
}

loadGate(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(23)
        rename(mixerChannName " Gate", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "gate", 23)
}

loadAutoPan(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(20)
        rename(mixerChannName " AutoPan", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "auto pan", 20)
}

loadSpeaker(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(12)
        rename(mixerChannName " Speaker", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "speaker", 12)
}

loadRingMod(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, 5)
        rename(mixerChannName " RingMod", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "ring mod", 1, 5)
}

load3xFilter(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, 2)
        rename(mixerChannName " 3xFilter", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "3xFilter", 1, 2)
}

loadVibrato(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, 3)
        rename(mixerChannName " Vibrato", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "vibrato", 1, 3)
}

loadChorus(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(21)
        rename(mixerChannName " Chorus", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "chorus", 21)
}

loadPhaser(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(24)
        rename(mixerChannName " Phaser", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "phaser", 24)
}

loadConv(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(31)
        rename(mixerChannName " Conv", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "conv", 31)
}

loadTransient(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(38, False, "trialVersion")
        rename(mixerChannName " Transient", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        msg("not implemented")
}

loadScratch(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(37)
        rename(mixerChannName " Scratch", False, True)
        centerMouse(winId)        
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "scratch", 37)
}

loadComp(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(22)
        rename(mixerChannName " Comp", False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "comp", 22)
}

loadNewTime(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(33)
        deactivateNewTimeToneKeyInput(winId)
        rename(mixerChannName " NewTime", False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "new time", 33)
}

loadNewTone(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(34, False, "bpmInfo")
        deactivateNewTimeToneKeyInput(winId)
        rename(mixerChannName " NewTone", False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
        msg("not implemented")
}

loadBass(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(30)
        rename(mixerChannName " Bass", False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "bass", 30)
}

load3xGross(mode := "mixer", version := "midi")
{
    Switch version
    {
    Case "midi":
        preset := 14
    Case "classic":
        preset := 9
    }
    if (mode == "mixer")
    {       
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, preset)
        Sleep, 300
        rename(mixerChannName " Gross", False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
    {
        if (version == "midi")
        {
            res := waitToolTip("Midi port will not work. Instead route port 21-26 from Root Patcher to its main entry.")
            if (!res)
                return
        }
        patcherLoadPlugin("fx", "3xGross", 1, preset)
    }
}

loadModMidi(mode := "mixer")
{
    inst := 1
    preset := 15
    if (mode == "mixer")
    {       
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(inst, preset)
        Sleep, 300
        rename(mixerChannName " ModMidi", False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
    {
        patcherLoadPlugin("fx", "MidiMod", inst, preset)
    }    
}

loadPitchShifter(mode := "mixer")
{
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(1, 8)
        rename(mixerChannName " Pitch shift", False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", "pitch shift", 1, 8)
}

loadEnvFx(mode := "mixer")
{
    inst := 1
    preset := 16
    name := "EnvFx"
    if (mode == "mixer")
    {
        mixerChannName := getMixerChanNameAndColor()
        winId := loadFx(inst, preset)
        rename(mixerChannName " " name, False, True)
        centerMouse(winId)
    }
    else if (mode == "patcher")
        patcherLoadPlugin("fx", name, inst, preset)
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
    y := scanColorsDown(x, -409  , 100, col, 10, 4, "")              ; à partir d'en haut du menu effets
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
        ;clipboardSave := clipboard
        ;Send {CtrlDown}c{CtrlUp}{Esc}
        name := copyTextWithClipboard()
        Send {Esc}
        ;clipboard := clipboardSave
    }
    return name    
}

; ----