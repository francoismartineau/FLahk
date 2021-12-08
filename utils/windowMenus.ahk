global EventEditorMenuShown := False
global PatcherMapMenuShown := False
global PianoRollMenusShown := False
global MixerMenuShown := False
global StepSeqMenusShown := False
global audacityMenuShown := False
global melodyneMenuShown := False

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
    else if (isPatcherMap(id))
    {
        dontHide.Push("PatcherMapMenu")
        ;if (!PatcherMapMenuShown)
        showPatcherMapMenu()
    }
    else if (isPianoRoll(id))
    {
        dontHide.Push("PianoRollMenus")
        if (!PianoRollMenusShown)
            showPianoRollMenus()
    }
    else if (isMixer(id) or isMasterEdison(id))
    {
        dontHide.Push("MixerMenu")
        if (!MixerMenuShown)
            showMixerMenu()
    }
    else if (isStepSeq(id))
    {
        dontHide.Push("StepSeqMenus")
        showStepSeqMenus()
    }  
    else if (isAudacity(id))
    {
        dontHide.Push("AudacityMenu")
        showAudacityMenu(id)
    }
    else if (isMelodyne(id))
    {
        dontHide.Push("MelodyneMenu")
        showMelodyneMenu(id)
    }   

    hideAllMenus(dontHide)
}

hideAllMenus(except)
{
    if (EventEditorMenuShown and !hasVal(except, "EventEditorMenu")) ; except != "EventEditorMenu")
        hideEventEditorMenu()
    else if (PatcherMapMenuShown and !hasVal(except, "PatcherMapMenu"))
        hidePatcherMapMenu()
    else if (PianoRollMenusShown and !hasVal(except, "PianoRollMenus")) ; except != "PianoRollMenus")
        hidePianoRollMenus()
    else if (StepSeqMenusShown and !hasVal(except, "StepSeqMenus")) ; except != "StepSeqMenu")
        hideStepSeqMenus()
    else if (MixerMenuShown and !hasVal(except, "MixerMenu")) ; except != "MixerMenu")
        hideMixerMenu()                        
    else if (audacityMenuShown and !hasVal(except, "AudacityMenu"))
        hideAudacityMenu()
    else if (melodyneMenuShown and !hasVal(except, "MelodyneMenu"))
        hideMelodyneMenu()
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
showPatcherMapMenu()
{
    PatcherMapMenuShown := True
    WinGetPos, pmX, pmY, pmW, _, A
    offsetLeft := 138
    offsetRight := 228
    menuX := pmX + offsetLeft
    menuH := 45
    menuW := pmW - offsetLeft - offsetRight
    if (isWrapperPlugin())
    {
        menuY := pmY - menuH
        Gui, PatcherMapMenu:Color, %patcherMapMenuColGrey%
    }
    else
    {
        menuY := pmY + 28
        Gui, PatcherMapMenu:Color, %patcherMapMenuColBlack%
    }
    Gui, PatcherMapMenu:Show, x%menuX% y%menuY% w%menuW% h%menuH% NoActivate
    startWinMenusClock(200)
}

hidePatcherMapMenu()
{
    PatcherMapMenuShown := False
    Gui, PatcherMapMenu:Hide
    startWinMenusClock()
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
showPianoRollMenus()
{
    PianoRollMenusShown := True
    Gui, PianoRollMenu1:Show, NoActivate
    Gui, PianoRollMenu2:Show, NoActivate
}

hidePianoRollMenus()
{
    Gui, PianoRollMenu1:Hide
    Gui, PianoRollMenu2:Hide
    PianoRollMenusShown := False
}

; --------------------
showStepSeqMenus()
{
    StepSeqMenusShown := True
    WinGetPos, ssX, ssY, ssW, ssH, A
    menu1H := 53    
    ;coords := winCoordsToScreenCoords(0, -menu1H)      ; forgotten dead code?
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

; --------------------
showAudacityMenu(audacityId)
{
    audacityMenuShown := True
    WinGetPos, audX, audY, audW, audH, ahk_id %audacityId%
    menuX := audX
    menuY := audY + audH - 7
    menuW := audW
    menuH := 40
    Gui, AudacityMenu:Show, x%menuX% y%menuY% w%menuW% h%menuH% NoActivate
}

hideAudacityMenu()
{
    Gui, AudacityMenu:Hide
    audacityMenuShown := False
}

; --------------------
showMelodyneMenu(melodyneId)
{
    melodyneMenuShown := True
    WinGetPos, audX, audY, audW, audH, ahk_id %melodyneId%
    menuX := audX
    menuY := audY + audH - 7
    menuW := audW
    menuH := 40
    Gui, melodyneMenu:Show, x%menuX% y%menuY% w%menuW% h%menuH% NoActivate
}

hideMelodyneMenu()
{
    Gui, melodyneMenu:Hide
    melodyneMenuShown := False
}