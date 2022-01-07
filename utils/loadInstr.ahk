loadSpeech()
{
    winId := loadInstrInStepSeq("s")
    ;;; attendre le prompt du texte pour renommer? au pire pas
    ;rename("Spee " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadSynth()
{
    name := "Synth " randString(randInt(1, 4))
    winId := loadInstr(1, 9, name)
    centerMouse(winId)
}

load3xosc()
{
    name :=
    winId := loadInstrInStepSeq(6)
    while(!is3xosc(winID))
        sleep, 10
    randomize3xosc()
    rename("3x " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadHarmless()
{
    name := "Har " randString(randInt(3, 4))
    winId := loadInstr(4, "", name)
    randomizeHarmless(winId)
    centerMouse(winId)
}

loadSlicex()
{
    name := "Slicx " randString(randInt(3, 4))
    winId := loadInstr(5, "", name)
    centerMouse(winId)
}

loadFlex()
{
    name := "Flx " randString(randInt(3, 4))
    winId := loadInstr(7, "", name)
    randomizeFlex(winId)
    centerMouse(winId)
}

loadBd()
{   ;;; changer le preset ça coupe toute le son?
    name := "BD " randString(randInt(1, 4))
    winId := loadInstr(8, "", name)
    centerMouse(winId)
}

loadChords()
{
    name := "Chords " randString(randInt(1, 4))
    winId := loadInstr(1, 2, name)
    centerMouse(winId)
}

loadGrnl(centerM = True)
{
    name := "Gra " randString(randInt(1, 4))
    winId := loadInstr(1, 3, name)
    if (centerM)
        centerMouse(winId)
    return winId
}

loadRaveGen()
{
    name := "Rave " randString(randInt(1, 4))
    winId := loadInstr(10, "", name)
    randomizeRaveGen()
    centerMouse(winId)
}

loadSytrus()
{
    name := "Sy " randString(randInt(1, 4))
    winId := loadInstr(11, "", name)
    randomizeSytrus(winId)
    centerMouse(winId)
}

loadPlucked()
{
    name := "Plu " randString(randInt(1, 4))
    winId := loadInstr(13, "", name)
    randomizePlucked()
    centerMouse(winId)
}

loadPiano()
{
    name := "Pia " randString(randInt(1, 4))
    winId := loadInstr(14, "", name)
    randomizePiano()
    centerMouse(winId)
}

loadBooBass()
{
    name := "Booba " randString(randInt(1, 4))
    winId := loadInstr(15, "", name)
    centerMouse(winId)
}

loadBeepMap()
{
    name := "BM " randString(randInt(1, 4))
    winId := loadInstrInStepSeq(16, "", name)
    rename(name, True)
    randomizeBeepMap()
    centerMouse(winId)
}

loadAutogun()
{
    name := "AG " randString(randInt(1, 4))
    winId := loadInstr(18, "", name)
    randomizeAutogun()
    centerMouse(winId)
}

loadPatcherSlicex(placeMouse := True)
{
    name := "slicex " randString(randInt(1, 4))
    winId := loadInstr(1, 8, name)
    if (placeMouse)
        centerMouse(winId)
    return winId
}

loadLongSynth()
{
    name := "long s " randString(randInt(1, 4))
    winId := loadInstrInStepSeq(21, "", name)
    centerMouse(winId)
    return winId
}

loadVox()
{
    name := "vox " randString(randInt(1, 4))
    winId := loadInstr(22, "", name)
    centerMouse(winId)
    return winId
}

loadRandomFlSynth()
{
    Random, s, 1, 3
    Switch s
    {
    Case 1:
        loadHarmless()
    Case 2:
        loadSytrus()
    Case 3:
        loadFlex()
    }
}

; -----------------------------------------
loadInstr(n, preset := "", name := "")
{
    choices := ["step seq", "new patcher", "existing patcher"]
    location := askLoadLocation(choices)
    winId := reachLoadLocation(choices, location)

    if (InStr(location, "patcher") and isPatcherMap(winId) and placeMouseOnMidiKnot())
        pluginId := patcherLoadPlugin("instr", name, n, preset)
    else if (InStr(location, "step"))
    {
        pluginId := loadInstrInStepSeq(n, preset)
    }
    return pluginId
}

askLoadLocation(choices)
{
    title := "Load in:"
    initIndex := randInt(1, 2)
    res := toolTipChoice(choices, title, initIndex, "Win")
    return res
}

reachLoadLocation(choices, location)
{
    Switch location
    {
    Case choices[1]:
        winId := bringStepSeq(False)
    Case choices[2]:
        winId := createRootPatcher()
    Case choices[3]:
        winId := activateExistingRootPatcher()
    }
    return winId
}

createRootPatcher()
{
    winId := loadInstrInStepSeq(1, 10)
    rename("RP " randString(randInt(1, 4)))
}

activateExistingRootPatcher()
{
    while (!isPatcherMap(winId))
    {
        res := waitToolTip("Activate RootPatcher")
        if (!res)
            return
        WinGet, winId, ID, A
    }
    return winId
}

placeMouseOnMidiKnot()
{
    mouseOverKnot := False
    while (!mouseOverKnot)
    {
        res := waitToolTip("PatcherMap: place mouse on knot")       
        if (!res)
            return
        mouseOverKnot := mouseOverMidiKnot()
    }
    MouseGetPos,,, patcherId
    if (!WinActive("ahk_id " patcherId))
        WinActivate, ahk_id %patcherId%  
    return mouseOverKnot
}

loadInstrInStepSeq(n, preset := "", name := "", waitInstr := True)
{
    stepSeqId := bringStepSeq(False)
    if (WinActive("ahk_class TStepSeqForm"))
    {
        clickStepSeqPlusButton(stepSeqId)
        if (n == "s")
        {
            Send sssss
            Send {Enter}
        }
        else
        {
            Send 1
            Loop % n
            {
                Send i
            }
            Send {Enter}
        }


        if (waitInstr or preset)
        {
            if (n == "s")
                class := "TSpeechForm"
            else
                class := "TPluginForm"
            pluginId := waitNewWindowOfClass(class, stepSeqId)
        }
        
        if (preset)
            openPresetPlugin(preset, pluginId)
        if (name != "")
            rename(name, True)
            
        isPatcher := n == 1
        if (isPatcher)
        {
            bringStepSeq(False)
            selChanToggleMidiChannelThrough()
            WinActivate, ahk_id %pluginId%
        }
    }
    moveInstRightScreen(pluginId)
    return pluginId  
}



clickStepSeqPlusButton(stepSeqId)
{
    WinGetPos, winX, winY, winW, winH, ahk_id %stepSeqId%
    adjustedWinPos := False
    ;if (winY + winH < 290)                                          ; if + is too high
    ;{
    ;    y := 290 - winH
    ;    WinMove, ahk_id %stepSeqId%,,, %y%                          ; temporarily move down window
    ;    adjustedWinPos := True
    ;}
    y := winH - 20
    MouseClick, Left, 262, %y%                                      ; click + 
    ;if (adjustedWinPos)
    ;    WinMove, ahk_id %stepSeqId%,, winX, winY, winW, winH        ; move back window
}

/*
clickInstr(n, stepSeqId)
{
    x := 169                                    ; relative to win
    instr1Ypos := 360                           ; relative to screen
    WinGetPos,, winY,,, ahk_id %stepSeqId%
    instr1Ypos := instr1Ypos - winY             ; now relative to win
    y := instr1Ypos + (n-1)*20
    Click, %x%, %y%
}
*/