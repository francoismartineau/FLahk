global PianoRollMenu
global EventEditorMenu
global StepSeqMenu
global StepSeqMenu2
global MixerMenu

global PianoRollMenuId
global StepSeqMenuId
global StepSeqMenu2Id
global MixerMenuId


global windowMenuColor := 0x3F484D
global windowMenuFontColor := 0xd3d8dc
global windowMenuFontColor2 := 0x7a7d80

global GuiStampMode

; -- Piano Roll ----------------------------------------------------
makePianoRollMenu()
{
    Gui, PianoRollMenu:New
    Gui, PianoRollMenu:+AlwaysOnTop +LastFound +ToolWindow +HwndPianoRollMenuId -Caption +E0x08000000
    Gui, PianoRollMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
    Gui, PianoRollMenu:Color, %windowMenuColor%
    Gui, PianoRollMenu:Show, x-1846 y1380 w1824 h73 NoActivate, PianoRollMenu
    Gui, PianoRollMenu:Hide
    

    Gui, PianoRollMenu:Add, Text, x5 y5 w50 h50 vGuiStampMode gTOGGLE_STAMP_STATE
    incr := 92/2
    x := 90
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_QUANTIZE, quantize
    x := x + incr*2
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_MAP, map
    x := x + incr*2
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_STRUM, |/ chords
    x := x + incr*2
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_TWINS, twins 
    x := x + incr*2
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_CHOP, chop
    x := x + incr*2
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_FLIP, flip
    x := x + incr*2
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_SCALE, scale 
    x := x + incr*2
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_LFO, lfo
    x := x + incr*2
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_2,  2 
    x := x + incr*2
    Gui, PianoRollMenu:Add, Text, x%x% y5 w%incr% h50, 
    x := x + incr*2
    pianoRollHotkeys =
(
.           1           2           3           4
           Rand        len         slide       +space     
ctrl       Gen                                 crop
alt        Arp         !len                    del
)
    Gui, PianoRollMenu:Add, Text, x%x% y5, %pianoRollHotkeys%

    updatePianoRollMenuStampMode()
}

updatePianoRollMenuStampMode()
{
    global stampMode
    if (!stampState)
    {
        stamp := "___"
        Gui, PianoRollMenu:Font, c%windowMenuFontColor2%
        GuiControl, PianoRollMenu:Font, GuiStampMode
    }
    else
    {
        stamp := stampMode
        if (stampMode == "rand")
            stamp := stamp "" stampRand
        Gui, PianoRollMenu:Font, c%windowMenuFontColor%
        GuiControl, PianoRollMenu:Font, GuiStampMode
    }
    GuiControl, PianoRollMenu:, GuiStampMode, Stamp`r`n(r,m)`r`n%stamp%
}

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
}

; -- Step Seq --------------------------------------------------------
makeStepSeqMenus()
{
    Gui, StepSeqMenu:New
    Gui, StepSeqMenu:-Caption +AlwaysOnTop +LastFound +ToolWindow +HwndStepSeqMenuId
    Gui, StepSeqMenu:+E0x08000000
    Gui, StepSeqMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
    Gui, StepSeqMenu:Show, NoActivate, StepSeqMenu
    Gui, StepSeqMenu:Hide
    Gui, StepSeqMenu:Color, %windowMenuColor%
    ;.     1        2        3        4        5        6        7        8        9        0
    text =
(
.     1        2        3        4        5        6        7        8        9        0     L: lock instr
      3x       long     chords   vox     rave      speech   granul                                         
alt   rand     plucked  beep     gun     bass      piano    slicex                            +(!)scroll
)
    Gui, StepSeqMenu:Add, Text, x10, %text%

    Gui, StepSeqMenu2:New
    Gui, StepSeqMenu2:-Caption +AlwaysOnTop +LastFound +ToolWindow +HwndStepSeqMenu2Id
    Gui, StepSeqMenu2:+E0x08000000
    Gui, StepSeqMenu2:Font, s9 c%windowMenuFontColor%, %mainFont%
    Gui, StepSeqMenu2:Show, NoActivate, StepSeqMenu2
    Gui, StepSeqMenu2:Hide
    Gui, StepSeqMenu2:Color, %windowMenuColor%    
    Gui, StepSeqMenu2:Add, Button, x10 w55 h15 gSPLIT_PATTERN, split p
}

mouseOnStepSeqMenuSection()
{
    MouseGetPos, mx, my
    if (mx > 48 and mx < 109)
        pos := "1"
    else if (mx > 109 and mx < 173)
        pos := "2"
    else if (mx > 173 and mx < 236)
        pos := "3"
    else if (mx > 236 and mx < 300)
        pos := "4"
    else if (mx > 300 and mx < 362)
        pos := "5"
    else if (mx > 362 and mx < 425)
        pos := "6"
    else if (mx > 425 and mx < 487)
        pos := "7"
    else if (mx > 487 and mx < 541)
        pos := "8"
    else if (mx > 541 and mx < 611)
        pos := "9"
    else if (mx > 611)
        pos := "0"

    if (my > -47 and my < -18)
        pos := pos "_1"
    else if (my > -18 and my < 1)
        pos := pos "_2"

    return pos
}

; -- Mixer -----------------------------------------------------------
makeMixerMenu()
{
    Gui, MixerMenu:New
    Gui, MixerMenu:-Caption +AlwaysOnTop +HwndMixerMenuId +LastFound +ToolWindow 
    Gui, MixerMenu:+E0x08000000
    Gui, MixerMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
    Gui, MixerMenu:Show, x-1711 y1000 w1476 h51 NoActivate, MixerMenu
    Gui, MixerMenu:Color, %windowMenuColor%
    Gui, MixerMenu:Add, Button, x30  y10 gASSIGN_TRACK_M1, m1
    Gui, MixerMenu:Add, Button, x+10 y10 gASSIGN_TRACK_M2, m2
    Gui, MixerMenu:Add, Button, x+10 y10 gASSIGN_TRACK_M3, m3
    Gui, MixerMenu:Add, Button, x+10 y10 gASSIGN_TRACK_BASS, bass
    Gui, MixerMenu:Add, Button, x+10 y10 gASSIGN_TRACK_NO_BASS, no bass    
    text =
(
.                       F5          0           9           8           7           6           5           4           3           2           1 
        newTone         comp       scratch     conv        chorus      filter      SPEAK       gate        stereo       EQ          PEAK        REV
alt     newTime         gross      bass        transi      phaser      VIBRATO     ringmod     auto        dist         equo        delay       MOD
)
; new tone      new time
    Gui, MixerMenu:Add, Text, x410 y3, %text%
    Gui, MixerMenu:Hide
}

mouseOnMixerMenuSection()
{
    MouseGetPos, mx, my
    if (mx > 1604 and mx < 1681)
        pos := "1"
    else if (mx > 1517 and mx < 1604)
        pos := "2"
    else if (mx > 1436 and mx < 1517)
        pos := "3"
    else if (mx > 1346 and mx < 1436)
        pos := "4"
    else if (mx > 1263 and mx < 1346)
        pos := "5"
    else if (mx > 1176 and mx < 1263)
        pos := "6"
    else if (mx > 1094 and mx < 1176)
        pos := "7"
    else if (mx > 1011 and mx < 1094)
        pos := "8"
    else if (mx > 929 and mx < 1011)
        pos := "9"
    else if (mx > 847 and mx < 929)
        pos := "0"
    else if (mx > 780 and mx < 847)
        pos := "F5"
    else if (mx > 670)
        pos := "F6"

    if (my > -25 and my < 7)
        pos := pos "_1"
    else if (my > 7 and my < 27)
        pos := pos "_2"

    return pos
}