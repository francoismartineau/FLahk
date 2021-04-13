;oriPluginX := Mon1Left + 20
;oriPluginY := Mon1Top + 20
;pluginX :=
;pluginY :=
;pluginRowHeight :=
channelPluginWins := []

/*
showChannelWindows()
{
    stepSeqId := bringStepSeq(False)
    instrId := openSelectedChannel(stepSeqId)
    WinMove, ahk_id %instrId%,, 900, 169
    openAllFx()
    moveFxWindows()
    WinActivate, ahk_id %instrId%
    centerMouse(instrId)
}
*/

openAllFx()
{
    bringMixer(False)
    moveMouseToFirstSlot()
    i := 1
    while (i <= 10)
    {
        if (!mouseOverEmptySlot())
        {
            openFx()
            WinActivate,, ahk_class TFXForm
        }
        moveMouseToNextSlot()
        i++
    }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
openFx()
{
    global channelPluginWins, windowHistory
    WinGet, mixerID, ID, A
    MouseClick, Left
    pluginID := waitNewWindowOfClass("TPluginForm", mixerID)
    channelPluginWins.Push(pluginID)
    registerWinToHistory(pluginID, "plugin")
}

;;;; Faire la différence entre le dernier effet ouvert et le présent
;;;; en conservant les ID

;;;; ----- Ne pas activer le truc si c'est le channel master?
;;;; Si edison est au dessus du mixeur, le
;;;; Dans le cas du limiteur master, pourquoi i se déplace pas?
;;;; Pourquoi le mixeur disparait.. ou pourquoi i revient pas toujours sous la souris?



;;;; Détecter si c'est Edison et ne rien faire?
moveFxWindows()
{
    global Mon1Right, Mon1Bottom
    global channelPluginWins
    maxH := 0
    i := 1
    while (i <= channelPluginWins.MaxIndex())
    {
        pluginID := channelPluginWins[i]
        WinGetPos,,, w, h, ahk_id %pluginID%
        if (i == 1)
        {
            x := -1880
            y := 602
            maxH := y + h
        }
        else
        {
            x := pX + pW + 10
            if (x + w > Mon1Right - 20)
            {
                x := -1880
                y := maxH + 10
                maxH := y + h
            }
            else
            {
                maxH := Max(maxH, h)
            }
        }
        WinMove, ahk_id %pluginID%,, x, y
        WinActivate, ahk_id %pluginID%
        pX := x
        pY := y
        pW := w
        pH := h
        i := 1 + i
    }
}

