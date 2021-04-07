; -- Numpad1 ----------------------------------------------
#If numpad1Context.IsActive and WinActive("ahk_exe FL64.exe")
::aaa::JACKPOT
NumLock Up::                                ; c min max
    ;msgTip("numlock")
    freezeExecute("applyMinMaxLinkController")
    return

NumpadDiv::                                 ; c link
    freezeExecute("linkControllerOnly") 
    return


NumpadMult::                                ; Main Events
    freezeExecute("toggleMainEvents")
    return

NumpadSub::                                 ; note
    freezeExecute("loadScore", True, True, 1)
    return


Numpad7 Up::                                ; Autom
    freezeExecute("newAutomation")
    return

Numpad8::                                   ; step edit
    freezeExecute("toggleStepEdit") 
    return

Numpad9::                                   ; ns
    CoordMode, Mouse, Screen
    MouseGetPos, oriX, oriY, oriWin
    CoordMode, Mouse, Client
    freezeExecute("createPatcherSampler", False, False, oriX, oriY, oriWin)
    return

^Numpad9::                                  ; ns slicex
    CoordMode, Mouse, Screen
    MouseGetPos, oriX, oriY, oriWin
    CoordMode, Mouse, Client
    freezeExecute("createPatcherSlicex", False, False, oriX, oriY, oriWin)
    return

NumpadAdd::                                 ; s
    CoordMode, Mouse, Screen
    MouseGetPos, oriX, oriY, oriWin
    CoordMode, Mouse, Client
    freezeExecute("dragDropAnyPatcherSampler", False, False, oriX, oriY, oriWin)
    return 

Numpad4 Up::                                ; LFO
    freezeExecute("LFO")
    return

Numpad5::                                   ; Make Unique
    freezeExecute("makeUnique")
    return

Numpad6::                                   ; Select similar clips
    freezeExecute("selectSimilarClips")
    return

BackSpace::                                 ; rand arp
    if (isInstr())
        freezeExecute("randomizeArpParams")
    return

^BackSpace::                                ; rand delay
    if (isInstr())
        freezeExecute("randomizeDelayParams")
    return


Numpad1 Up::                                ; EC
    freezeExecute("EnvC")
    return                                

Numpad2::                                   ; source
    freezeExecute("selectSourceForAllSelectedClips")
    return

Numpad3::                                   ; reverse sound
    freezeExecute("reverseSound")
    return


Numpad0::                                   ; Layer
    freezeExecute("Layer")
    return

NumpadDot Up::                              ; Note length
    freezeExecute("hoveredNoteLength", True, True)       
    return

~NumpadEnter::
    return
    
NumpadEnter Up::                            ; Lock channel
    if (isPianoRoll())
        freezeExecute("pianorollActivate2")
    else if (mouseOverStepSeqInstruments())
        freezeExecute("assign2")
    return
#If
; --


; -- Main Keyboard ----------------------------------------
#If !numpad1Context.IsActive and WinActive("ahk_exe FL64.exe")
NumLock Up::                                    ; edison
    freezeExecute("bringMasterEdison", False)
    return

+NumLock Up::                                   ; audacity 
    freezeExecute("openAudacity", False)
    return

NumpadDiv Up::                                  ; render in place
    freezeExecute("renderInPlace")              
    return

Numpad7::                                       ; mixer
    freezeExecute("bringMixer", False)
    return

Numpad8::                                       ; mixer <---
    freezeExecute("assignMixerTrack", False)
    return

Numpad9::                                       ; event editor
    freezeExecute("bringEventEditor", False, False, True)
    return

^Numpad9::                                      ; knob edit events
    waitForModifierKeys()
    freezeExecute("EditEvents", False, False, True)
    return    

!Numpad9::                                      ; knob place edit events value
    waitForModifierKeys()
    freezeExecute("insertEditEventsValue", True, True)
    return 

Numpad4::                                       ; piano roll
    freezeExecute("bringPianoRoll", False, False, False, True)
    return  

Numpad5::                                       ; playlist
    bringFL()
    freezeExecute("bringPlaylist", False)
    return

Numpad6::                                       ; rec
    if (isEdison())
        freezeExecute("toggleArmEdison")
    else
        midiRequest("toggle_rec")
    return

^Numpad6::                                      ; rec on play
    freezeExecute("recOnPlay")              
    return

!Numpad6::                                      ; Edison rec
    freezeExecute("masterEdisonTransport", True, True, "rec")
    return

Numpad2::                                       ; step seq
    bringFL()
    freezeExecute("bringStepSeq", False)
    return

Numpad1::                                       ; play pause
    midiRequest("toggle_play_pause")
    return

!Numpad1::                                      ; Edison play pause
    freezeExecute("masterEdisonTransport", True, True, "playPause")
    return

Numpad3::                                       ; stop
    midiRequest("stop")
    return

!Numpad3::                                      ; Edison stop
    freezeExecute("masterEdisonTransport", True, True, "stop")
    return

NumpadDot::                                     ; patt song
    freezeExecute("togglePatternSong")
    return
#If
; --