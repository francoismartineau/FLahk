
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
    freezeExecute("saveLoadKnob", False, False, "load", 1)
    return

2 Up::
    freezeExecute("saveLoadKnob", False, False, "load", 2)   
    return

3 Up::
    freezeExecute("saveLoadKnob", False, False, "load", 3)
    return

4 Up::
    freezeExecute("saveLoadKnob", False, False, "load", 4)   
    return

5 Up::
    freezeExecute("saveLoadKnob", False, False, "load", 5)   
    return 

!1 Up::
    freezeExecute("saveLoadKnob", False, False, "save", 1)
    return

!2 Up::
    freezeExecute("saveLoadKnob", False, False, "save", 2)   
    return

!3 Up::
    freezeExecute("saveLoadKnob", False, False, "save", 3)
    return

!4 Up::
    freezeExecute("saveLoadKnob", False, False, "save", 4)   
    return

!5 Up::
    freezeExecute("saveLoadKnob", False, False, "save", 5)   
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

/*
#If WinActive("ahk_exe FL64.exe")
~e::
    return

~i::
    return

e & 1::
    winId := freezeExecute("loadFx", True, False, 3)            ; EQUO
    freezeExecute("centerMouse", False, False, winId)
    return

e & 2::
    winId := freezeExecute("loadFx", True, False, 1, 3)         ; Patcher vibrato
    freezeExecute("centerMouse", False, False, winId)
    return

i & 1::
    winId := freezeExecute("loadInstr", True, False, 5)         ; Slicex
    freezeExecute("centerMouse", False, False, winId)
    return

i & 2::
    winId := freezeExecute("loadInstr", True, False, 1)         ; Patcher instr empty
    freezeExecute("centerMouse", False, False, winId)
    return

i & 3::
    winId := freezeExecute("load3xosc")         ; 3xosc
    return 

i & 4::
    winId := freezeExecute("loadInstr", True, False, 2)         ; EnvC
    freezeExecute("centerMouse", False, False, winId)
    return    

i & 5::
    winId := freezeExecute("loadInstr", True, False, 7)         ; Flex
    freezeExecute("randomizePlugin", False, False, winId)
    freezeExecute("centerMouse", False, False, winId)
    return     

i & 6::
    winId := freezeExecute("loadInstr", True, False, 4)         ; Harmless
    freezeExecute("randomizePlugin", False, False, winId)
    freezeExecute("centerMouse", False, False, winId)
    return   

#If
*/
