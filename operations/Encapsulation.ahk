; ------------------------------------------
; While a sound is open (in a saved project)
; get its name and folder
; save
; open project with the name in the folder

class Encapsulation
{
    start()
    {
        choices := ["Wrap in new project", "Unwrap project", "Parent project", "Previous project"]
        funcs := ["wrapProject", "unwrapProject", "openParentProject", "openPreviousProject"]
        title := "Encapsulation:"
        initIndex := 1
        res := toolTipChoice(choices, title, initIndex)
        if (!res)
            return
        func := "Encapsulation." funcs[toolTipChoiceIndex]
        success := execFunc(func)
        return success
    }
    unwrapProject()
    {
        if (!isSampleClip())
        {
            msg("No sample clip plugin open")
            return
        }
        WinGet, clipWinId, ID, A
        centerMouse(clipWinId)
        projectName := Encapsulation.__getParentProjectName(clipWinId)
        projectFolder := Encapsulation.__getParentProjectFolder(clipWinId)
        if (!projectFolder)
            return
        bringMainFLWindow()
        saveProject()
        Encapsulation.__openParentProject(clipWinId, projectFolder, projectName)
    }
    __getParentProjectName(clipWinId)
    {
        WinGetTitle, projectName, ahk_id %clipWinId%                    ; le nom du projet à ouvrir
        projectName := StrSplit(projectName , "")[1]
        projectName := StrSplit(projectName , "_")[1]               ; si projet_1 ou projet: projet
        return projectName
    }
    __getParentProjectFolder(clipWinId)
    {
        quickClick(222, 97)                 ; folder button
        browseWindowId := waitNewWindowOfClass("#32770", clipWinId)
        toolTip("Getting project folder")
        i := 0
        while (!InStr(FileExist(projectFolder), "D") and i < 5)
        {
            WinMove, ahk_id %browseWindowId%,, 439, 250, 872, 668
            quickClick(552, 51)             ; select folder path
            SendInput ^a
            projectFolder := copyTextWithClipboard()
            i += 1
        }
        toolTip()

        if !InStr(FileExist(projectFolder), "D")
        {
            msg("Can't copy folder")
            projectFolder := ""
        }
        WinClose, ahk_id %browseWindowId%
        WinActivate, ahk_id %clipWinId%
        return projectFolder
    }
    __openParentProject(browseWindowId, projectFolder, projectName)
    {
        SendInput, ^o
        openWinId := waitNewWindowOfClass("#32770", winId)
        WinMove, ahk_id %openWinId%,, 439, 250, 872, 668
        
        quickClick(559, 50)                 ; folder path
        typeText(projectFolder)
        Send {Enter}

    
        projectFile := Encapsulation.__getConfirmedProjectFile(projectFolder, projectName)
        if (!projectFile)
            return
        
        quickClick(589, 573)                ; file name
        SendInput ^a
        typeText(projectFile)
        quickClick(686, 631)                ; Open
    }   
    __getConfirmedProjectFile(projectFolder, projectName) 
    {
        projectChoices := []
        Loop %projectFolder%\%projectName%*.flp
            projectChoices.Push(A_LoopFileName)
        if (projectChoices.MaxIndex() < 1)
        {
            res := waitToolTip("No project file found for: " projectName "`r`nPick one manually or Esc.")
            if (!res)
                return
        }
        else if (projectChoices.MaxIndex() == 1)
        {
            res := waitToolTip("Confirm open " projectFile " ?")
            if (!res)
                return
            projectFile := projectChoices[1]
        }
        else
        {
            projectFile := toolTipChoice(projectChoices, "open:", projectChoices.MaxIndex())
            if (!projectFile)
                return
        }
        projectPath := projectFolder "\" projectFile
        if (!FileExist(projectPath))
        {
            msg("Path: " projectPath " doesn't exist.")
            return
        }
        return projectFile
    }
    wrapProject()
    {
        projectName := getProjectName()
        projectDir := getProjectDir()
        if (!(projectName or projectDir))
            return

        mp3Exists := Encapsulation.__currentProjectMp3Exists(projectDir, projectName)
        if (!mp3Exists or (mp3Exists and waitToolTip("OverWrite existing?")))
        {
            res := Automation.makeTimeSel(_, _)                             
            if (!res)
                return
            res := Encapsulation.__exportMp3()  
            if (!res)
                return
        }
 
        incredProjectName := Encapsulation.__incr_n(projectName)

        if (Encapsulation.__projectExists(incredProjectName))
            Encapsulation.__openProjectName(incredProjectName)
        else
            createNewProject(False, incredProjectName, projectDir)
                                            
        WinActivate, ahk_exe Explorer.EXE
        waitToolTip("drag " projectName ".mp3")
    }
    __currentProjectMp3Exists(projectDir, projectName)
    {
        mp3FileName := projectDir "" projectName ".mp3"
        success := FileExist(mp3FileName)
        return success
    }
    __projectExists()
    {

    }
    __openProjectName(projectName)
    {

    }
    __exportMp3()
    {
        success := False
        WinGet, currWinId, ID, A
        SendInput +^r
        unfreezeMouse()
        saveWinId := waitNewWindowOfClass("#32770", currWinId, 0)
        if (!saveWinId)
            return success
        exportWinId := waitNewWindowOfClass("TWAVRenderForm", saveWinId, 0)
        if (!exportWinId)
            return success
        explorerWinId := waitNewWindowOfProcess("Explorer.EXE", exportWinId, 0)
        if (!exportWinId)
            return success
        freezeMouse()
        bringMainFLWindow()
        success := True
        return success
    }
    __incr_n(projectName)
    {
        isOriginalName := True
        if (SubStr(projectName, -1, 1) == "_")
        {
            lastChar := SubStr(projectName, 0, 1)
            if lastChar is digit
            {
                isOriginalName := False
                projectName := SubStr(projectName, 1, -1) . (lastChar + 1)
            }
        }
        if (isOriginalName)
            projectName := projectName "_2"
        return projectName
    }

    openParentProject()
    {
        msg("openParentProject")
    }
    openPreviousProject()
    {
        SendInput !2
    }
    
    ;;; while save new project save win
    ;;;     Click: accept
    ;;;     RClick: Gen new name
    ;;;                 ou toolTipChoice ?: gen new name
    ;;;                                   : incr curr name    < ------- 
}









; ------------------------------------------
; While a saved project is open
; save
; export mp3 and note the name
; create new project
/*
wrapInNewProject()
{
    bringMainFLWindow()
    save()
    projectName := exportMp3()
    projectName := getNextProjectName(projectName)
    newProject(projectName)
    WinActivate, ahk_exe Explorer.EXE
}

save()
{
    Send {Ctrl Down}s{Ctrl Up}
    Sleep, 200
}

exportMp3()
{
    MouseClick, Left, 14, 15                        ; open menu
    Sleep, 200
    Loop, 8
    {
        Send {Down}
        Sleep, 100
    }
    Send {Right}
    Sleep, 100
    Send {Down}
    Sleep, 100
    Send {Enter}                                    ; export
    Sleep, 200
    WinWaitActive, Save As,, 3
    Sleep, 500
    projectName := getProjectName()
    Send {Enter}
    WinWaitActive, ahk_class TWAVRenderForm,, 3     
    Send {Enter}
    WinWaitClose, ahk_class TWAVRenderForm          ; rendering
    WinWaitActive, ahk_exe Explorer.EXE,, 3
    Sleep, 200
    WinActivate, ahk_exe FL64.exe                   ; activate FL, keep explorer window
    Sleep, 100
    WinActivate, ahk_class TFruityLoopsMainForm  
    Sleep, 500
    return projectName
}

getProjectName()
{
    clip := copyTextWithClipboard()         ; copy name in save as window
    projectName := SubStr(clip, 1 , StrLen(clip) - 4)
    return projectName
}

getNextProjectName(projectName)
{
    num := getProjectNameNumber(projectName) + 1
    projectname = %projectName%_%num%
    return projectName
}

getProjectNameNumber(projectName)
{
        projectNameNumber := 
        n := SubStr(projectName, StrLen(projectName) - 1 , StrLen(projectName))
        nIsNumber := False
        if n is digit
            isNumber := True
        underscore := SubStr(projectName, StrLen(projectName) - 2 , StrLen(projectName) - 1)
        isFirst := (underscore != "_" or !nIsNumber)
        if (isFirst)
            projectNameNumber := 1
        else
            projectNameNumber := n
    return projectNameNumber
}

newProject(projectName)
{
    MouseClick, Left, 14, 15                ; open menu
    Sleep, 200
    Send {Down}
    Sleep, 100
    Send {Enter}                            ; new project
    Sleep, 4000
    Send {Ctrl Down}s{Ctrl Up}
    WinWaitActive, Save As,, 3
    ;clipboard := projectName
    ;Sleep, 1000
    ;Send {Ctrl Down}v{Ctrl Up}
    ;Sleep, 200
    typeText(projectName)
    Send {Enter}
    Sleep, 200
    WinWaitActive, ahk_class TFruityLoopsMainForm,, 3
}

; ------------------------------------------
openNextProject()
{
    WinActivate, ahk_class TFruityLoopsMainForm  
    MouseClick, Left, 14, 15                        ; open menu
    Sleep, 1000
    Loop, 3
    {
        Send {Down}
        Sleep, 100
    }
    Send {Enter}

    GroupAdd, nextWindow, ahk_class TMsgForm
    GroupAdd, nextWindow, Open
    msgTip("waiting for new win")
    WinWaitActive, ahk_group nextWindow,, 3
    WinGetClass, class, A
    if (class == "TMsgForm")
    {
        msgTip("found save prompt")
        Send {Enter}
        WinWaitActive, Open,, 3
    }
    projectName := getProjectName()
    nextProjectName := getNextProjectName(projectName)
    typeText(nextProjectName)
    ;clipboard := nextProjectName
    ;Sleep, 1000
    ;Send {Ctrl Down}v{Ctrl Up} 
    ;Sleep, 1000
    Send {Enter}
}

openPrevProject()
{
    bringFL()
    Send {Ctrl Down}s{Ctrl Up}
    Send {Alt Down}2{Alt Up} 
}
*/
