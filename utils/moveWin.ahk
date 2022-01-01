global leftScreenWindowsShown := True
global moveWinSpeed := 100

moveWindows()
{
    WinMaximize, ahk_class TFruityLoopsMainForm 
    playlistId := bringPlaylist(False)
    movePlaylist(playlistId)
    if (leftScreenWindowsShown)
    {
        moveEventEditor()
        movePianoRoll()
        moveMixer()
        moveMasterEdison()
        moveRootPatcher()

        moveScreenKeyboard()
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

    ;msgTip("id: " knobsWinId)
    ;WinRestore, ahk_id %knobsWinId%
    WinMove, ahk_id %knobsWinId%,,  240, 933, 1680, 118
    ;;WinMove, WinTitle, WinText, X, Y, [Width, Height, ExcludeTitle, ExcludeText]
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
    WinMove, ahk_id %playlistId%,, 240, 82, 1680, 884
}

movePianoRoll(pianoRollId = "")
{
    if (!pianoRollId)
        WinGet, pianoRollId, ID, ahk_class TEventEditForm, Piano roll

    if (pianoRollId)
    {
        WinActivate, ahk_id %pianoRollId%
        WinMove, ahk_id %pianoRollId%,, -1920, 568, 1920, 1080
        WinMaximize, ahk_id %pianoRollId%
    }
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

moveRootPatcher()
{
    WinGet, rootPatcherId, ID, Root Patcher ahk_class TPluginForm
    WinRestore, ahk_id %rootPatcherId%
    WinMove, ahk_id %rootPatcherId%,, -1920, 568, 1920, 1080   
}

moveMasterEdison()
{
    global leftScreenWindowsShown
    if (leftScreenWindowsShown)
    {
        WinGet, edisonId, ID, Master Edison
        WinRestore, ahk_id %edisonId%
        WinMove, ahk_id %edisonId%,, -1920, 568, 1920, 459
    }
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

moveWinRightScreen(id = "")
{
    if (!id)
    WinGet, id, ID, A
    WinGetPos, x, y,,, ahk_id %id%
    if (x < 0)
    {
        x := x + 1920
        y := y - 560
        WinMove, ahk_id %id%,, %x%, %y%
        centerMouse(id)
    }
}

moveWinLeftScreen(id = "")
{
    if (!id)
        WinGet, id, ID, A
    WinGetPos, x, y,,, ahk_id %id%
    if (x > 0)
    {
        x := x - 1920
        y := y + 560	
        WinMove, ahk_id %id%,, %x%, %y%
        centerMouse(id)
    } 
}

moveWinUp()
{
    global Mon2Top, Mon1Top, Mon2Left
    global moveWinSpeed
    WinGet, id, ID, A
    WinGetPos, x, y,,, ahk_id %id%
    if (x > Mon2Left)
    {
        higherLimit := 82
    }
    else
    {
        higherLimit := Mon1Top
    }
    y := y - moveWinSpeed
    if (y < higherLimit)
        y := higherLimit
    WinMove, ahk_id %id%,, %x%, %y%
    centerMouse(id)
}

moveWinDown()
{
    global Mon2Bottom, Mon1Bottom, Mon2Left
    global moveWinSpeed
    WinGet, id, ID, A
    WinGetPos, x, y,, h, ahk_id %id%
    if (x > Mon2Left)
    {
        lowerLimit := Mon2Bottom
    }
    else
    {
        lowerLimit := Mon1Bottom
    }
    y := y + moveWinSpeed
    if (y + h > lowerLimit)
        y := lowerLimit - h
    WinMove, ahk_id %id%,, %x%, %y%
    centerMouse(id)
}

moveWinRight(key)
{  
    global Mon2Right, Mon2Left, Mon1Top
    global moveWinSpeed
    WinGet, id, ID, A
    WinGetPos, x, y, w, h, ahk_id %id%
    pressing := GetKeyState(key)
    while (pressing)
    {
        wasInLeftScreen := x + w < Mon2Left
        if (x + w < Mon2Right) 
            x := x + moveWinSpeed
        else
            x := Mon2Right - w
        isInRightScreen := x + w >= Mon2Left
        if (wasInLeftScreen and isInRightScreen)
        {
            x := Mon2Left
            y := y - Mon1Top
        }
        WinMove, ahk_id %id%,, %x%, %y%
        if (!isStepSeq(id))
            centerMouse(id)
        else
            moveMouse(14, 37)   ; avoid clicking on sel chan
        pressing := GetKeyState(key)
    }
}

moveWinLeft(key)
{   
    global Mon1Left, Mon2Left, Mon1Top
    global moveWinSpeed
    WinGetClass, class, A
    WinGet, id, ID, A
    WinGetPos, x, y, w, h, ahk_id %id%
    pressing := GetKeyState(key)
    while (pressing)
    {
        wasInRightScreen := x + w > Mon2Left
        if (x > Mon1Left)
            x := x - moveWinSpeed
        else
            x := Mon1Left
        isInLeftScreen := x < Mon2Left
        if (wasInRightScreen and isInLeftScreen)
        {
            x := Mon2Left - w
            y := y + Mon1Top
        }
        WinMove, ahk_id %id%,, %x%, %y%
        if (!isStepSeq(id))
            centerMouse(id)
        else
            moveMouse(14, 37)   ; avoid clicking on sel chan
        pressing := GetKeyState(key)
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
    CoordMode, Mouse, Screen
    while (True)
    {
        MouseGetPos,,, mWinId
        if (mWinId == desiredWinId)
            break
        else
        {
            WinMove, ahk_id %mWinId%,, %newWinX%, %newWinY%
            newWinX := newWinX + 10 + randInt(1, 10)
            newWinY := newWinY + 10 + randInt(1, 10)
        }
    }
    CoordMode, Mouse, Client
}