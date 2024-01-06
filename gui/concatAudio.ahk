;;;;
;; avoir un slider de temps en BPM / avec multiplication à côté
;; les deux s'ajustent en même temps

global ConcatAudioShown := False

; path
global ConcatAudioPaths := []
global ConcatAudioFolder1
global ConcatAudioFolder2
global ConcatAudioFolder3
global ConcatAudioFolder4
global ConcatAudioFolder5
global ConcatAudioFolderEmpty := "----"
global ConcatAudioFolder1id
global ConcatAudioFolder2id
global ConcatAudioFolder3id
global ConcatAudioFolder4id
global ConcatAudioFolder5id

; num
global ConcatAudioMinNum := 3
global ConcatAudioMaxNum := 128
global ConcatAudioNumSliderVal
global ConcatAudioNumText
global ConcatAudioNumSliderID
global ConcatAudioNumTextID
global ConcatAudioForceNumToggle
global ConcatAudioForceNumToggleID

; len
global ConcatAudioMinLen := .01
global ConcatAudioMaxLen := 10
global ConcatAudioLenSliderVal
global ConcatAudioLenSliderID
global ConcatAudioLenText
global ConcatAudioLenTextID
global ConcatAudioLenToggle
global ConcatAudioLenToggleID
global ConcatAudioBpm
global ConcatAudioBpmID
global ConcatAudioBpmToggle

; gate
global ConcatAudioMinGate := -40
global ConcatAudioMaxGate := -5
global ConcatAudioGateSliderVal
global ConcatAudioGateSliderID
global ConcatAudioGateText
global ConcatAudioGateTextID
global ConcatAudioGateToggle
global ConcatAudioGateToggleID

; run
global ConcatAudioRunButtonID



makeConcatAudioButtons()
{
    makeConcatAudioBrowseHint()
    makeConcatAudioPathsText()
    makeConcatAudioNumSlider()
    makeConcatAudioLenSlider()
    makeConcatAudioGateSlider()
    makeConcatAudioRunButton()
}

hideConcatAudio()
{
    Gui, Main2:Show, h%gui2H%
    ConcatAudioShown := false
}

showConcatAudio()
{    
    ConcatAudioShown := true
    randomizeConcatAudioPath(1)
    i := 2
    while (i <= 5)
    {
        disableConcatAudioPath(i)
        i := i + 1
    }
    randomizeConcatAudioNumSlider()
    randomizeConcatAudioLenSlider()
    randomizeConcatAudioGateSlider()
    chooseGateLenMode()
    Gui, Main2:Show, h%maxedGui2H%
    moveMouse(783, 126)
}




; -- make ------------------------------
; paths
makeConcatAudioBrowseHint()
{
    global gui2H
    y := gui2H + 15    
    Gui, Main2:Add, Text, x10 y%y% h20 w800 gCONCAT_AUDIO_BROWSE, !^: search      !v: go to run button
    return

    CONCAT_AUDIO_BROWSE:
    freezeExecute("browseRandomSingleSound", [], False)
    return
}

makeConcatAudioPathsText()
{
    Gui, Main2:Add, Text, x10 y+10 h20 w200 vConcatAudioFolder1 hwndConcatAudioFolder1Id gPICK_CONCAT_AUDIO_PATH1,
    Gui, Main2:Add, Text, x+10 h20 w200 vConcatAudioFolder2 hwndConcatAudioFolder2Id gPICK_CONCAT_AUDIO_PATH2,
    Gui, Main2:Add, Text, x+10 h20 w200 vConcatAudioFolder3 hwndConcatAudioFolder3Id gPICK_CONCAT_AUDIO_PATH3,
    Gui, Main2:Add, Text, x+10 h20 w200 vConcatAudioFolder4 hwndConcatAudioFolder4Id gPICK_CONCAT_AUDIO_PATH4,
    Gui, Main2:Add, Text, x+10 h20 w200 vConcatAudioFolder5 hwndConcatAudioFolder5Id gPICK_CONCAT_AUDIO_PATH5,
    i := 1
    while (i <= 5)
    {
        updateConcatAudioPath(i)
        i := i + 1
    }
    return

    PICK_CONCAT_AUDIO_PATH1:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(1)
        else
            pickConcatAudioPaths(1)
    return

    PICK_CONCAT_AUDIO_PATH2:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(2)
        else
            pickConcatAudioPaths(2)
    return

    PICK_CONCAT_AUDIO_PATH3:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(3)
        else
            pickConcatAudioPaths(3)
    return

    PICK_CONCAT_AUDIO_PATH4:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(4)
        else
            pickConcatAudioPaths(4)
    return

    PICK_CONCAT_AUDIO_PATH5:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(5)
        else
            pickConcatAudioPaths(5)
    return
}


; num
makeConcatAudioNumSlider()
{
    minSlider := LogarithmicToLinear(ConcatAudioMinNum)
    maxSlider := LogarithmicToLinear(ConcatAudioMaxNum)
    global ConcatAudioNumSliderVal_TT := "Number of sounds to be used in the generated file"
    Gui, Main2:Add, Slider, x10 y+5 w200 Range%minSlider%-%maxSlider% NoTicks vConcatAudioNumSliderVal gUPDATE_CONCAT_AUDIO_NUM_SLIDER AltSubmit hwndConcatAudioNumSliderID,
    Gui, Main2:Add, Text, x+0 w15 vConcatAudioNumText hwndConcatAudioNumTextID,
    global ConcatAudioForceNumToggle_TT := "Force num: If requested num is higher than number of sounds, reuse some"
    Gui, Main2:Add, CheckBox, x+0 w30 vConcatAudioForceNumToggle hwndConcatAudioForceNumToggleID checked,
    updateConcatAudioNumSlider()
    return

    UPDATE_CONCAT_AUDIO_NUM_SLIDER:
    if (ConcatAudioShown)
        updateConcatAudioNumSlider()
    return
}

; len
makeConcatAudioLenSlider()
{
    global ConcatAudioMinLen, ConcatAudioMaxLen, ConcatAudioLenSliderVal, ConcatAudioLenSliderID
    global ConcatAudioLenText, ConcatAudioLenTextID
    global ConcatAudioLenToggle, ConcatAudioLenToggleID
    minSlider := LogarithmicToLinear(ConcatAudioMinLen)
    maxSlider := LogarithmicToLinear(ConcatAudioMaxLen)
    global ConcatAudioLenSliderVal_TT := "Length of every sound in sec"
    Gui, Main2:Add, Slider, x+20 w150 Range%minSlider%-%maxSlider% NoTicks vConcatAudioLenSliderVal gUPDATE_CONCAT_AUDIO_LEN_SLIDER AltSubmit hwndConcatAudioLenSliderID,
    Gui, Main2:Add, Text, x+0 w30 h30 vConcatAudioLenText hwndConcatAudioLenTextID,
    global ConcatAudioBpm_TT := ConcatAudioLenSliderVal_TT "`r`nClick to set."
    Gui, Main2:Add, Text, x+2 w40 h30 vConcatAudioBpm gCONCAT_AUDIO_BPM hwndConcatAudioBpmID,
    global ConcatAudioLenToggle_TT := "Apply length of sounds parameter"
    Gui, Main2:Add, CheckBox, x+2 vConcatAudioLenToggle hwndConcatAudioLenToggleID gUPDATE_CONCAT_AUDIO_LEN_SLIDER
    updateConcatAudioLenSlider()
    return

    UPDATE_CONCAT_AUDIO_LEN_SLIDER:
    if (ConcatAudioShown)
    {
        updateConcatAudioLenSlider()
        checkConcatAudioLen()
        ConcatAudioBpmToggle := False
    }
    return


    CONCAT_AUDIO_BPM:
    bpm := promptUserBpm()
    if (bpm)
    {
        updateConcatAudioLenSlider(1/(bpm/60))
        checkConcatAudioLen()
        ConcatAudioBpmToggle := True
    }
    return
}

promptUserBpm()
{
    res := ""
    mouseGetPos(mX, mY, "Screen")
    winW := 165
    winH := 125
    winX := mX - winW/2
    winY := mY - winH/2 + 100
    title := "Set Bpm"
    prompt := "python syntax"
    InputBox, res , %title%, %prompt%,, %winW%, %winH%, %winX%, %winY%,,, 120*2
    if res is not number
    {
        res := SysCommand("python -c ""print(" res ")""")
        res := removeBreakLines(res)
    }
    if res is not number
        res := ""
    return res    
}


; gate
makeConcatAudioGateSlider()
{
    global ConcatAudioMinGate, ConcatAudioMaxGate, ConcatAudioGateSliderVal, ConcatAudioGateSliderID
    global ConcatAudioGateText, ConcatAudioGateTextID
    global ConcatAudioGateToggle, ConcatAudioGateToggleID
    global ConcatAudioGateSliderVal_TT := "Cut sound when reaches threshold"
    Gui, Main2:Add, Slider, x+20 w150 Range%ConcatAudioMinGate%-%ConcatAudioMaxGate% NoTicks vConcatAudioGateSliderVal gUPDATE_CONCAT_AUDIO_GATE_SLIDER AltSubmit hwndConcatAudioGateSliderID,
    Gui, Main2:Add, Text, x+2 w35 vConcatAudioGateText hwndConcatAudioGateTextID,
    global ConcatAudioGateToggle_TT := "Apply gate parameter"
    Gui, Main2:Add, CheckBox, x+2 vConcatAudioGateToggle hwndConcatAudioGateToggleID gUPDATE_CONCAT_AUDIO_GATE_SLIDER
    updateConcatAudioGateSlider()   
    return

    UPDATE_CONCAT_AUDIO_GATE_SLIDER:
    if (ConcatAudioShown)
        updateConcatAudioGateSlider()
        checkConcatAudioGate()
    return
}

; run
makeConcatAudioRunButton()
{
    Gui, Main2:Add, Button, x+40 gCONCAT_AUDIO_RUN hwndConcatAudioRunButtonID, run
    return

    CONCAT_AUDIO_RUN:
    if (ConcatAudioShown)
        concatAudioRun()
    return  
}


; -- Checkmarks -----------------------------
checkConcatAudioGate()
{
    global ConcatAudioLenToggle, ConcatAudioGateToggle
    ConcatAudioLenToggle := 0
    ConcatAudioGateToggle := 1
    GuiControl, Main2:, ConcatAudioLenToggle, %ConcatAudioLenToggle%
    GuiControl, Main2:, ConcatAudioGateToggle, %ConcatAudioGateToggle%
}

checkConcatAudioLen()
{
    global ConcatAudioLenToggle, ConcatAudioGateToggle
    ConcatAudioLenToggle := 1
    ConcatAudioGateToggle := 0
    GuiControl, Main2:, ConcatAudioLenToggle, %ConcatAudioLenToggle%
    GuiControl, Main2:, ConcatAudioGateToggle, %ConcatAudioGateToggle%
}


; -- update -----------------------------
; paths
updateConcatAudioPath(n)
{
    Switch n
    {
    Case 1:
        GuiControl, Main2:, ConcatAudioFolder1, %ConcatAudioFolder1%
    Case 2:        
        GuiControl, Main2:, ConcatAudioFolder2, %ConcatAudioFolder2%
    Case 3:        
        GuiControl, Main2:, ConcatAudioFolder3, %ConcatAudioFolder3%
    Case 4:        
        GuiControl, Main2:, ConcatAudioFolder4, %ConcatAudioFolder4%
    Case 5:        
        GuiControl, Main2:, ConcatAudioFolder5, %ConcatAudioFolder5%
    }
}

; num
updateConcatAudioNumSlider()
{
    num := LinearToLogarithmic(ConcatAudioNumSliderVal, true)
    GuiControl, Main2:, ConcatAudioNumSliderVal, %ConcatAudioNumSliderVal%
    GuiControl, Main2:, ConcatAudioNumText, %num%
}

; len
updateConcatAudioLenSlider(len := "")
{
    if (len == "")
        len := LinearToLogarithmic(ConcatAudioLenSliderVal)
    else
    {
        sliderVal := LogarithmicToLinear(len)
        ConcatAudioLenSliderVal := sliderVal
        GuiControl, Main2:, ConcatAudioLenSliderVal, %sliderVal%
    }
    display := Format("sec`r`n{:.2f}", len)
    GuiControl, Main2:, ConcatAudioLenText, %display%
    GuiControl, Main2:, ConcatAudioLenToggle, %ConcatAudioLenToggle%
    bpm := Format("bpm`r`n{:.1f}", 1/len*60)
    GuiControl, Main2:, ConcatAudioBpm, %bpm%
}

; gate
updateConcatAudioGateSlider()
{
    GuiControl, Main2:, ConcatAudioGateSliderVal, %ConcatAudioGateSliderVal%
    display := Format("{}dB", ConcatAudioGateSliderVal)
    GuiControl, Main2:, ConcatAudioGateText, %display%
    GuiControl, Main2:, ConcatAudioGateToggle, %ConcatAudioGateToggle%
}
; -----------------


; -- randomize -----------------------------
; paths
randomizeConcatAudioPath(n)
{
    Switch n
    {
    Case 1:
        path := getRandomSoundDir()
        ConcatAudioPaths[1] := path
        SplitPath, path, ConcatAudioFolder1
    Case 2:
        path := getRandomSoundDir()
        ConcatAudioPaths[2] := path
        SplitPath, path, ConcatAudioFolder2
    Case 3:
        path := getRandomSoundDir()
        ConcatAudioPaths[3] := path
        SplitPath, path, ConcatAudioFolder3
    Case 4:
        path := getRandomSoundDir()
        ConcatAudioPaths[4] := path
        SplitPath, path, ConcatAudioFolder4
    Case 5:
        path := getRandomSoundDir()
        ConcatAudioPaths[5] := path
        SplitPath, path, ConcatAudioFolder5
    }
    updateConcatAudioPath(n)
}

; num
randomizeConcatAudioNumSlider()
{
    minSlider := LogarithmicToLinear(ConcatAudioMinNum)
    maxSlider := LogarithmicToLinear(ConcatAudioMaxNum)
    Random, ConcatAudioNumSliderVal, %minSlider%, %maxSlider%
    updateConcatAudioNumSlider()    
}

; len
randomizeConcatAudioLenSlider()
{
    minSlider := LogarithmicToLinear(ConcatAudioMinLen)
    maxSlider := LogarithmicToLinear(ConcatAudioMaxLen)
    Random, ConcatAudioLenSliderVal, %minSlider%, %maxSlider%
    Random, ConcatAudioLenToggle, 0, 1
    updateConcatAudioLenSlider()
}

; gate
randomizeConcatAudioGateSlider()
{
    Random, ConcatAudioGateSliderVal, %ConcatAudioMinGate%, %ConcatAudioMaxGate%
    Random, ConcatAudioGateToggle, 0, 1
    updateConcatAudioGateSlider()
}

; gate / len
chooseGateLenMode()
{
    Random, choice, 0, 1
    if (choice == 0) {
        checkConcatAudioLen()
    } else {
        checkConcatAudioGate()
    }
}
; -----