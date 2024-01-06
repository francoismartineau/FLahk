; -- Enter / NumpadEnter / MButton ------------------------------------------
#If WinActive("ahk_exe FL64.exe")
Enter::
NumpadEnter::
    return

Enter Up::
NumpadEnter Up::
    if (!acceptPressed)
        acceptPressed := True
    else if (mouseOverMixerSlotSection())
        mixerOpenSlot()
    else if (isPlugin() or isEventEditForm() or isMixer())
        return
    else
        send {Enter}
    return

+Enter Up::
+NumpadEnter Up::
    if (!acceptPressed)
        acceptPressed := True
    else
        SendInput +{Enter}
    return
#If

/*

; Accept abort
#If !acceptPressed and !numpad1Context.IsActive
Enter Up::
    acceptPressed := True
    return



NumpadEnter Up::           ; with shift also for selectSourceForAllSelectedClips()
    acceptPressed := True
    return

+NumpadEnter Up::
    acceptPressed := True
    return

+Enter Up::
    acceptPressed := True
    return
#If

#If WinActive("ahk_exe FL64.exe") and !numpad1Context.IsActive and acceptPressed and mouseOverMixerSlotSection()
Enter::
    mixerOpenSlot()
    return

NumpadEnter::
    mixerOpenSlot()
    return
#If

#If WinActive("ahk_exe FL64.exe") and !numpad1Context.IsActive and acceptPressed and isEventEditForm()
Enter::
    return

NumpadEnter::
    return
#If

#If
*/
; ----


; -- Esc ------------------------------------------
#If WinActive("ahk_exe FL64.exe")
Esc::
    return
Esc Up::
    if (!acceptPressed)
        abortPressed := True 
    else if (whileWaiting)
        stopWaitFunction()
    else if (scrollingInstr)
        scrollInstrQuit()
    else if (numpadGShown)
        hideNumpadG()
    else if (PreGenBrowser.running)
        PreGenBrowser.stop()
    else if (ConcatAudioShown)
        hideConcatAudio()
    else if (freezeExecuting)  
        stopExec := True

    else if (StepSeq.isWin())
        Send {F6}
    else if (isPianoRollTool())
    {
        Send {Enter}
    }        
    else if (Playlist.isWin() or isMainFlWindow())
        freezeExecute("bringHistoryWins")
    else if (isMasterEdison() or isControlSurface())
        freezeExecute("activatePrevPlugin")
    else if (isInstr())
        WinClose, A
    else if (isWrapperPlugin())
    {
        closeWrapperPlugin()
        freezeExecute("activatePrevPlugin")
    }
    else if (isPlugin() or isEventEditor())
    {
        WinClose, A
        freezeExecute("activatePrevPlugin")
    }
    else if (mouseFrozen)
        unfreezeMouse()
    else
        Send {Esc}
    return

+Esc::
    return
+Esc Up::
    if (!acceptPressed)
        abortPressed := True
    else
        SendInput +{Esc}
    return

; ----

#If WinActive("ahk_exe FL64.exe") and isMasterEdison()
!t::
    freezeExecute("masterEdisonTruncateAudio")
    return
#If

; -- Space -----------------------------------------
#If WinActive("ahk_exe FL64.exe") and !WinActive("ahk_class TNameEditForm") and !isFormulaCtl() and !isBrowser()
Space::
    if (!freezeExecuting)
    {
        midiRequest("toggle_play_pause")
        ;if (songPlaying() and recordEnabled())
        ;    midiRequest("toggle_rec")
    }
    else
        Send {Space}
    return

^Space::
    if (!freezeExecuting)
    {
        midiRequest("stop")
        ;if (recordEnabled())
        ;    midiRequest("toggle_rec")
    }
    else
        Send {Space}
    return
#If

#If WinActive("ahk_exe FL64.exe") and !WinActive("ahk_class TNameEditForm")
!Space::
    freezeExecute("masterEdisonTransport", ["playPause"], True, True)
    return

^!Space::
    freezeExecute("masterEdisonTransport", ["stop"], True, True)
    return
#If
; ----

; -- misc ------------------------------------------
#If True
!F2::               ; Quit app
    exitFlahk()
    return
    
!#Tab::
	sendAllKeysUp()
    
    ;SendInput !Tab
    return
~!Tab::
    return
~^#!Right::
	sendAllKeysUp()
    return
~^#!Left::
	sendAllKeysUp()
    return    
#If
#If WinActive("ahk_exe FL64.exe") and !IsEdison()
^n::                                                            ; new
    freezeExecute("createNewProject")
    return
#If

#If WinActive("ahk_exe FL64.exe")
^s Up::                                                         ; save
    if (isEdison())
        saveEdisonSound(Paths.packs)
    else
        freezeExecute("saveProject")
    return


^+s Up::
    lastSaveTime := timeOfDaySeconds()
    return

^z::                                                            ; undo
    Send {Ctrl Down}{Alt Down}z{Alt Up}{Ctrl Up}
    return

!d::
    SendInput ^b
    return

^y::                                                            ; redo
    Send {Ctrl Down}z{Ctrl Up}
    return
#If
; ----


; -- Win History -------------------
;Tab::
;    freezeExecute("activatePrevPlugin")
;    return
;^Tab::
;    freezeExecute("activateNextPlugin")
;    return

;CapsLock::
;    freezeExecute("activatePrevMainWin")
;    return 
;^CapsLock::
;    freezeExecute("activateNextMainWin")
;    return     



#If WinActive("ahk_exe FL64.exe") and !whileToolTipChoiceActivateWin
Tab::
    freezeExecute("toolTipChoiceActivatePlugin")
    return
CapsLock::
    freezeExecute("toolTipChoiceActivateMainWin")
    return
#If


#If whileToolTipChoiceActivateWin and !acceptPressed
Tab::
Capslock::
    return
Capslock Up::
Tab Up::
    acceptPressed := True
    return
#If

#If WinActive("ahk_exe FL64.exe") and whileToolTipChoiceActivateWin and !alternativeChoicePressed
RButton::
    alternativeChoicePressed := True
    return
#If
#If WinActive("ahk_exe FL64.exe")
^Tab::
    incrLoadKnobPosIndex()
    freezeExecute("loadKnobPos", [], False)
    return
;LWin & Tab::
;    toolTip("History: last 3 plugins")
;    winHistoryClosePluginsExceptLast(3)
;    closePluginsNotInHistory()
;    Sleep, 200
;    toolTip()
;    return
#If
; ----


; -- Conflictual keys ---------------------------
#If WinActive("ahk_exe FL64.exe") and isInstr()
e::
    Send {m down}
    return

e Up::
    Send {m up} 
    return
#If

#If WinActive("ahk_exe FL64.exe") and (isMixer() or isMasterEdison())
s::
    return
#If
; ----

; -- Event Editor tools ----------------------------------
#If WinActive("ahk_exe FL64.exe") and (Playlist.isWin() or PianoRoll.isWin())
q::
    freezeExecute("activatePencilTool")
    return

w::
    freezeExecute("activateBrushTool")
    return

e::
    freezeExecute("activateMuteTool")
    return

!e::
    muteSelection()
    return

+!e::
    unmuteSelection()
    return

^i::
    invertSelection()
    return

c::
    freezeExecute("cutUnderMouse")
    return

+c::
    freezeExecute("cutAfterMouse")
    return

!c UP::
    freezeExecute("chopClip")
    return

t::
    freezeExecute("activateMuteTool")
    return

b::
    freezeExecute("activateBrushTool")
    return

p::
    freezeExecute("activatePencilTool")
    return
#If

#If WinActive("ahk_exe FL64.exe") and !(Playlist.isWin() or PianoRoll.isWin())
~b::
    return

~c::
    return
#If
; -----