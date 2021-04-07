eventEditorCycleParam(dir)
{
    MouseMove, 450, 15, 0
    Click
    Send {%dir%}{Enter}
}

activateEventEditorLFO()
{
    global retrieveMouse
    Send {AltDown}o{AltUp}
    LFOwinID := waitNewWindowOfClass("TPRLFOForm", "")
    WinMove, ahk_id %LFOwinID%,, -469, 936
    MouseMove, 72, 168     
    midiRequest("toggle_play_pause_twice")
    retrieveMouse := False
}

activateEventEditorScale()
{
    global retrieveMouse
    Send {AltDown}x{AltUp}
    scaleWinID := waitNewWindowOfClass("TPRLevelScaleForm", "")
    WinMove, ahk_id %scaleWinID%,, -469, 936
    MouseMove, 72, 168     
    midiRequest("toggle_play_pause_twice")
    retrieveMouse := False
}

insertCurrentControllerValue()
{
    Send {CtrlDown}i{CtrlUp}
}