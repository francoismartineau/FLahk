﻿global PianoRollMenu1
global PianoRollMenu2
global EventEditorMenu
global StepSeqMenu
global StepSeqMenu2
global MixerMenu
global MasterEdisonMenu
global PatcherMapMenu
global AudacityMenu
global MelodyneMenu
global Mmenu

global StepSeqMenuId
global StepSeqMenu2Id
global MixerMenuId
global MasterEdisonMenuId
global PatcherMapMenuId
global AudacityMenuId
global MelodyneMenuId
global MmenuId


global windowMenuColor := 0x3F484D
global windowMenuFontColor := 0xd3d8dc
global windowMenuFontColor2 := 0x7a7d80

global GuiStampMode

; -- Piano Roll ----------------------------------------------------


; ----

; -- Patcher Map --------------------------------------------------
global patcherMapMenuColBlack := 0x21272B
global patcherMapMenuColGrey := 0x31373B
makePatcherMapMenu()
{
    Gui, PatcherMapMenu:New
    Gui, PatcherMapMenu:-Caption +AlwaysOnTop +LastFound +ToolWindow +HwndPatcherMapMenuId
    Gui, PatcherMapMenu:+E0x08000000
    Gui, PatcherMapMenu:Show, NoActivate, PatcherMapMenu
    Gui, PatcherMapMenu:Hide
    Gui, PatcherMapMenu:Color, %patcherMapMenuColBlack%
    nums =
(     
        1         2         3         4         5         6         7         8         9         0             double click plugins
)    
    insts =
(
inst    Sampler   Slicex    Synth     Piano     EnvC                          Plucked   Vox       Chords
)
    fxs = 
(
fx      ROOM      MOD       FILTER    PATCHER4  lfo      formula    PITCH     DYN       speaker   SEQ
)
/*
    scroll                                   0           9           8           7           6           5           4          3           2           1 
    +1 +2 +3  m1 m2 m3     + ou ^ slots      EDIT                                                        DYN         PITCH      FILTER      MOD         rev
    !    <- ->      !+ <<- ->>                           3xGross     scratch     conv        speaker     autopan     dist       PATCHER4    peak        delay
*/
    Gui, PatcherMapMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
    Gui, PatcherMapMenu:Add, Text, x10 y-2, %nums%
    Gui, PatcherMapMenu:Font, s9 c%midiKnotCol%, %mainFont%
    Gui, PatcherMapMenu:Add, Text, x10 y+0, %insts%
    Gui, PatcherMapMenu:Font, s9 c%audioKnotCol%, %mainFont%
    Gui, PatcherMapMenu:Add, Text, x10 y+0, %fxs%        
}
; ----

; -- Event Editor ----------------------------------------------------
makeEventEditorMenu()
{
    Gui, EventEditorMenu:New
    Gui, EventEditorMenu:-Caption +AlwaysOnTop +LastFound +ToolWindow
    Gui, EventEditorMenu:+E0x08000000
    Gui, EventEditorMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
    Gui, EventEditorMenu:Show, x-1355 y1029 w1256 h22 NoActivate, EventEditorMenu
    Gui, EventEditorMenu:Hide
    Gui, EventEditorMenu:Color, %windowMenuColor%
    Gui, EventEditorMenu:Add, Text, x10 gEVENT_EDITOR_LFO, 1 lfo
    Gui, EventEditorMenu:Add, Text, x+150 gEVENT_EDITOR_SCALE, 2 scale
    Gui, EventEditorMenu:Add, Text, x+150 gEVENT_EDITOR_INSERT_CURR_CTL_VAL, 3 curr ctl val
    Gui, EventEditorMenu:Add, Text, x+150 gEVENT_EDITOR_MAKE_AUTOMATION, 4 make automation
    Gui, EventEditorMenu:Add, Text, x+150, ^v cycle params
    return 

    EVENT_EDITOR_LFO:
    freezeExecute("activateEventEditorLFO")
    return

    EVENT_EDITOR_SCALE:
    freezeExecute("activateEventEditorScale")
    return

    EVENT_EDITOR_INSERT_CURR_CTL_VAL:
    freezeExecute("insertCurrentControllerValue")
    return

    EVENT_EDITOR_MAKE_AUTOMATION:
    freezeExecute("turnEventsIntoAutomation")
    return    
}
; ----

; -- M menu ---------------------------------------------------------

; ----


; -- Mixer -----------------------------------------------------------
makeMixerMenu()
{
    Gui, MixerMenu:New
    Gui, MixerMenu:-Caption +AlwaysOnTop +HwndMixerMenuId +LastFound +ToolWindow 
    Gui, MixerMenu:+E0x08000000
    Gui, MixerMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
    res := getMixerMenuPos()
    mixerMenuX := res[1]
    mixerMenuY := res[2]
    Gui, MixerMenu:Show, x%mixerMenuX% y%mixerMenuY% w1476 h51 NoActivate, MixerMenu
    Gui, MixerMenu:Color, %windowMenuColor%
    Gui, MixerMenu:Add, Button, x30  y10 gASSIGN_TRACK_M1, m1
    Gui, MixerMenu:Add, Button, x+10 y10 gASSIGN_TRACK_M2, m2
    Gui, MixerMenu:Add, Button, x+10 y10 gASSIGN_TRACK_M3, m3
    Gui, MixerMenu:Add, Button, x+10 y10 gASSIGN_TRACK_BASS, bass
    Gui, MixerMenu:Add, Button, x+10 y10 gASSIGN_TRACK_NO_BASS, no bass    
    ;                                        ;           ;           ;           ;           ;           ;           ;
    text =
(   
    scroll                                   0           9           8           7           6           5           4          3           2           1 
    +1 +2 +3  m1 m2 m3     + ou ^ slots      EDIT        peak                                                        DYN        PITCH       SEQ         ROOM
    !    <- ->      !+ <<- ->>                                       scratch                 speaker     autopan     dist       PATCHER4    FILTER      MOD
)
    ; to add a slot on the left,
    ; take a screen shot and display it in photo shop (zoom 100%, f)
    ; set the gui transparent (WinSet, Transparent, 155, ahk_id %MixerMenuId%) and never hide it
    ; nudge it until the gui over photoshop is in place with the screenshot
    x := 354
    Gui, MixerMenu:Add, Text, x%x% y3, %text%
    Gui, MixerMenu:Hide
    return

    ASSIGN_TRACK_M1:
    freezeExecute("assignMixerTrackRoute", ["m1"])
    return

    ASSIGN_TRACK_M2:
    freezeExecute("assignMixerTrackRoute", ["m2"])
    return

    ASSIGN_TRACK_M3:
    freezeExecute("assignMixerTrackRoute", ["m3"])
    return

    ASSIGN_TRACK_BASS:
    freezeExecute("assignMixerTrackRoute", ["bass"])
    return

    ASSIGN_TRACK_NO_BASS:
    freezeExecute("assignMixerTrackRoute", ["no bass"])
    return    

}

getMixerMenuPos()
{
    if (WinExist("ahk_class TFXForm"))
    {
        WinGetPos, mixerX, mixerY,,, ahk_class TFXForm
        mixerMenuX := mixerX + 209
        mixerMenuY := mixerY - 27
    }
    else
    {
        mixerMenuX := Mon1Left + 209
        mixerMenuY := 1027 - 27
    }
    return [mixerMenuX, mixerMenuY]
}

mouseOnMixerMenuSection()
{
    MouseGetPos, mx, my

    if (mx > 1624 and mx < 1662)
        pos := "1"
    else if (mx > 1543 and mx < 1591)
        pos := "2"
    else if (mx > 1458 and mx < 1505)
        pos := "3"
    else if (mx > 1372 and mx < 1417)
        pos := "4"
    else if (mx > 1289 and mx < 1339)
        pos := "5"
    else if (mx > 1205 and mx < 1264)
        pos := "6"
    else if (mx > 1121 and mx < 1182)
        pos := "7"
    else if (mx > 1037 and mx < 1098)
        pos := "8"
    else if (mx > 953 and mx < 1009)
        pos := "9"
    else if (mx > 871 and mx < 925)
        pos := "0"
    else if (mx > 780 and mx < 847)
        pos := "F5"
    else if (mx > 702 and mx < 763)
        pos := "F6"
    else if (mx > 617 and mx < 667)
        pos := "F7"
        
    if (my > -25 and my < 7)
        pos := pos "_1"
    else if (my > 7 and my < 27)
        pos := pos "_2"

    return pos
}
; ----

; -- Master Edison --------------------------------------------------
makeMasterEdisonMenu()
{
    Gui, MasterEdisonMenu:New
    Gui, MasterEdisonMenu:-Caption +AlwaysOnTop +HwndMasterEdisonMenuId +LastFound +ToolWindow 
    Gui, MasterEdisonMenu:+E0x08000000
    Gui, MasterEdisonMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
    MasterEdisonMenuX := Mon1Left + 209
    MasterEdisonMenuY := 1000
    MasterEdisonMenuW := 1476
    MasterEdisonMenuH := 51
    Gui, MasterEdisonMenu:Show, x%MasterEdisonMenuX% y%MasterEdisonMenuY% w%MasterEdisonMenuW% h%MasterEdisonMenuH% NoActivate, MasterEdisonMenu
    Gui, MasterEdisonMenu:Color, %windowMenuColor%
    text =
(
!t: truncate audio          
Win v: drag             Ctrl v^: !rec           Alt v^: !onPlay                 Ctrl+Alt v^: scroll
^s: save sound                                                                                      !▶⏸■⏺: mEdison trans
)
    Gui, MasterEdisonMenu:Add, Text, x10 y3, %text%
    static DENOISE_BUTTON
    global DENOISE_BUTTON_TT := "Denoise current Edison sample"
    Gui, MasterEdisonMenu:Add, Button, x+10 h13 w60 vDENOISE_BUTTON gDENOISE_BUTTON, denoise
    Gui, MasterEdisonMenu:Hide
    return

    DENOISE_BUTTON:
    denoise()
    return
}
; ----


; -- Transfer Sound -----------------------------------------------------------
makeAudacityMenu()
{
    Gui, AudacityMenu:New
    Gui, AudacityMenu:-Caption +AlwaysOnTop +HwndAudacityMenuId +LastFound +ToolWindow 
    Gui, AudacityMenu:+E0x08000000
    Gui, AudacityMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
    Gui, AudacityMenu:Color, %windowMenuColor%
    text = !t: truncate audio      win scroll^: load Transfer Sound    win scrollv: export transfer sound          F4: close
    Gui, AudacityMenu:Add, Text, x10 y10, %text%
}

makeMelodyneMenu()
{
    Gui, MelodyneMenu:New
    Gui, MelodyneMenu:-Caption +AlwaysOnTop +HwndMelodyneMenuId +LastFound +ToolWindow 
    Gui, MelodyneMenu:+E0x08000000
    Gui, MelodyneMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
    Gui, MelodyneMenu:Color, %windowMenuColor%
    text = win scroll^: load Transfer Sound    win scrollv: export transfer midi          F4: close
    Gui, MelodyneMenu:Add, Text, x10 y10, %text%
}
; ----
