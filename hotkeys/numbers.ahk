
; ---- Patcher 4 --------------------------------------------
#If WinActive("ahk_exe FL64.exe") and isPatcher4()
1::
    freezeExecute("patcher4ChangeFx")
    return

2::
    freezeExecute("patcher4ChangeFx")
    return

3::
    freezeExecute("patcher4ChangeFx")
    return

4::
    freezeExecute("patcher4ChangeFx")
    return
#If
; ----

; ---- Event Editor -----------------------------------------
#If WinActive("ahk_exe FL64.exe") and isEventEditor()
1::
    freezeExecute("activateEventEditorLFO")
    return

2::
    freezeExecute("activateEventEditorScale")
    return
    
3::
    freezeExecute("insertCurrentControllerValue")
    return    

4::
    freezeExecute("turnEventsIntoAutomation")
    return       
#If
; ----


; ---- Knob Save --------------------------------
#If WinActive("ahk_exe FL64.exe") and isPlugin() and !isFormulaCtl()
1 Up::
    freezeExecute("saveLoadKnob", ["load", 1], False)
    return

2 Up::
    freezeExecute("saveLoadKnob", ["load", 2], False)   
    return

3 Up::
    freezeExecute("saveLoadKnob", ["load", 3], False)
    return

4 Up::
    freezeExecute("saveLoadKnob", ["load", 4], False)   
    return

5 Up::
    freezeExecute("saveLoadKnob", ["load", 5], False)   
    return 

!1 Up::
    freezeExecute("saveLoadKnob", ["save", 1], False)
    return

!2 Up::
    freezeExecute("saveLoadKnob", ["save", 2], False)   
    return

!3 Up::
    freezeExecute("saveLoadKnob", ["save", 3], False)
    return

!4 Up::
    freezeExecute("saveLoadKnob", ["save", 4], False)   
    return

!5 Up::
    freezeExecute("saveLoadKnob", ["save", 5], False)   
    return    
#If
; -------

; ---- Piano roll --------------------------------
#If WinActive("ahk_exe FL64.exe") and isPianoRoll()
1::
    freezeExecute("pianorollRand")
    return

+1::
    freezeExecute("pianorollGen")
    return

!1::
    freezeExecute("pianorollArp")
    return


2::
    freezeExecute("pianorollLen")
    return

!2::
    freezeExecute("pianorollDisableLenghts")
    return

3::
    freezeExecute("toogleNoteSlide")
    return

+3::
    return
+3 Up::
    freezeExecute("createBlankNote")
    return

!3::
    freezeExecute("pianoRollDismissPitches")
    return

4::
    freezeExecute("pianoRollAddSpace")
    return

+4::
    freezeExecute("pianoRollCropTimeSel")
    return

!4::
    pianoRollDelTimeSel()
    return
#If
; -------


; ---- Piano roll windows ------------------------
#If WinActive("ahk_exe FL64.exe") and isPianorollRand()
1::
    freezeExecute("changeSeed")
    return
#If
; -------
