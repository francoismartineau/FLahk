#If WinActive("ahk_exe FL64.exe") or isAhkGui()
; -----------
WheelUp::
    if (whileToolTipChoice)
       incrToolTipChoiceIndex()
    else if (StepSeq.mouseOverGroupButton())
        StepSeq.changeGroup("chans")       
    else if (scrollingInstr)
        scrollInstr("up")      
    else if (GetWords.choosingNum)
        GetWords.incrNum("up")
    else if (PianoRoll.mouseOverChannChoice())
        scrollInstrStart("pianoRoll")
    else if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        scrollPatternUp()
    else if (isPianorollLen() and mouseOverPianorollLenOptions())
        Send {LButton}{WheelUp}
    else if (!isMixer("", True) or mouseOverInstrMixerInsert() or StepSeq.mouseOverMixerInserts())
        Send {WheelUp}
    return

WheelDown::
    if (whileToolTipChoice)
       decrToolTipChoiceIndex()
    else if (StepSeq.mouseOverGroupButton())
        StepSeq.changeGroup("utils")       
    else if (scrollingInstr)
        scrollInstr("down")
    else if (GetWords.choosingNum)
        GetWords.incrNum("down")                 
    else if (PianoRoll.mouseOverChannChoice())
        scrollInstrStart("pianoRoll")       
    else if (mouseOverPlaylistPatternRow() or hoveringUpperMenuPattern())
        scrollPatternDown()
    else if (isPianorollLen() and mouseOverPianorollLenOptions())
        Send {LButton}{WheelDown}     
    else if (!isMixer("", True) or mouseOverInstrMixerInsert() or StepSeq.mouseOverMixerInserts())
        Send {WheelDown}
    return


; --    +    --------------------------------------
+WheelUp::
    if (numpadGShown)
        numpadGScroll("up")
    else if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", ["up"], False)
    else if (Playlist.isWin())
        scrollInstrStart("playlist")
    else if (isPlugin())
        scrollInstrStart("plugin")
    else if (StepSeq.isWin() and !scrollingInstr)
        SendInput +{WheelUp}
    else if (makingUnique)
        Send {WheelUp}
    return


+WheelDown::
    if (numpadGShown)
        numpadGScroll("down")
    else if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", ["down"], False)
    else if (PianoRoll.isWin())
        scrollInstrStart("pianoRoll")
    else if (Playlist.isWin())
        scrollInstrStart("playlist")
    else if (isPlugin())
        scrollInstrStart("plugin")
    else if (StepSeq.isWin() and !scrollingInstr)
        SendInput +{WheelDown}
    else if (makingUnique)
        Send {WheelDown}        
    return

~Shift::
    return

#If

#If (WinActive("ahk_exe FL64.exe") or isAhkGui()) and numpadGShown
RButton::
Esc::
    return
RButton Up::
Esc Up::
    freezeExecute("hideNumpadG")
    return
#If 




; --    !    --------------------------------------
#If WinActive("ahk_exe FL64.exe") or isAhkGui()
!WheelUp::
    if (PreGenBrowser.running)
        PreGenBrowser.browse()
    else if (ConcatAudioShown)  
        freezeExecute("PreGenBrowser.start", [], False) 
    else if (isMasterEdison())
        freezeExecute("setMasterEdisonMode", ["onPlay"])
    else if (StepSeq.isWin() or (isPlugin())) ; and !isMasterEdison()))
        freezeExecute("MoveWin.nudge", ["up"])
    else if (isMixer())
        Send {Left}  
    else if (PianoRoll.isWin())
        freezeExecute("PianoRoll.scrollColors", ["up"])
    return

!WheelDown::
    if (PreGenBrowser.running)
        moveMouseToConcatAudio() 
    else if (isMasterEdison())
        freezeExecute("setMasterEdisonMode", ["input"])
    else if (StepSeq.isWin() or (isPlugin())) ; and !isMasterEdison()))
        freezeExecute("MoveWin.nudge", ["down"])
    else if (isMixer())
        Send {Right}        
    else if (PianoRoll.isWin())
        freezeExecute("PianoRoll.scrollColors", ["down"], False)
    return

#If
#If PianoRoll.scrollingColors
~LAlt Up::
    PianoRoll.stopScrollColors()
    return
#If
#If WinActive("ahk_exe FL64.exe") or isAhkGui()
; --------



; --    #    --------------------------------------
#If (WinActive("ahk_exe FL64.exe") or isAhkGui())
LWin & WheelUp::
    if (whileToolTipChoice)
       incrToolTipChoiceIndex()           
    else if (Playlist.isWin())     
        scrollTab("left", "playlist")
    else if (PianoRoll.isWin())     
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
    else if (Playlist.isWin())     
        scrollTab("right", "playlist")
    else if (PianoRoll.isWin())     
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
    else if (scrollingTab and (Playlist.isWin() or PianoRoll.isWin()))
        scrollTabStop()
    return
#If
; --------




#If WinActive("ahk_exe FL64.exe")
; --    ^    --------------------------------------
^WheelUp::
    if (scrollingInstr)
        scrollInstr("up")
    if (isMasterEdison())
        freezeExecute("armEdison")
    else if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", ["up"], False)        
    else if (PianoRoll.isWin())
        scrollInstrStart("pianoRoll")
    else if (Playlist.isWin())
        scrollInstrStart("playlist")
    else if (isPlugin())
        scrollInstrStart("plugin")      
    else if (StepSeq.isWin() and !scrollingInstr)
        scrollInstrStart("stepSeq")         
    return

^WheelDown::
    if (scrollingInstr)
        scrollInstr("down")
    else if (isMasterEdison())
        freezeExecute("unarmEdison")    
    else if (isMixer())
        freezeExecute("moveMouseOnMixerSlot", ["down"], False)        
    else if (PianoRoll.isWin())
        scrollInstrStart("pianoRoll")
    else if (Playlist.isWin())
        scrollInstrStart("playlist")
    else if (isPlugin())
        scrollInstrStart("plugin")    
    else if (StepSeq.isWin() and !scrollingInstr)
        scrollInstrStart("stepSeq")           
    return
; --------

; --     +^     ---------------------------------
+^WheelUp::
    if (scrollingInstr or StepSeq.mouseOverInstr())
        scrollInstr("up")
    ;else if (StepSeq.mouseOverInstr())        ; move instr doesnt work probably because of modifier keys conflict
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
    else if (scrollingInstr or StepSeq.mouseOverInstr()) 
        scrollInstr("down")
    ;else if (StepSeq.mouseOverInstr())        ; move instr doesnt work probably because of modifier keys conflict
    ;    SendInput +^{WheelDown}
    else if (isMixer("", True)) mouseOverMixerDuplicateTrackRegion()
        freezeUnfreezeMouse("cloneMixerTrackState")
    return
; --------

; --    ^!      ----------------------------------
^!WheelUp::
    if (StepSeq.isWin() or PianoRoll.isWin() or Playlist.isWin())
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
    if (StepSeq.isWin() or PianoRoll.isWin() or Playlist.isWin())
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
    else if (mouseOverBrowser())
        freezeExecute("browserMove", ["up", 8], False)
    return

+!WheelDown::
    if (numpadGShown)
        numpadGScroll("right")
    else if (isMixer())
        freezeExecute("bigScrollMixer", ["right"])
    else if (mouseOverBrowser())
        freezeExecute("browserMove", ["down", 8], False)
    return
; --------
#If


; --    RButton      -----------------------
#If WinActive("ahk_exe FL64.exe") and StepSeq.isWin()
~RButton & WheelUp::
    ;msgTip("RButton & WheelDown")
    ;if (StepSeq.isWin())
    ;    freezeExecute("changeInstrGroup", ["left"])
    return     


RButton & WheelDown::
    if (StepSeq.isWin())
        freezeExecute("PianoRoll.activateLoop")
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