; -- Mouse ------------------------------------------
mouseGetPos(ByRef mX, ByRef mY,  mode := "Client")
{
    prevMode := setMouseCoordMode(mode)
    MouseGetPos, mX, mY
    setMouseCoordMode(prevMode)
}

centerMouse(winId := "", speed := 1.5)
{
    res := True
    if (winId == "")
        WinGet, winId, ID, A

    if (removeFromHistoryIfInvisible(winId))
    {
        res := False
        return res
    }


    restoreWin(winId)

    WinGetPos, winX, winY, winW, winH, ahk_id %winId%
    ;mouseGetPos(currMouseX, _, "Screen")

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
    showSecondMouse()
    moveMouse(mX, mY, "Screen", speed)

    global retrieveMouse
    retrieveMouse := False
    return res
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

; -- saveFile -------------------
saveProject()
{
    lastSaveTime := timeOfDaySeconds()
    if (projectIsSaved())
    {
        if (savesFilePath == "")
            freezeExecute("getCurrentProjFilePath")
        saveKnobSavesToFile()
        saveWinHistoriesToFile()
        sendinput ^s
    }
    else
    {
        sendinput ^s
        savePromptId := waitNewWindowOfClass("#32770", "")
        WinMove, ahk_id %savePromptId%,,,, 642, 579
    }
}

projectIsSaved()
{
    ; When a project isn't saved, username FranoisMartineau is displayed (top left). Look for that.
    ; x, y: from Martineau's t bar pixel to the right
    colorListX := 68
    colorListY := 52
    colorList := [0x9d9272, 0x4d5b82, 0x9eb6af]
    prevMode := setPixelCoordMode("Screen")
    res := !scanColorsLine(colorListX, colorListY, colorList)
    setPixelCoordMode(prevMode)
    return res
}

getCurrentProjFilePath()
{
    res := False
    Send {CtrlDown}{ShiftDown}s{ShiftUp}{CtrlUp}
    WinGet, savePromptId, ID, ahk_class #32770
    if (!savePromptId)
    {
        WinGet, id, ID, ahk_class TFruityLoopsMainForm
        toolTip("    waiting save prompt")
        savePromptId := waitNewWindowOfClass("#32770", id)
        toolTip()
    }
    if (savePromptId)
    {
        cliboardSave := clipboard
        clipboard := ""
        toolTip("copying project name")
        i := 0
        while (clipboard == "")
        {
            Sleep, 30
            Send {CtrlDown}c{CtrlUp}
            i += 1
            if (i > 100)
                return
        }
        toolTip()
        projName := clipboard
        if (projName != "untitled.flp")
        {
            WinMove, ahk_id %savePromptId%,,,, 642, 579
            moveMouse(313, 52)
            clipboard := ""
            toolTip("copying project folder")
            while (clipboard == "" or FileExist(folderName) != "D")
            {
                Sleep, 30
                Click
                Send {CtrlDown}ac{CtrlUp}
                folderName := clipboard
            }
            toolTip()
            currProjPath := folderName "\" projName
            getSaveFilePath(folderName, projName)
        }
        WinClose, ahk_id %savePromptId%
        clipboard := cliboardSave
    }
    updateGuiFilePath()
    return currProjPath
}

getSaveFilePath(folderName, projName)
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

loadSaveFileIfExists()
{
    res := False
    if (projectIsSaved())
    {
        if (savesFilePath == "")
            getCurrentProjFilePath()
        loadWinHistories()
        loadKnobSaves()
        res := True
    }
    else
    {
        sendinput ^s
        savePromptId := waitNewWindowOfClass("#32770", "")
        WinMove, ahk_id %savePromptId%,,,, 642, 579
        centerMouse(savePromptId)
    }
    return res
}

updateGuiFilePath()
{
    folderAndFileHierarchy := StrSplit(savesFilePath, "\")
    fileName := folderAndFileHierarchy[folderAndFileHierarchy.MaxIndex()]
    fileNameNoExtension := SubStr(fileName, 1, -4)
    folderName := folderAndFileHierarchy[folderAndFileHierarchy.MaxIndex() - 1]
    txt := folderName "/" fileNameNoExtension
    GuiControl, Main1:, ProjPathGui, -> %txt%
}
; -----


; -- Misc -------------------------------------
restoreWin(winId := "")
{

    if (winId == "")
        WinGet, winId, ID, A

    if (!isFLWindow(winId))
        return

    if (isMainFlWindow(winId) or isPianoRoll(winId))
    {
        WinMaximize, ahk_id %winId%
        return
    }

    WinGet, WinState, MinMax, ahk_id %winId%
    WinGetPos,,, winW, winH, ahk_id %winId%
    if (WinState == 1)  ; maximized
        WinRestore, ahk_id %winId%
    else if (winH < 40) ; FL minimized
    {
        moveMouse(winW-50, 20)
        Click           ; click bar button
    }
}

moveWinAtMouse(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    prevMode := setMouseCoordMode("Screen")
    MouseGetPos, mX, mY
    setMouseCoordMode(prevMode)
    WinGetPos,,, winW, winH, ahk_id %id%
    winX := mX - winW/2
    winY := mY - winH/2
    WinMove, ahk_id %id%,, winX, winY
}

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

retrieveWinPos(winX, winY, winId)
{
    WinGetPos, currWinX, currWinY,,, ahk_id %winId%
    if (winY != currWinY or winX != currWinX)
        WinMove, ahk_id %winId%,, %winX%, %winY%  
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
    ;WinGet, codeId, ID, ahk_exe Code.exe
    ;if (codeId)
    ;{
    ;    WinActivate, ahk_id %codeId%
    ;    centerMouse(codeId)
    ;}
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

    usingFL := WinActive("ahk_exe FL64.exe") or WinActive("ahk_id "FLahkGuiId1) or WinActive("ahk_id "FLahkGuiId2) or WinActive("ahk_class #32770 ahk_exe ahk.exe") or isAudacity() or isMelodyne() ;or WinActive("ahk_id " MouseCursorGuiId)
    FLahkOpen := FLahkIsOpen()
    ;maxedWin := rightScreenMaximizedWin()

    if (usingFL and !FLahkOpen) ; and !maxedWin)
    {
        WinShow, ahk_id %FLahkGuiId1%
        WinShow, ahk_id %FLahkGuiId2%
        showSecondMouse()
        ;if (leftScreenWindowsShown)
        ;    WinActivate, ahk_id %FLahkBackgroundGuiId%
        ;WinActivate, ahk_exe FL64.exe
        startWinMenusClock()
        startWinHistoryClock()
        startMouseCtlClock()
    }
    ;else if ((!usingFL or maxedWin) and FLahkOpen)
    else if (!usingFL and FLahkOpen)
    {
        ;WinHide, ahk_id %FLahkBackgroundGuiId%
        hideSecondMouse()
        hideMainGuis()
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