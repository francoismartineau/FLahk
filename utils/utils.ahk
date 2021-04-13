; -- Mouse ------------------------------------------
moveMouse(x := "", y := "", mode := "Client", speed := 0)
{
    CoordMode, Mouse, Screen
    static := betweenScreensX := 0
    static := betweenScreensY := 870

    if (x == "")
        MouseGetPos, x
    else if (y == "")
        MouseGetPos,, y

    if (mode == "Client")
    {
        WinGetPos, winX, winY,,, A
        x := winX + x
        y := winY + y
    }

    MouseGetPos, mx
    crossScreen := (mx < 0 and x > 0) or (x < 0 and mx > 0)
    if (crossScreen)
    {
        MouseMove, %betweenScreensX%, %betweenScreensY%, %speed%
        MouseMove, %x%, %betweenScreensY%, %speed%
    }

    MouseMove, %x%, %y%, %speed%

    CoordMode, Mouse, Client
}

mouseGetPos(ByRef mX, ByRef mY,  mode := "Client")
{
    CoordMode, Mouse, %mode%
    MouseGetPos, mX, mY
    CoordMode, Mouse, Client
}

centerMouse(winId := "", speed := 1.5)
{
    if (winId == "")
        WinGet, winId, ID, A

    CoordMode, Mouse, Screen
    WinGetPos, winX, winY, winW, winH, ahk_id %winId%
    MouseGetPos, currMouseX

    if (isMixer(winId))
    {
        mX := 1747
        mY := mixerSlotIndexToY(mixerSlotIndex)
    }
    else if (isStepSeq(winId))
    {
        mX := 220
        mY := getFirstSelChannelY() + 10      
    }
    else if (isPianoRoll(winId))
    {
        loop := [98, 12]
        notes := [261, 464]
        menu := [302, 823 ]
        loc := weightedRandomChoice([[loop,2], [notes,4], [menu, 1]])
        mX := loc[1]
        mY := loc[2]
    }
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
    else
    {
        mX := winW/2
        mY := winH/2
    }
    mX := mX + winX
    mY := mY + winY
    moveMouse(mX, mY, "Screen", speed)
    CoordMode, Mouse, Client

    global retrieveMouse
    retrieveMouse := False
}

QuickClick(x, y, param := "")
{
    moveMouse(x, y)
    Click, %param%
}

mouseOverKnobsWin()
{
    MouseGetPos,,, winId
    return isPlugin(winId) or isMixer(winId) or isWrapperPlugin(winId) ;or isStepSeq(winId) non parce que copy score
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
        if (isPlaylist(winId))
        {
            res := 278 < mx and 48 < my
        }
        else if (isPianoRoll(winId))
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

doubleClicked()
{
    global doubleClickTime
    return A_PriorHotkey == "~LButton" and A_TimeSincePriorHotkey <= doubleClickTime
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

getCurrentProjSaveFilePath()
{
    res := False
    Send {CtrlDown}{ShiftDown}s{ShiftUp}{CtrlUp}
    savePromptId := waitNewWindowOfClass("#32770", id)
    if (savePromptId)
    {
        cliboardSave := clipboard
        Sleep, 50
        Send {CtrlDown}c{CtrlUp}
        projName := clipboard
        if (projName != "untitled.flp")
        {
            WinMove, ahk_id %savePromptId%,,,, 642, 579
            quickClick(313, 19)
            Send {CtrlDown}c{CtrlUp}
            folderName := clipboard
            currProjPath := folderName "\" projName
            createSaveFilePath(folderName, projName)
            res := currProjPath
        }
        WinClose, ahk_id %savePromptId%
        clipboard := cliboardSave
    }
    return currProjPath
}

createSaveFilePath(folderName, projName)
{
    folderNameList := StrSplit(folderName, "\")
    folderName := folderNameList[folderNameList.MaxIndex()]
    if (folderName == "")
        folderName := folderNameList[folderNameList.MaxIndex()-1]

    savesFileFolder := savesFolderPath "\" folderName
    if (FileExist(savesFileFolder) != "D")
        FileCreateDir, %savesFileFolder%

    projName := StrSplit(projName, ".")[1]
    
    savesFilePath := savesFileFolder "\" projName ".ini"
    return savesFilePath
}

setPixelCoordMode(mode)
{
    pixelCoordMode := mode
    CoordMode, Pixel, %mode%
}

mute()
{
    midiO_1.controlChange(116, 0, 2)
}

unmute()
{
    midiO_1.controlChange(116, 100, 2)
}

renderInPlace()
{
    mixerId := bringMixer(False)
    diskRecX := 83
    diskRecY := 423
    if (colorsMatch(82, 418, [0xB0B7BA], 20))      ; not armed ?
    {
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
; ----


; -- Wallpaper ---
setFlahkWallpaper()
{
    wallPaperFolder := "C:\Util2\FLahk\wallpapers\"
    wallpapers := ["hotkeys"] ;, "mixer"]
    w := wallPaperFolder . randomChoice(wallpapers) ".bgi"
    cmd = C:\Util3\Bginfo.exe %w% /silent /timer 0
    Run, %cmd%
}

setBlackWallpaper()
{
    cmd = C:\Util3\Bginfo.exe C:\Util2\FLahk\wallpapers\wallpaperBlack.bgi /silent /timer 0
    Run, %cmd%

}
;-------

exitFlahk()
{  
    msg("close", 100) 
	sendAllKeysUp()
    setBlackWallpaper() 
	GuiClose:
    WinGet, codeId, ID, ahk_exe Code.exe
    if (codeId)
    {
        WinActivate, ahk_id %codeId%
        centerMouse(codeId)
    }
	ExitApp
}

keepNumLockOn()
{
    if (!GetKeyState("NumLock", "T"))
        SetNumLockState, On
}

; ---- hideShow FLahk ---------------------------------------
hideShowFLahk()
{
    global FLahkGuiId1, FLahkGuiId2 ;, FLahkBackgroundGuiId
    global leftScreenWindowsShown

    if (!WinExist("ahk_exe FL64.exe"))
        exitFlahk()   

    usingFL := WinActive("ahk_exe FL64.exe") or WinActive("ahk_id "FLahkGuiId1) or WinActive("ahk_id "FLahkGuiId2) or WinActive("ahk_class #32770 ahk_exe ahk.exe")
    FLahkOpen := FLahkIsOpen()
    maxedWin := rightScreenMaximizedWin()

    if (usingFL and !FLahkOpen and !maxedWin)
    {
        WinShow, ahk_id %FLahkGuiId1%
        WinShow, ahk_id %FLahkGuiId2%
        ;if (leftScreenWindowsShown)
        ;    WinActivate, ahk_id %FLahkBackgroundGuiId%
        WinActivate, ahk_exe FL64.exe
        startWinMenusClock()
        startWinHistoryClock()
        startMouseCtlClock()
    }
    else if ((!usingFL or maxedWin) and FLahkOpen)
    {
        ;WinHide, ahk_id %FLahkBackgroundGuiId%
        WinHide, ahk_id %FLahkGuiId1%
        WinHide, ahk_id %FLahkGuiId2%
        stopWinMenusClock()
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