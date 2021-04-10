Layer()
{
    ;;;;;; suggest a name in the box
    name := prompLayerName()
    res := groupChannels(name)
    if (!res)
        return
    loadInstr(3, False, False)             ; load 3_Layer
    Sleep, 100
    layerID := bringLayer()
    if (layerID)
    {
        setChildren(layerID)
        setLayerVolume(layerID)
        pasteColor("", True)
        rename("Layer " name)
    }
}


prompLayerName()
{
    unfreezeMouse()
    n := randString(2)
    InputBox, name , Layer name,,,,100, 100, 500, 500,,,, %n%
    return name
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
    ;Sleep, 100
    Click, 147, %layerY% 
    layerID := waitNewWindowOfClass("TPluginForm", stepSeqID)
    moveWinLeftScreen(layerID)
    return layerID
}

isNewWindow(id)
{
    stopWinHistoryClock()
    isNew := !inWinHistory(id)
    startWinHistoryClock()
    return isNew
}

currentWinIsPlugin()
{
    id :=
    WinGetClass, class, A
    if (class == "TPluginForm")
        WinGet, id, ID, A
    return id
}


setChildren(layerID)
{
    WinActivate, ahk_class TStepSeqForm
    Sleep, 500
    sepX := 274
    MouseClick, Left, %sepX%, 62, 2                             ; sélectionne tous les channels en double-cliquant
    WinActivate, ahk_id %layerID%
    MouseClick, Left, 82, 226                                   ; Set Children
    WinActivate, ahk_class TStepSeqForm
    WinGetPos,,,, h, A
    LayerY := h - 60
    MouseClick, Left, %sepX%, %LayerY%
    WinActivate, ahk_id %layerID%
    Sleep, 100
}

setLayerVolume(layerID)
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