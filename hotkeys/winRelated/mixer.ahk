; -- External Mixer Slots References------------------------------
#If WinActive("ahk_exe FL64.exe") and doubleClicked() and (mouseOverStepSeqMixerInserts() or mouseOverInstrMixerInsert())
~LButton::
    freezeExecute("openMixerInsert")
    return
#If
;-- 

; -- Open Slot LMButton ------------------------------------------
#If WinActive("ahk_exe FL64.exe") and acceptPressed and mouseOverMixerSlotSection()
MButton::
    freezeExecute("mixerOpenSlot")
    return

LButton::
    freezeExecute("mixerOpenSlot")
    return
#If
; --



#If WinActive("ahk_exe FL64.exe") and mouseOverMixerSlotSection()
RButton::
    bringMixer()
    return
#If




; -- Mixer Menu Clicks ------------------------------------------
#If WinActive("ahk_exe FL64.exe") and isMixer("", True)
LButton::           ;;;; be able to click on hidden mixer menu without loading effect
    return
#If

#If WinActive("ahk_exe FL64.exe") and mouseOnMixerMenu() and isMixer()
LButton Up::
    pos := mouseOnMixerMenuSection()
    waitKey("LButton")
    Switch pos
    {
    Case "1_1":
        freezeExecute("loadRev")
    Case "1_2":
        freezeExecute("loadDelay")

    Case "2_1":
        freezeExecute("loadFxFromChoice", False, False, "mod")
    Case "2_2":
        freezeExecute("loadLfo")

    Case "3_1":
        freezeExecute("loadFxFromChoice", False, False, "filter")
    Case "3_2":
        freezeExecute("loadStereos")

    Case "4_1":
        freezeExecute("loadFxFromChoice", False, False, "pitch")
   Case "4_2":
        freezeExecute("loadDist")

    Case "5_1":
        freezeExecute("loadFxFromChoice", False, False, "dyn")
    Case "5_2":
        freezeExecute("loadAutoPan")

    ;Case "6_1":
    Case "6_2":
        freezeExecute("loadSpeaker")

    ;Case "7_1":
    Case "7_2":
        freezeExecute("loadConv")

    ;Case "8_1":
    Case "8_2":
        freezeExecute("loadScratch")

    ;Case "9_1":
    Case "9_2":
        freezeExecute("load3xGross")

    ;Case "0_1":
    ;Case "0_2":

    ;Case "F5_1":
    ;Case "F5_2":

    ;Case "F6_1":
    ;Case "F6_2":

    Case "F7_1":
        freezeExecute("loadFxFromChoice", False, False, "edit")
    ;Case "F7_2":
    Default:
        Click
    }
    return
#If
; --