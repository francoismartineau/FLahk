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


OnMessage(0x0200, "onMouseMoveOverGui")     ; https://www.autohotkey.com/docs/misc/SendMessageList.htm
OnMessage(0x020A, "onWheelOverGui")

makeWindow()
{
    makeFLahkIsRunningWindow()
    ;makeBackgroundWindow()
    PianoRoll.makeMenus()
    makeEventEditorMenu()
    makePatcherMapMenu()
    StepSeq.makeMenus()
    makeMixerMenu()
    makeMasterEdisonMenu()
    makeAudacityMenu()
    makeMelodyneMenu()

    makeWindowRow1()
    makeWindowRow2()
    makeConcatAudioButtons()
    makeNumpadG()
    EnvC.makeMmenu()
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
    Gui, Main1:Add, Button, x+10 h20 w20 gBPM, 💓 
    Gui, Main1:Add, Button, x+5 h20 w20 gRANDOM_TYPING_KEYBOARD, 🎹
    Gui, Main1:Add, Button, x+5 h20 w20 gRAND_PLUGIN, 🎲
    Gui, Main1:Add, Button, x+10 gCONCAT_AUDIO, _gen   
    global GenWord 
    ;global GenWord_TT := "clipboard random word(s). Scroll over to change quantity."
    Gui, Main1:Add, Button, x+10 h13 w34 vGenWord gGEN_WORD, word

    static ENCAPSULATION
    Gui, Main1:Add, Button, x+52 vENCAPSULATION h20 gENCAPSULATION, Encapsulation
    static SET_DATA_FOLDER
    global SET_DATA_FOLDER_TT := "Set current project's Data Folder as ...\projFolder\projName"
    Gui, Main1:Add, Button, x+10 h20 vSET_DATA_FOLDER gSET_DATA_FOLDER, DataFolder

    Gui, Main1:Add, Text, x+30 h50 w260 vProjPathGui gOPEN_PROJECT_FOLDERS,
    Gui, Main1:Add, Text, x+10, !F3: win@mouse
    ;;; marche pas? 
    ;Gui, Main1:Add, Text, x+50 vMainGuiMsg, %MainGuiMsg%    
    return

    BPM:
    freezeExecute("randomizeBpm")
    return

    RANDOM_TYPING_KEYBOARD:
    freezeExecute("randomizeTypingKeyboard")
    return

    RAND_PLUGIN:
    freezeExecute("randomizePlugin")
    return

    CONCAT_AUDIO:
    toggleShowConcatAudio()
    return

    GEN_WORD:
    words := GetWords.gen()
    clipboard := words
    msg(words)
    return

    ENCAPSULATION:
    waitKey("LButton")
    freezeExecute("Encapsulation.start")
    return


    SET_DATA_FOLDER:
    waitKey("LButton")
    freezeExecute("DataFolder.set")
    return

    OPEN_PROJECT_FOLDERS:
    openProjectFolders()
    return
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
    static TOGGLE_LEFT_SCREEN
    global TOGGLE_LEFT_SCREEN_TT := "Close left screen windows / Show Mixer and Edison"
    Gui, Main2:Add, Button, x+10 h20 h20 w20 vTOGGLE_LEFT_SCREEN gTOGGLE_LEFT_SCREEN,🢤


    static LOOP_MIDI
    global LOOP_MIDI_TT := "Edit virtual midi ports"
    Gui, Main2:Add, Button, x+10 h13 w35 vLOOP_MIDI gLOOP_MIDI, midi
    Gui, Main2:Add, Button, x+5 h13 w50 gWINDOW_SPY, WinSpy
    Gui, Main2:Add, CheckBox, x+10 vPYnoteToggleGui gPY_NOTE_TOGGLE checked, PY

    ;Gui, Main2:Add, Text, x+75 w45 vGuiMouseCtlL, L:
    ;Gui, Main2:Add, Text, x+10 w45 vGuiMouseCtlR, R:
    ;Gui, Main2:Add, Text, x+10 w45 w50 gTOGGLE_MOUSE_CTL_INTERPOLATION_MODE vGuiMouseCtlIncrMode, stop
    ;Gui, Main2:Add, Text, x+10 w45 w100, ^(+)mclick
    Gui, Main2:Add, CheckBox, x+10 vwinHistoryDebugGui gWIN_HISTORY_DEBUG_TOGGLE, winHistory
    Gui, Main2:Add, CheckBox, x+10 vknobSavesDebugToggleGui gKNOB_SAVES_DEBUG_TOGGLE, knobSaves

    ;Gui, Main2:Add, Text, x438 y20 w100 vGuiMouseCtlActive, ^
    ;Gui, Main2:Add, Text, x+10 y20 w200 vGuiMouseCtlIncrActive, L0 R0
    return

    TOGGLE_LEFT_SCREEN:
    toggleLeftScreenWindows()
    return

    LOOP_MIDI:
    bringLoopMidi()
    return

    WINDOW_SPY:
    windowSpyPath := Paths.windowSpy
    run, %windowSpyPath%
    return

    PY_NOTE_TOGGLE:
    ; pyNoteToggle()
    return    

    ;TOGGLE_MOUSE_CTL_INTERPOLATION_MODE:
    ;toggleMouseCtlInterpolationMode()
    ;return

    WIN_HISTORY_DEBUG_TOGGLE:
    winHistoryDebugToggle()
    return

    KNOB_SAVES_DEBUG_TOGGLE:
    knobSavesDebugToggle()
    return

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
; -----

; -----
onMouseMoveOverGui(disableTT := False)
{
    static CurrControl, PrevControl, _TT
    if (!isValidVarName(A_GuiControl))
        return
    CurrControl := A_GuiControl
    if (disableTT)
    {
        SetTimer, DisplayGuiInfoToolTip, Off
        SetTimer, HideGuiInfoToolTip, Off
        ToolTip
    }
    else if (CurrControl != PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip
        SetTimer, DisplayGuiInfoToolTip, 1000
        PrevControl := CurrControl
    }
    return

    DisplayGuiInfoToolTip:
    SetTimer, DisplayGuiInfoToolTip, Off
    ToolTip % %CurrControl%_TT  ; The leading percent sign tell it to use an expression.
    ;SetTimer, HideGuiInfoToolTip, 3000
    return

    HideGuiInfoToolTip:
    SetTimer, HideGuiInfoToolTip, Off
    ToolTip
    return
}

onWheelOverGui()
{
    Switch A_ThisHotkey
    {
    Case "WheelUp":
        dir := "up"
    Case "WheelDown":
        dir := "down"
    }
    Switch A_GuiControl
    {
    Case "GuiPianoRollMagnet":
        freezeExecute("PianoRoll.toggleMagnet")
    Case "GenWord":
        GetWords.incrNum(dir)
    }
}

mouseOverAhkGui()
{
    MouseGetPos,,, mWinId
    WinGetClass, class, ahk_id %mWinId%
    return class == "AutoHotkeyGUI"
}
; -----