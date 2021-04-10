loadSpeech()
{
    winId := loadInstr("s")
    ;;; attendre le prompt du texte pour renommer? au pire pas
    ;rename("Spee " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

load3xosc()
{
    winId := loadInstr(6)
    while(!is3xosc(winID))
        sleep, 10
    randomize3xosc()
    rename("3x " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadHarmless()
{
    winId := loadInstr(4)
    randomizeHarmless(winId)
    rename("Har " randString(randInt(3, 4)), True)
    centerMouse(winId)
}

loadSlicex()
{
    winId := loadInstr(5)
    rename("Slicx " randString(randInt(3, 4)), True)
    centerMouse(winId)
}

loadFlex()
{
    winId := loadInstr(7)
    randomizeFlex(winId)
    rename("Flx " randString(randInt(3, 4)), True)
    centerMouse(winId)
}

loadBd()
{   ;;; changer le preset ça coupe toute le son?
    winId := loadInstr(8)
    centerMouse(winId)
}

loadSampler()
{
    winId := loadInstr(1, 1)
    centerMouse(winId)
}

loadChords()
{
    winId := loadInstr(1, 2)
    rename("Chords " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadGranular(centerM = True)
{
    winId := loadInstr(1, 3)
    rename("Gra " randString(randInt(1, 4)), True)
    if (centerM)
        centerMouse(winId)
    return winId
}

loadK()
{
    winId := loadInstr(1, 4)
    centerMouse(winId)
}

loadH()
{
    winId := loadInstr(1, 5)
    centerMouse(winId)
}

loadS()
{
    winId := loadInstr(1, 6)
    centerMouse(winId)
}

loadRaveGen()
{
    winId := loadInstr(10)
    randomizeRaveGen()
    Sleep, 100
    rename("Rave " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadSytrus()
{
    winId := loadInstr(11)
    randomizeSytrus(winId)
    rename("Sy " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadPlucked()
{
    winId := loadInstr(13)
    randomizePlucked()
    rename("Plu " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadPiano()
{
    winId := loadInstr(14)
    randomizePiano()
    rename("Pia " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadBooBass()
{
    winId := loadInstr(15)
    rename("Booba " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadBeepMap()
{
    winId := loadInstr(16)
    randomizeBeepMap()
    rename("BM " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadAutogun()
{
    winId := loadInstr(18)
    randomizeAutogun()
    rename("AG " randString(randInt(1, 4)), True)
    centerMouse(winId)
}

loadPatcherSlicex(placeMouse = True)
{
    winId := loadInstr(20)
    rename("slicex " randString(randInt(1, 4)), True)
    if (placeMouse)
        centerMouse(winId)
    return winId
}

loadLongSynth()
{
    winId := loadInstr(22)
    rename("long s " randString(randInt(1, 4)), True)
    return winId
}

loadVox()
{
    winId := loadInstr(23)
    rename("vox " randString(randInt(1, 4)), True)
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
loadInstr(n, preset = "",waitInstr = True)
{
    stepSeqId := bringStepSeq(False)
    if (WinActive("ahk_class TStepSeqForm"))
    {
        clickPlusButton(stepSeqId)
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
    }
    return pluginId
}

clickPlusButton(stepSeqId)
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