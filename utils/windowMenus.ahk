global PianoRollMenuShown := False
global EventEditorMenuShown := False
global MixerMenuShown := False
global StepSeqMenusShown := False

global freezeWindowMenuClock := False

windowMenusTic()
{
    if (freezeWindowMenuClock)
        return
    dontHide := []
    WinGet, id, ID, A
    if (isEventEditor(id))
    {
        dontHide.Push("EventEditorMenu")
        if (!EventEditorMenuShown)
                showEventEditorMenu()
    }
    else if (isPianoRoll(id))
    {
        dontHide.Push("PianoRollMenu")
        if (!PianoRollMenuShown)
            showPianoRollMenu()
    }
    else if (isMixer(id) or isMasterEdison(id))
    {
        dontHide.Push("MixerMenu")
        if (!MixerShown)
            showMixerMenu()
    }
    else if (isStepSeq(id))
    {
        dontHide.Push("StepSeqMenus")
        if (!StepSeqShown)
            showStepSeqMenus()
    }  


    hideAllMenus(dontHide)
}

hideAllMenus(except)
{
    if (EventEditorMenuShown and !hasVal(except, "EventEditorMenu")) ; except != "EventEditorMenu")
        hideEventEditorMenu()
    else if (PianoRollMenuShown and !hasVal(except, "PianoRollMenu")) ; except != "PianoRollMenu")
        hidePianoRollMenu()
    else if (StepSeqMenusShown and !hasVal(except, "StepSeqMenus")) ; except != "StepSeqMenu")
        hideStepSeqMenus()
    else if (MixerMenuShown and !hasVal(except, "MixerMenu")) ; except != "MixerMenu")
        hideMixerMenu()                        
}

; --------------------
showEventEditorMenu()
{
    EventEditorMenuShown := True 
    Gui, EventEditorMenu:Show, NoActivate
}

hideEventEditorMenu()
{
    Gui, EventEditorMenu:Hide
    EventEditorMenuShown := False
}

; --------------------
showMixerMenu()
{
    MixerMenuShown := True 
    Gui, MixerMenu:Show, NoActivate
}

hideMixerMenu()
{
    MixerMenuShown := False
    Gui, MixerMenu:Hide
}

mouseOnMixerMenu()
{
    MouseGetPos, mx,, winId
    return MixerMenuShown and winId == MixerMenuId and mx > 568
}



; --------------------
showPianoRollMenu()
{
    PianoRollMenuShown := True
    Gui, PianoRollMenu:Show, NoActivate
}

hidePianoRollMenu()
{
    Gui, PianoRollMenu:Hide
    PianoRollMenuShown := False
}

; --------------------
showStepSeqMenus()
{
    StepSeqMenusShown := True
    WinGetPos, ssX, ssY, ssW, ssH, A
    menu1H := 53    
    coords := winCoordsToScreenCoords(0, -menu1H)
    menu1X := ssX
    menu1Y := ssY - menu1H
    Gui, StepSeqMenu:Show, x%menu1X% y%menu1Y% w%ssW% h%menu1H% NoActivate
    menu2H := 30
    menu2Y := ssY + ssH - menu2H
    menu2X := 3
    menu2W := 105 - menu2X
    menu2X := menu2X + ssX
    Gui, StepSeqMenu2:Show, x%menu2X% y%menu2Y% w%menu2W% h%menu2H% NoActivate
    startWinMenusClock(50)
}


hideStepSeqMenus()
{
    Gui, StepSeqMenu:Hide
    Gui, StepSeqMenu2:Hide
    StepSeqMenusShown := False
    startWinMenusClock()
}

mouseOnStepSeqMenu()
{
    MouseGetPos,,, winId
    return winId == StepSeqMenuId
}