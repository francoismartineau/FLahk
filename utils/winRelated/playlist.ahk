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
        ;msgBox(mx < 270)
        ;msgBox(169 < mx)
        ;msgBox(270 < my)
        ;msgBox(my < 991)
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
    }
}

deleteNextPlaylistTab()
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

global scrollingPlaylistTab := False
global scrollingPlaylitMx
global scrollingPlaylitMy
scrollPlaylistTab(dir)
{
    if (!scrollingPlaylistTab)
        scrollPlaylistTabStart()

    incr := 10
    Switch dir
    {
    Case "left":
        x := -incr
    Case "right":
        x := incr
    }    
    MouseMove, %x%, 0, 0, R
}

scrollPlaylistTabStart()
{
    scrollingPlaylistTab := True
    playlistId := bringPlaylist(False)
    MouseGetPos, scrollingPlaylitMx, scrollingPlaylitMy
    timeLineY:= 80
    freezeMouse()
    mX := scanColorRight(scrollingPlaylitMx , timeLineY, 100, [0x1C272F], 10, 5, "", False, True)
    if (mX)
    {
        MouseMove, %mX%, %timeLineY%, 1
        Sleep, 100
        Send {LButton down}
    }    
}

scrollPlaylistTabStop()
{
    Send {LButton Up}
    scrollingPlaylistTab := False
    MouseMove, %scrollingPlaylitMx%, %scrollingPlaylitMy%, 0
    unfreezeMouse()
}


/*
setPlaylistLoop()
{
    Send {CtrlDown}{LButton Down}{CtrlUp}
    KeyWait, LButton
    savePlaylistSongPos()
    Send {LButton Up}
    Sleep, 100
    loadSavedPlaylistSongPos()
}

savePlaylistSongPos()
{
    midiRequest("save_load_song_pos", 1)
}

loadSavedPlaylistSongPos()
{
    midiRequest("save_load_song_pos", 0)
}
*/
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
        ;bringPlaylist(False)        
        bringStepSeq(False)
    }

    if (rewind)
        key := "NumpadMult"
    else
        key := "NumpadDiv"
    
    i := 100 
    while ((InStr(A_ThisHotkey, "XButton1") and !xbutton1Released) or (InStr(A_ThisHotkey, "XButton2") and !xbutton2Released))
    ;while ((A_ThisHotkey == "XButton1" and !xbutton1Released) or (A_ThisHotkey == "XButton2" and !xbutton2Released))
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

