global currProjPath := ""
global projectNameNoExtension := ""

; -- newProject -------------------
createNewProject(mouseOverNewProject := False, projectName := "", projectDir := "")
{
    toolTip("New project...")
    clickNewProjectInCtxMenu(mouseOverNewProject)

    res := newProjectIfAreYouSurePrompt()
    if (!res)
        return

    waitLoadProject()
    if (saveNewProject(projectName, projectDir))
        randomizeBpm()
    toolTip()
}

clickNewProjectInCtxMenu(mouseOverNewProject)
{
    if (!mouseOverNewProject)
    {
        WinGetClass, winClass, A
        if (winClass != TFruityLoopsMainForm)
        {
            WinActivate, ahk_class TFruityLoopsMainForm
            WinGet, mainFlWinId, ID, A
        }

        Click, 16, 15
        Send {Down}
    }
    Send {Enter}
}

newProjectIfAreYouSurePrompt()
{
    if (waitNewWindowOfClass("TMsgForm", "", 50))
    {
        centerMouse()
        toolTip("yes / no")
        clickAlsoAccepts := True
        unfreezeMouse()
        res := waitWindowNotOfClass("TMsgForm", 0)
        if (!res)
            return False
        freezeMouse()
        toolTip("")
    }
    return True
}

waitLoadProject()
{
    ; looks at the loading bar until it disappears
    ;x1 := 217
    ;x2 := 220
    ;y := 57
    ;cols1 := [0x46c71]
    ;cols2 := [0xd9e1e5]
    ;colVar := 10
    ;timeout := 5000
    ;hint := ""
    ;debug := False
    ;reverse := True
    toolTip("Waiting 2 sec while project loading")
    Sleep, 2000
    ;;;;;;; marche trop vite. Faudrait regarder un pixel plus à droite
    ;res:= waitForColor(x1, y, cols1, colVar, timeout, debug, reverse)
    ;if (res)
    ;    res:= waitForColor(x2, y, cols2, colVar, timeout, debug, reverse)
    ;toolTip("done loading")
    toolTip()
    return res
}

global saveNewProjectRighClickGenName := False
saveNewProject(projectName := "", projectDir := "")
{
    WinGet, currWinId, ID, A
    sendinput ^s
    toolTip("waiting save window")
    savePromptId := waitNewWindowOfClass("#32770", currWinId, 0)
    if (!savePromptId)
        return
    toolTip()
    resizeSavePrompt(savePromptId)

    if (projectName != "")
        savePromptSetProjectName(projectName)
    if (projectDir != "")
        savePromptSetProjectDir(projectDir)
    
    centerMouse()
    while (!accepted)
    {
        saveNewProjectRighClickGenName := True
        accepted := waitToolTip("Accept`r`nRclick: GetWords")
        saveNewProjectRighClickGenName := False
        if (!accepted)
        {
            res := waitToolTip("Quit?")
            if (res)
                return
        }
        Sleep, 200
    }

    res := savePromptClickSave()
    if (!res)
        return False
    
    Sleep, 50
    if (WinActive("Confirm Save As")) 
    {
        centerMouse()
        unfreezeMouse()
        toolTip("waiting yes/no prompt")
    }
    res := waitWindowNotOfClass("#32770", 0)
    if (!res)
        return False
    toolTip()
    freezeMouse()
    lastSaveTime := timeOfDaySeconds()
    if (!getCurrentProjFilePath())
        return False
    return True
}

savePromptSetProjectName(projectName)
{
    selProjFileName()
    typeText(projectName)
}

savePromptSetProjectDir(projectDir)
{
    selProjDir()
    typeText(projectDir)
}

generateProjectName()
{
    selProjFileName()
    words := GetWords.gen(1)
    typeText(words)
}

Class DataFolder
{
    set()
    {
        res := DataFolder.__makeSureProjectIsSaved()
        if (!res)
            return False

        toolTip("Setting Data folder")
        settingsWinId := DataFolder.__bringProjectSettings()
        if (!settingsWinId)
            return False
        while (!dataFolderIsSet)
        {
            dataFolderExists := DataFolder.__checkIfExists(dataFolderPath)
            if (dataFolderExists)
                dataFolderIsSet := DataFolder.__askIfAlreadySet(dataFolderPath, settingsWinId)
            if (!dataFolderIsSet)
            {
                dirPickerWinId := DataFolder.__bringDirPickerWin(settingsWinId)
                if (!dirPickerWinId)
                    return False
                Sleep, 100
                if (!dataFolderExists)
                    FileCreateDir, %dataFolderPath%
                res := DataFolder.__pickExistingFolder(dataFolderPath)
                if (!res)
                    return False
                DataFolder.__closePrompt(settingsWinId)
            }
        }
        DataFolder.__closeSettingsWin(settingsWinId)
        toolTip()
        return True        
    }
    __makeSureProjectIsSaved()
    {
        res := True
        if (!projectNameNoExtension)
        {   
            res := saveProject()
            if (!res)
                msg("Project must be saved to set Data Folder.")
        }
        return res
    }
    __bringProjectSettings()
    {
        WinGet, currWinId, ID, A
        Send {F11}                                      ; Settings win
        settingsWinId := waitNewWindowOfClass("TMIDIForm", currWinId, 0)
        if (!settingsWinId)
            msg("DataFolder.set() can't bring settings window")
        else
        {
            Sleep, 5
            quickClick(376, 52)                             ; Project tab
        }
        return settingsWinId
    }
    __checkIfExists(ByRef dataFolderPath)
    {
        SplitPath, currProjPath,, projectFolder 
        dataFolderPath := projectFolder "\" projectNameNoExtension
        success := InStr(FileExist(dataFolderPath), "D")
        return success
    }
    __askIfAlreadySet(dataFolderPath, settingsWinId)
    {
        success := False
        if (!WinActive("ahk_id " settingsWinId))
        {
            WinActivate %ahk_id% settingsWinId
            Sleep, 200
        }
        toolTip(dataFolderPath, 1, 120, 90)
        moveMouse(129, 134)
        success := waitToolTip("Is this a match? Enter: Y   Esc: N")
        toolTip("", 1)
        return success
    }
    __bringDirPickerWin(currWinId)
    {
        quickClick(69, 120)                         ; Auto
        quickClick(109, 119)                        ; Folder
        dirPickerWinId := waitNewWindowOfClass("#32770", currWinId, 0)
        if (dirPickerWinId)                         ; Dir picker win
            WinMove, ahk_id %dirPickerWinId%,, 801, 264, 642, 579
        else
            msg("Expected file picker. Aborting st Data folder.")   
        return dirPickerWinId
    }
    __pickExistingFolder(dataFolderPath)
    {
        success := True
        moveMouse(403, 154)                 ; Trick to activate curr folder in browser
        Click, R                            ;   (open ctx menu in browser area)
        Send {Esc}{Right}                   ;   (leave ctx menu, open current folder)
        nthFolder := DataFolder.__getNthInParentFolder(dataFolderPath)
        if (nthFolder)
        {
            Loop %nthFolder%
            {
                Send {Down}                 ; Reach existing folder
                Sleep, 10
            }
        }
        else
            success := waitToolTip("pick " projectNameNoExtension " and accept")
        if (success and WinActive("ahk_class #32770"))
        {
            quickClick(490, 550)                ; Ok, close dir picker win
            unfreezeMouse()
            success := waitWindowNotOfClass("#32770", 0)
            if (!success)
                msg("Couldn't close dir picker win")
            freezeMouse()
            toolTip()    
        }
        if (!success)
            msg("Couldn't pick existing folder")        
        return success
    }
    __getNthInParentFolder(dataFolderPath)
    {
        SplitPath, dataFolderPath,, projectFolder
        nth := 1
        success := False
        folderNames := getSortedFilesInFolder(projectFolder, "D")
        for nth, folderName in folderNames
        {
            fullPath := projectFolder "\" folderName
            if (InStr(FileExist(fullPath), "D"))
            {
                if (fullPath == dataFolderPath)
                {
                    success := True
                    break
                }
                nth += 1
            }            
        }
        if (!success)
            nth := ""
        return nth
    }
    __closePrompt(currWinId)
    {
        toolTip("Waiting Yes No Prompt")
        promptWinId := waitNewWindowOfClass("TMsgForm", currWinId, 0)
        if (promptWinId)
        {
            Send {Right}{Enter}                     ; Are you sure?
            toolTip("Waiting Yes No Prompt to close")
            unfreezeMouse()
            waitWindowNotOfClass("TMsgForm", 0)
            freezeMouse()
        }
        toolTip()  
    }
    __closeSettingsWin(settingsWinId)
    {
        WinClose, ahk_id %settingsWinId%
        toolTip("Waiting settings win to close")
        unfreezeMouse()
        waitWindowNotOfClass("TMIDIForm", 0)
        freezeMouse()
        toolTip()
    }    
}
; -----



; -- saveFile -------------------
saveProject()
{
    success := False
    if (projectIsSaved())
    {
        if (savesFilePath == "")
            getCurrentProjFilePath()
        if (savesFilePath != "")
        {
            saveKnobSavesToFile()
            saveWinHistoriesToFile()
            sendinput ^s
            lastSaveTime := timeOfDaySeconds()
            success := True            
        }
        else
            msg("did not save", 400)
    }
    else
    {
        success := saveNewProject()
        if (success)
            if (waitToolTip("Set Data Folder?"))
                if (!DataFolder.set())
                    waitToolTip("Could not set Data Folder. Ac/Ab")
    }
    return success
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
    savePromptId := bringSavePrompt()
    cliboardSave := clipboard
    if (savePromptId)
    {
        while (!FileExist(currProjPath))
        {
            toolTip("getting project path")
            res := clipboardCurrProjFilePath(savePromptId)
            if (!res)
                return False
        }
        toolTip()
    }
    clipboard := cliboardSave
    if (WinExist("ahk_id " savePromptId))
        WinClose, ahk_id %savePromptId%    
    if (FileExist(currProjPath))
        updateGuiFilePath()
    else
        currProjPath := ""
    return currProjPath
}

resizeSavePrompt(savePromptId)
{
    WinGetPos,,, winW, winH, ahk_id %savePromptId%
    while (winW != 642 or winH != 579)
    {
        WinMove, ahk_id %savePromptId%,,,, 642, 579
        WinGetPos,,, winW, winH, ahk_id %savePromptId%
    }
}

bringSavePrompt()
{
    WinActivate, ahk_class TFruityLoopsMainForm
    if (!wasSaving)
    {
        Send {CtrlDown}{ShiftDown}s{ShiftUp}{CtrlUp}
        WinGet, savePromptId, ID, ahk_class #32770
    }
    if (!savePromptId)
    {
        WinGet, id, ID, ahk_class TFruityLoopsMainForm
        toolTip("    waiting save prompt")
        savePromptId := waitNewWindowOfClass("#32770", id)
        centerMouse(savePromptId)
        toolTip()
    }
    return savePromptId
}

mouseOverSavePromptSaveButton()
{
    res := False
    winId := mouseGetPos(mX, mY, "Window")
    WinGetClass, winClass, ahk_id %winId%
    if (winClass == "#32770")
    {
        resizeSavePrompt(winId)
        res := (mY >= 525 and mY <= 560 and mX >= 425 and mX <= 518)
        if (res and !WinActive("ahk_id " winId))
            WinActivate, ahk_id %winId%
    }
    return res
}

savePromptClickSave()
{
    WinGetClass, winClass, A
    if (winClass != "#32770")
        WinActivate, ahk_class #32770
    WinGetClass, winClass, A
    if (winClass != "#32770") 
        return
    WinGet, winId, ID, A
    resizeSavePrompt(winId)
    moveMouse(480, 540)
    Click
    res := waitNewWindow(winId, 0)
    return res
}

clipboardCurrProjFilePath(savePromptId)
{
    res := False
    resizeSavePrompt(savePromptId)
    
    projName := clipboardProjFileName()
    folderName := clipboardProjFolderName()
    path := folderName "\" projName

    if (FileExist(path))
    {
        currProjPath := path
        getSaveFilePath(folderName, projName)
        if (waitToolTip("confirm current projName: " projName))
            res := True
        else
        {
            quit := waitToolTip("Quit?")
            if (quit)
                res := False
            else
                res := clipboardCurrProjFilePath(savePromptId)
        }
    }
    else
    {
        keepTrying := waitToolTip(path "`r`nDoes not exist. Try again?")
        if (keepTrying)
            res := clipboardCurrProjFilePath(savePromptId)
    }
    return res
}

clipboardProjFileName()
{
    selProjFileName()
    clipboard := ""
    toolTip("copying project name")
    i := 0
    while (clipboard == "")
    {
        Send {CtrlDown}ac{CtrlUp}
        i += 1
        if (i > 100)
            return
    }
    toolTip()
    projName := clipboard
    toolTip("projName: " projName)
    return projName
}

selProjFileName()
{
    quickClick(235, 473)
    SendInput ^a
}

selProjDir()
{
    quickClick(313, 52)
    SendInput ^a
}

clipboardProjFolderName()
{
    clipboard := ""
    toolTip("copying project folder")
    whileWaiting := True
    while (clipboard == "" or FileExist(folderName) != "D" and whileWaiting)
    {
        selProjDir()
        SendInput ^c
        folderName := clipboard
        toolTip("folderName: " folderName)
    }
    whileWaiting := False
    toolTip()
    return folderName
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
        saveNewProject()
    return res
}

getProjectName()
{
    if (currProjPath == "")
        getCurrentProjFilePath()
    if (currProjPath == "")
        return

    folderAndFileHierarchy := StrSplit(currProjPath, "\")
    fileName := folderAndFileHierarchy[folderAndFileHierarchy.MaxIndex()]
    projectNameNoExtension := SubStr(fileName, 1, -4)   
    return projectNameNoExtension
}

getProjectDir()
{
    if (currProjPath == "")
        getCurrentProjFilePath()
    if (currProjPath == "")
        return

    folderAndFileHierarchy := StrSplit(currProjPath, "\")
    folderAndFileHierarchy.Pop()
    dir := ""
    for _, pathElement in folderAndFileHierarchy
        dir := dir . pathElement . "/"
    return dir
}

updateGuiFilePath()
{
    projectNameNoExtension := getProjectName()
    folderName := folderAndFileHierarchy[folderAndFileHierarchy.MaxIndex() - 1]
    txt := folderName "/" projectNameNoExtension
    GuiControl, Main1:, ProjPathGui, -> %txt%
}
; -----

; -- gui ----------
openProjectFolders()
{
    if (savesFilePath and currProjPath)
    {
        browseFolder(savesFilePath)
        browseFolder(currProjPath)
    }
    else
        freezeExecute("loadSaveFileIfExists")
}
; -----