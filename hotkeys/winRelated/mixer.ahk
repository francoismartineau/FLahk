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
        freezeExecute("loadMixer1_1")
    Case "1_2":
        freezeExecute("loadMixer1_2")

    Case "2_1":
        freezeExecute("loadMixer2_1")
    Case "2_2":
        freezeExecute("loadMixer2_2")

    Case "3_1":
        freezeExecute("loadMixer3_1")
    Case "3_2":
        freezeExecute("loadMixer3_2")

    Case "4_1":
        freezeExecute("loadMixer4_1")
    Case "4_2":
        freezeExecute("loadMixer4_2")

    Case "5_1":
        freezeExecute("loadMixer5_1")
    Case "5_2":
        freezeExecute("loadMixer5_2")

    Case "6_1":
        freezeExecute("loadMixer6_1")
    Case "6_2":
        freezeExecute("loadMixer6_2")

    Case "7_1":
        freezeExecute("loadMixer7_1")
    Case "7_2":
        freezeExecute("loadMixer7_2")

    Case "8_1":
        freezeExecute("loadMixer8_1")
    Case "8_2":
        freezeExecute("loadMixer8_2")

    Case "9_1":
        freezeExecute("loadMixer9_1")
    Case "9_2":
        freezeExecute("loadMixer9_2")

    Case "0_1":
        freezeExecute("loadMixer0_1")
    Case "0_2":
        freezeExecute("loadMixer0_2")

    Default:
        Click
    }
    return
#If
; --


; ---- Mixer --------------------------------
#If WinActive("ahk_exe FL64.exe") and isMixer() and acceptAbortSpecialKey == ""
1:: 
    freezeExecute("loadMixer1_1")
    return
!1:: 
    freezeExecute("loadMixer1_2")
    return    

2:: 
    freezeExecute("loadMixer2_1")
    return
!2:: 
    freezeExecute("loadMixer2_2")
    return    

3::
    freezeExecute("loadMixer3_1")
    return
!3::
    freezeExecute("loadMixer3_2")
    return    

4::
    freezeExecute("loadMixer4_1")
    return    
!4::
    freezeExecute("loadMixer4_2")
    return        

5::
    freezeExecute("loadMixer5_1")
    return
!5::
    freezeExecute("loadMixer5_2")
    return    

6::
    freezeExecute("loadMixer6_1")
    return
!6::
    freezeExecute("loadMixer6_2")
    return    

7::
    freezeExecute("loadMixer7_1")
    return
!7::
    freezeExecute("loadMixer7_2")
    return    

8::
    freezeExecute("loadMixer8_1")
    return
!8::
    freezeExecute("loadMixer8_2")
    return    

9::
    freezeExecute("loadMixer9_1")
    return
!9::
    freezeExecute("loadMixer9_2")
    return    

0::
    freezeExecute("loadMixer0_1")
    return
!0::
    freezeExecute("loadMixer0_2")
    return    

+1:: 
    freezeExecute("mouseOnM123", ["m1"])
    return
+2:: 
    freezeExecute("mouseOnM123", ["m2"])
    return
+3:: 
    freezeExecute("mouseOnM123", ["m3"])
    return
#If
; -------