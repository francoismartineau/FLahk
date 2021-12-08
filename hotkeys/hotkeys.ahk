; -- Enter / NumpadEnter / MButton ------------------------------------------

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
    return
#If

#If WinActive("ahk_exe Code.exe") or WinActive("ahk_exe FL64.exe") and acceptPressed and !isEventEditForm() and !isStepSeq() and !mouseOverMixerSlotSection() or WinActive("ahk_exe ahk.exe")
MButton::
    Send {Enter}
    pianoRollToolTip()
    return
#If
; ----


; -- Esc ------------------------------------------
#If numpadGShown
Esc::
    hideNumpadG()
    return
#If

#If preGenBrowsing
Esc::
    return

Esc Up::
    stoppreGenBrowsing()
    return
#If 

#If ConcatAudioShown
Esc Up::
    hideConcatAudio()
    return
#If

#If WinActive("ahk_exe FL64.exe") and !acceptPressed
Esc::
    return
Esc Up::            ; otherwise, esc up was sent to fl after esc down
    abortPressed := True   
    return

+Esc Up::           ;for accept abort while +pressed
    abortPressed := True   
    return
#If

#If WinActive("ahk_exe FL64.exe") and freezeExecuting
F4::
Esc::
    return
F4 Up::
Esc Up::
    stopExec := True
    return
#If

#If WinActive("ahk_exe FL64.exe") and isStepSeq()
Esc Up::
    Send {F6}
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPianoRollTool()
Esc::
    return
Esc Up::
    pianoRollToolTip()
    Send {Enter}
    return
#If

#If WinActive("ahk_exe FL64.exe") and (isPlaylist() or isMainFlWindow()) ;and (leftScreenWindowsShown and isOneOfMainWindows()) or (!leftScreenWindowsShown and (isMainFlWindow() or isPlaylist()))
Esc::
    return
Esc Up::
    freezeExecute("bringHistoryWins")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isEventEditor()
Esc::
    return
Esc Up::
    freezeExecute("activatePrevPlugin")
    return
#If

/*

#If WinActive("ahk_exe FL64.exe") and isWrapperPlugin()
Esc::
    closeAllWrapperPlugins()
    freezeExecute("activatePrevPlugin")
    return
#If
*/

#If WinActive("ahk_exe FL64.exe") and isMasterEdison()
Esc::
    return
Esc Up::
    freezeExecute("activatePrevPlugin")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isInstr() and acceptPressed
~Esc::
    return
Esc Up::
    freezeExecute("bringStepSeq")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPlugin()
Esc::
    return
Esc Up::
    if (isWrapperPlugin())
    {
        WinClose, A
        msg("closing wrapper plugin", 100)
    }
    else
        WinClose, A
    freezeExecute("activatePrevPlugin")
    return
#If

; ----

; -- Space -----------------------------------------
#If WinActive("ahk_exe FL64.exe") and !WinActive("ahk_class TNameEditForm")
Space::
    ;isEdison := isMasterEdison()
    ;if (isEdison)
    ;    bringStepSeq(False)
    midiRequest("toggle_play_pause")
    if (!songPlaying() and recordEnabled())
        midiRequest("toggle_rec")
    ;if (isEdison)    
    ;    bringMasterEdison(False)
    return

!Space::
    freezeExecute("masterEdisonTransport", True, True, "playPause")
    return

^Space::
    ;isEdison := isMasterEdison()
    ;if (isEdison)
    ;    bringStepSeq(False)
    midiRequest("stop")
    if (recordEnabled())
        midiRequest("toggle_rec")
    ;if (isEdison)    
    ;    bringMasterEdison(False)
    return

^!Space::
    freezeExecute("masterEdisonTransport", True, True, "stop")
    return
#If
; ----

; -- misc ------------------------------------------
#If True
!F2::
^Esc::              ; Quit app
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
    WinActivate, ahk_class TFruityLoopsMainForm
    WinGet, winId, ID, A
    Click, 16, 15
    Send {Down}{Enter}
    promptWinId := waitNewWindow(winId)
    centerMouse(promptWinId)
    return
#If

#If WinActive("ahk_exe FL64.exe")
^s Up::                                                         ; save
    if (isEdison())
        saveEdisonSound(packsPath)
    else
        saveProject()
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

LWin & Tab::
    toolTip("History: last 3 plugins")
    winHistoryClosePluginsExceptLast(3)
    closePluginsNotInHistory()
    Sleep, 200
    toolTip()
    return

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