Layer()
{
    res := prompLayerName(name)
    if (!res)
        return

    res := groupChannels(name)
    if (!res)
        return
    
    loadInstrInStepSeq(3, False, "", False)             ; load 3_Layer
    Sleep, 100
    layerId := bringLayer()
    if (layerId)
    {
        setChildren(layerId)
        setLayerVolume()
        pasteColor("", True)
        rename("Layer " name)
        lockChanFromInstrWin()
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
    stepSeqID := bringStepSeq(False)
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

; Pour l'activer une première fois, il faut cliquer dessus dans le step seq
bringLayer()
{
    stepSeqID := bringStepSeq(False)
    WinGetPos,,,, winH, ahk_id %stepSeqID%

    layerY := winH - 60
    Click, 147, %layerY% 
    layerId := waitNewWindowOfClass("TPluginForm", stepSeqID)
    moveWinRightScreen(layerId)
    return layerId
}

currentWinIsPlugin()
{
    id :=
    WinGetClass, class, A
    if (class == "TPluginForm")
        WinGet, id, ID, A
    return id
}


setChildren(layerId)
{
    WinActivate, ahk_class TStepSeqForm
    Sleep, 500
    sepX := 274
    MouseClick, Left, %sepX%, 62, 2                             ; sélectionne tous les channels en double-cliquant
    WinActivate, ahk_id %layerId%
    MouseClick, Left, 82, 226                                   ; Set Children
    WinActivate, ahk_class TStepSeqForm
    WinGetPos,,,, h, A
    LayerY := h - 60
    MouseClick, Left, %sepX%, %LayerY%
    WinActivate, ahk_id %layerId%
    Sleep, 100
}

setLayerVolume()
{
    setKnobValue(70, 125, .6)
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