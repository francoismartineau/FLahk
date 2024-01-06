class PreGenBrowser
{
    static sounds := []
    static running := False
    static backupFilePath := 
    static currBackupNum := 
    static latestBackupNum := 
    static lnkDir :=
    static defautlMsgHeader :=
    static debugConcatAudio := False
    start()
    {
        PreGenBrowser.running := True
        PreGenBrowser.backupFilePath := PreGenBrowser.__createNewBackupFile()
        PreGenBrowser.__initMsgRefresh()
        startHighlight("browser")        
        PreGenBrowser.browse()
    }

    __initMsgRefresh(supLines := "")
    {
        if (supLines == "")
            supLines := []   
        initLines := [PreGenBrowser.defautlMsgHeader]
        initLines.Push(supLines*)
        condition := "PreGenBrowser.msgRefreshDisplayCondition"
        startMsgRefresh(initLines, condition)
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
        propertiesWinId := PreGenBrowser.openFileProperties(isFolder)
        if (propertiesWinId)
        {
            Sleep, 50
            dirPath := PreGenBrowser.copyDirName(isFolder)
            if (dirPath)
            {
                soundPath := PreGenBrowser.getFilePath(dirPath)
                if (soundPath)
                {
                    soundName := PreGenBrowser.__getSoundName(soundPath)
                    msgRefreshAddLine(soundName)
                    PreGenBrowser.sounds.Push(soundPath)
                    PreGenBrowser.__addSoundToBackupFile(soundPath)
                }
            }
            WinClose, ahk_id %propertiesWinId%
        }
        startMsgRefreshClock()
    }



    addFolder()
    {
        PreGenBrowser.addSound(True)
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
        if (!propertiesWinId)
        {
            hideHighlight()
            msg("no properties window found")
            return        
        }
        return propertiesWinId
    }

    copyDirName(isFolder)
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
            if (!mouseOverWindowOfClass("#32770"))
                break
            Click
            Send {LButton Down}
            moveMouse(349, y, "Client", 2)
            Sleep, 2
            Send {LButton Up}
            soundDir := copyTextWithClipboard()
            if  (InStr(FileExist(soundDir), "D"))
                break

            moveMouse(340, y)
            Click
            Send {LButton Down}
            moveMouse(54, y, "Client", 2)
            Send {LButton Up}
            soundDir := copyTextWithClipboard()
            i += 1
        }
        if (!InStr(FileExist(soundDir), "D"))
        {
            hideHighlight()
            msg("Could not copy dir path: " soundDir)
            soundDir := ""
        }
        return soundDir
    }

    getFilePath(dirPath)
    {
        moveMouse(304, 86)
        i := 0
        while (mouseOverWindowOfClass("#32770") and !FileExist(filePath) and i < 5)
        {
            Click
            Send {Ctrl Down}a{Ctrl Up}
            Sleep, 10
            filePath := dirPath "\" copyTextWithClipboard()
            i += 1
        }
        if (!FileExist(filePath))
        {
            hideHighlight()
            msg("Could not copy filePath: " filePath)
            filePath := ""
        }
        return filePath
    }
    ; ----

    stop()
    {
        PreGenBrowser.sounds := []
        PreGenBrowser.clearLnkDir()
        PreGenBrowser.__clearEmptyBackups()
        stopHighlight()
        stopMsgRefresh()
        PreGenBrowser.running := False
    }

    msgRefreshDisplayCondition()
    {
        return mouseOverBrowser() or mouseOverAhkGui()
    }

    removeSound()
    {
        if (PreGenBrowser.sounds.MaxIndex() > 0)
        {
            PreGenBrowser.sounds.Pop()
            msgRefreshRemoveLine()
        }
    }

    genLnkDir()
    {
        PreGenBrowser.clearLnkDir()
        dir := PreGenBrowser.lnkDir
        FileCreateDir, %dir%
        for i, sound_path in PreGenBrowser.sounds
        {
            lnk_path := dir "\" i ".lnk"
            FileCreateShortcut, %sound_path%, %lnk_path%
        }
        return dir
    }

    clearLnkDir()
    {
        if (!PreGenBrowser.debugConcatAudio)
        {
            dir := PreGenBrowser.lnkDir
            FileRemoveDir, %dir%, 1
        }

    }

    __getSoundName(filePath)
    {
        pathList := StrSplit(filePath, "\")
        fileName := pathList[pathList.MaxIndex()]
        soundName := StrSplit(fileName, ".")[1]
        return soundName
    }


    ; -- File Backup -------------------------
    __createNewBackupFile()
    {
        PreGenBrowser.__clearEmptyBackups()
        num := PreGenBrowser.__getLatestBackupNum()
        PreGenBrowser.latestBackupNum := num + 1
        PreGenBrowser.currBackupNum := PreGenBrowser.latestBackupNum
        filePath := PreGenBrowser.__getBackupFileName(PreGenBrowser.currBackupNum)
        f := FileOpen(filePath, "w")
        f.close()
        return filePath
    }

    __getBackupFileName(num)
    {
        Pack := "0000"
        fileNum := SubStr(Pack, 1, StrLen(Pack) - StrLen(num)) . num
        backupFolder := PreGenBrowser.__getBackupFolder()
        fileName := backupFolder "\" fileNum ".backup"
        return fileName
    }

    __getBackupFolder()
    {
        backupFolder := savesFolderPath "\preGenBrowserBackups"
        if (!InStr(FileExist(backupFolder), "D"))
        {
            FileCreateDir, %backupFolder%
        }
        return backupFolder
    }

    __getLatestBackupNum()
    {
        backupFolder := PreGenBrowser.__getBackupFolder()
        num := 0
        Loop %backupFolder%\*.*
        {
            if (PreGenBrowser.__isBackupFileName(A_LoopFileName))
                num := 0 + StrSplit(A_LoopFileName, ".")[1]          
        }
        return num
    }

    useBackup(direction)
    {
        foudBackupFile := PreGenBrowser.__useBackupGetFileName(direction)
        if (!foudBackupFile)
            return
        f := FileOpen(PreGenBrowser.backupFilePath, "r")
        filePaths := readLines(f)
        f.close()
        PreGenBrowser.__filterPaths(filePaths)
        f := FileOpen(PreGenBrowser.backupFilePath, "r")
        PreGenBrowser.sounds := filePaths
        PreGenBrowser.__UseBackupUpdateMsgRefresh(direction)
    }

    __UseBackupUpdateMsgRefresh(direction)
    {
        if (direction == "last" or PreGenBrowser.currBackupNum == PreGenBrowser.latestBackupNum)
            supLine := "curr backup"
        else
            supLine := "backup " PreGenBrowser.currBackupNum
        PreGenBrowser.__initMsgRefresh([supLine])
        for _, s in PreGenBrowser.sounds
        {
            soundName := PreGenBrowser.__getSoundName(s)
            msgRefreshAddLine(soundName)
        }        
    }

    __useBackupGetFileName(direction)
    {
        success := False
        backupNum := PreGenBrowser.currBackupNum
        Switch direction
        {
        Case "prev":
            backupNum -= 1
            if (backupNum < 1)
                backupNum := PreGenBrowser.latestBackupNum
  
        Case "next":
            backupNum += 1
            if (backupNum > PreGenBrowser.latestBackupNum)
                backupNum := 1
        Case "last":
            backupNum := PreGenBrowser.latestBackupNum
        Default:
            msgRefreshMsg("direction arg should be ""prev"" or ""next""")
        }
        if (backupNum < 1)
            msgRefreshMsg("can't get previous PreGenBrowser backup")
        else
        {
            backupFilePath := PreGenBrowser.__getBackupFileName(backupNum)
            if (FileExist(backupFilePath))
            {
                success := True
                PreGenBrowser.backupFilePath := backupFilePath
                PreGenBrowser.currBackupNum := backupNum
            }
            else
                msgRefreshMsg("PreGenBrowser backup file doesn't exist: " backupFilePath)
        }
        return success
    }

    __filterPaths(ByRef filePaths)
    {
        i := 1
        while (i <= filePaths.MaxIndex())
        {
            path := filePaths[i]
            if (!FileExist(path))
                filePaths.RemoveAt(i)
            else
                i += 1
        }
    }

    __clearEmptyBackups()
    {
        backupFolder := PreGenBrowser.__getBackupFolder()
        fileNum := 0
        num := fileNum
        Loop %backupFolder%\*.*
        {
            if (!PreGenBrowser.__isBackupFileName(A_LoopFileName))
                continue
            currFileName := backupFolder "\" A_LoopFileName
            FileGetSize, size, %currFileName%
            if (size == 0)
                FileDelete, %currFileName%   

            num += 1
            fileNum := 0 + StrSplit(A_LoopFileName, ".")[1]
            if (fileNum != num)
            {
                newFileName := PreGenBrowser.__getBackupFileName(num)
                FileMove, %currFileName%, %newFileName%
            }
        }
    }

    __isBackupFileName(fileName)
    {
        nameExt := StrSplit(fileName, ".")
        name := nameExt[1]
        ext := nameExt[2]
        return StrLen(name) == 4 and ext == "backup" and name is integer
    }

    __addSoundToBackupFile(soundPath)
    {
        f := FileOpen(PreGenBrowser.backupFilePath, "a")
        f.WriteLine(soundPath)
        f.close()
    }
}

PreGenBrowser.lnkDir := Paths.packs "\_gen\_preGenBrowser"
msgHeader =
(
Win:: pick sound              RClick::rm sound
Esc:: abort                   <>^:: prev/next/last backup
Alt scr down:: run        Alt scr up::browse
--------------
)
PreGenBrowser.defautlMsgHeader := msgHeader