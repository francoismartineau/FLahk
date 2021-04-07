dragDropAnyPatcherSampler(oriX, oriY, oriWin)
{    
    playlistToolTip("Activate the sampler and press Enter")
    WinGet, winId, ID, A
    if (!isInstr(winId))
        activatePrevWin()
    global sendEnterKeyToFL
    sendEnterKeyToFL := False
    unfreezeMouse()
    waitAcceptAbort()
    freezeMouse()
    toolTip()
    sendEnterKeyToFL := True
    WinGet, samplerId, ID, A    
    which := detectWhichSampler(samplerId)
    movedSampler := moveWinIfOverPos(oriX, oriY, samplerId)
    Switch which
    {
    Case "patcherSampler":
        dragDropPatcherSampler(samplerId, oriX, oriY, oriWin)
        baseName := "Sp"
    Case "patcherSlicex":
        dragDropPatcherSlicex(samplerId, oriX, oriY, oriWin)
        baseName := "Slcx"
    Case "patcherGranular":
        dragDropPatcherGranular(samplerId, oriX, oriY, oriWin)
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
    else if (isPatcherGranular(samplerId))
        which := "patcherGranular"
    return which
}

dragDropPatcherSampler(patcherId, oriX, oriY, oriWin)
{
    directwaveId := revealPatcherDirectWave(patcherId)
    dragDropPatcherDirectWaveSample(oriX, oriY, oriWin, directwaveId)
    hideInternalSampler(directwaveId, patcherId)
}

dragDropPatcherSlicex(patcherId, oriX, oriY, oriWin)
{
    slicexId := revealInternalSlicex(samplerID)
    dragDropSlicexSample(oriX, oriY, oriWin, slicexId)
    hideInternalSampler(slicexId, samplerID)
}

dragDropPatcherGranular(patcherId, oriX, oriY, oriWin)
{
    directwaveId := revealPatcherDirectWave(patcherId)
    msgTip("sample revealed")
    dragDropPatcherDirectWaveSample(oriX, oriY, oriWin, directwaveId)
    MouseMove, 447, 633, 0          ; loop
    Send {LButton}{WheelDown}{WheelDown}{LButton}
    hideInternalSampler(directwaveId, patcherId)
}