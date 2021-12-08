﻿#SingleInstance Force
#Persistent
#InstallKeybdHook
#InstallMouseHook
#KeyHistory
#MaxHotkeysPerInterval 150
FileEncoding, UTF-8

; -- utils
#Include utils/utils.ahk
#Include utils/loadFx.ahk
#Include utils/loadInstr.ahk
#Include utils/applyController.ahk
#Include utils/upperMenu.ahk
#Include utils/isWin.ahk
#Include utils/wait.ahk
#Include utils/windowMenus.ahk
#Include utils/windows.ahk
#Include utils/bringWin.ahk
#Include utils/moveWin.ahk
#Include utils/ctxMenu.ahk
#Include utils/winHistory.ahk
#Include utils/scroll.ahk  
#Include utils/toolTipChoice.ahk 
#Include utils/samplers.ahk 
#Include utils/saveReminder.ahk 
#Include utils/knobSaves.ahk 
#Include utils/pattern.ahk 

#Include utils/msgRefresh.ahk 
#Include utils/transferSounds.ahk 
#Include utils/winRelated/eventEditor.ahk
#Include utils/winRelated/pianoRoll.ahk
#Include utils/winRelated/pianoRollToolWindows.ahk
#Include utils/winRelated/mixer.ahk
#Include utils/winRelated/plugin.ahk
#Include utils/winRelated/stepSeq.ahk
#Include utils/winRelated/distructor.ahk
#Include utils/winRelated/edison.ahk
#Include utils/winRelated/playlist.ahk
#Include utils/winRelated/patcher4.ahk
#Include utils/winRelated/instr.ahk
#Include utils/winRelated/patcherSampler.ahk
#Include utils/winRelated/patcherSlicex.ahk
#Include utils/winRelated/patcherGranular.ahk
#Include utils/winRelated/patcherMap.ahk

; -- operations
#Include operations/EditEvents.ahk
#Include operations/EnvC.ahk
#Include operations/showChannelWindows.ahk
#Include operations/Note.ahk
#Include operations/equo.ahk
#Include operations/BPM.ahk
#Include operations/LFO.ahk
#Include operations/Encapsulation.ahk
#Include operations/Arp.ahk
#Include operations/concatAudio.ahk
#Include operations/recOnPlay.ahk
#Include operations/deletePlugin.ahk
#Include operations/knobs.ahk
#Include operations/3xosc.ahk
#Include operations/sampleToSlicex.ahk
#Include operations/NewLib.ahk
#Include operations/Automation.ahk
#Include operations/rename.ahk
#Include operations/vsCode.ahk
#Include operations/goForwardBackward.ahk
#Include operations/makeUnique.ahk
#Include operations/clone.ahk
#Include operations/toggleMainEvents.ahk
#Include operations/chopClip.ahk
#Include operations/eventWindowTools.ahk
#Include operations/denoise.ahk
#Include operations/assignMixerTrackRoute.ahk
#Include operations/Layer.ahk
#Include operations/bigScrollMixer.ahk
#Include operations/resetSoundDevice.ahk
#Include operations/DelB.ahk
#Include operations/Filter.ahk
#Include operations/browser.ahk
#Include operations/dragSamples.ahk
#Include operations/lockChan.ahk
#Include operations/browsePreGen.ahk
#Include operations/browsePostGen.ahk

; -- lib
#Include %A_MyDocuments%/AutoHotkey/Lib/maLib.ahk
#Include %A_MyDocuments%/AutoHotkey/Lib/vision.ahk
; -- gui
#Include gui/g.ahk
#Include gui/concatAudio.ahk
#Include gui/windowMenusGuis.ahk
#Include gui/splashScreen.ahk
#Include gui/highlight.ahk
#Include gui/numpadG.ahk
#Include gui/secondMouse.ahk
; -- Test
#Include Test.ahk

; -- midi I/O
#Include midi/MidiIn.ahk
#Include midi/MidiOut.ahk
#Include midi/midiRequest.ahk
#Include hotkeys/mouseCtl.ahk
#Include midi/midiInit.ahk
;#Include midi/knobIn.ahk



; -- program start -------------------------
makeMouseCursor()
toolTip("starting")
#Include run/run.ahk
#Include run/clock.ahk
#Include run/obsCheckMousePos.ahk
splashScreenToggle := False
setFlahkWallpaper()
showSplashScreen()
makeWindow()
hideSplashScreen()
WinActivate, ahk_exe FL64.exe
isSaved := freezeExecute("loadSaveFileIfExists")
if (isSaved)
    bringStepSeq(True)
toolTip()



; -- hotkeys
#Include AutoHotInterception/AutoHotInterception.ahk
#Include hotkeys/AutoHotInterception.ahk 
#Include hotkeys/secondMouse.ahk
#Include hotkeys/numpad.ahk
#Include hotkeys/arrows.ahk
#Include hotkeys/winRelated/patcherMap.ahk
#Include hotkeys/numbers.ahk
#Include hotkeys/fKeys.ahk
;#Include midi/midiInputs.ahk
#Include hotkeys/mouse.ahk  
#Include hotkeys/scroll.ahk  
#Include hotkeys/hotkeys.ahk
#Include %A_MyDocuments%/AutoHotkey/Lib/libHotkeys.ahk

#Include hotkeys/winRelated/pianoRoll.ahk
#Include hotkeys/winRelated/pianoRollToolWindows.ahk
#Include hotkeys/winRelated/stepSeq.ahk
#Include hotkeys/winRelated/playlist.ahk
#Include hotkeys/winRelated/mixer.ahk
#Include hotkeys/winRelated/patcherSampler.ahk
#Include hotkeys/winRelated/patcherSlicex.ahk
#Include hotkeys/winRelated/transferSounds.ahk
#Include hotkeys/winRelated/instr.ahk

; -- goto
#Include run/goto.ahk