
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
#If WinActive("ahk_exe FL64.exe") and PianoRoll.isWin()
1::
    freezeExecute("PianoRoll.randNotes")
    return

+1::
    freezeExecute("PianoRoll.genNotes")
    return

!1::
    freezeExecute("PianoRoll.arp")
    return


2::
    freezeExecute("PianoRoll.notesLen")
    return

!2::
    freezeExecute("PianoRoll.disableLenghts")
    return

3::
    freezeExecute("PianoRoll.toogleNoteSlide")
    return

+3::
    return
+3 Up::
    freezeExecute("createBlankNote")
    return

!3::
    freezeExecute("PianoRoll.dismissPitches")
    return

4::
    freezeExecute("PianoRoll.addSpace")
    return

+4::
    freezeExecute("PianoRoll.cropTimeSel")
    return

!4::
    PianoRoll.delTimeSel()
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
