global leftScreenWindowsShown := True

moveWindows()
{
    return
    WinMaximize, ahk_class TFruityLoopsMainForm 
    playlistId := Playlist.bringWin(False)
    movePlaylist(playlistId)
    if (leftScreenWindowsShown)
    {
        moveEventEditor()
        PianoRoll.moveWin()
        moveMixer()
        moveMasterEdison()
        ;moveScreenKeyboard()
        moveKnobsWin()
    }
    moveScriptOutput()
    bringHistoryWins()
    HideTaskbar(True)
}

moveScreenKeyboard()
{
    if (!WinExist("ahk_class TTouchKeybForm"))
    {
        WinGet, id, ID, A
        Send {AltDown}{F7}{AltUp}
        waitNewWindowOfClass("TTouchKeybForm", id)
    }
    WinMove, ahk_class TTouchKeybForm,, 0, 1050, 1922, 135
}

moveKnobsWin()
{
    WinGet, knobsWinId, ID, Control Surface
    WinMove, ahk_id %knobsWinId%,,  240, 962, 1680, 118
}

moveEventEditor(eventEditorId = "")
{
    global Mon1Left, Mon1Right, Mon1Bottom
    if (!eventEditorId)
        WinGet, eventEditorId, ID, Events -
    WinRestore, ahk_id %eventEditorId%
    evX := Mon1Left
    evY := 1027
    evW:= Mon1Right - evX 
    evH := Mon1Bottom - evY
    WinMove, ahk_id %eventEditorId%,, %evX%, %evY%, %evW%, %evH%
    WinActivate, ahk_id %eventEditorId%
}

movePlaylist(playlistId)
{
    WinRestore, ahk_id %playlistId%
    WinMove, ahk_id %playlistId%,, 240, 82, 1680, 908
}

moveMixer()
{
    global Mon1Left, Mon1Right, Mon1Bottom
    WinActivate, ahk_class TFXForm    
    WinRestore, ahk_class TFXForm
    mxX := Mon1Left
    mxY := 1027
    mxW := Mon1Right - mxX 
    mxH := Mon1Bottom - mxY
    WinMove, ahk_class TFXForm,, %mxX%, %mxY%, %mxW%, %mxH%    
}

moveMixerMenu()
{
    res := getMixerMenuPos()
    mixerMenuX := res[1]
    mixerMenuY := res[2]
    WinMove, ahk_id %MixerMenuId%,, %mixerMenuX%, %mixerMenuY%
}

hidePianoRoll()
{
    moveMixer() 
    moveMixerMenu()
    moveMasterEdison()
    WinGet, pianoRollId, ID, ahk_class TEventEditForm, Piano roll
    WinClose, ahk_id %pianoRollId%
}

moveMasterEdison()
{
    WinGet, edisonId, ID, Master Edison
    WinRestore, ahk_id %edisonId%
    WinMove, ahk_id %edisonId%,, %Mon1Left%, %Mon1Top%, %Mon1Width%, 459
}


moveScriptOutput()
{
    WinGet, winId, ID, ahk_class TPythonForm
    if (winId)
    {
        WinMove, ahk_id %winId%,, -916, 783, 630, 680
        WinActivate, ahk_id %winId%
    }
}

; ------------------------------

Class MoveWin
{
    switchMon(dir, winId := "")
    {
        if (winId == "")
            WinGet, winId, ID, A
        MoveWin.__initMonYdiff()
        WinGetPos, winX, winY,,, ahk_id %winId%
        Switch dir
        {
        Case "left":
            MoveWin.__switchMonLeft(winX, winY, winId)
        Case "right":
            MoveWin.__switchMonRight(winX, winY, winId)
        }
        MoveWin.__apply(winX, winY, winId)
    }
    __switchMonLeft(ByRef winX, ByRef winY, winId)
    {
        if (winX >= Mon2Left)
        {
            winX -= Mon2Width
            winY += MoveWin.monYdiff
        } 
    }
    __switchMonRight(ByRef winX, ByRef winY, winId)
    {
        if (winX < Mon1Right)
        {
            winX += Mon1Width
            winY -= MoveWin.monYdiff
        }
    }    
    __apply(ByRef winX, ByRef winY, winId, moveRight := False)
    {
        MoveWin.__moveAndKeepInScreen(winX, winY, winId, moveRight)
        centerMouse(winId)
    }
    static __nudgeWinSpeed := 100
    nudge(dir, winId := "")
    {
        if (winId == "")
            WinGet, winId, ID, A
        MoveWin.__initMonYdiff()
        WinGetPos, winX, winY,,, ahk_id %winId%
        Switch dir
        {
        Case "up":
            MoveWin.__nudgeUp(winX, winY, winId)
        Case "down":
            MoveWin.__nudgeDown(winX, winY, winId)
        Case "left":
            MoveWin.__nudgeLeft(winX, winY, winId)
        Case "right":
            MoveWin.__nudgeRight(winX, winY, winId)
        }
    }
    __nudgeUp(ByRef winX, ByRef winY, winId)
    {
        winY -= MoveWin.__nudgeWinSpeed
        MoveWin.__apply(winX, winY, winId)
    }   
    __nudgeDown(ByRef winX, ByRef winY, winId)
    {
        winY += MoveWin.__nudgeWinSpeed
        MoveWin.__apply(winX, winY, winId)
    }   
    __nudgeLeft(ByRef winX, ByRef winY, winId)
    {
        while (keyDown("XButton1"))
        {
            wasInMon2 := winX >= Mon2Left
            winX -= MoveWin.__nudgeWinSpeed
            isInMon1 := winX < Mon1Right
            if (wasInMon2 and isInMon1)
                winY += MoveWin.monYdiff
            MoveWin.__apply(winX, winY, winId)
        }
    }             
    __nudgeRight(ByRef winX, ByRef winY, winId)
    {
        WinGetPos,,, winW,, ahk_id %winId%
        while (keyDown("XButton2"))
        {
            wasInMon1 := winX < Mon1Right
            winX += MoveWin.__nudgeWinSpeed
            isInMon2 := winX+winW >= Mon2Left
            if (wasInMon1 and isInMon2)
                winY -= MoveWin.monYdiff
            MoveWin.__apply(winX, winY, winId, True)
        }        
    }
    static monYdiff
    __initMonYdiff()
    {
        if (MoveWin.monYdiff == "")
            MoveWin.monYdiff := Abs(Mon2Top - Mon1Top)
    }      
    __moveAndKeepInScreen(ByRef winX, ByRef winY, winId, moveRight := False)
    {
        WinGetPos,,, winW, winH, ahk_id %winId%
        mon := MoveWin.__getMon(winX)
        if (winX < %mon%Left)
            winX := %mon%Left
        else if (winX+winW >= %mon%Right)
        {
            if (moveRight)
                winX := Mon2Left
            else
                winX := Mon1Right - winW
        }
        mon := MoveWin.__getMon(winX)
        if (winY < %mon%Top)
            winY := %mon%Top
        else if (winY+winH > %mon%Bottom)
            winY := %mon%Bottom - winH        
        WinMove, ahk_id %winId%,, %winX%, %winY%
    }   
    __getMon(winX)
    {
        if (winX >= Mon2Left)
            mon := "Mon2"
        else
            mon := "Mon1"  
        return mon
    }
    centerInMon(winId) 
    {
        if (!winExists(winId))
            return
        WinGetPos, winX, winY, winW, winH, ahk_id %winId%
        mon := MoveWin.__getMon(winX)
        horiCenter := %mon%Width/2 + %mon%Left
        vertiCenter := %mon%Height/2 + %mon%Top
        winX := horiCenter - winW/2
        winY := vertiCenter - winH/2
        WinMove, ahk_id %winId%,, %winX%, %winY%            
    }
}




; ------------------------------
upperMenuMoveWindowIfNecessary()
{
    WinGetPos,, y,,, ahk_class TPluginForm
    if ((x >= 0 and y > 550) or (x < 0 and y > 1210))
        WinMove, ahk_class TPluginForm,,, 550
}

clearWayToMouse(desiredWinId, newWinX, newWinY)
{
    res := False
    if (!winExists(desiredWinId))
    {
        msg("clearWayToMouse(): win doesn't exist")
        return res
    }
    CoordMode, Mouse, Screen
    toolTip("clearing way to mouse")
    while (True)
    {
        MouseGetPos,,, mWinId
        if (mWinId == desiredWinId)
        {
            res := True
            break
        }
        else
        {
            WinMove, ahk_id %mWinId%,, %newWinX%, %newWinY%
            newWinX := newWinX + 10 + randInt(1, 10)
            newWinY := newWinY + 10 + randInt(1, 10)
        }
        Sleep, 10
    }
    toolTip()
    CoordMode, Mouse, Client
    return res
}