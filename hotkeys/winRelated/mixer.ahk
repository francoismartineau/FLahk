; -- External Mixer Slots References------------------------------
#If WinActive("ahk_exe FL64.exe") and doubleClicked() and (mouseOverStepSeqMixerInserts() or mouseOverInstrMixerInsert())
~LButton::
    freezeExecute("openMixerInsert")
    return
#If

#If WinActive("ahk_exe FL64.exe") and (mouseOverStepSeqMixerInserts() or mouseOverInstrMixerInsert())
+LButton::
    freezeExecute("openMixerInsert")
    return
#If
;-- 

; -- Open Slot LMButton ------------------------------------------
#If WinActive("ahk_exe FL64.exe") and acceptPressed and mouseOverMixerSlotSection()
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
#If WinActive("ahk_exe FL64.exe") and mouseOnMixerButUnderMenu()
LButton::           ;;;; be able to click on hidden mixer menu without loading an effect
    freezeExecute("bringMixer")
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
        freezeExecute("loadFxFromChoice", False, False, "patcher4")

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

    Case "0_1":
        freezeExecute("loadFxFromChoice", False, False, "edit")

    ;Case "0_2":

    ;Case "F5_1":
    ;Case "F5_2":

    ;Case "F6_1":
    ;Case "F6_2":

    ;Case "F7_1":
    ;Case "F7_2":
    Default:
        Click
    }
    return
#If
; --


; ---- Mixer --------------------------------
#If WinActive("ahk_exe FL64.exe") and isMixer() and acceptAbortSpecialKey == ""
1:: 
    freezeExecute("loadRev")
    return
!1:: 
    freezeExecute("loadDelay")
    return    

2:: 
    freezeExecute("loadFxFromChoice", False, False, "mod")
    return
!2:: 
    freezeExecute("loadLfo")
    return    

3::
    freezeExecute("loadFxFromChoice", False, False, "filter")
    return
!3::
    freezeExecute("loadStereos")
    return    

4::
    freezeExecute("loadFxFromChoice", False, False, "pitch")
    return    
!4::
    freezeExecute("loadDist")
    return        

5::
    freezeExecute("loadFxFromChoice", False, False, "dyn")
    return
!5::
    freezeExecute("loadAutoPan")
    return    

6::
    return
!6::
    freezeExecute("loadSpeaker")
    return    

7::
    return
!7::
    freezeExecute("loadConv")
    return    

8::
    return
!8::
    freezeExecute("loadScratch")
    return    

9::
    return
!9::
    freezeExecute("load3xGross")
    return    

0::
    return
!0::
    return    

F5::
    return
!F5::
    return   

F6::
    return
!F6::
    return    

F7::
    freezeExecute("loadFxFromChoice", False, False, "edit")
    return    
!F7::
    return    


+1:: 
    freezeExecute("mouseOnM123", True, False, "m1")
    return
+2:: 
    freezeExecute("mouseOnM123", True, False, "m2")
    return
+3:: 
    freezeExecute("mouseOnM123", True, False, "m3")
    return
#If
; -------