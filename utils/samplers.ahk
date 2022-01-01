dragDropAnyPatcherSampler(oriX, oriY, oriWin, samplerId = "")
{    
    if (samplerId == "")
    {
        playlistToolTip("Activate the sampler and press Enter")
        WinGet, winId, ID, A
        if (!isOneOfTheSamplers(winId))
            activatePrevPlugin()
        unfreezeMouse()
        waitAcceptAbort()
        freezeMouse()
        toolTip()
        WinGet, samplerId, ID, A  
    }
    else
        WinActivate, ahk_id %samplerId%
    
    whichSampler := detectWhichSampler(samplerId)
    movedSampler := moveWinIfOverPos(oriX, oriY, samplerId)
    Switch whichSampler
    {
    Case "patcherSampler":
        dragDropPatcherSampler(samplerId, oriX, oriY, oriWin)
        baseName := "Sp"
    Case "patcherSlicex":
        dragDropPatcherSlicex(samplerId, oriX, oriY, oriWin)
        baseName := "Slcx"
    Case "patcherGrnl":
        dragDropPatcherGrnl(samplerId, oriX, oriY, oriWin)
        baseName := "Grnl"
    }
    if (movedSampler)
        WinMove, ahk_id %samplerId%,, 400, 200
    randomizeName(True, False, False, baseName)
}

detectWhichSampler(samplerId)
{
    if (isPatcherSampler(samplerId))
        which := "patcherSampler"
    else if (isPatcherSlicex(samplerId))
        which := "patcherSlicex"
    else if (isPatcherGrnl(samplerId))
        which := "patcherGrnl"
    return which
}

; -----------------------------------------------
altClickSampler()
{
    if (isPatcherSampler("", True))
        whichSampler := "patcherSampler"
    else if isPatcherGrnl("", True)
        whichSampler := "patcherGrnl"

    if (whichSampler)        
    {
        whichLfo := mouseOverSamplerLfoSpeedSet()
        if (whichLfo)
            samplerLfoSetTime(whichLfo, whichSampler)
        else if (mouseOverSamplerPatcherArp())
            randomizeArpParams()
        else if (mouseOverSamplerPatcherDel())
            randomizeDelayParams()
        else
        {
            n := mouseOverNsetter()
            if (n)
                patcherSamplerSetKnobN(n)   
        }
    }
}