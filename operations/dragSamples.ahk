


dragSample(proposeEdison := True)
{
    winId := mouseGetPos(mX, mY, "Screen")
    dragLabels := {}
    choice := proposeDragLocations(dragLabels, proposeEdison)
    stopHighlight()
    readyToDrag := False
    if (choice == "")
        return

    Switch choice
    {
    Case dragLabels["patcherSamplerLabel"]:
        createPatcherSampler(mX, mY, winId, loadInPatcher)   
    Case dragLabels["patcherSlicexLabel"]:
        createPatcherSlicex(mX, mY, winId, loadInPatcher)  
    Case dragLabels["patcherGrnlLabel"]:
        createPatcherGrnl(mX, mY, winId, loadInPatcher)  
    Case dragLabels["edisonLabel"]:
        dragSampleToEdison(mX, mY)           
    Case dragLabels["existingSamplerLabel"]:
        dragDropAnyPatcherSampler(mX, mY, winId)               
    Case dragLabels["audacityLabel"]:
        fromEdisonToAudacity()
    Case dragLabels["melodyneLabel"]:
        fromEdisonToMelodyne()
    Case dragLabels["percEnvLabel"]:
        PercEnv.dragDrop(mX, mY, winId)
    }
}

proposeDragLocations(dragLabels, proposeEdison)
{
    dragLabels["patcherSamplerLabel"] := "Ps"
    dragLabels["patcherSlicexLabel"] := "Slcx"
    dragLabels["patcherGrnlLabel"] := "Grnl"
    dragLabels["percEnvLabel"] := "PercEnv"
    dragLabels["edisonLabel"] := "Edison"
    dragLabels["existingSamplerLabel"] := "existing sampler"
    dragLabels["audacityLabel"] := "Audacity"
    dragLabels["melodyneLabel"] := "Melodyne"

    choices := [dragLabels["patcherSamplerLabel"], dragLabels["patcherSlicexLabel"], dragLabels["patcherGrnlLabel"], dragLabels["percEnvLabel"]]
    if (proposeEdison)
        choices.Push(dragLabels["edisonLabel"])    
    if (findInPluginWinHistory("isOneOfTheSamplers"))
        choices.Push(dragLabels["existingSamplerLabel"])
    if (isMasterEdison())
    {
        choices.Push(dragLabels["audacityLabel"])
        choices.Push(dragLabels["melodyneLabel"])
    }
    initIndex := randInt(1, choices.MaxIndex())
    choice := toolTipChoice(choices, "", initIndex, "Win")
    return choice
}

dontDragSample()
{
    readyToDrag := False
    stopHighlight()
}