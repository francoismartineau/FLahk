global EventEditorMenuShown := False
global PatcherMapMenuShown := False
global PianoRollMenusShown := False
global MixerMenuShown := False
global MasterEdisonMenuShown := False
global audacityMenuShown := False
global melodyneMenuShown := False
global mMenuShown := False

global freezeWindowMenuClock := False

guiTick()
{
    if (freezeWindowMenuClock)
        return
    dontHide := []
    WinGet, id, ID, A

    if (isPatcherMap(id))
    {
        dontHide.Push("PatcherMapMenu")
        showPatcherMapMenu(id)
    }
    else if (StepSeq.isWin(id))
    {
        dontHide.Push("StepSeqMenus")
        StepSeq.showMenus(id)
        if (!StepSeq.maximized(id))
            freezeExecute("StepSeq.maximize", [id])
    }   

    if (isEventEditor(id))
    {
        dontHide.Push("EventEditorMenu")
        if (!EventEditorMenuShown)
                showEventEditorMenu()
    }
    else if (PianoRoll.isWin(id) or (PianoRoll.winOpen() and isMidiWin(id)))
    {
        dontHide.Push("PianoRollMenus")
        if (!PianoRoll.menusShown)
            PianoRoll.showMenus()
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
    else if (isAudacity(id))
    {
        dontHide.Push("AudacityMenu")
        if (!audacityMenuShown)
            showAudacityMenu(id)
    }
    else if (isMelodyne(id))
    {
        dontHide.Push("MelodyneMenu")
        if (!melodyneMenuShown)
            showMelodyneMenu(id)
    }   

    hideAllMenus(dontHide)
}

hideAllMenus(except)
{
    if (EventEditorMenuShown and !hasVal(except, "EventEditorMenu"))
        hideEventEditorMenu()
    else if (PatcherMapMenuShown and !hasVal(except, "PatcherMapMenu"))
        hidePatcherMapMenu()
    else if (PianoRoll.menusShown and !hasVal(except, "PianoRollMenus"))
        PianoRoll.hideMenus()
    else if (StepSeq.menusShown and !hasVal(except, "StepSeqMenus"))
        StepSeq.hideMenus()
    else if (MixerMenuShown and !hasVal(except, "MixerMenu"))
        hideMixerMenu()                        
    else if (MasterEdisonMenuShown and !hasVal(except, "MasterEdisonMenu"))
        hideMasterEdisonMenu()
    else if (audacityMenuShown and !hasVal(except, "AudacityMenu"))
        hideAudacityMenu()
    else if (melodyneMenuShown and !hasVal(except, "MelodyneMenu"))
        hideMelodyneMenu()
    else if (mMenuShown and !hasVal(except, "Mmenu"))
        EnvC.hideMmenu()
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
showPatcherMapMenu(id)
{
    PatcherMapMenuShown := True
    WinGetPos, pmX, pmY, pmW, _, ahk_id %id%
    offsetLeft := 138
    offsetRight := 228
    menuX := pmX + offsetLeft
    menuH := 45
    menuW := pmW - offsetLeft - offsetRight
    if (isWrapperPlugin(id))
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
    startGuiClock(200)
}

hidePatcherMapMenu()
{
    PatcherMapMenuShown := False
    Gui, PatcherMapMenu:Hide
    startGuiClock()
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


; --------------------

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

