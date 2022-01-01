global EventEditorMenuShown := False
global PatcherMapMenuShown := False
global PianoRollMenusShown := False
global MixerMenuShown := False
global MasterEdisonMenuShown := False
global StepSeqMenusShown := False
global audacityMenuShown := False
global melodyneMenuShown := False
global mMenuShown := False

global freezeWindowMenuClock := False

windowMenusTick()
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
        if (!PatcherMapMenuShown)
            showPatcherMapMenu()
    }
    else if (isPianoRoll(id))
    {
        dontHide.Push("PianoRollMenus")
        if (!PianoRollMenusShown)
            showPianoRollMenus()
    }
    else if (isMixer(id))
    {
        dontHide.Push("MixerMenu")
        if (!MixerMenuShown)
            showMixerMenu()
    }
    else if (isMasterEdison(id))
    {
        dontHide.Push("MasterEdisonMenu")
        if (!MasterEdisonMenuShown)
            showMasterEdisonMenu()        
    }
    else if (isStepSeq(id))
    {
        dontHide.Push("StepSeqMenus")
        showStepSeqMenus(id)
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
    else if (isM1(id))
    {
        dontHide.Push("Mmenu")
        showMmenu(id)
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
    else if (MasterEdisonMenuShown and !hasVal(except, "MasterEdisonMenu"))
        hideMasterEdisonMenu()
    else if (audacityMenuShown and !hasVal(except, "AudacityMenu"))
        hideAudacityMenu()
    else if (melodyneMenuShown and !hasVal(except, "MelodyneMenu"))
        hideMelodyneMenu()
    else if (mMenuShown and !hasVal(except, "Mmenu"))
        hideMmenu()
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
showMasterEdisonMenu()        
{
    MasterEdisonMenuShown := True 
    Gui, MasterEdisonMenu:Show, NoActivate
}

hideMasterEdisonMenu()
{
    MasterEdisonMenuShown := False 
    Gui, MasterEdisonMenu:Hide
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
showStepSeqMenus(ssId)
{
    StepSeqMenusShown := True
    WinGetPos, ssX, ssY, ssW, ssH, ahk_id %ssId%
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
showMmenu(mId)
{
    mMenuShown := True
    WinGetPos, m1X, m1Y, m1W, m1H, ahk_id %mId%
    menuH := 25   
    menuX := m1X
    menuY := m1Y - menuH
    Gui, Mmenu:Show, x%menuX% y%menuY% w%m1W% h%menuH% NoActivate    
    startWinMenusClock(50)
}

hideMmenu()
{
    Gui, Mmenu:Hide
    mMenuShown := True
    startWinMenusClock()
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

