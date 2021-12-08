; -- Scroll Tabs --------------------------------------
global scrollingTab := False
global scrollingTabMx
global scrollingTabMy
global scrollingTabIncr
global scrollingTabNumScroll := 0
scrollTab(dir, mode)
{
    if (!scrollingTab)
        started := scrollTabStart(mode)
    if (!started)
    {
        msg("didn't find tab")
        return
    }

    Switch mode
    {
    Case "playlist":
        incr := 30
    Case "pianoroll":
        incr := 50
    }

    Switch dir
    {
    Case "left":
        x := -incr
    Case "right":
        x := incr
    }
    MouseMove, %x%, 0, 0, R
}

scrollTabStart(mode)
{
    res := False
    freezeMouse()
    Switch mode
    {
    Case "playlist":
        MouseGetPos, x
        timeLineY := 80
        w := 400
        incr := 30
    Case "pianoroll":
        MouseGetPos, x
        timeLineY:= 75
        timelineEnd := 1895
        w := timelineEnd - x
        incr := 40
    }    
    colVar := 10
    timelineCol := [0x1B272E, 0xA25B5D]
    tabX := scanColorRight(x , timeLineY, w, timelineCol, colVar, incr, "", False, True)
    x := tabX-(incr-6)
    w := incr
    incr := 7
    tabX := scanColorRight(x, timeLineY, w, timelineCol, colVar, incr, "", False, True)
    if (tabX)
    {
        scrollingTab := True
        MouseMove, %tabX%, %timeLineY%, 1
        Sleep, 100
        Send {LButton down}
        res := True
    }
    unfreezeMouse()
    return res
}

scrollTabStop()
{
    Send {LButton Up}
    scrollingTab := False
    MouseMove, %scrollingTabMx%, %scrollingTabMy%, 0
}
; ----



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