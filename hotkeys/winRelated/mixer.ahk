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
    Case "2_1":
        freezeExecute("loadLfo")
    Case "3_1":
        freezeExecute("loadEq")
    Case "4_1":
        freezeExecute("loadStereos")
    Case "5_1":
        freezeExecute("loadGate")
    Case "6_1":
        freezeExecute("loadSpeaker")
    Case "7_1":
        freezeExecute("loadFilter")
    Case "8_1":
        freezeExecute("loadChorus")
    Case "9_1":
        freezeExecute("loadConv")
    Case "0_1":
        freezeExecute("loadScratch")
    Case "F5_1":
        freezeExecute("loadComp")
    Case "F6_1":
        freezeExecute("loadNewTone")        
    Case "1_2":
        freezeExecute("loadModulation")
    Case "2_2":
        freezeExecute("loadDelay")
    Case "3_2":
        freezeExecute("loadEquo")
    Case "4_2":
        freezeExecute("loadDist")
    Case "5_2":
        freezeExecute("loadAutoPan")
    Case "6_2":
        freezeExecute("loadRingMod")
    Case "7_2":
        freezeExecute("loadVibratos")
    Case "8_2":
        freezeExecute("loadPhaser")
    Case "9_2":
        freezeExecute("loadTransient")
    Case "0_2":
        freezeExecute("loadBass")
    Case "F5_2":
        freezeExecute("loadGross")
    Case "F6_2":
        freezeExecute("loadNewTime")         
    Default:
        Click
    }
    return
#If
; --