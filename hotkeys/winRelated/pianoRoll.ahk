#If WinActive("ahk_exe FL64.exe") and PianoRoll.isWin()  
/::
    freezeExecute("hoveredNoteLength", ["long"], True, True)
    return

m::
    freezeExecute("PianoRoll.minMajStamp")
    return

r::
    freezeExecute("PianoRoll.randomizeStamp")
    return

!x::
    freezeExecute("activateParamX")
    return
!y::
    freezeExecute("activateParamY")
    return

!v::
    freezeExecute("activateParamVel")
    return

!XButton1::
    PianoRoll.setSelectedNotesCol()
    return

!XButton2::
    PianoRoll.selNotesOfCurrColor()
    return

LWin & XButton1::
    freezeExecute("PianoRoll.deactivateLoop")
    return
#If


#If WinActive("ahk_exe FL64.exe") and PianoRoll.isWin() and PianoRoll.mouseOnLoopButton()
!LButton::
    freezeExecute("PianoRoll.burnLoopButton")
    return
#If

#If WinActive("ahk_exe FL64.exe") and PianoRoll.mouseOnTimeline() and !PianoRoll.mouseOnMarker()
^LButton::
    waitForModifierKeys()
    freezeExecute("PianoRoll.createEndMarker")
    return
#If

#If WinActive("ahk_exe FL64.exe") and PianoRoll.mouseOnMarker()
!LButton::
    waitForModifierKeys()
    freezeExecute("PianoRoll.burnLoopMarker")
    return

^LButton::
    waitForModifierKeys()
    freezeExecute("PianoRoll.activateLoopMarkerUnderMouse")
    return
#If


