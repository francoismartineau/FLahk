dragSample(proposeEdison = True)
{
    choices := ["Sp", "slcx", "gran"]
    if (proposeEdison)
        choices.Push("Edison")    
    if (findInWinHistory("isOneOfTheSamplers"))
        choices.Push("existing sampler")

    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY, winId
    CoordMode, Mouse, Client
    ;winAlsoAccepts := True
    choice := toolTipChoice(choices, "", randInt(1, choices.MaxIndex()), "Win")
    stopHighlight()
    readyToDrag := False
    if (choice == "")
        return
    mute()
    Switch choice
    {
    Case "Sp":
        createPatcherSampler(mX, mY, winId)   
    Case "slcx":
        createPatcherSlicex(mX, mY, winId)  
    Case "gran":
        granId := loadGranular(False)
        dragDropAnyPatcherSampler(mX, mY, winId, granId)
    Case "Edison":
        dragSampleToEdison(mX, mY)           
    Case "existing sampler":
        dragDropAnyPatcherSampler(mX, mY, winId)               
    }
    unmute()
}


dontDragSample()
{
    readyToDrag := False
    stopHighlight()
}