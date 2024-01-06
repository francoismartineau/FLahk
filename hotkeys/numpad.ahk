; -- Main Keyboard ----------------------------------------
#If WinActive("ahk_exe FL64.exe") ; and !numpad1Context.IsActive
Volume_Mute::
    return
Volume_Mute Up::
    msg("disabled. See StepSeq.bringKnownChannels")
    ;freezeExecute("bringM1")
    return
NumLock Up::                                    ; edison
    freezeExecute("bringMasterEdison", [], False)
    return

+NumLock Up::                                   ; audacity 
    freezeExecute("openAudacity", [], False)
    return

!NumLock Up::                                   ; melodyne
    freezeExecute("openMelodyne", [], False)
    return

NumpadDiv Up::                                  ; render in place
    freezeExecute("renderInPlace")              
    return

NumpadMult::                                    ; activate loop (playlist: start)
    if (Playlist.isWin())
        freezeExecute("setPlaylistLoop", ["start"])
    else if (PianoRoll.isWin())
        freezeExecute("PianoRoll.activateLoop")
    return

NumpadSub::                                     ; activate loop (playlist: end)
    if (Playlist.isWin())
        freezeExecute("setPlaylistLoop", ["end"])
    else if (PianoRoll.isWin())
        freezeExecute("PianoRoll.activateLoop")
    return

LWin & NumpadMult::                             ; deactivate loop / playlist tab
LWiN & NumpadSub::
    if (Playlist.isWin())
        freezeExecute("deleteNextPlaylist")
    else if (PianoRoll.isWin())
        freezeExecute("PianoRoll.deactivateLoop", [False])
    return

Numpad7::                                       ; mixer
    freezeExecute("bringMixer", [], False)
    return

Numpad8::                                       ; mixer <---
    freezeExecute("assignMixerTrack", [], False)
    return

Numpad9::                                       ; event editor
    freezeExecute("bringEventEditor", [True], False)
    return

^Numpad9::                                      ; knob edit events
    waitForModifierKeys()
    freezeExecute("Knob.editEvents")
    return    

!Numpad9::                                      ; knob place edit events value
    waitForModifierKeys()
    freezeExecute("insertEditEventsValue", [], True, True)
    return 


Numpad4::                                       ; piano roll
    freezeExecute("PianoRoll.bringWin")
    return  

Numpad5::                                       ; playlist
    bringFL()
    freezeExecute("Playlist.bringWin", [], False)
    return

Numpad6::                                       ; rec
    isEdison := isMasterEdison()
    if (isEdison)
        bringMainFLWindow()
    midiRequest("toggle_rec")
    if (isEdison)    
        bringMasterEdison(False)
    return    

^Numpad6::                                      ; rec on play
    freezeExecute("recOnPlay", [], True, True)              
    return

!Numpad6::                                      ; Edison rec
LWin & Numpad6::
    freezeExecute("masterEdisonTransport", ["rec"], True, True)
    return

^!Numpad6::                                     ; Move to Master Edison drag
    freezeExecute("moveToMasterEdisonDrag", [], False)
    return

Numpad2::                                       ; step seq
    bringFL()
    freezeExecute("StepSeq.bringWin", [], False)
    return

Numpad1::                                       ; play pause
    isEdison := isMasterEdison()
    if (isEdison)
        bringMainFLWindow()
    midiRequest("toggle_play_pause")
    if (isEdison)    
        bringMasterEdison(False)
    return

!Numpad1::                                      ; Edison play pause
LWin & Numpad1::
    freezeExecute("masterEdisonTransport", ["playPause"], True, True)
    return

Numpad3::                                       ; stop
    isEdison := isMasterEdison()
    if (isEdison)
        bringMainFLWindow()
    midiRequest("stop")
    if (isEdison)    
        bringMasterEdison(False)
    return

!Numpad3::                                      ; Edison stop
LWin & Numpad3:: 
    freezeExecute("masterEdisonTransport", ["stop"], True, True)
    return

NumpadDot::                                     ; patt song
    freezeExecute("togglePatternSong")
    return

Numpad0::
    freezeExecute("Knob.openLinkWin")
    return
#If
; --