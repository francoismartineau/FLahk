
pickConcatAudioPaths(n)
{
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
    updateConcatAudioPathText(n)
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
    updateConcatAudioPathText(n)
}

getRandomSoundDir()
{
    dir := SysCommand(pythonPath " " ConcatAudioPath "\getRandomSoundDir.py")
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
    cmd = cmd.exe /q /c %pythonPath%
    cmd = %cmd% %ConcatAudioPath%\concat_audio.py
    cmd = %cmd% --paths %pathsArg% --num %num% --len %len% --gate %gate%
    if (PreGenBrowser.running)
        cmd = %cmd% --browse 1
    ;clipboard := cmd
    ; replace with SysCommand() ?
    ComObjCreate("WScript.Shell").Exec(cmd).StdOut.ReadAll()
    if (PreGenBrowser.running)
        PreGenBrowser.stop()
}

moveMouseToConcatAudio()
{
    WinActivate, ahk_id %FLahkGuiId2%
    moveMouse(783, 126)
}