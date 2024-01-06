global masterEdisonSoundLeftX := 7
global masterEdisonSoundWidth := 1905
global masterEdisonSoundRightX := masterEdisonSoundLeftX + masterEdisonSoundWidth
global masterEdisonSoundUpY := 151
global masterEdisonSoundHeight := 254
global masterEdisonSoundBottomY := masterEdisonSoundUpY + masterEdisonSoundHeight
global masterEdisonRecModes := ["now", "onInput", "input", "onPlay"]

; -- High level --------------------------------------------------
masterEdisonTruncateAudio()
{
    res := waitToolTip("Currently doesn't work parce qu'il faudrait regarder plus globalement. Le fait que le signal aille de haut en bas ne signifie pas que c'est le silence. Il faudrait, une fois un silence trouvé, regarder à x distance pour voir si on ne retrouve pas du signal")
    if (!res)
        return
    threshY := masterEdisonTruncateAudioGetThreshY()
    choices := ["silence", "sound"]
    title := "Remove:"
    initIndex := 1
    mode := toolTipChoice(choices, title, initIndex)
    masterEdisonTruncateAudioDeleteSections(mode, threshY)
}

masterEdisonTruncateAudioGetThreshY()
{
    while (True)
    {
        res := waitToolTip("Mouse Y on threshold, Accept")
        if (!res)
            return
        mouseGetPos(mX, mY)
        mouseOverSound := (mX > masterEdisonSoundLeftX and mX < masterEdisonSoundRightX) and (mY > masterEdisonSoundUpY and mY < masterEdisonSoundBottomY)
        if (!mouseOverSound)
        {
            unfreezeMouse()
            msg("Place mouse over sound")
            freezeMouse()
        }
        else
            break
    }
    return mY
}

masterEdisonTruncateAudioDeleteSections(mode, threshY)
{
    reverse := mode == "sound"
    remove := reverse
    leftX := masterEdisonSoundLeftX
    while (True)
    {
        rightX := masterEdisonTruncateAudioScanSound(mode, threshY, leftX, reverse)
        moveMouse(leftX, threshY)
        msg(rightX)
        reverse := !reverse
        if (rightX and remove)
        {
            moveMouse(leftX, threshY)
            Send {LButton Down}
            moveMouse(rightX, threshY)
            Send {LButton Up}
            res := waitToolTip("delete?")
            if (!res)
                return
            Send {Delete}
        }
        else
            break

        remove := !remove
        leftX := rightX+1
    }

}

masterEdisonTruncateAudioScanSound(mode, threshY, leftX, reverse)
{
    cols := [0xD2D6E6]
    colVar := 30
    incr := 1
    width := masterEdisonSoundRightX - leftX
    colorsMatchDebug := True
    colorsMatchDebugTime := 1000
    rightX := scanColorsRight(leftX, threshY, masterEdisonSoundWidth, cols, colVar, incr, reverse)
    colorsMatchDebug := False
    return rightX
}
; ----


; --- Set Master Edison ------------------------------------------
masterEdisonTransport(mode)
{
    bringMasterEdison(False)
    Switch mode
    {
    Case "stop":
        mX := 142
        mY := 47
    Case "playPause":
        mX := 85
        mY := 47
    Case "rec":
        mX := 173
        mY := 48
    }
    moveMouse(mX, mY)
    Click
}

setMasterEdisonMode(mode, masterEdisonID := "")
{
    if (masterEdisonID == "")
        WinGet, masterEdisonID, ID, A
    if (isMasterEdison(masterEdisonID))
    {
        moveMouse(233, 50)
        toolTip(mode)
        currMode := getMasterEdisonRecMode()
        currIndex := hasVal(masterEdisonRecModes, currMode)
        index := hasVal(masterEdisonRecModes, mode)
        dist := index - currIndex
        if (dist < 0)
            dist := (4-currIndex) + index
        Loop %dist%
        {
            Sleep, 5
            Send {WheelDown}
            Sleep, 5
        }
    }
    toolTip()
}

armEdison()
{
    if (!edisonArmed())
        toggleArmEdison() 
}

unarmEdison()
{
    if (edisonArmed())
        toggleArmEdison()     
}

toggleArmEdison()
{
    MouseMove, 182, 49
    MouseClick
}
; ----


; -- Mouse move ------------------------------------------------
getReadyToDragFromMasterEdison()
{
    readyToDrag := True
    startHighlight("edisonDrag")     
    moveToMasterEdisonDrag()
}

moveToMasterEdisonDrag(bringEdison := True)
{
    if (bringEdison)
        bringMasterEdison(False)
    mX := 1833
    mY := 100  
    moveMouse(mX, mY)
}

dragSampleToEdison(mX := "", mY := "")
{
    if (mX == "" or mY == "")
    {
        prevCoordMode := setMouseCoordMode("Screen")
        MouseGetPos, mX, mY
        setMouseCoordMode(prevCoordMode)
    }

    if (!isMasterEdison(masterEdisonId))
        masterEdisonId := bringMasterEdison(False)
    if (isMasterEdison(masterEdisonId))
    {
        moveMouse(mX, mY, "Screen")
        Send {LButton down}
        toolTip("Click down")
        Sleep, 30
        WinActivate, ahk_id %masterEdisonId%
        moveMouse(926, 285)
        toolTip("Click down")
        Sleep, 30
        Send {LButton up}
        toolTip("Click up")
        Sleep, 30
        toolTip()
    }
    return masterEdisonId
}

scrollMasterEdison(dir)
{
    MouseGetPos, mX, mY
    record := [175, 50]
    onPlay := [231, 46]
    sound := [929, 279]
    if (dir == "down")
    {
        if (mx < record[1])
        {
            mx := record[1]
            my := record[2]
        }
        else if (mx < onPlay[1])
        {
            mx := onPlay[1]
            my := onPlay[2]            
        }
        else if (mx < sound[1])
        {
            mx := sound[1]
            my := sound[2] 
        }
        else
        {
            mx := record[1]
            my := record[2]            
        }
    }
    else if (dir == "up")
    {
        if (mx < record[1]+10)
        {
            mx := sound[1]
            my := sound[2]
        }
        else if (mx < onPlay[1]+10)
        {
            mx := record[1]
            my := record[2]            
        }
        else if (mx < sound[1]+10)
        {
            mx := onPlay[1]
            my := onPlay[2] 
        }
        else
        {
            mx := sound[1]
            my := sound[2]            
        }        
    }
    MouseMove, %mX%, %mY%, 0
}
; ----


; -- Vision -----------------------------------------------------
edisonArmed()
{
    x := 174
    y := 49
    col := [0xB62B08]
    colVar := 0
    ;colorsMatchDebug := True
    res := colorsMatch(x, y, col, colVar)
    ;colorsMatchDebug := False
    return res
}

getMasterEdisonRecMode()
{
    if (colorsMatch(211, 46, [0x9eb1bb]))
        res := "onPlay"
    else if (colorsMatch(206, 46, [0xaeafb6]))
        res := "onInput"
    else if (colorsMatch(225, 46, [0xa2c0c9]))
        res := "now"
    else if (colorsMatch(221, 46, [0x99b7b1]))
        res := "input"
    return res
}
; ----


; -- Mouse position ---------------------------------------------
mouseOverEdisonDrag()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY, winId
    CoordMode, Mouse, Client
    if (isMasterEdison(winId))
    {
        WinGetPos, winX, winY,,, ahk_id %winId%
        mX := mX - winX
        mY := mY - winY
        res := mX >= 1814 and mY <= 115 and my >= 85 and mX <= 1852
    }
    return res
}
; ----