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
    else if (isPlugin() or isEventEditForm())
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

#If WinActive("ahk_exe FL64.exe") and acceptPressed and isInstr()
MButton::
MButton Up::
    return
#If

#If WinActive("ahk_exe Code.exe") or WinActive("ahk_exe FL64.exe") and acceptPressed and !isEventEditForm() and !isStepSeq() and !mouseOverMixerSlotSection() or WinActive("ahk_exe ahk.exe")
MButton::
    return
MButton Up::
    Send {Enter}
    pianoRollTempMsg()
    return
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
    else if (numpadGShown)
        hideNumpadG()
    else if (preGenBrowsing)
        stoppreGenBrowsing()
    else if (ConcatAudioShown)
        hideConcatAudio()
    else if (freezeExecuting)  
        stopExec := True

    else if (isStepSeq())
        Send {F6}
    else if (isPianoRollTool())
    {
        Send {Enter}
    }        
    else if (isPlaylist() or isMainFlWindow())
        freezeExecute("bringHistoryWins")
    else if (isMasterEdison() or isControlSurface())
        freezeExecute("activatePrevPlugin")
    else if (isInstr())
    {
        WinClose, A
        freezeExecute("bringStepSeq")
    }
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
#If WinActive("ahk_exe FL64.exe") and !WinActive("ahk_class TNameEditForm") and !isFormulaCtl()
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
    freezeExecute("masterEdisonTransport", True, True, "playPause")
    return

^!Space::
    freezeExecute("masterEdisonTransport", True, True, "stop")
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
        saveEdisonSound(packsPath)
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
; ----


; -- Win History -------------------
Tab::
    freezeExecute("activatePrevPlugin")
    return
^Tab::
    freezeExecute("activateNextPlugin")
    return

CapsLock::
    freezeExecute("activatePrevMainWin")
    return 
^CapsLock::
    freezeExecute("activateNextMainWin")
    return     

+^Tab::
    freezeExecute("toolTipChoiceActivatePlugin")
    return
+^CapsLock::
    freezeExecute("toolTipChoiceActivateMainWin")
    return
#If
#If whileToolTipChoiceActivateWin and !acceptPressed
~Shift & Ctrl Up::
~Ctrl & Shift Up::
    acceptPressed := True
    return
#If

#If WinActive("ahk_exe FL64.exe")
;LWin & Tab::
;    toolTip("History: last 3 plugins")
;    winHistoryClosePluginsExceptLast(3)
;    closePluginsNotInHistory()
;    Sleep, 200
;    toolTip()
;    return

+Tab::
    incrLoadKnobPosIndex()
    freezeExecute("loadKnobPos", False)
    return
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
#If WinActive("ahk_exe FL64.exe") and (isPlaylist() or isPianoRoll())
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

#If WinActive("ahk_exe FL64.exe") and !(isPlaylist() or isPianoRoll())
~b::
    return

~c::
    return
#If
; -----