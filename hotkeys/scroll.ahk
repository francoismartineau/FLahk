#If WinActive("ahk_exe FL64.exe")
; -----------
WheelUp::
    if (whileToolTipChoice)
       incrToolTipChoiceIndex()
    else if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        scrollPatternUp()
    else if (isPianorollLen() and mouseOverPianorollLenOptions())
        Send {LButton}{WheelUp}
    else if (!isMixer("", True) or mouseOverInstrMixerInsert() or mouseOverStepSeqMixerInserts())
        Send {WheelUp}
    return

WheelDown::
    if (whileToolTipChoice)
       decrToolTipChoiceIndex()
    else if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        scrollPatternDown()
    else if (isPianorollLen() and mouseOverPianorollLenOptions())
        Send {LButton}{WheelDown}     
    else if (!isMixer("", True) or mouseOverInstrMixerInsert() or mouseOverStepSeqMixerInserts())
        Send {WheelDown}
    return


; --    +    --------------------------------------
+WheelUp::
    if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", False, False, "up")
    else if (isPianoRoll())
        eventEditorScrollInstr("pianoRoll")
    else if (isPlaylist())
        eventEditorScrollInstr("playlist")
    else if (eventEditorScrollingInstr or isStepSeq()) 
        scrollChannels("up")
    return


+WheelDown::
    if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", False, False, "down")
    else if (isPianoRoll())
        eventEditorScrollInstr("pianoRoll")
    else if (isPlaylist())
        eventEditorScrollInstr("playlist")
    else if (eventEditorScrollingInstr or isStepSeq())
        scrollChannels("down")
    return

~Shift::
    return

Shift Up::
    if (eventEditorScrollingInstr)
        eventEditorScrollInstrStop()
    return
; --------



; --    !    --------------------------------------
!WheelUp::
    if (isStepSeq() or (isPlugin() and !isMasterEdison()))
        moveWinUp()
    else if (isMixer())
        Send {Left}  
    return

!WheelDown::
    if (isStepSeq() or (isPlugin() and !isMasterEdison()))
        moveWinDown()
    else if (isMixer())
        Send {Right}        
    return
; --------



; --    Win    --------------------------------------
LWin & WheelUp::
    if (whileToolTipChoice)
       incrToolTipChoiceIndex()
    else if (isPlaylist())     
        scrollTab("left", "playlist")
    else if (isPianoRoll())     
        scrollTab("left", "pianoroll")
    else if (isMasterEdison())
        Sleep, 1
    else if (!browsingFiles and !mouseOverBrowser())
        freezeExecute("browseRandomGenFolder", False)        
    else
    {
        if (GetKeyState("Shift"))
            incr := 8
        else
            incr := 1        
        freezeExecute("browserMoveFromCurrentMousePos", False, False, "up", incr)
    }
    return

LWin & WheelDown::
    if (whileToolTipChoice)
       decrToolTipChoiceIndex()
    else if (isPlaylist())     
        scrollTab("right", "playlist")
    else if (isPianoRoll())     
        scrollTab("right", "pianoroll")
    else if (isMasterEdison())
        freezeExecute("dragSampleFromMasterEdison", False)        
    else if (!browsingFiles and !mouseOverBrowser())
        freezeExecute("browseRandomGenFolder", False)
    else
    {
        if (GetKeyState("Shift"))
            incr := 8
        else
            incr := 1
        freezeExecute("browserMoveFromCurrentMousePos", False, False, "down", incr)

    }
    return
#If

#If scrollingTab and !browsingFiles and (isPlaylist() or isPianoRoll())
~LWin::
    return

~LWin Up::
    scrollTabStop()
    return 
#If    

#If WinActive("ahk_exe FL64.exe") and browsingFiles
~LWin Up::
    if (mouseOverBrowser() or isMasterEdison())
        freezeExecute("dragSample", False)
    else
        stopDragSample()
    return 
#If  

#If !freezeExecuting and WinActive("ahk_exe FL64.exe") and !browsingFiles and (mouseOverBrowser() or mouseOverEdisonDrag())
LWin Up::
    freezeExecute("dragSample", False)
    return
#If  
; --------




#If WinActive("ahk_exe FL64.exe")
; --    ^    --------------------------------------
^WheelUp::
    if (isMasterEdison())
        freezeExecute("setMasterEdisonOnPlay")
    return
^WheelDown::
    if (isMasterEdison())
        freezeExecute("setMasterEdisonOnInput")    
    return
; --------

; --     ^+     ---------------------------------
^+WheelUp::
    if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        freezeExecute("insertPattern")
    else if (eventEditorScrollingInstr or isStepSeq())
        scrollChannels("up")        
    return

^+WheelDown::
    if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())    
        freezeExecute("clonePattern", True, True)
    else if (isInstr())
        freezeExecute("cloneActiveInstr")
    else if (eventEditorScrollingInstr or isStepSeq())
        scrollChannels("down")
    else if (mouseOverMixerDuplicateTrackRegion())
        freezeUnfreezeMouse("cloneMixerTrackState")
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