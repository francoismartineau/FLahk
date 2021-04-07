#SingleInstance Force
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
#Include utils/vision.ahk
#Include utils/upperMenu.ahk
#Include utils/isWin.ahk
#Include utils/wait.ahk
#Include utils/winDowMenus.ahk
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
#Include utils/winRelated/patcherSlicex.ahk
#Include utils/winRelated/instr.ahk
#Include utils/winRelated/patcherSampler.ahk

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
#Include operations/mouseCoords.ahk
#Include operations/_NewPattern.ahk
#Include operations/_NewAutomation.ahk
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
;#Include operations/REV.ahk
#Include operations/DelB.ahk
#Include operations/Filter.ahk
#Include operations/browser.ahk
#Include operations/assign2.ahk

; -- other
#Include %A_MyDocuments%/AutoHotkey/Lib/maLib.ahk
#Include gui/g.ahk
#Include gui/concatAudio.ahk
#Include gui/windowMenusGuis.ahk
#Include Test.ahk

; -- midi i/0
#Include midi/MidiIn.ahk
#Include midi/MidiOut.ahk
#Include midi/midiRequest.ahk
#Include hotkeys/mouseCtl.ahk

global midiI := new Midi()
midiI.OpenMidiIn(0)
global midiO := new MidiOut(1)
global midiO2 := new MidiOut(2)






; -- program start ----------------------------
#Include run/run.ahk
#Include run/clock.ahk
debugOn := False
makeWindow()
bringFL()
;freezeExecute("moveWindows")
;turnOffLeftScreenWindows() 

#Include AutoHotInterception/AutoHotInterception.ahk
#Include hotkeys/AutoHotInterception.ahk 
#Include hotkeys/numpad.ahk
#Include hotkeys/arrows.ahk
#Include hotkeys/numbers.ahk
#Include hotkeys/fKeys.ahk
#Include hotkeys/clipboard.ahk
#Include midi/midiInputs.ahk
#Include hotkeys/mouse.ahk  
#Include hotkeys/scroll.ahk  
#Include hotkeys/hotkeys.ahk

#Include hotkeys/winRelated/pianoRoll.ahk
#Include hotkeys/winRelated/pianoRollToolWindows.ahk
#Include hotkeys/winRelated/eventEditor.ahk
#Include hotkeys/winRelated/stepSeq.ahk
#Include hotkeys/winRelated/playlist.ahk
#Include hotkeys/winRelated/mixer.ahk
#Include hotkeys/winRelated/patcherSampler.ahk
#Include hotkeys/winRelated/patcherSlicex.ahk
#Include hotkeys/winRelated/audacity.ahk
#Include hotkeys/winRelated/instr.ahk

#Include %A_MyDocuments%/AutoHotkey/Lib/mesHotkeys.ahk
#Include goto.ahk
