global mainFont := "Consolas"
global mainMenusColor := 0x596267

FL_IS_MAXIMIZED := true
WinMaximize, ahk_class TFruityLoopsMainForm 

global FLahkGuiId1
global FLahkGuiId2
;global MainGuiMsg := "-"

;global FLahkBackgroundGuiId

global maxedGui2H := 150
global gui2H := 35
global gui2W := 985

global GuiMouseCtlL, GuiMouseCtlR, GuiMouseCtlActive, GuiMouseCtlIncrMode, GuiMouseCtlIncrActive

global PYnoteToggleGui
global winHistoryDebugGui
global knobSavesDebugToggleGui
global ProjPathGui

makeWindow()
{
    makeFLahkIsRunningWindow()
    ;makeBackgroundWindow()
    makePianoRollMenus()
    makeEventEditorMenu()
    makePatcherMapMenu()
    makeStepSeqMenus()
    makeMixerMenu()
    makeMasterEdisonMenu()
    makeAudacityMenu()
    makeMelodyneMenu()

    makeWindowRow1()
    makeWindowRow2()
    makeConcatAudioButtons()
    makeNumpadG()
    makeMmenu()
    makeRecordEnabledGui()
    
    Menu, Tray, Icon, fl.ico,,1
    

}

makeFLahkIsRunningWindow()
{
    Gui, FLahkIsRunningWindow:New
    Gui, FLahkIsRunningWindow:-Caption +E0x08000000 +E0x20 +AlwaysOnTop +LastFound +ToolWindow
    Gui, FLahkIsRunningWindow:Color, %mainMenusColor%
    Gui, FLahkIsRunningWindow:Show, x0 y0 w1 h1 NoActivate, FLahkIsRunningWindow
}

makeWindowRow1()
{
    global FLahkGuiId1
    Gui, Main1:New
    Gui, Main1:-Caption +E0x08000000 +AlwaysOnTop +LastFound +ToolWindow +HwndFLahkGuiId1
    Gui, Main1:Color, %mainMenusColor%
    Gui, Main1:Font, s9 cCCCCCC, %mainFont%
    Gui, Main1:Show, x935 y1 w918 h39, FLahk window1

    Gui, Main1:Add, Text, x0 y5, 
    Gui, Main1:Add, Button, x+10 gBPM, 💓 
    Gui, Main1:Add, Button, x+8 gRANDOM_TYPING_KEYBOARD, 🎹
    Gui, Main1:Add, Button, x+8 gRAND_PLUGIN, 🎲
    Gui, Main1:Add, Button, x+10 gCONCAT_AUDIO, _gen    

    Gui, Main1:Add, Button, x+52 h20 gUNWRAP_PROJECT, unwrap
    Gui, Main1:Add, Button, x+10 h20 gPREV_PROJECT, prev proj
    Gui, Main1:Add, CheckBox, x+10 vPYnoteToggleGui gPY_NOTE_TOGGLE checked, PY
    Gui, Main1:Add, Button, x+2 h13 w35 gLOOP_MIDI, midi

    Gui, Main1:Add, Text, x+50 h50 w260 vProjPathGui gOPEN_PROJECT_FOLDERS,
    Gui, Main1:Add, Text, x+10, !F3: win@mouse

    ;;; marche pas? 
    ;Gui, Main1:Add, Text, x+50 vMainGuiMsg, %MainGuiMsg%
}

mouseOverAhkGui()
{
    MouseGetPos,,, mWinId
    WinGetClass, class, ahk_id %mWinId%
    return class == "AutoHotkeyGUI"
}


makeWindowRow2()
{
    global gui2H, gui2W, maxedGui2H, FLahkGuiId2
    Gui, Main2:New
    Gui, Main2:+AlwaysOnTop +LastFound +ToolWindow +HwndFLahkGuiId2 -Caption +E0x08000000
    Gui, Main2:Color, %mainMenusColor%
    Gui, Main2:Font, s9 cCCCCCC, %mainFont%
    Gui, Main2:Show, x935 y45 w%gui2W% h%gui2H%, FLahk window2

    Gui, Main2:Add, Text, x0 y5 h+5,
    Gui, Main2:Add, Button, x+10 h20 gTOGGLE_LEFT_SCREEN,🢤 screen
    ;Gui, Main2:Add, Button, x+10 gRESET_AUDIO_DEVICE, ↺ device
    Gui, Main2:Add, Button, x+10 h20 gAUTO_CLEAN_AUDIO, denoise
    Gui, Main2:Add, Button, x+50 h20 gWINDOW_SPY, Win Spy
    Gui, Main2:Add, Button, x+10 h20 gADJUST_WINDOW_SEPARATORS, separators

    Gui, Main2:Add, Text, x+75 w45 vGuiMouseCtlL, L:
    Gui, Main2:Add, Text, x+10 w45 vGuiMouseCtlR, R:
    Gui, Main2:Add, Text, x+10 w45 w50 gTOGGLE_MOUSE_CTL_INTERPOLATION_MODE vGuiMouseCtlIncrMode, stop
    Gui, Main2:Add, Text, x+10 w45 w100, ^(+)mclick
    Gui, Main2:Add, CheckBox, x+10 vwinHistoryDebugGui gWIN_HISTORY_DEBUG_TOGGLE, winHistory
    Gui, Main2:Add, CheckBox, x+10 vknobSavesDebugToggleGui gKNOB_SAVES_DEBUG_TOGGLE, knobSaves

    Gui, Main2:Add, Text, x438 y20 w100 vGuiMouseCtlActive, ^
    Gui, Main2:Add, Text, x+10 y20 w200 vGuiMouseCtlIncrActive, L0 R0
}


makeWindowControls()
{
    global gui2W
    quitButtonSize := 15
    
    quitButtonX := gui2W - quitButtonSize - 5
    Gui, Main1:Add, Button, x%quitButtonX% y5 w%quitButtonSize% h%quitButtonSize% gQUIT, x
        
    restoreMaximizeButtonX := quitButtonX - quitButtonSize - 3
    Gui, Main1:Add, Button, x%restoreMaximizeButtonX% y5 w%quitButtonSize% h%quitButtonSize% gRESTORE_MAXIMIZE, □

    minimizeButtonX := restoreMaximizeButtonX - quitButtonSize - 3
    Gui, Main1:Add, Button, x%minimizeButtonX% y5 w%quitButtonSize% h%quitButtonSize% gMINIMIZE, -
    
    questionButtonX := minimizeButtonX - quitButtonSize - 3
    Gui, Main1:Add, Button, x%questionButtonX% y5 w%quitButtonSize% h%quitButtonSize% gQUESTION_BUTTON, ?
}

; -----
hideMainGuis()
{
    WinHide, ahk_id %FLahkGuiId1%
    WinHide, ahk_id %FLahkGuiId2%    
}

showMainGuis()
{
    WinShow, ahk_id %FLahkGuiId1%
    WinShow, ahk_id %FLahkGuiId2%    
}