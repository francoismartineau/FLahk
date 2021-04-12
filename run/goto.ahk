; -- clocks ---------------
WINDOW_HISTORY_CLOCK:
    winHistoryTic()
    return

MAIN_CLOCK:
    hideShowFLahk()
    keepNumLockOn()
    return

WINDOW_MENUS_CLOCK:
    windowMenusTic()
    return

SAVE_REMINDER_CLOCK:
    saveReminder()
    return

; -- gen -----------------------
CONCAT_AUDIO:
    if (ConcatAudioShown)
        hideConcatAudio()
    else
        showConcatAudio()
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
OCR_TOGGLE:
    GuiControlGet, checked,, OcrToggleGui
    OcrToggleEnabled := checked
    return

FILE_SAVED_TOGGLE:
    GuiControlGet, checked,, FileSavedToggleGui
    fileSavedToggleEnabled := checked
    if (fileSavedToggleEnabled and savesFilePath == "")
    {
        getCurrentProjSaveFilePath()
        loadWinHistory()
        loadKnobSaves()
    }
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
        freezeExecute("denoise", False)
    }
    return

RESET_AUDIO_DEVICE:
    bringFL()
    freezeExecute("resetSoundDevice")
    return

ASSIGN_TRACK_M1:
    bringFL()
    freezeExecute("assignMixerTrackRoute", True, True, "m1")
    return

ASSIGN_TRACK_M2:
    bringFL()
    freezeExecute("assignMixerTrackRoute", True, True, "m2")
    return

ASSIGN_TRACK_M3:
    bringFL()
    freezeExecute("assignMixerTrackRoute", True, True, "m3")
    return

ASSIGN_TRACK_BASS:
    bringFL()
    freezeExecute("assignMixerTrackRoute", True, True, "bass")
    return

ASSIGN_TRACK_NO_BASS:
    bringFL()
    freezeExecute("assignMixerTrackRoute", True, True, "no bass")
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
    freezeExecute("bpm")
    return

RANDOM_TYPING_KEYBOARD:
    bringFL()
    freezeExecute("randomizeTypingKeyboard")
    return


TOGGLE_LEFT_SCREEN:
    toggleLeftScreenWindows()
    return

WINDOW_SPY:
    run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AutoHotkey\Window Spy.lnk
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

