createPatcherGranular(dragX, dragY, dragWin, inPatcher := False)
{
    if (inPatcher)
    {
        WinActivate, ahk_class TPluginForm
        mouseOverKnot := False
        unfreezeMouse()
        while (!mouseOverKnot)
        {
            toolTip("PatcherMap: place mouse on knot")        
            res := waitAcceptAbort()
            toolTip()
            if (res == "abort")
                return
            mouseOverKnot := mouseOverMidiKnot()
        }
        MouseGetPos,,, patcherId
        if (!WinActive("ahk_id " patcherId))
            WinActivate, ahk_id %patcherId%
        freezeMouse()
        samplerId := patcherLoadPatcherGranular()
    }
    else
        samplerId := loadGranular(False)

    movedSampler := moveWinIfOverPos(dragX, dragY, samplerId)
    dragDropAnyPatcherSampler(dragX, dragY, dragWin, samplerId)
    if (movedSampler)
        WinMove, ahk_id %samplerId%,, 700, 200      
}