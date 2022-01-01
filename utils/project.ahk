; -- newProject -------------------
createNewProject(mouseOverNewProject := False)
{
    toolTip("New project...")
    clickNewProjectInCtxMenu(mouseOverNewProject)

    res := newProjectIfAreYouSurePrompt()
    if (!res)
        return

    waitLoadProject()
    if (saveNewProject())
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
    ;res:= waitForColor(x1, y, cols1, colVar, timeout, hint, debug, reverse)
    ;if (res)
    ;    res:= waitForColor(x2, y, cols2, colVar, timeout, hint, debug, reverse)
    ;toolTip("done loading")
    toolTip()
    return res
}

setDataFolder(mainFlWinId := "")
{
    if (mainFlWinId == "")
        mainFlWinId := bringMainFLWindow()
    if (mainFlWinId == "")
        return
    if (projectNameNoExtension == "")
    {   
        msg("Save project first")
        return
    }

    toolTip("Setting data Folder")
    WinActivate, ahk_id %mainFlWinId%
    
    Send {F11}
    settingsWinId := waitNewWindowOfClass("TMIDIForm", mainFlWinId, 0)
    if (!settingsWinId)
        return
    moveMouse(376, 52)                      ; Project
    Click
    moveMouse(69, 120)                      ; Auto
    Click
    moveMouse(109, 119)                     ; Folder
    Click

    dirWinId := waitNewWindowOfClass("#32770", settingsWinId, 0)
    if (!dirWinId)
        return
    WinMove, ahk_id %dirWinId%,, 801, 264, 642, 579
    Sleep, 100
    moveMouse(97, 549)                      ; Make New Folder
    Click
    Sleep, 100
    typeText(projectNameNoExtension)        ; Name Data Folder
    res := waitToolTip("Folder ok?")
    if (!res)
        return
    moveMouse(490, 550)                     ; Ok
    Click

    toolTip("Waiting dir window to close")
    unfreezeMouse()
    waitWindowNotOfClass("#32770", 0)
    freezeMouse()
    toolTip()

    promptWinId := waitNewWindowOfClass("TMsgForm", settingsWinId, 0)
    if (!promptWinId)
        return
    Send {Right}{Enter}
    toolTip("Waiting Yes No Prompt to close")
    unfreezeMouse()
    waitWindowNotOfClass("TMsgForm", 0)
    freezeMouse()
    toolTip()

    WinClose, ahk_id %settingsWinId%
    toolTip("Waiting settings win to close")
    unfreezeMouse()
    waitWindowNotOfClass("TMIDIForm", 0)
    freezeMouse()
    toolTip()
    return True
}
; -----



; -- saveFile -------------------
saveProject()
{
    if (projectIsSaved())
    {
        if (savesFilePath == "")
            getCurrentProjFilePath()
        saveKnobSavesToFile()
        saveWinHistoriesToFile()
        sendinput ^s
        lastSaveTime := timeOfDaySeconds()
    }
    else
        saveNewProject()
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

saveNewProject()
{
    WinGet, currWinId, ID, A
    sendinput ^s
    toolTip("waiting save window")
    savePromptId := waitNewWindowOfClass("#32770", currWinId, 0)
    if (!savePromptId)
        return
    toolTip()
    resizeSavePrompt(savePromptId)
    centerMouse()

    msg("will wait accept")
    while (!accepted)
    {
        accepted := waitToolTip("Accept")
        if (!accepted)
        {
            res := waitToolTip("Quit?")
            if (res)
                return
        }
        Sleep, 200
    }
    msg("done")

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


    setDataF := waitToolTip("Set Data Folder?")
    if (setDataF)
    {
        res := setDataFolder(mainFlWinId)
        if (!res)
            waitToolTip("Could not set Data Folder")
    }
    return True
}

getCurrentProjFilePath()
{
    savePromptId := bringSavePrompt()
    cliboardSave := clipboard
    if (savePromptId)
    {
        while (!FileExist(currProjPath))
        {
            res := clipboardCurrProjFilePath(savePromptId)
            if (!res)
                return False
        }
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
        if (waitToolTip("confirm projName: " projName))
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
    moveMouse(235, 473)         ; double click file name
    Click
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

clipboardProjFolderName()
{
    moveMouse(313, 52)
    clipboard := ""
    toolTip("copying project folder")
    whileWaiting := True
    while (clipboard == "" or FileExist(folderName) != "D" and whileWaiting)
    {
        Click
        Send {CtrlDown}ac{CtrlUp}
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


global projectNameNoExtension := ""
updateGuiFilePath()
{
    folderAndFileHierarchy := StrSplit(savesFilePath, "\")
    fileName := folderAndFileHierarchy[folderAndFileHierarchy.MaxIndex()]
    projectNameNoExtension := SubStr(fileName, 1, -4)
    folderName := folderAndFileHierarchy[folderAndFileHierarchy.MaxIndex() - 1]
    txt := folderName "/" projectNameNoExtension
    GuiControl, Main1:, ProjPathGui, -> %txt%
}
; -----


