Layer()
{
    if (!isInstr())
    {
        msg("Layer: not an instrument")
        return
    }
    WinGet, chanId, ID, A
    chanName := copyName()
    ;chanName := filterPluginTitle()
    StepSeq.bringWin(False, False)
    oriChanIndex := StepSeq.getFirstSelChanIndex()
    loadInstrInStepSeq(3, False, "", False)             ; load 3_Layer
    Sleep, 100
    layerIndex := StepSeq.getFirstSelChanIndex()
    if (oriChanIndex == layerIndex)
    {
        msg("Couldn't load Layer")
        return
    }
    StepSeq.moveSelectedChannel(oriChanIndex+1, layerIndex)
    layerId := StepSeq.bringChanUnderMouse(False)
    if (layerId)
    {
        setChildren(layerId, [oriChanIndex])
        setLayerVolume()
        pasteColor("", True)
        rename("Layer " chanName)
        ;lockChanFromInstrWin()
    }
}


prompLayerName(ByRef name)
{
    res := True
    unfreezeMouse()
    n := randString(2)
    InputBox, name , Layer name,,,,100, 100, 500, 500,,,, %n%
    if ErrorLevel
        res := False
    return res
}

groupChannels(name)
{
    res := True
    stepSeqID := StepSeq.bringWin(False)
    Send {AltDown}g{AltUp}                                      ; Alt G
    nameEditWin := waitNewWindowOfClass("TNameEditForm", stepSeqID)
    if (nameEditWin)
    {
        WinMove, ahk_id %nameEditWin%,, 500, 500
        TypeText(name)
        Send {Enter}
    }
    else
    {
        res := False
    }
    return res
}

currentWinIsPlugin()
{
    id :=
    WinGetClass, class, A
    if (class == "TPluginForm")
        WinGet, id, ID, A
    return id
}


setChildren(layerId, childIndexes)
{
    StepSeq.bringWin(False, False)
    StepSeq.selChanIndexes(childIndexes)
    WinActivate, ahk_id %layerId%
    quickClick(82, 226)                  ; Set Children
}

setLayerVolume()
{
    Knob.setVal(70, 125, .6)
}

;; inutile pour l'instant
lockKeyboardToLayer()
{
    WinActivate, ahk_class TStepSeqForm
    MouseClick, Right, 158, %LayerY% 
    Sleep, 100
    MouseMove, 420, 208 ,, R
    Sleep, 100
    MouseMove, 61, 25 ,, R
    Sleep, 100
    Click                                                       ; Lock Layer to typing keyboard
}