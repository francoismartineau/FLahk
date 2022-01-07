global preGenBrowsing := False
global preGenBrowsingSounds := []
global preGenBrowsingDir := packsPath "\_gen\_preGenBrowsing"
global preGenBrowsingCurrBackupNum := 
global preGenBrowsingCurrBackupFile := 
global debugKeepPreGenBrowsingDir := True

class PreGenBrowser
{
    static running := False
    start()
    {
        this.browse()
        PreGenBrowser.running := True
        msgRefreshCondition := "msgRefreshPreGenCondition"
        startMsgRefresh(["Win:: pick sound      RClick::rm sound", , "Esc:: abort", "Alt scr down:: run        Alt scr up::browse", "--------------"])
        startHighlight("browser")
        this.backupFile := this.__createNewBackupFile()
    }

    browse()
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
    addSound(isFolder := False)
    {
        makeSureMainFLWinActive()
        hideMsgRefresh()
        propertiesWinId := openFileProperties(isFolder)
        if (propertiesWinId)
        {
            Sleep, 1
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
                    preGenBrowsingCurrBackupFile.WriteLine(soundFilePath)
                }
            }
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

        if (!waitForWindowsCtxMenu())
        {
            hideHighlight()
            msg("no windows ctx menu found")
            return        
        }
        WinGet, currWinId, ID, A
        Send {Up}{Enter}
        propertiesWinId := waitNewWindowOfClass("#32770", currWinId)
        if (propertiesWinId == "")
        {
            hideHighlight()
            msg("no properties window found")
            return        
        }
        return propertiesWinId
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
            soundDir := copyTextWithClipboard()
            if  (FileExist(soundDir) == "D")
                break

            moveMouse(340, y)
            Click
            Send {LButton Down}
            moveMouse(54, y, "Client", 2)
            Send {LButton Up}
            soundDir := copyTextWithClipboard()
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
            soundFileName := soundDir "\" copyTextWithClipboard()
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
        if (!debugKeepPreGenBrowsingDir)
            clearPreGenBrowsingDir()
        preGenBrowsingCurrBackupFile.close()
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


    ; -- File Backup -------------------------
    __createNewBackupFile()
    {
        fileName := this.__getNewBackupFileName()
        file := FileOpen(fileName, "w")
        return file
    }


    __getNewBackupFileName()
    {
        backupFolder := this.__getBackupFolder()
        num := this.__getLatestBackupNum(backupFolder)
        num += 1
        this.currBackupNum := num
        Pack := "0000"
        fileNum := SubStr(Pack, 1, StrLen(Pack) - StrLen(num)) . num
        fileName := folder "\" fileNum ".backup"
        return fileName
    }

    __getBackupFolder()
    {
        backupFolder := savesFolderPath "\preGenBrowsingBackups"
        if (!InStr(FileExist(backupFolder), "D"))
        {
            FileCreateDir, %backupFolder%
        }
        return backupFolder
    }

    __getLatestBackupNum(folder := "")
    {
        if (folder == "")
            folder := this.__getBackupFolder()
        num := 0
        Loop %folder%\*.*
        {
            name := StrSplit(A_LoopFileName, ".")[1]
            if name is integer
                num := name + 0
        }
        return num
    }

    __usedPrevBackedUpBrowsing()
    {
        this.currBackupNum -= 1
        if (this.currBackupNum < 0)
            this.currBackupNum := this.__getLatestBackupNum()
    }    
}

; ----------------------------------------
