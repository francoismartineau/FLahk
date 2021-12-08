global preGenBrowsing := False
global preGenBrowsingSounds := []
global preGenBrowsingDir := "C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs\_gen\_preGenBrowsing"

startPreGenBrowsing()
{
    preGenBrowsingMove()
    preGenBrowsing := True
    msgRefreshCondition := "msgRefreshPreGenCondition"
    startMsgRefresh(["Win:: pick sound      RClick::rm sound", , "Esc:: abort", "Alt scr down:: run        Alt scr up::browse", "--------------"])
    startHighlight("browser")
}

preGenBrowsingMove()
{
    if (!isMainFlWindow())
        WinActivate, ahk_class TFruityLoopsMainForm  
    hideMsgRefresh()
    while (mouseOverBrowser() and closeCurrentlyOpenPacksFolder())
    {
    }
    folderChances := [1, 4, 4, 4, 2, 2, 1, 2]
    n := weightedRandomChoiceIndexOnly(folderChances)
    n += 10
    browsePacks(n, "preGen")
    unhideMsgRefresh()
}

;-- Add ------------------------
addPreGenSound(isFolder := False)
{
    makeSureMainFLWinActive()
    hideMsgRefresh()
    propertiesWinId := openFileProperties(isFolder)
    if (propertiesWinId)
    {
        Sleep, 1
        clipboardSave := clipboard
        soundDir := copySoundDir(isFolder)
        if (soundDir)
        {
            soundFilePath := copyFileName(soundDir)
            if (soundFilePath)
            {
                pathList := StrSplit(soundFilePath, "\")
                fileName := pathList[pathList.MaxIndex()]
                soundName := StrSplit(fileName, ".")[1]
                msgRefreshAddLine(soundName)
                preGenBrowsingSounds.Push(soundFilePath)
            }
        }
        clipboard := clipboardSave
        WinClose, ahk_id %propertiesWinId%
    }
    startMsgRefreshClock()
}

addPreGenFolder()
{
    addPreGenSound(True)
}


openFileProperties(isFolder)
{
    Click, Right
    Sleep, 10
    if (!waitforBrowserCtxMenu(isFolder))
    {
        hideHighlight()
        msg("no ctx menu found")
        return
    }
    Loop, 2
    {
        Sleep, 1
        Send {WheelUp}
    }
    Click


    y := -12
    ;Switch (windowsCtxMenuPos())
    ;{
    ;Case "over":
    ;    y := -12
    ;Case "under":
    ;    y := 556
    ;Default:
    ;    hideHighlight()
    ;    msg("no windows ctxmenu found")
    ;    return
    ;}

    MouseMove, 17, %y% , 0, R
    Click

    propertiesWinId := waitNewWindowOfClass("#32770", id)
    if (propertiesWinId == "")
        hideHighlight()
        msg("no propeties window found")
    return propertiesWinId
}

windowsCtxMenuPos()
{
    res := ""        ;unsel   ,sel
    ctxMenuCol := [0xf2f2f2, 0x90c8f6]
    mouseGetPos(mx, mY, "Screen")
    colorsMatchDebug := True
    prevMode := setPixelCoordMode("Screen")
    if (colorsMatch(mX+5, my-5, ctxMenuCol))
        res := "over"
    else if (colorsMatch(mX+5, my+5, ctxMenuCol))
        res := "under"
    colorsMatchDebug := False
    setPixelCoordMode(prevMode)
    return res
}


copySoundDir(isFolder)
{
    soundDir := ""
    i := 0
    
    while (!InStr(FileExist(soundDir), "D") and i < 5)
    {
        if (isFolder)
            y := 153
        else
            y := 190
        moveMouse(98, y)
        Click
        Send {LButton Down}
        moveMouse(349, y, "Client", 2)
        Sleep, 2
        Send {LButton Up}
        Send {Ctrl Down}c{Ctrl Up}
        Sleep, 1
        soundDir := clipboard 
        if  (FileExist(soundDir) == "D")
            break

        moveMouse(340, y)
        Click
        Send {LButton Down}
        moveMouse(54, y, "Client", 2)
        Send {LButton Up}
        Send {Ctrl Down}c{Ctrl Up}
        Sleep, 1
        soundDir := clipboard 
        i++
    }
    if (!InStr(FileExist(soundDir), "D"))
    {
        hideHighlight()
        msg("could not copy dir path: " soundDir, 10000)
        soundDir := ""
    }
    return soundDir
}

copyFileName(soundDir)
{
    i := 0
    moveMouse(304, 86)
    while (!FileExist(soundFileName) and i < 5)
    {
        Click
        Send {Ctrl Down}a{Ctrl Up}
        Sleep, 10
        Send {Ctrl Down}c{Ctrl Up}
        Sleep, 10
        soundFileName := soundDir "\" clipboard
        i++
    }
    if (!FileExist(soundFileName))
    {
        hideHighlight()
        msg("invalid: " soundFileName, 10000)
        soundFileName := ""
    }
    return soundFileName
}
; ----

stoppreGenBrowsing()
{
    preGenBrowsing := False
    hideMsgRefresh()
    resetMsgRefresh()
    stopHighlight()
    preGenBrowsingSounds := []
    clearPreGenBrowsingDir()
}

msgRefreshPreGenCondition()
{
    return mouseOverBrowser() or mouseOverAhkGui()
}

removePreGenSound()
{
    if (preGenBrowsingSounds.MaxIndex() > 0)
    {
        preGenBrowsingSounds.Pop()
        msgRefreshRemoveLine()
    }
}

createPreGenBrowsingDir()
{
    clearPreGenBrowsingDir()
    dir := preGenBrowsingDir
    FileCreateDir, %dir%
    for i, sound in preGenBrowsingSounds
    {
        path := dir "\" i ".lnk"
        FileCreateShortcut, %sound%, %path%
    }
    return dir
}

clearPreGenBrowsingDir()
{
    dir := preGenBrowsingDir
    FileRemoveDir, %dir%, 1
}
