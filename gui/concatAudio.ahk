;;;;
;; avoir un slider de temps en BPM / avec multiplication à côté
;; les deux s'ajustent en même temps

global ConcatAudioShown := True

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

; len
global ConcatAudioMinLen := .01
global ConcatAudioMaxLen := 10
global ConcatAudioLenSliderVal
global ConcatAudioLenSliderID
global ConcatAudioLenText
global ConcatAudioLenTextID
global ConcatAudioLenToggle
global ConcatAudioLenToggleID

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
    makeConcatAudioPathsText()
    makeConcatAudioNumSlider()
    makeConcatAudioLenSlider()
    makeConcatAudioGateSlider()
    makeConcatAudioRunButton()
    showConcatAudio()
    hideConcatAudio()
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
}




; -- make ------------------------------
; paths
makeConcatAudioPathsText()
{
    global gui2H
    y := gui2H + 25    
    Gui, Main2:Add, Text, x10 y%y% h20 w200 vConcatAudioFolder1 hwndConcatAudioFolder1Id gPICK_CONCAT_AUDIO_PATH1,
    Gui, Main2:Add, Text, x+10 h20 w200 vConcatAudioFolder2 hwndConcatAudioFolder2Id gPICK_CONCAT_AUDIO_PATH2,
    Gui, Main2:Add, Text, x+10 h20 w200 vConcatAudioFolder3 hwndConcatAudioFolder3Id gPICK_CONCAT_AUDIO_PATH3,
    Gui, Main2:Add, Text, x+10 h20 w200 vConcatAudioFolder4 hwndConcatAudioFolder4Id gPICK_CONCAT_AUDIO_PATH4,
    Gui, Main2:Add, Text, x+10 h20 w200 vConcatAudioFolder5 hwndConcatAudioFolder5Id gPICK_CONCAT_AUDIO_PATH5,
    i := 1
    while (i <= 5)
    {
        updateConcatAudioPathText(i)
        i := i + 1
    }
}


; num
makeConcatAudioNumSlider()
{
    minSlider := LogarithmicToLinear(ConcatAudioMinNum)
    maxSlider := LogarithmicToLinear(ConcatAudioMaxNum)
    Gui, Main2:Add, Slider, x10 y+30 w200 Range%minSlider%-%maxSlider% NoTicks vConcatAudioNumSliderVal gUPDATE_CONCAT_AUDIO_NUM_SLIDER AltSubmit hwndConcatAudioNumSliderID,
    Gui, Main2:Add, Text, x+2 w22 vConcatAudioNumText hwndConcatAudioNumTextID,
    updateConcatAudioNumSlider()
}

; len
makeConcatAudioLenSlider()
{
    global ConcatAudioMinLen, ConcatAudioMaxLen, ConcatAudioLenSliderVal, ConcatAudioLenSliderID
    global ConcatAudioLenText, ConcatAudioLenTextID
    global ConcatAudioLenToggle, ConcatAudioLenToggleID
    minSlider := LogarithmicToLinear(ConcatAudioMinLen)
    maxSlider := LogarithmicToLinear(ConcatAudioMaxLen)
    Gui, Main2:Add, Slider, x+10 w150 Range%minSlider%-%maxSlider% NoTicks vConcatAudioLenSliderVal gUPDATE_CONCAT_AUDIO_LEN_SLIDER AltSubmit hwndConcatAudioLenSliderID,
    Gui, Main2:Add, Text, x+2 w50 vConcatAudioLenText hwndConcatAudioLenTextID,
    Gui, Main2:Add, CheckBox, x+2 vConcatAudioLenToggle hwndConcatAudioLenToggleID gUPDATE_CONCAT_AUDIO_LEN_SLIDER
    updateConcatAudioLenSlider()
    
}


; gate
makeConcatAudioGateSlider()
{
    global ConcatAudioMinGate, ConcatAudioMaxGate, ConcatAudioGateSliderVal, ConcatAudioGateSliderID
    global ConcatAudioGateText, ConcatAudioGateTextID
    global ConcatAudioGateToggle, ConcatAudioGateToggleID
    Gui, Main2:Add, Slider, x+10 w150 Range%ConcatAudioMinGate%-%ConcatAudioMaxGate% NoTicks vConcatAudioGateSliderVal gUPDATE_CONCAT_AUDIO_GATE_SLIDER AltSubmit hwndConcatAudioGateSliderID,
    Gui, Main2:Add, Text, x+2 w50 vConcatAudioGateText hwndConcatAudioGateTextID,
    Gui, Main2:Add, CheckBox, x+2 vConcatAudioGateToggle hwndConcatAudioGateToggleID gUPDATE_CONCAT_AUDIO_GATE_SLIDER
    updateConcatAudioGateSlider()   
}

; run
makeConcatAudioRunButton()
{
    Gui, Main2:Add, Button, x+40 gCONCAT_AUDIO_RUN hwndConcatAudioRunButtonID, run
}


; -- checkmarks -----------------------------
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
updateConcatAudioPathText(n)
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
updateConcatAudioLenSlider()
{
    len := LinearToLogarithmic(ConcatAudioLenSliderVal)
    GuiControl, Main2:, ConcatAudioLenSliderVal, %ConcatAudioLenSliderVal%
    display := Format("{:.2f} sec", len)
    GuiControl, Main2:, ConcatAudioLenText, %display%
    GuiControl, Main2:, ConcatAudioLenToggle, %ConcatAudioLenToggle%
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
    updateConcatAudioPathText(n)
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