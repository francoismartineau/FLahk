Bpm() {
    clipboardSave := clipboard
    id := bringMainFLWindow()
    if (id) {
        MouseMove, 513, 20, 0
        Click, Right
        MouseMove, 42, 243, 0, R
        Click
        Random, bpm, 70, 140
        clipboard := bpm
        Send {CtrlDown}v{CtrlUp}
        Send, {Enter}
        clipboard := clipboardSave
    }
}