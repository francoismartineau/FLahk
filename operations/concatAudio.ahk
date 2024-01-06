toggleShowConcatAudio()
{
    if (ConcatAudioShown)
        hideConcatAudio()
    else
        showConcatAudio()    
}


pickConcatAudioPaths(n)
{
    packsPath := Paths.packs
    Switch n
    {
    Case 1:
        FileSelectFolder path, %packsPath%,,`t
        if (path)
        {
            ConcatAudioPaths[1] := path
            SplitPath, path, ConcatAudioFolder1
        }
    Case 2:
        FileSelectFolder path, packsPath,,`t
        if (path)
        {
            ConcatAudioPaths[2] := path
            SplitPath, path, ConcatAudioFolder2
        }
    Case 3:
        FileSelectFolder path, %packsPath%,,`t
        if (path)
        {
            ConcatAudioPaths[3] := path
            SplitPath, path, ConcatAudioFolder3
        }
    Case 4:
        FileSelectFolder path, %packsPath%,,`t
        if (path)
        {
            ConcatAudioPaths[4] := path
            SplitPath, path, ConcatAudioFolder4
        }
    Case 5:
        FileSelectFolder path, %packsPath%,,`t
        if (path)
        {
            ConcatAudioPaths[5] := path
            SplitPath, path, ConcatAudioFolder5
        }
    }
    updateConcatAudioPath(n)
}

disableConcatAudioPath(n)
{
    ConcatAudioPaths[n] := ConcatAudioFolderEmpty
    Switch n
    {
    Case 1:
        ConcatAudioFolder1 := ConcatAudioFolderEmpty
    Case 2:
        ConcatAudioFolder2 := ConcatAudioFolderEmpty
    Case 3:
        ConcatAudioFolder3 := ConcatAudioFolderEmpty
    Case 4:
        ConcatAudioFolder4 := ConcatAudioFolderEmpty
    Case 5:
        ConcatAudioFolder5 := ConcatAudioFolderEmpty
    }
    updateConcatAudioPath(n)
}

getRandomSoundDir()
{
    dir := SysCommand(Paths.python " " Paths.ConcatAudio "\getRandomSoundDir.py")
    return dir
}

concatAudioRun()
{
    if (PreGenBrowser.running)
    {
        hideMsgRefresh()
        dir := PreGenBrowser.genLnkDir()
        pathsArg = "%dir%"
    }
    else
    {
        i := 1
        pathsArg := ""
        while (i <= ConcatAudioPaths.MaxIndex())
        {
            if (ConcatAudioPaths[i] != ConcatAudioFolderEmpty)
            {
                p := removeBreakLines(ConcatAudioPaths[i])
                pathsArg = %pathsArg% "%p%"
            }        
            i := i + 1
        }
    }
    if (!pathsArg)
    {
        msgTip("Choose a folder.")
        return
    }

    num := LinearToLogarithmic(ConcatAudioNumSliderVal, true)
    GuiControlGet, forceNum,, ConcatAudioForceNumToggle
    if (ConcatAudioLenToggle)
    {
        len := LinearToLogarithmic(ConcatAudioLenSliderVal)
        gate := 0
    }
    else if (ConcatAudioGateToggle)
    {
        gate := ConcatAudioGateSliderVal
        len := 0
    }
    pythonPath := Paths.python
    cmd = cmd.exe /q /c %pythonPath%
    concatAudioPath := Paths.ConcatAudio
    cmd = %cmd% %concatAudioPath%\concat_audio.py
    cmd = %cmd% --paths %pathsArg%
    cmd = %cmd% --num %num%
    if (forceNum)
        cmd = %cmd% --forceNum
    cmd = %cmd% --len %len%
    cmd = %cmd% --gate %gate%
    if (PreGenBrowser.running)
        cmd = %cmd% --preGenBrowser
    if (ConcatAudioBpmToggle)
        cmd = %cmd% --bpmFileName
    if (PreGenBrowser.debugConcatAudio)
    {
        clipboard := cmd
        msg("Run manually.`r`nclipboard: " cmd)
    }
    else
    {
        response := SysCommand(cmd)
        concatAudioReachFile(response)
    }
        
    if (PreGenBrowser.running)
        PreGenBrowser.stop()
}

concatAudioReachFile(response)
{
    concatAudioResponseGetFilesRows(response, dirRow, fileRow)
    browsePacks(dirRow, "fileRow", fileRow)
}

concatAudioResponseGetFilesRows(response, ByRef dirRow, ByRef fileRow)
{
    caseSensitive := True
    dirFlag := "dirPos|"
    endFlag := "|"
    dirPos := InStr(response, dirFlag, caseSensitive) + StrLen(dirFlag)
    dirEndPos := InStr(response, "|", caseSensitive, dirPos) - dirPos
    dirRow := SubStr(response, dirPos, dirEndPos)
    fileFlag := "filePos|"
    filePos := InStr(response, fileFlag, caseSensitive, dirEndPos) + StrLen(fileFlag)
    fileEndPos := InStr(response, endFlag, caseSensitive, filePos) - filePos
    fileRow := SubStr(response, filePos, fileEndPos)
}


moveMouseToConcatAudio()
{
    WinActivate, ahk_id %FLahkGuiId2%
    moveMouse(783, 126)
}