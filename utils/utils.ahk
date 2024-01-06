; -- Mouse ------------------------------------------
centerMouse(winId := "", speed := 1.5)
{
    if (!isActive(winId))
        activateWin(winId)
        
    res := True
    if (winId == "")
        WinGet, winId, ID, A

    if (removeFromHistoryIfInvisible(winId))
    {
        res := False
        return res
    }

    WinGetPos, winX, winY, winW, winH, ahk_id %winId%
    ;mouseGetPos(currMouseX, _, "Screen")

    if (isMixer(winId))
    {
        mX := 1747
        mY := mixerSlotIndexToY(mixerSlotIndex)
    }
    else if (StepSeq.isWin(winId))
    {
        mX := 220
        mY := StepSeq.getFirstSelChanY() + 10      
    }
    /*
    else if (PianoRoll.isWin(winId))
    {
        loop := [98, 12]
        notes := [261, 464]
        menu := [302, 823 ]
        loc := weightedRandomChoice([[loop,2], [notes,4], [menu, 1]])
        mX := loc[1]
        mY := loc[2]
    }
    */
    else if (isRev())
    {
        mX := 506
        mY := 67        
    }
    else if (isPatcherSlicex(winId))
    {
        mX := 165
        mY := 419
    }
    else if (isPatcherSampler(winId))
    {
        mX := 126
        mY := 153        
    }
    else if (isDistructor(winId))
    {
        mX := 878
        mY := 55           
    }
    else if (isProbablyEq(winId))
    {
        mX := 606
        mY := 295         
    }    
    else
    {
        mX := winW/2
        mY := winH/2
    }

    mX := mX + winX
    mY := mY + winY
    sencondMouseX := mX
    sencondMouseY := mY
    ;msg(sencondMouseX "  , " sencondMouseY)
    ;showSecondMouse()
    moveMouse(mX, mY, "Screen", speed)
    ;restoreWin(winId)

    global retrieveMouse
    retrieveMouse := False
    return res
}

quickClick(x, y, param := "")
{
    moveMouse(x, y)
    Click, %param%
}

mouseOverKnobsWin()
{
    MouseGetPos,,, winId
    return isPlugin(winId) or isMixer(winId) or isWrapperPlugin(winId) ;or StepSeq.isWin(winId) non parce que copy score
}

mouseOverEventEditorZoomSection()           ; The little square top right. (Why did I make this function?)
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mx, my, winId
    CoordMode, Mouse, Client

    if (isEventEditForm(winId))
    {
        WinGetPos, winX, winY,,, ahk_id %winId%
        mx := mx - winX
        my := my - winY
        if (Playlist.isWin(winId))
        {
            res := 278 < mx and 48 < my
        }
        else if (PianoRoll.isWin(winId))
        {
            res := 72 < mx and 44 < my and mx < 1897 and my < 810     

        }
        else if (isEventEditor(winId))
        {
            res := mx < 1910 and 49 < my
        }
    }
    return res
}

mouseOverMainFileMenu(row := "")
{
    res := False
    winId := mouseGetPos(mX, mY, "Screen")
    WinGetClass, winClass, ahk_id %winId%
    if (winClass == "TQuickPopupMenuWindow" and mY <= 465 and mX <= 185  and mx >= 6 and mY >= 38)
    {
        prevMode := setPixelCoordMode("Screen")
        menuOpen := colorsMatch(10, 7, [0x3a4e4f])
        if (menuOpen)
        {
            Switch row
            {
            Case "":
                res := True
            Case "new":
                res := colorsMatch(8, 47, [0x5e6c75])
            }
        setPixelCoordMode(prevMode)
        }
    }
    return res
}



global doubleClickTime := DllCall("User32\GetDoubleClickTime")
doubleClicked()
{
    return InStr(A_PriorHotkey, "LButton") and A_TimeSincePriorHotkey <= doubleClickTime and InStr(A_ThisHotkey, "LButton")
}
; ----


; -- Misc -------------------------------------
sendDelete()
{
    waitForModifierKeys()
    isMEd := isMasterEdison()
    if (isMEd)
    {
        mEdKeysActivated := colorsMatch(1762, 17, [0xD3D8DC])
        if (!mEdKeysActivated)
        {
            MouseGetPos, mX, mY
            moveMouse(1761, 20)
            Click
        }
    }
    Send {Delete}
    if (isMEd and !mEdKeysActivated)
    {
        moveMouse(1761, 20)
        Click
        moveMouse(mX, mY)
    }
}

winCoordsToScreenCoords(x, y)
{
    WinGetPos, winX, winY,,, A
    return [winX+x, winY+y]
}

renderInPlace()
{
    ; arm master track
    ; alt+r to  bring render win
    ; accept / abort
    mixerId := bringMixer(False)
    diskRecX := 82
    diskRecY := 399
    notArmed := colorsMatch(diskRecX, diskRecY, [0xB0B7BA])
    if (notArmed)
    {
        msg("not armed")
        moveMouse(diskRecX, diskRecY)
        Sleep, 100
        Click         
    }
    SendInput !r
    exportWinId := waitNewWindow(mixerId)
    moveMouse(244, 68)
    waitAcceptAbort(True, True)
    toolTip("rendering")
    waitNewWindow(exportWinId, 10000)
    toolTip()
    bringMixer(False)
    moveMouse(diskRecX, diskRecY)
    Sleep, 100
    Click     
}

winMenuOpen()
{
    
    winMenuCol := [0x282a2c]
    colVar := 10
    highlightedButtonCol := [0x535359]
    setPixelCoordMode("Screen")
    res := colorsMatch(643, 1024, winMenuCol, colVar) ; and colorsMatch(41, 1043, highlightedButtonCol)
    setPixelCoordMode("Client")
    return res
}

makeSureMainFLWinActive()
{
    WinGet, mainFlWinId, ID, ahk_class TFruityLoopsMainForm
    WinGet, activeWinId, ID, A
    if (activeWinId != mainFlWinId)
        WinActivate, ahk_id %mainFlWinId%
}
; ----


; -- Wallpaper ---
setFlahkWallpaper()
{
    wallPaperFolder := Paths.FLahk "\wallpapers\"
    wallpapers := ["hotkeys"] ;, "mixer"]
    w := wallPaperFolder . randomChoice(wallpapers) ".bgi"
    bginfoPath := Paths.BGinfo
    cmd = %bginfoPath% %w% /silent /timer 0
    Run, %cmd%
}

setBlackWallpaper()
{
    FLahkPath := Paths.FLahk
    bginfoPath := Paths.BGinfo
    cmd = %bginfoPath% %FLahkPath%\wallpapers\black.bgi /silent /timer 0
    Run, %cmd%

}
;-------

exitFlahk()
{  
    msg("close", 100) 
	sendAllKeysUp()
    setBlackWallpaper() 
	GuiClose:
    ;WinGet, codeId, ID, ahk_exe Code.exe
    ;if (codeId)
    ;{
    ;    WinActivate, ahk_id %codeId%
    ;    centerMouse(codeId)
    ;}
	ExitApp
}

; ---- hideShow FLahk ---------------------------------------
hideShowFLahk()
{
    global FLahkGuiId1, FLahkGuiId2 ;, FLahkBackgroundGuiId
    global leftScreenWindowsShown

    if (!WinExist("ahk_exe FL64.exe"))
        exitFlahk()   

    usingFL := WinActive("ahk_exe FL64.exe") or WinActive("ahk_id "FLahkGuiId1) or WinActive("ahk_id "FLahkGuiId2) or WinActive("ahk_class #32770 ahk_exe ahk.exe") or isAudacity() or isMelodyne() ;or WinActive("ahk_id " MouseCursorGuiId)
    FLahkOpen := FLahkIsOpen()
    ;maxedWin := rightScreenMaximizedWin()

    if (usingFL and !FLahkOpen) ; and !maxedWin)
    {
        showMainGuis()
        ;showSecondMouse()
        ;if (leftScreenWindowsShown)
        ;    WinActivate, ahk_id %FLahkBackgroundGuiId%
        WinActivate, ahk_exe FL64.exe
        startGuiClock()
        startWinHistoryClock()
        startMouseCtlClock()
    }
    ;else if ((!usingFL or maxedWin) and FLahkOpen)
    else if (!usingFL and FLahkOpen)
    {
        ;WinHide, ahk_id %FLahkBackgroundGuiId%
        ;hideSecondMouse()
        hideMainGuis()
        stopGuiClock()
        stopWinHistoryClock()
        stopMouseCtlClock()
    }
}

rightScreenMaximizedWin()
{
    WinGet, winId, ID, A
    WinGetPos, winX, winY, winW, winH, ahk_id %winId%
    return winX == 0 and winY == 0 and !isMainFlWindow(winId) and winW == Mon2Width and winH == Mon2Height
}

FLahkIsOpen()
{
    WinGet, Style, Style, ahk_id %FLahkGuiId1%
    Transform, Result1, BitAnd, %Style%, 0x10000000 ; 0x10000000  = is WS_VISIBLE.
    WinGet, Style, Style, ahk_id %FLahkGuiId2%
    Transform, Result2, BitAnd, %Style%, 0x10000000
    return Result1 <> 0 and Result2 <> 0
}
; ----