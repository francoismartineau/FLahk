Class Playlist
{
; -- Win -----
    isWin(winId := "")
    {
        success := False
        if (winId == "")
            WinGet, winId, ID, A
        WinGetClass, class, ahk_id %winId%
        if (class == "TEventEditForm")
        {
            WinGetTitle, title, ahk_id %winId%
            success := InStr(title, "Playlist -")
        }
        if (success)
            Playlist.winId := winId
        return success
    }
    bringWin(moveMouse := True, winId := "")
    {
        if (winId == "")
            winId := Playlist.__forceGetWinId()

        WinActivate, ahk_id %winId%
        if (!Playlist.__patternsShown())
            Playlist.__showPatterns()

        if (moveMouse)
            centerMouse(winId)
        
        return winId
    }
    static winId := ""
    __forceGetWinId()
    {
        winId := Playlist.winId
        if (!Playlist.isWin(winId))
            winId := Playlist.__getExistingWin()
        if (!Playlist.isWin(winId))
            winId := Playlist.__bringWinWithKey()
        if (!Playlist.isWin(winId))
            return False
        else
            return winId
    }
    __getExistingWin()
    {
        WinGet, winId, ID, ahk_class TEventEditForm, Playlist
        return winId
    }
    __bringWinWithKey()
    {
        WinGet, currId, ID, A
        Send {F5}
        winId := waitNewWindowTitled("Playlist", currId)  
        return winId
    }


    static __patternsPianoButtonX := 27
    static __patternsPianoButtonY := 74
    __patternsShown()
    {
        x := Playlist.__patternsPianoButtonX
        y := Playlist.__patternsPianoButtonY
        success := colorsMatch(x, y, [0x3F4879])
        return success
    }
    __showPatterns()
    {
        mX := Playlist.__patternsPianoButtonX
        mY := Playlist.__patternsPianoButtonY
        quickClick(mX, mY)
    }
; --
}

global timelineMouseDownX := 
global timelineMouseUpX := 

; -- timeline --------------------
playlistUnselectClips()
{
    moveMouse(566, 103)
    Send {CtrlDown}
    Click
    Send {ShiftDown}
    Click
    Send {ShiftUp}{CtrlUp}
}

moveMouseOverPlaylistTimeline()
{
    mouseGetPos(mX, _)
    moveMouse(mX, 65)
}

playlistTimelineIsSelected()
{
    playlistId := Playlist.bringWin(False)
    colorsMatch(280, 53, [0xA05A5B])
    x := 280
    y := 53
    w := 1365
    colVar := 20
    incr := 10
    return scanColorsRight(x, y, w, timelineRed, colVar, incr)
}

mouseOverPlaylist()
{
    MouseGetPos,,, winId
    return Playlist.isWin(winId)
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
    if (Playlist.isWin(winId))
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
    if (Playlist.isWin(winId))
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
    if (Playlist.isWin(winId))
    {
        WinGetPos, winX, winY, winW, winH, ahk_id %winId%
        mX := mX - winX
        mY := mY - winY
        res := (mx < 270 and 169 < mx) and (69 < my and my < 991)
    }
    return res
}
; ----

; -- Loop -------------------------------
setPlaylistLoop(mode)
{
    playlistId := Playlist.bringWin(False)
    MouseGetPos, mX, mY
    timeLineY:= 80
    MouseMove, %mX%, %timeLineY%, 0
    Click, Right
    Send {WheelDown}
    Click
    waitNewWindowOfClass("TNameEditForm", playlistId)
    Send {Enter}

    WinActivate, ahk_id %playlistId%
    reverse := True
    mX := scanColorsRight(mX , timeLineY, 30, [0x1C272F], 40, 20, reverse)
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
    reverse := True
    tabX := scanColorsRight(x, timeLineY, w, timelineCol, colVar, incr, reverse)

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
    playlistId := Playlist.bringWin(False)
    MouseGetPos, mX, mY
    timeLineY:= 80
    reverse := True
    mX := scanColorsRight(mX , timeLineY, 100, [0x1C272F], 10, 20, reverse)
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

playlistCtrlB()
{
    if playlistTimelineIsSelected()
    {
        moveMouseOverPlaylistTimeline()
        SendInput ^{LButton}


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
        StepSeq.bringWin(False)
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
        quickClick(x, y)
    }
}

playlistToolTip(msg)
{
    Tooltip, %msg%, 280, 60
}