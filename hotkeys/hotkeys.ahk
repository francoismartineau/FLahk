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
    return
#If
; ----


; -- Esc ------------------------------------------
#If WinActive("ahk_exe FL64.exe") and !acceptPressed
Esc::
    abortPressed := True   
    return

+Esc::  ;for accept abort
    abortPressed := True   
    return
#If

#If WinActive("ahk_exe FL64.exe") and freezeExecuting
F4::
Esc::
    stopExec := True
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPianoRollTool()
Esc::
    Send {Enter}
    return
#If

#If WinActive("ahk_exe FL64.exe") and (isPlaylist() or isMainFlWindow()) ;and (leftScreenWindowsShown and isOneOfMainWindows()) or (!leftScreenWindowsShown and (isMainFlWindow() or isPlaylist()))
Esc::
    freezeExecute("bringHistoryWins")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isEventEditor()
Esc::
    freezeExecute("activatePrevPlugin")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isWrapperPlugin()
Esc::
    closeAllWrapperPlugins()
    freezeExecute("activatePrevPlugin")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isMasterEdison()
Esc::
    freezeExecute("activatePrevPlugin")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isInstr()
~Esc::
    freezeExecute("bringStepSeq")
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPlugin()
~Esc::
    freezeExecute("activatePrevPlugin")
    return
#If

; ----

; -- Space -----------------------------------------
#If WinActive("ahk_exe FL64.exe") and !WinActive("ahk_class TNameEditForm")
Space::
    midiRequest("toggle_play_pause")
    return

!Space::
    freezeExecute("masterEdisonTransport", True, True, "playPause")
    return

^Space::
    midiRequest("stop")
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
    SendInput !Tab
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
    lastSaveTime := timeOfDaySeconds()
    if (fileSavedToggleEnabled)
    {
        if (savesFilePath == "")
            freezeExecute("getCurrentProjSaveFilePath")
        saveKnobSavesToFile()
        saveWinHistoriesToFile()
    }
    Send {CtrlDown}s{CtrlUp}
    return

^+s Up::
    lastSaveTime := timeOfDaySeconds()
    return

^z::                                                            ; undo
    Send {Ctrl Down}{Alt Down}z{Alt Up}{Ctrl Up}
    return

^d::
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
    ;winHistoryRemoveMainWins()
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