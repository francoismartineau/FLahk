#If WinActive("ahk_exe FL64.exe") or isAhkGui()
; -----------
WheelUp::
    if (numpadGShown)
        numpadGScroll("next")
    else if (whileToolTipChoice)
       incrToolTipChoiceIndex()
    else if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        scrollPatternUp()
    else if (isPianorollLen() and mouseOverPianorollLenOptions())
        Send {LButton}{WheelUp}
    else if (!isMixer("", True) or mouseOverInstrMixerInsert() or mouseOverStepSeqMixerInserts())
        Send {WheelUp}
    return

WheelDown::
    if (numpadGShown)
        numpadGScroll("prev")
    else if (whileToolTipChoice)
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
    if (numpadGShown)
        numpadGScroll("up")
    else if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", ["up"], False)
    else if (isPianoRoll())
        scrollInstr("pianoRoll")
    else if (isPlaylist())
        scrollInstr("playlist")
    else if (isPlugin())
        scrollInstr("plugin")
    else if (isStepSeq() and !scrollingInstr)
        scrollInstr("stepSeq")        
    else if (scrollingInstr or isStepSeq()) 
        scrollChannels("up")
    else if (makingUnique)
        Send {WheelUp}
    return


+WheelDown::
    if (numpadGShown)
        numpadGScroll("down")
    else if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", ["down"], False)
    else if (isPianoRoll())
        scrollInstr("pianoRoll")
    else if (isPlaylist())
        scrollInstr("playlist")
    else if (isPlugin())
        scrollInstr("plugin")
    else if (isStepSeq() and !scrollingInstr)
        scrollInstr("stepSeq")         
    else if (scrollingInstr or isStepSeq())
        scrollChannels("down")
    else if (makingUnique)
        Send {WheelDown}        
    return

~Shift::
    return

#If

#If (WinActive("ahk_exe FL64.exe") or isAhkGui()) and numpadGShown
RButton::
Esc::
    freezeExecute("hideNumpadG")
    return
#If 

#If WinActive("ahk_exe FL64.exe") or isAhkGui()
Shift Up::
    if (scrollingInstr and !keyIsDown("Ctrl")) 
        scrollInstrStop("instr")
    return
; --------



; --    !    --------------------------------------
!WheelUp::
    if (PreGenBrowser.running)
        PreGenBrowser.browse()
    else if (ConcatAudioShown)  
        freezeExecute("PreGenBrowser.start", [], False) 
    else if (isMasterEdison())
        freezeExecute("setMasterEdisonMode", ["onPlay"])
    else if (isStepSeq() or (isPlugin())) ; and !isMasterEdison()))
        moveWinUp()
    else if (isMixer())
        Send {Left}  
    else if (isPianoRoll())
        freezeExecute("pianoRollScrollColors", ["up"])
    return

!WheelDown::
    if (PreGenBrowser.running)
        moveMouseToConcatAudio() 
    else if (isMasterEdison())
        freezeExecute("setMasterEdisonMode", ["input"])
    else if (isStepSeq() or (isPlugin())) ; and !isMasterEdison()))
        moveWinDown()
    else if (isMixer())
        Send {Right}        
    else if (isPianoRoll())
        freezeExecute("pianoRollScrollColors", ["down"], False)
    return

#If
#If pianoRollScrollingColors
~LAlt Up::
    pianoRollStopScrollingColors()
    return
#If
#If WinActive("ahk_exe FL64.exe") or isAhkGui()
; --------



; --    #    --------------------------------------
#If (WinActive("ahk_exe FL64.exe") or isAhkGui())
LWin & WheelUp::
    if (whileToolTipChoice)
       incrToolTipChoiceIndex()           
    else if (isPlaylist())     
        scrollTab("left", "playlist")
    else if (isPianoRoll())     
        scrollTab("left", "pianoroll")
    else if (isMasterEdison())
        msg("not implemented")
    else if (!ConcatAudioShown)
        showConcatAudio()     
    else if (mouseOverBrowser())
    {
        if (mouseOverBrowserScroll())
            Send {WheelUp}
        else
            freezeExecute("browserRelMove", ["up", 1], False)
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
        freezeExecute("getReadyToDragFromSampleClip", [], False)        
    else if (isMasterEdison() or isMasterEdison("", True))
        freezeExecute("getReadyToDragFromMasterEdison", [], False)        
    else if (!readyToDrag and !mouseOverBrowser())
        freezeExecute("browsePostGen", [], False)
    else if (mouseOverBrowser())
    {
        if (mouseOverBrowserScroll())
            Send {WheelDown}
        else
        {
            freezeExecute("browserRelMove", ["down", 1], False)
        }
    }

    return
#If



#If WinActive("ahk_exe FL64.exe") or isAhkGui()
LWin::
    if (!readyToDrag and !PreGenBrowser.running)
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

LWin Up::
    if (readyToDrag)
        if (mouseOverEdisonDrag() or mouseOverSampleClipSound())
            freezeExecute("dragSample", [], False)
        else if (mouseOverBrowser() and !mouseOverFolder())
            freezeExecute("dragSample", [], False)
        else
            dontDragSample()
    else if (PreGenBrowser.running and mouseOverBrowser())
        if (mouseOverFolder())
            freezeExecute("PreGenBrowser.addFolder", [], True, True)        
        else
            freezeExecute("PreGenBrowser.addSound", [], True, True)        
    else if (scrollingTab and (isPlaylist() or isPianoRoll()))
        scrollTabStop()
    return
#If
; --------




#If WinActive("ahk_exe FL64.exe")
; --    ^    --------------------------------------
^WheelUp::
    if (isMasterEdison())
        freezeExecute("armEdison")
    else if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", ["up"], False)        
    else if (isPianoRoll())
        scrollInstr("pianoRoll")
    else if (isPlaylist())
        scrollInstr("playlist")
    else if (isPlugin())
        scrollInstr("plugin")      
    else if (isStepSeq() and !scrollingInstr)
        scrollInstr("stepSeq")         
    else if (scrollingInstr or isStepSeq()) 
        scrollChannels("up")          
    return

^WheelDown::
    if (isMasterEdison())
        freezeExecute("unarmEdison")    
    else if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", ["down"], False)        
    else if (isPianoRoll())
        scrollInstr("pianoRoll")
    else if (isPlaylist())
        scrollInstr("playlist")
    else if (isPlugin())
        scrollInstr("plugin")    
    else if (isStepSeq() and !scrollingInstr)
        scrollInstr("stepSeq")           
    else if (scrollingInstr or isStepSeq()) 
        scrollChannels("down")          
    return

~Ctrl::
    return

Ctrl Up::
    if (scrollingInstr and !keyIsDown("Shift")) 
        scrollInstrStop("pianoRoll")
    return
; --------

; --     +^     ---------------------------------
+^WheelUp::
    if (scrollingInstr or mouseOverStepSeqInstruments())
        scrollChannels("up")        
    ;else if (mouseOverStepSeqInstruments())        ; move instr doesnt work probably because of modifier keys conflict
    ;{
    ;    Send {Ctrl Up}
    ;    Send {WheelUp}
    ;    Send {Ctrl Down}
    ;}   
    else if (whileToolTipChoice)
       incrToolTipChoiceIndex()
    else if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        freezeExecute("insertPattern")
    else
        freezeExecute("moveToPatternRow")
    return

+^WheelDown::
    if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())    
        freezeExecute("clonePattern", [], True, True)
    else if (whileToolTipChoice)
       decrToolTipChoiceIndex()
    else if (isInstr())
        freezeExecute("cloneActiveInstr")
    else if (scrollingInstr or mouseOverStepSeqInstruments()) 
        scrollChannels("down")
    ;else if (mouseOverStepSeqInstruments())        ; move instr doesnt work probably because of modifier keys conflict
    ;    SendInput +^{WheelDown}
    else if (isMixer("", True)) mouseOverMixerDuplicateTrackRegion()
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
        Send {WheelDown}    
    }
    return
; --------



; --    +^!      -----------------------
+^!WheelUp::
    ;if (isMixer())
    ;    freezeExecute("bigScrollMixer", True, False, "left")
    return

+^!WheelDown::
    showNumpadG()
    ;if (isMixer())
    ;    freezeExecute("bigScrollMixer", True, False, "right")
    return
; --------




; --    +!      -----------------------
+!WheelUp::
    if (numpadGShown)
        numpadGScroll("left")
    else if (isMixer())
        freezeExecute("bigScrollMixer", ["left"])
    else if (isStepSeq())
        freezeExecute("changeInstrGroup", ["left"])
    else if (isPlugin() and !isMasterEdison())
        moveWinRightScreen()
    else if (mouseOverBrowser())
        freezeExecute("browserMove", ["up", 8], False)
    return

+!WheelDown::
    if (numpadGShown)
        numpadGScroll("right")
    else if (isMixer())
        freezeExecute("bigScrollMixer", ["right"])
    else if (isStepSeq())
        freezeExecute("changeInstrGroup", ["right"])
    else if (isPlugin() and !isMasterEdison())
        moveWinLeftScreen()
    else if (mouseOverBrowser())
        freezeExecute("browserMove", ["down", 8], False)
    return
; --------
#If


; --    RButton      -----------------------
#If WinActive("ahk_exe FL64.exe") and isStepSeq()
~RButton & WheelUp::
    msgTip("RButton & WheelDown")
    if (isStepSeq())
        freezeExecute("changeInstrGroup", ["left"])
    return     


RButton & WheelDown::
    if (isStepSeq())
        freezeExecute("activatePianoRollLoop", ["True"])
    return
#If     

#If WinActive("ahk_exe FL64.exe") and numpadGShown
+!XButton1 Up::
+XButton1 Up::
    numpadGScroll("left")
    return

+!XButton2 Up::
+XButton2 Up::
    numpadGScroll("right")
    return
#If

; --------

; -- XButton  < > ---------------------------
#If WinActive("ahk_exe FL64.exe") and mouseOverBrowser()
XButton1::
    freezeExecute("closeCurrentlyOpenPacksFolder", [], False)
    return
#If

#If WinActive("ahk_exe FL64.exe")
^!XButton1 Up::
    freezeExecute("sendDelete")
    return

XButton1::
    xbutton1Released := False
    advanceInSong(False)
    return

XButton2::
    xbutton2Released := False
    advanceInSong(True)   
    return 

XButton1 Up::
    xbutton1Released := True
    return

^XButton1 Up::
    xbutton1Released := True
    return

XButton2 Up::
    xbutton2Released := True
    return

^XButton2 Up::
    xbutton2Released := True
    return     
#If
;--

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