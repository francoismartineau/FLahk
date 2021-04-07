; Utilisateur active la fenetre du son
; Copier son nom courant
; Changer son nom
; Spawn Slicex F8, double clique sur slicex
; slicex est activé, change son nom
; placer les deux fenetres
; faire le drag n drop
; New pattern: Shift+Ctrl+Ins Enter
; drop notes: clique sur piton pour
; laisser l'utilisateur placer le pattern

;créer un slicex
;placer les deux fenêtres à des endroits précis
;faire le drag and drop

sampleToSlicex() {
    sampleName := tempRenameSample()
    createSlicex(sampleName)
    dragAndDropSample(sampleName)
    renameActivatedSlicex(sampleName)
    dropNotesInNewPattern(sampleName)
}

tempRenameSample() {
    WinActivate, ahk_class TPluginForm
    MouseMove 16, 12
    MouseClick
    MouseMove, 56, 339
    MouseClick
    Send {CtrlDown}c{CtrlUp}
    sampleName := clipboard
    Send {Enter}
    WinMove, %sampleName%,, 300, 200
    return sampleName
}

createSlicex(sampleName) {
    Send {F8}
    MouseMove, 385, 939
    Sleep, 1000
    MouseMove, 1109, 508
    Sleep, 100
    MouseClick
    MouseClick
    Sleep, 100
    renameActivatedSlicex(sampleName)
    WinMove, Slicex_%sampleName%,, 868, 200
}

renameActivatedSlicex(sampleName) {
    MouseMove 16, 12
    MouseClick
    MouseMove, 88, 362
    MouseClick
    Send, Slicex_%sampleName%{Enter}
}

dragAndDropSample(sampleName) {
    ; ça va pas ici
    WinActivate, %sampleName%
    MouseMove, 277, 388
    Sleep, 5000
    Click, Down
    MouseMove, 940, 515
    Sleep, 5000
    Click, Up
    Sleep, 50
    Send {Space}{Space}
}

dropNotesInNewPattern(sampleName) {
    Send {ShiftDown}{CtrlDown}{Insert}{CtrlUp}{ShiftUp}
    Send %sampleName%{Enter}
    Sleep, 50
    MouseMove, 646, 388
    MouseClick, Right
    Send {Up}{Enter}{Esc}{Esc}
}
