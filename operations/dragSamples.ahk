dragSample(proposeEdison := True)
{
    patcherSamplerLabel := "Ps"
    patcherSlicexLabel := "Slcx"
    patcherGrnlLabel := "Grnl"
    percEnvLabel := "PercEnv"
    edisonLabel := "Edison"
    existingSamplerLabel := "existing sampler"
    audacityLabel := "Audacity"
    melodyneLabel := "Melodyne"

    newSamplerChoices := [patcherSamplerLabel, patcherSlicexLabel, patcherGrnlLabel, percEnvLabel]
    choices := deepCopy(newSamplerChoices)
    if (proposeEdison)
        choices.Push(edisonLabel)    
    if (findInPluginWinHistory("isOneOfTheSamplers"))
        choices.Push(existingSamplerLabel)
    if (isMasterEdison())
    {
        choices.Push(audacityLabel)
        choices.Push(melodyneLabel)
    }

    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY, winId
    CoordMode, Mouse, Client
    initIndex := randInt(1, choices.MaxIndex())
    choice := toolTipChoice(choices, "", initIndex, "Win")
    stopHighlight()
    readyToDrag := False
    if (choice == "")
        return

    choiceIsNewSampler := hasVal(newSamplerChoices, choice)
    if (choiceIsNewSampler)
        loadInPatcher := askToLoadInPatcher()

    Switch choice
    {
    Case patcherSamplerLabel:
        createPatcherSampler(mX, mY, winId, loadInPatcher)   
    Case patcherSlicexLabel:
        createPatcherSlicex(mX, mY, winId, loadInPatcher)  
    Case patcherGrnlLabel:
        createPatcherGrnl(mX, mY, winId, loadInPatcher)  
    Case edisonLabel:
        dragSampleToEdison(mX, mY)           
    Case existingSamplerLabel:
        dragDropAnyPatcherSampler(mX, mY, winId)               
    Case audacityLabel:
        fromEdisonToAudacity()
    Case melodyneLabel:
        fromEdisonToMelodyne()
    Case percEnvLabel:
        dragDropPercEnv(mX, mY, winId)
    }
}


askToLoadInPatcher()
{
    title := "Load in:"
    initIndex := randInt(1, 2)
    choices := ["step seq", "patcher"]
    res := 
    (choices, title, initIndex, "Win")
    inPatcher := res == "patcher"
    return inPatcher
}

dontDragSample()
{
    readyToDrag := False
    stopHighlight()
}