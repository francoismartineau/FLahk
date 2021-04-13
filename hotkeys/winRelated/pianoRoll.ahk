#If WinActive("ahk_exe FL64.exe") and isPianoRoll()  
/::
    freezeExecute("hoveredNoteLength", True, True, "long")
    return

m::
    freezeExecute("minMajStamp")
    return

r::
    freezeExecute("randomizeStamp")
    return

LWin & XButton1::
    freezeExecute("activatePianoRollLoop", True, False, False)
    return
#If


; -- Mouse ----------------------------------------------------
#If WinActive("ahk_exe FL64.exe") and isPianoRoll() and mouseOnLoopButton()
LButton::
    freezeExecute("activatePianoRollLoop", False, False, True)
    return

RButton::
    freezeExecute("activatePianoRollLoop", False, False, False)
    return

!LButton::
    freezeExecute("burnLoopButton")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPianoRoll() and mouseOnPianoRollTimeline() and mouseOnPianoRollMarker()
!LButton::
    freezeExecute("burnLoopMarker")
    return
#If


