; -- clocks ---------------
WINDOW_HISTORY_CLOCK:
    winHistoryTick()
    return

MAIN_CLOCK:
    hideShowFLahk()
    keepNumLockOn()
    knobSavesDebuger()
    startStopObsClock()
    return

WINDOW_MENUS_CLOCK:
    windowMenusTick()
    return

SAVE_REMINDER_CLOCK:
    saveReminder()
    return

RECORD_ENABLED_CLOCK:
    mouseGetPos(mX, mY, "Screen")
    showRecordEnabledGui(mX-recordGuiW/3, mY+50)
    return

PY_CHECK:
    if (!checkIfPYrunning())
        restartPY()
    return

LOOP_MIDI:
    bringLoopMidi()
    return

; -- concat audio -----------------------
CONCAT_AUDIO:
    if (ConcatAudioShown)
        hideConcatAudio()
    else
        showConcatAudio()
    return
CONCAT_AUDIO_BROWSE:
    freezeExecute("browseRandomSingleSound", [], False)
    return
PICK_CONCAT_AUDIO_PATH1:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(1)
        else
            pickConcatAudioPaths(1)
    return

PICK_CONCAT_AUDIO_PATH2:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(2)
        else
            pickConcatAudioPaths(2)
    return

PICK_CONCAT_AUDIO_PATH3:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(3)
        else
            pickConcatAudioPaths(3)
    return

PICK_CONCAT_AUDIO_PATH4:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(4)
        else
            pickConcatAudioPaths(4)
    return

PICK_CONCAT_AUDIO_PATH5:
    if (ConcatAudioShown)
        if (GetKeyState("Ctrl"))
            disableConcatAudioPath(5)
        else
            pickConcatAudioPaths(5)
    return


UPDATE_CONCAT_AUDIO_NUM_SLIDER:
    if (ConcatAudioShown)
        updateConcatAudioNumSlider()
    return

UPDATE_CONCAT_AUDIO_LEN_SLIDER:
    if (ConcatAudioShown)
        updateConcatAudioLenSlider()
        checkConcatAudioLen()
    return

UPDATE_CONCAT_AUDIO_GATE_SLIDER:
    if (ConcatAudioShown)
        updateConcatAudioGateSlider()
        checkConcatAudioGate()
    return

CONCAT_AUDIO_RUN:
    if (ConcatAudioShown)
        concatAudioRun()
    return


; -- gui buttons ------------------------
OPEN_PROJECT_FOLDERS:
    if (savesFilePath and currProjPath)
    {
        browseFolder(savesFilePath)
        browseFolder(currProjPath)
    }
    else
        freezeExecute("loadSaveFileIfExists")
    return

PY_NOTE_TOGGLE:
    GuiControlGet, checked,, PYnoteToggleGui
    if (checked)
        startPYbootClock()
    else
    {
        stopPYbootClock()
        stopPY()
    }
    return

WIN_HISTORY_DEBUG_TOGGLE:
    GuiControlGet, checked,, winHistoryDebugGui
    debugWindowHistory := checked
    if (!debugWindowHistory)
        toolTip("", toolTipIndex["debug"])
    return

KNOB_SAVES_DEBUG_TOGGLE:
    GuiControlGet, checked,, knobSavesDebugToggleGui
    knobSavesDebug := checked
    if (!knobSavesDebug)
        toolTip("", toolTipIndex["debug"])
    return

MOVE_WIN_AT_MOUSE:
    moveWinAtMouse()
    return

RAND_PLUGIN:
    bringFL()
    freezeExecute("randomizePlugin")
    return

AUTO_CLEAN_AUDIO:
    bringFL()
    WinGetClass, class, A
    if (class == "TPluginForm")
    {
        WinGet, id, ID, A
        freezeExecute("denoise", [], False)
    }
    return

RESET_AUDIO_DEVICE:
    bringFL()
    freezeExecute("resetSoundDevice")
    return

ASSIGN_TRACK_M1:
    bringFL()
    freezeExecute("assignMixerTrackRoute", ["m1"], True, True)
    return

ASSIGN_TRACK_M2:
    bringFL()
    freezeExecute("assignMixerTrackRoute", ["m2"], True, True)
    return

ASSIGN_TRACK_M3:
    bringFL()
    freezeExecute("assignMixerTrackRoute", ["m3"], True, True)
    return

ASSIGN_TRACK_BASS:
    bringFL()
    freezeExecute("assignMixerTrackRoute", ["bass"], True, True)
    return

ASSIGN_TRACK_NO_BASS:
    bringFL()
    freezeExecute("assignMixerTrackRoute", ["no bass"], True, True)
    return

UNWRAP_PROJECT:
    bringFL()
    freezeExecute("unwrapProject")
    return

PREV_PROJECT:
    bringFL()
    Send {Ctrl Down}s{Ctrl Up}
    Send {Alt Down}2{Alt Up}
    return

 BPM:
    bringFL()
    freezeExecute("randomizeBpm")
    return

RANDOM_TYPING_KEYBOARD:
    bringFL()
    freezeExecute("randomizeTypingKeyboard")
    return


TOGGLE_LEFT_SCREEN:
    toggleLeftScreenWindows()
    return

WINDOW_SPY:
    run, %windowSpyPath%
    return


ADJUST_WINDOW_SEPARATORS:
    freezeExecute("adjustStepSeqSep")
    freezeExecute("adjustPianoRollSep")
    bringHistoryWins()
    return

;-- Window menus ----------------------------------------------------
TOGGLE_STAMP_STATE:
    freezeExecute("toggleStampState")
    return

PIANOROLL_QUANTIZE:
    freezeExecute("quantize")
    return

PIANOROLL_MAP:
    freezeExecute("pianorollMap")
    return

PIANOROLL_STRUM:
    freezeExecute("pianorollStrum")
    return

PIANOROLL_TWINS:
    freezeExecute("pianorollTwins")
    return   

PIANOROLL_CHOP:
    freezeExecute("pianorollChop")
    return  

PIANOROLL_FLIP:
    freezeExecute("pianorollFlip")
    return  

PIANOROLL_SCALE:
    freezeExecute("pianorollScale")
    return

PIANOROLL_LFO:
    freezeExecute("pianorollLfo")
    return

PIANOROLL_2:
    waitKey("LButton")
    freezeExecute("pianorollActivate2")
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

SPLIT_PATTERN:
    freezeExecute("splitPattern")
    return

; -- Highlight ---------------------------------------------
HIGHLIGHT_TICK:
    highlightTick()
    return


; -- Mouse Midi --------------------------------------------
MOUSE_CTL_TICK:
    mouseCtlTick()
    return

TOGGLE_MOUSE_CTL_INTERPOLATION_MODE:
    Switch mctlIncrMode
    {
    Case "stop":
        mctlIncrMode := "pacman"
        mctlIncrMode := "pacman"
    Case "pacman":
        mctlIncrMode := "pong"
        mctlIncrMode := "pong"
    Case "pong":
        mctlIncrMode := "stop"
        mctlIncrMode := "stop"
    }
    updateGuiMouseCtlIncrMode()
    return

; -- MsgRefresh ------------------------------------------------
MSG_REFRESH_TICK:
    msgRefreshTick()
    return

; -- NumpadG ------------------------------------------------
NUMPAD_G_1:                                 ; c min max
    hideNumpadG()
    freezeExecute("applyMinMaxLinkController")
    return
NUMPAD_G_2:                                 ; c link
    hideNumpadG()
    freezeExecute("linkControllerOnly") 
    return
NUMPAD_G_3:                                 ; Main Events
    hideNumpadG()
    freezeExecute("toggleMainEvents")
    return
NUMPAD_G_4:                                 ; note
    hideNumpadG()
    freezeExecute("loadScore", [2], True, True)
    return

NUMPAD_G_5:                                 ; Autom
    hideNumpadG()
    freezeExecute("Autom")
    return
NUMPAD_G_6:                                 ; step edit
    hideNumpadG()
    freezeExecute("toggleStepEdit") 
    return
NUMPAD_G_7:
    hideNumpadG()
    return
NUMPAD_G_8:
    hideNumpadG()
    return

NUMPAD_G_9:                                 ; LFO
    hideNumpadG()
    freezeExecute("LFO")
    return
NUMPAD_G_10:                                ; Make Unique
    hideNumpadG()
    freezeExecute("makeUnique")
    return
NUMPAD_G_11:                                ; Select similar clips
    hideNumpadG()
    freezeExecute("selectSimilarClips")
    return
NUMPAD_G_12:
    hideNumpadG()
    return

NUMPAD_G_13:                                ; EC
    hideNumpadG()
    msg("env c?")
    freezeExecute("EnvC")
    return
NUMPAD_G_14:                                ; source
    hideNumpadG()
    freezeExecute("selectSourceForAllSelectedClips")
    return
NUMPAD_G_15:                                ; reverse sound
    hideNumpadG()
    freezeExecute("reverseSound")
    return
NUMPAD_G_16:                                ; Layer
    hideNumpadG()
    freezeExecute("Layer")
    return    

NUMPAD_G_17:                                ; Note length
    hideNumpadG()
    freezeExecute("toggleHoveredNoteLenght", [], True, True)       
    return    

NUMPAD_G_18:                                ; Lock channel
    hideNumpadG()
    if (isPianoRoll())
        freezeExecute("pianorollActivate2")
    else if (mouseOverStepSeqInstruments())
        freezeExecute("lockChan")
    else if (isInstr())
        freezeExecute("lockChanFromInstrWin")
    return    

NUMPAD_G_19:                                ;
    return

NUMPAD_G_20:                                ;
    return

; -- OBS Mouse Pos ---------------------------------------------
OBS_CHECK_MOUSE_POS_TICK:
    obsCheckMousePosTick()
    return