; -- timeline --------------------
mouseOverPlaylist()
{
    MouseGetPos,,, winId
    return isPlaylist(winId)
}

mouseOverPlaylistPatternRow()
{
    return mouseOverPlaylist() and !mouseOverPlaylistSong()
}

mouseOverPlaylistSong()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY, winId
    CoordMode, Mouse, Client
    if (isPlaylist(winId))
    {
        WinGetPos, winX, winY, winW, winH, ahk_id %winId%
        mX := mX - winX
        mY := mY - winY
        res := (67 <= mY) and (278 < mX and mX < 1653)
    }
    return res
}

mouseOverPlaylistTimeLine()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY, winId
    CoordMode, Mouse, Client
    if (isPlaylist(winId))
    {
        WinGetPos, winX, winY, winW, winH, ahk_id %winId%
        mX := mX - winX
        mY := mY - winY
        res := (50 < mY and mY < 67) and (278 < mX and mX < 1653)
    }
    return res
}

deselectPlaylistTimeline()
{
    MouseGetPos, mx
    MouseMove, %mx%, 56, 0
    Send {CtrlDown}{LButton}{CtrlUp}
}

mouseOverPlaylistTrackNames()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY, winId
    CoordMode, Mouse, Client
    if (isPlaylist(winId))
    {
        WinGetPos, winX, winY, winW, winH, ahk_id %winId%
        mX := mX - winX
        mY := mY - winY
        res := (mx < 270 and 169 < mx) and (69 < my and my < 991)
    }
    return res
}


; -- Loop -------------------------------
setPlaylistLoop(mode)
{
    playlistId := bringPlaylist(False)
    MouseGetPos, mX, mY
    timeLineY:= 80
    MouseMove, %mX%, %timeLineY%, 0
    Click, Right
    Send {WheelDown}
    Click
    waitNewWindowOfClass("TNameEditForm", playlistId)
    Send {Enter}

    WinActivate, ahk_id %playlistId%
    mX := scanColorRight(mX , timeLineY, 30, [0x1C272F], 40, 20, "", False, True)
    if (mX)
    {
        MouseMove, %mX%, %timeLineY%, 0
        Click, Right
        Switch mode
        {
        Case "start":
            n := 10
            name := "-->"
        Case "end":
            n := 11
            name := "<--"
        }
        Loop, %n%
        {
            Sleep, 10
            Send {WheelDown}
        }
        Click
        MouseMove, %mX%, %timeLineY%, 0
        Click, Right
        Loop, 5
        {
            Sleep, 10
            Send {WheelDown}
        }
        Click
        waitNewWindowOfClass("TNameEditForm", playlistId)
        typeText(name)
        Send {Enter}
        fineTuneLoopPos(mX)
    }
}

fineTuneLoopPos(mX)
{
    scrollingTab := True

    incr := 7
    x := mX-20
    timeLineY := 80
    w := 40
    colVar := 10
    timelineCol := [0x1B272E, 0xA25B5D]
    tabX := scanColorRight(x, timeLineY, w, timelineCol, colVar, incr, "", False, True)

    MouseMove, %tabX%, %timeLineY%, 0
    Send {LButton down}

    clickAlsoAccepts := True
    unfreezeMouse()
    playlistToolTip("Click when done")
    waitAcceptAbort()
    toolTip()

    Send {LButton up}
    scrollingTab := False
}

deleteNextPlaylist()
{
    playlistId := bringPlaylist(False)
    MouseGetPos, mX, mY
    timeLineY:= 80
    mX := scanColorRight(mX , timeLineY, 100, [0x1C272F], 10, 20, "", False, True)
    if (mX)
    {
        MouseMove, %mX%, %timeLineY%, 1
        Sleep, 100
        Click, Right
        Loop, 4
        {
            Sleep, 20
            Send {WheelDown}
        }        
        Click
    }
}

; ----
; --------------------------------
global xbutton1Released := True
global xbutton2Released := True
advanceInSong(rewind = False)
{
    toolWinActive := isPianoRollTool()
    if (toolWinActive)
    {
        WinGet, toolWinId, ID, A
        bringStepSeq(False)
    }

    if (rewind)
        key := "NumpadMult"
    else
        key := "NumpadDiv"
    
    i := 100 
    while ((InStr(A_ThisHotkey, "XButton1") and !xbutton1Released) or (InStr(A_ThisHotkey, "XButton2") and !xbutton2Released))
    {
        if (i > 1)
            i := i - 10
        i := Max(1, i)
        Send {%key%}
        Sleep, %i% 
    }

    if (toolWinActive)
        WinActivate, ahk_id %toolWinId%
}



activateSlideTool()
{
    x := 157
    y := 15   
    if (!colorsMatch(x, y, [0xFFA64A]))
    {
        QuickClick(x, y)
    }
}

