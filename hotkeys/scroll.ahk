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
        scrollInstr("pianoRoll")
    else if (isPlaylist())
        scrollInstr("playlist")
    else if (isPlugin())
        scrollInstr("plugin")
    else if (scrollingInstr or isStepSeq()) 
        scrollChannels("up")
    return


+WheelDown::
    if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", False, False, "down")
    else if (isPianoRoll())
        scrollInstr("pianoRoll")
    else if (isPlaylist())
        scrollInstr("playlist")
    else if (isPlugin())
        scrollInstr("plugin")
    else if (scrollingInstr or isStepSeq())
        scrollChannels("down")
    return

~Shift::
    return

Shift Up::
    if (scrollingInstr)
        scrollInstrStop()
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
    else if (!readyToDrag and !mouseOverBrowser())
        freezeExecute("browseRandomGenFolder", False)        
    else if (mouseOverBrowser())
    {
        if (mouseOverBrowserScroll())
            Send {WheelUp}
        else
            freezeExecute("browserRelMove", False, False, "up", 1)
    }
    return

LWin & WheelDown::
    if (whileToolTipChoice)
       decrToolTipChoiceIndex()
    else if (isPlaylist())     
        scrollTab("right", "playlist")
    else if (isPianoRoll())     
        scrollTab("right", "pianoroll")
    else if (isSampleClip())    
        freezeExecute("getReadyToDragFromSampleClip", False)        
    else if (isMasterEdison() or isMasterEdison("", True))
        freezeExecute("getReadyToDragFromMasterEdison", False)        
    else if (!readyToDrag and !mouseOverBrowser())
        freezeExecute("browseRandomGenFolder", False)
    else if (mouseOverBrowser())
    {

        if (mouseOverBrowserScroll())
            Send {WheelDown}
        else
        {
            freezeExecute("browserRelMove", False, False, "down", 1)
        }
    }
    return
#If




#If WinActive("ahk_exe FL64.exe")
LWin::
    if (!readyToDrag)
    {
        if (mouseOverBrowser())
        {
            readyToDrag := True
            startHighlight("browser")
        }
        else if (mouseOverEdisonDrag())
        {
            readyToDrag := True
            startHighlight("edisonDrag")
        }
    }
    return

~LWin Up::
    if (readyToDrag)
    {
        if (mouseOverBrowser() or mouseOverEdisonDrag() or mouseOverSampleClipSound())
            freezeExecute("dragSample", False)
        else
            dontDragSample()
    }
    else if (scrollingTab and (isPlaylist() or isPianoRoll()))
        scrollTabStop()
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
    else if (scrollingInstr or isStepSeq())
        scrollChannels("up")        
    return

^+WheelDown::
    if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())    
        freezeExecute("clonePattern", True, True)
    else if (isInstr())
        freezeExecute("cloneActiveInstr")
    else if (scrollingInstr or isStepSeq())
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