dragSample(proposeEdison = True)
{
    newSamplerChoices := ["Ps", "slcx", "gran"]
    choices := deepCopy(newSamplerChoices)
    if (proposeEdison)
        choices.Push("Edison")    
    if (findInPluginWinHistory("isOneOfTheSamplers"))
        choices.Push("existing sampler")
    if (isMasterEdison())
    {
        choices.Push("Audacity")
        choices.Push("Melodyne")
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
    mute()

    choiceIsNewSampler := hasVal(newSamplerChoices, choice)
    if (choiceIsNewSampler)
        loadInPatcher := askToLoadInPatcher()

    Switch choice
    {
    Case "Ps":
        createPatcherSampler(mX, mY, winId, loadInPatcher)   
    Case "slcx":
        createPatcherSlicex(mX, mY, winId, loadInPatcher)  
    Case "gran":
        createPatcherGranular(mX, mY, winId, loadInPatcher)  
    Case "Edison":
        dragSampleToEdison(mX, mY)           
    Case "existing sampler":
        dragDropAnyPatcherSampler(mX, mY, winId)               
    Case "Audacity":
        fromEdisonToAudacity()
    Case "Melodyne":
        fromEdisonToMelodyne()
    }
    unmute()
}


askToLoadInPatcher()
{
    title := "Load in:"
    initIndex := randInt(1, 2)
    choices := ["step seq", "patcher"]
    res := toolTipChoice(choices, title, initIndex, "Win")
    inPatcher := res == "patcher"
    return inPatcher
}

dontDragSample()
{
    readyToDrag := False
    stopHighlight()
}