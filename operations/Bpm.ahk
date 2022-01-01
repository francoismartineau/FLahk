randomizeBpm()
{
    ;clipboardSave := clipboard
    controlSurfaceId := bringControlSurface(False)
    if (controlSurfaceId)
    {
        setKnobValue(1556, 85, centeredExpRand(0, 1))
    }
    /*
    id := bringMainFLWindow()
    if (id)
    {
        MouseMove, 513, 20, 0
        Click, Right
        MouseMove, 42, 243, 0, R
        Click
        projectBpm := randGaussian(10, 100)
        projectBpm := Abs(projectBpm)

        bringControlSurface
        ;Random, projectBpm, 70, 140
        clipboard := projectBpm
        Send {CtrlDown}v{CtrlUp}
        Send, {Enter}
        clipboard := clipboardSave
        externalizeBpm()
    }
    */
}

externalizeBpm()
{
    bpm := getBpmWithUi() ; midiRequest("get_bpm_from_FL")  
    midiRequest("send_bpm", bpm)
}

getBpmWithUi()
{
    id := bringMainFLWindow()
    if (id)
    {
        moveMouse(513, 20, "Screen")
        Click, R
        MouseMove, 23, 239 ,, R
        Click
        bpm := copyTextWithClipboard()
        Send {Esc}
    }
    return bpm
}