global savedPatternToggle := 0
savedLoopRecState := None

toggleMainEvents()
{
    n := getPatternNumber()
    lrEn := loopRecordingEnabled()
    if (n > 1)
        activateMainEvents(lrEn, n)
    else if (n == 1)
        disableMainEvents(lrEn)
}

activateMainEvents(lrEn, currPatt = 0)
{
    global savedPatternToggle, savedLoopRecState
    if (currPatt != 0) 
        savedPatternToggle := currPatt
        midiRequest("set_pattern", 1)        
    if (!lrEn)
    {
        toggleLoopRecording()
        savedLoopRecState := False  
    }
    else
        savedLoopRecState := True  
}

disableMainEvents(lrEn)
{
    global savedPatternToggle, savedLoopRecState
    if (lrEn and savedLoopRecState == False)
        toggleLoopRecording()
    if (savedLoopRecState != None)
        savedLoopRecState := None
    if (savedPatternToggle != 0)
    {
        midiRequest("set_pattern", savedPatternToggle)
        savedPatternToggle := 0
    }
}

getPatternNumber()
{
    n := midiRequest("get_pattern")
    return n
}