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

setMasterEdisonOnPlay(edisonID = "")
{
    if (edisonID == "")
        WinGet, edisonID, ID, A
    if (isMasterEdison(edisonID))
    {
        WinActivate, ahk_id %edisonID%
        Click, 233, 50
        Click, 225, 127
        if (!edisonArmed())
            toggleArmEdison()  
    }
}

setMasterEdisonOnInput(edisonID = "")
{
    if (edisonID == "")
        WinGet, edisonID, ID, A
    if (isMasterEdison(edisonID))
    {
        WinActivate, ahk_id %edisonID%
        Click, 238, 52
        Click, 234, 107  
        armed := edisonArmed() 
        if (armed)
            toggleArmEdison()  
    }
}

setOnInput(edisonID)
{
    WinActivate, ahk_id %edisonID%
    Click, 233, 50
    Click, 237, 83
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

moveToMasterEdisonDrag()
{
    bringMasterEdison(False)
    mX := 1833
    mY := 100  
    moveMouse(mX, mY)
}

dragSampleToEdison(mX, mY)
{
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
    hint := ""
    ;colorsMatchDebug := True
    res := colorsMatch(x, y, col, colVar, hint)
    ;colorsMatchDebug := False
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