#If WinActive("ahk_exe FL64.exe")
; -----------
WheelUp::
    if (whileToolTipChoice)
       incrToolTipChoiceIndex()
    else if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        scrollPatternUp()
    else if (isPianorollLen() and mouseOverPianorollLenOptions())
        Send {LButton}{WheelUp}
    else if (!isMixer())
        Send {WheelUp}
    return

WheelDown::
    if (whileToolTipChoice)
       decrToolTipChoiceIndex()
    else if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        scrollPatternDown()
    else if (isPianorollLen() and mouseOverPianorollLenOptions())
        Send {LButton}{WheelDown}     
    else if (!isMixer())
        Send {WheelDown}
    return


; --    +    --------------------------------------
+WheelUp::
    if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", False, False, "up")
    else if (isPianoRoll())
        pianoRollScrollInstr()
    else if (pianoRollScrollingInstr or isStepSeq())
        scrollChannels("up")
    else if (mouseOverBrowser())
        freezeExecute("browserMove", False, False, "up", 1)
    return


+WheelDown::
    if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", False, False, "down")
    else if (isPianoRoll())
        pianoRollScrollInstr()
    else if (pianoRollScrollingInstr or isStepSeq())
        scrollChannels("down")
    else if (mouseOverBrowser())
        freezeExecute("browserMove", False, False, "down", 1)
    return

~Shift::
    return

Shift Up::
    if (pianoRollScrollingInstr)
        pianoRollScrollInstrStop()
    return
; --------



; --    !    --------------------------------------
!WheelUp::
    if (isStepSeq() or (isPlugin() and !isMasterEdison()))
        moveWinUp()
    else if (isPianoRoll())
        freezeExecute("activatePianoRollLoop", False, False, True)
    else if (isMixer())
        Send {Left}  
    else if (isPlaylist())      
        scrollPlaylistTab("left")
    return
!WheelDown::
    if (isStepSeq() or (isPlugin() and !isMasterEdison()))
        moveWinDown()
    else if (isPianoRoll())
        freezeExecute("activatePianoRollLoop", True, False, False)
    else if (isMixer())
        Send {Right}        
    else if (isPlaylist())      
        scrollPlaylistTab("right")
    return

#If scrollingPlaylistTab and isPlaylist()
~Alt::
    return
Alt Up::
    scrollPlaylistTabStop()
    return
#If
; --------

; --    ^    --------------------------------------
^WheelUp::
    return
^WheelDown::
    return
; --------

; --     ^+     ---------------------------------
^+WheelDown::
    if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())    
        freezeExecute("clonePattern", True, True)
    else if (isInstr())
        freezeExecute("cloneActiveInstr")
    else if (mouseOverStepSeqInstrOrScore())
        freezeExecute("cloneChannelUnderMouse")
    else if (mouseOverMixerDuplicateTrackRegion())
        freezeUnfreezeMouse("cloneMixerTrackState")
    return

^+WheelUp::
    if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        freezeExecute("insertPattern")
    return
; --------

; --    ^!      ----------------------------------
^!WheelUp::
    if (isStepSeq() or isPianoRoll() or isPlaylist())
        scrollMouseHorizontal()
    else if (isMixer())
        scrollMixerMenu("left")
    else if (isInstr() and instrWrenchActivated())
        scrollWrenchPanel()
    else if (isMasterEdison())  
        scrollMasterEdison("up")
    else if (isPianorollLen())
        scrollPianorollLen()
    else if (isPianorollRand())
        scrollPianorollRand()
    else if (isPianorollGen())
    {
        moveMouseOnToggle()
        Send {WheelUp}    
    }
    return

^!WheelDown::
    if (isStepSeq() or isPianoRoll() or isPlaylist())
        scrollMouseHorizontal()
    else if (isMixer())
        scrollMixerMenu("right")
    else if (isInstr() and instrWrenchActivated())
        scrollWrenchPanel()
    else if (isMasterEdison())
        scrollMasterEdison("down")
    else if (isPianorollLen())
        scrollPianorollLen()
    else if (isPianorollRand())
        scrollPianorollRand()        
    else if (isPianorollGen())
    {
        moveMouseOnToggle()
        Send {WheelUp}    
    }
    return
; --------



; --    ^+!      -----------------------
^+!WheelUp::
    if (isMixer())
        freezeExecute("bigScrollMixer", True, False, "left")
    return

^+!WheelDown::
    if (isMixer())
        freezeExecute("bigScrollMixer", True, False, "right")
    return
; --------




; --    +!      -----------------------
+!WheelUp::
    if (isMixer())
        freezeExecute("bigScrollMixer", True, False, "left")
    else if (isStepSeq())
        freezeExecute("changeInstrGroup", True, False, "left")
    else if (isPlugin() and !isMasterEdison())
        moveWinRightScreen()
    else if (mouseOverBrowser())
        freezeExecute("browserMove", False, False, "up", 8)
    return

+!WheelDown::
    if (isMixer())
        freezeExecute("bigScrollMixer", True, False, "right")
    else if (isStepSeq())
        freezeExecute("changeInstrGroup", True, False, "right")
    else if (isPlugin() and !isMasterEdison())
        moveWinLeftScreen()
    else if (mouseOverBrowser())
        freezeExecute("browserMove", False, False, "down", 8)
    return
; --------
#If


; --    RButton      -----------------------
#If WinActive("ahk_exe FL64.exe") and isStepSeq()
~RButton & WheelUp::
    msgTip("RButton & WheelDown")
    if (isStepSeq())
        freezeExecute("changeInstrGroup", True, False, "left")
    return     


RButton & WheelDown::
    if (isStepSeq())
        freezeExecute("activatePianoRollLoop", True, False, "True")
    return
#If     
; --------


/*
; -- Playlist Scrolling and Zooming ----------------------------------------

#If WinActive("ahk_exe FL64.exe") and mouseOverPlaylist() and mouseOverPlaylistSong()
WheelDown::
    if (GetKeyState("Shift"))
    {

    }
    return

+WheelDown::
    Send {AltDown}{WheelDown}{AltUp}
    return

+WheelUp::
    Send {AltDown}{WheelUp}{AltUp}
    return
#If
*/