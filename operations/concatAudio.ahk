pickConcatAudioPaths(n)
{
    Switch n
    {
    Case 1:
        FileSelectFolder path, C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs,,`t
        if (path)
        {
            ConcatAudioPaths[1] := path
            SplitPath, path, ConcatAudioFolder1
        }
    Case 2:
        FileSelectFolder path, C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs,,`t
        if (path)
        {
            ConcatAudioPaths[2] := path
            SplitPath, path, ConcatAudioFolder2
        }
    Case 3:
        FileSelectFolder path, C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs,,`t
        if (path)
        {
            ConcatAudioPaths[3] := path
            SplitPath, path, ConcatAudioFolder3
        }
    Case 4:
        FileSelectFolder path, C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs,,`t
        if (path)
        {
            ConcatAudioPaths[4] := path
            SplitPath, path, ConcatAudioFolder4
        }
    Case 5:
        FileSelectFolder path, C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs,,`t
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
    dir := SysCommand("python C:\Util2\concat_audio\getRandomSoundDir.py")
    return dir
}

concatAudioRun()
{
    pathsArg := ""
    i := 1
    while (i <= ConcatAudioPaths.MaxIndex())
    {
        if (ConcatAudioPaths[i] != ConcatAudioFolderEmpty)
        {
            p := removeBreakLines(ConcatAudioPaths[i])
            pathsArg = %pathsArg% "%p%"
        }        
        i := i + 1
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
    cmd = cmd.exe /q /c python
    cmd = %cmd% C:\Util2\concat_audio\concat_audio.py
    cmd = %cmd% --paths %pathsArg% --num %num% --len %len% --gate %gate%
    ComObjCreate("WScript.Shell").Exec(cmd).StdOut.ReadAll()
}