#If WinActive("ahk_exe FL64.exe") and isPianoRoll()  
m::
    freezeExecute("minMajStamp")
    return

r::
    freezeExecute("randomizeStamp")
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


