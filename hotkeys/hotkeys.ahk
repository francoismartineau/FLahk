; -- Enter / NumpadEnter / MButton ------------------------------------------
#If WinActive("ahk_exe FL64.exe") and !acceptPressed and !numpad1Context.IsActive
Enter::
    acceptPressed := True
    return



NumpadEnter::
    acceptPressed := True
    return

; with shift also for selectSourceForAllSelectedClips()
+NumpadEnter::
    acceptPressed := True
    return

+Enter::
    acceptPressed := True
    return
#If

#If WinActive("ahk_exe FL64.exe") and acceptPressed and mouseOverMixerSlotSection()
Enter::
    mixerOpenSlot()
    return

NumpadEnter::
    mixerOpenSlot()
    return
#If

#If WinActive("ahk_exe FL64.exe") and acceptPressed and mouseOverBrowser()
Enter::
    clickBrowser()
    return

NumpadEnter::
    clickBrowser()
    return
#If


#If WinActive("ahk_exe FL64.exe") and acceptPressed and isEventEditForm()
Enter::
    return

NumpadEnter::
    return
#If

#If WinActive("ahk_exe FL64.exe") and acceptPressed and !isEventEditForm() and !isStepSeq() and !mouseOverMixerSlotSection() or WinActive("ahk_exe ahk.exe")
MButton::
    Send {Enter}
    return
#If

; -- Esc ------------------------------------------
#If WinActive("ahk_exe FL64.exe") and acceptPressed and freezeExecuting
Esc::
    stopExec := True
    return
#If

#If WinActive("ahk_exe FL64.exe") and !acceptPressed
Esc::
    abortPressed := True   
    return

+Esc::  ;for accept abort
    abortPressed := True   
    return
#If

#If WinActive("ahk_exe FL64.exe") and isPianoRollTool() and acceptPressed
Esc::
    Send {Enter}
    return
#If

#If WinActive("ahk_exe FL64.exe") and acceptPressed and (isPlaylist() or isMainFlWindow()) ;and (leftScreenWindowsShown and isOneOfMainWindows()) or (!leftScreenWindowsShown and (isMainFlWindow() or isPlaylist()))
Esc::
    freezeExecute("bringHistoryWins")
    return
#If

#If WinActive("ahk_exe FL64.exe") and acceptPressed and isEventEditor()
Esc::
    bringMixer(False)
    return
#If

#If WinActive("ahk_exe FL64.exe") and acceptPressed and isWrapperPlugin()
Esc::
    closeAllWrapperPlugins()
    freezeExecute("bringHistoryWins")
    return
#If

#If WinActive("ahk_exe FL64.exe") and acceptPressed and isPlugin() and !isMasterEdison()
~Esc::
    freezeExecute("activateLastFlWin")
    return
#If

lastFlWin := currFlWin

; -- misc ------------------------------------------
#If WinActive("ahk_exe FL64.exe") and !IsEdison()
^n::
    WinActivate, ahk_class TFruityLoopsMainForm
    WinGet, winId, ID, A
    Click, 16, 15
    Send {Down}{Enter}
    promptWinId := waitNewWindow(winId)
    centerMouse(promptWinId)
    return
#If

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

#If WinActive("ahk_exe FL64.exe")
^s Up::
    lastSaveTime := timeOfDaySeconds()
    freezeExecute("saveKnobSavesToFile")
    Send {CtrlDown}s{CtrlUp}
    return

^+s Up::
    lastSaveTime := timeOfDaySeconds()
    return

^z::
    Send {Ctrl Down}{Alt Down}z{Alt Up}{Ctrl Up}
    return

^y::
    Send {Ctrl Down}z{Ctrl Up}
    return

; -- Win History -------------------
Tab::
    freezeExecute("activatePrevWin")
    return

CapsLock::
    freezeExecute("activateNextWin")
    return 

^!Tab::
    winHistoryRemovePluginsExceptLast(3)
    return

^!CapsLock::
    winHistoryRemoveMainWins()
    return

+Tab::
    ;;;;;;;;;;;;;;;;; Alt Caps: le pouce sur alt, on risque d'overwriter après (!1 !2 etc)
    incrLoadKnobPosIndex()
    freezeExecute("loadKnobPos", False)
    return

;^CapsLock::
;    decrLoadKnobPosIndex()
;    freezeExecute("loadKnobPos", False)
;    return
#If
; -------------

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


#If WinActive("ahk_exe FL64.exe") and (isPlaylist() or isPianoRoll())
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