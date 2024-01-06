global pluginWinHistory := []
global mainWinHistory := []
global pluginWinHistoryIndex := 1
global mainWinHistoryIndex := 1

global duringWinHistoryTick := False
global debugWindowHistory := False
global masterEdisonId

winHistoryTick()
{
    if (!duringWinHistoryTick)
    {
        duringWinHistoryTick := True
        WinGet, id, ID, A
    
        if (isFLWindow(id) and justChangedWindow(id) and !isWindowHistoryExclude(id))
        {
            if (isPlugin(id))
                mode := "plugin"
            else
                mode := "mainWin"
            index := inWinHistory(id, mode)
            if (index)
                removeWinFromHistory(index, mode)

            registerWinToHistory(id, mode)
            if (isMasterEdison(id))
                masterEdisonId := id
        }
        if (debugWindowHistory)
            displayHistoryContent(mode "   foundIndex: " index)   
        duringWinHistoryTick := False
    }
}


justChangedWindow(id)
{
    res := False
    if (id != "")
        res := id != pluginWinHistory[1] and id != mainWinHistory[1]
    return res
}

inWinHistory(id, mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
    Case "mainWin":
        history := "mainWinHistory"
    }
    index := HasVal(%history%, id)
    return index
}

removeWinFromHistory(index, mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
    Case "mainWin":
        history := "mainWinHistory"
    }   
    if index >= 1 and index <= %history%.MaxIndex()
        %history%.RemoveAt(index)
}

removeWinFromHistoryById(winId, mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
    Case "mainWin":
        history := "mainWinHistory"
    }    

    index := 1
    while (%history%.MaxIndex() >= 1 and index <= %history%.MaxIndex())
    {
        currWinId := %history%[index]
        if (winId == currWinId)
        {
            removeWinFromHistory(index, mode)
            break
        }
        index += 1
    }
}

removeFromHistoryIfInvisible(winId)
{
    res := False
    if (!isVisible(winId))
    {
        if (isPlugin(winId))
            mode := "plugin"
        else
            mode := "mainWin"
        removeWinFromHistoryById(winId, mode)
        res := True
    }    
    return res
}

registerWinToHistory(id, mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
    Case "mainWin":
        history := "mainWinHistory"
    }    
    %history%.InsertAt(1, id)
}

displayHistoryContent(moreInfo = "")
{
    msg = %moreInfo% `r`n`r`n
    n := mainWinHistory.MaxIndex()
    msg = %msg% mainWins %n% 
    Loop %n%
    {
        id := mainWinHistory[A_Index]
        WinGetTitle, title, ahk_id %id%
        msg = %msg% `r`n
        if (A_Index == 1)
            msg := msg ">"
        else
            msg := msg " "
        msg = %msg%%A_Index% : %title%
    }

    n := pluginWinHistory.MaxIndex()
    msg = %msg% `r`n`r`n
    msg = %msg% pluginWins %n% 
    Loop %n%
    {
        id := pluginWinHistory[A_Index]
        WinGetTitle, title, ahk_id %id%
        msg = %msg% `r`n
        if (A_Index == 1)
            msg := msg ">"
        else
            msg := msg " "
        msg = %msg%%A_Index% : %title%
    }
    toolTip(msg, toolTipIndex["debug"], 1422, 82, "Screen")
}

isLastPlugin(title)
{
    lastPluginTitle := getLastPluginTitle()
    return InStr(lastPluginTitle, title)
}

getLastPluginTitle()
{
    lastPluginId := pluginWinHistory[1]
    WinGetTitle, lastPluginTitle, ahk_id %lastPluginId%
    return lastPluginTitle
}


; -- Tab Caps -------------------------------------
activatePrevPlugin()
{
    winId := activatePrevNextWin("plugin", "prev")
}

activateNextPlugin()
{
    winId := activatePrevNextWin("plugin", "next")
}

activatePrevMainWin()
{
    winId := activatePrevNextWin("mainWin", "next")
}

activateNextMainWin()
{
    winId := activatePrevNextWin("mainWin", "next")
}

activatePrevNextWin(mode, dir)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
        notFoundFunc := "activateAhkFoundPlugin"
    Case "mainWin":
        history := "mainWinHistory"
        notFoundFunc := "StepSeq.bringWin"
    }   

    found := False
    if (currentHistoryWinIsNotActive(mode))
    {
        found := True
        id := %history%[1]
    }
    else if (dir == "next")
        index := %history%.MaxIndex()
    while (%history%.MaxIndex() > 1 and !found)
    {
        if (dir == "prev")
            index := Max(2, %history%.MaxIndex())
        id := %history%[index]
        if (winExists(id))
            found := True
        else
            removeWinFromHistory(index, mode)
    }   
    
    if (found)
    {
        WinActivate, ahk_id %id%
        centerMouse(id)
    }
    return id
}

activateAhkFoundPlugin()
{
    WinGet, id, ID, ahk_class TPluginForm
    WinGetTitle, title, ahk_id %id%
    clipboard := title
    if (title != "Control Surface (knobs)")
    {
        WinActivate, ahk_id %id%
        centerMouse(id)
    }
    return id
}

toolTipChoiceActivatePlugin()
{
    toolTipChoiceActivateWin("plugin")
}

toolTipChoiceActivateMainWin()
{
    toolTipChoiceActivateWin("mainWin")
}

global whileToolTipChoiceActivateWin := False
toolTipChoiceActivateWin(mode)
{
    winHistoryTick()
    whileToolTipChoiceActivateWin := True
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
        notFoundFunc := "activateAhkFoundPlugin"
        initIndex := isPlugin() ? 2 : 1
    Case "mainWin":
        history := "mainWinHistory"
        notFoundFunc := "StepSeq.bringWin"
        initIndex := isPlugin() ? 1 : 2
    }    
    presentToolTip := True
    while (presentToolTip)
    {
        cleanHistory(mode)
        winTitleList := historyToWinTitleList(mode)
        initIndex := Min(initIndex, winTitleList.MaxIndex())
        res := toolTipChoice(winTitleList, "-------- R: close", initIndex, "", True)
        id := %history%[toolTipChoiceIndex]
        if (res == "alternative")
        {
            presentToolTip := True
            removeWinFromHistory(toolTipChoiceIndex, mode)
            WinClose, ahk_id %id%
            Send {Tab Down}
        }
        else if (res != "")
        {
            presentToolTip := False
            if (mode == "plugin")
                centerMouse(id)
            else if (mode == "mainWin")
                bringMainWin(id)
        }
        else if (res == "")
            presentToolTip := False
    }
    whileToolTipChoiceActivateWin := False
}

cleanHistory(mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
    Case "mainWin":
        history := "mainWinHistory"
    Default:
        waitToolTip("cleanHistory(mode): mode is == to """". Error")
        return
    }
    index := 1
    while (index <= %history%.MaxIndex())
    {   
        id := %history%[index]
        if (!winExists(id))
        {
            removeWinFromHistory(index, mode)
            continue
        }
        else
            index += 1
    }
}

historyToWinTitleList(mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
    Case "mainWin":
        history := "mainWinHistory"
    }
    titleList := []
    for _, id in %history%
    {
        WinGetTitle, title, ahk_id %id%
        if (isPlugin(id))    
            title := filterPluginTitle(title)             
        else if isEventEditForm(id)
            title := cleanEventEditorTitle(title)
        title := filterTitleList(title)
        titleList.Push(title)
    }
    return titleList
}

filterTitleList(title)
{
    if (InStr(title, "Channel Rack"))
        title := "Step Seq"
    return title
}
; ----

; ---------------------------------------------------
currentHistoryWinIsNotActive(mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
    Case "mainWin":
        history := "mainWinHistory"
    }     
    WinGet, id, ID, A
    return id != %history%[1]
}

bringHistoryWins(mode := "plugin")
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
    Case "mainWin":
        history := "mainWinHistory"
    } 
    index := %history%.MaxIndex()
    n := %history%.MaxIndex()
    while (index >= 1 and %history%.MaxIndex() >= 1)
    {
        id := %history%[index]
        if (winExists(id))
            WinActivate, ahk_id %id%
        else
            removeWinFromHistory(index, mode)
        index -= 1
    }
    centerMouse(id)
}


findInPluginWinHistory(filterFunction)
{
    ; mode plugin or mainWin
    found := False
    index := pluginWinHistory.MaxIndex()
    while (pluginWinHistory.MaxIndex() >= 1 and !found and index >= 1)
    {
        id := pluginWinHistory[index]
        if (winExists(id) and %filterFunction%(id))
                found := True
        else
            removeWinFromHistory(index, mode)
        index -= 1
    }
    if (found)
        return id
}
; ----


; -- Save Load File -----------------------------------------
loadWinHistories()
{
    pluginWinTitles := loadDumpedToFile(savesFilePath, currProjPath, "pluginWinTitles")
    loadWindowHistoryFromTitles(pluginWinTitles, "plugin")
    mainWinTitles := loadDumpedToFile(savesFilePath, currProjPath, "mainWinTitles")
    loadWindowHistoryFromTitles(mainWinTitles, "mainWin")
}

loadWindowHistoryFromTitles(windowTitles, mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
    Case "mainWin":
        history := "mainWinHistory"
    } 
    for _, title in windowTitles
    {
        WinGet, id, ID, %title%
        if (id)
        {
            WinGet, exe, ProcessName, ahk_id %id%
            if (exe == "FL64.exe")
                %history%.Push(id)
        }
    }
}

windowsIdToTitle(windowIds)
{
    windowTitles := []
    for _, id in windowIds
    {
        WinGetTitle, title, ahk_id %id%
        windowTitles.Push(title)
    }
    return windowTitles
}

saveWinHistoriesToFile()
{
    cleanHistory("plugin")
    cleanHistory("mainWin")
    pluginWinTitles := windowsIdToTitle(pluginWinHistory)
    dumpToFile(pluginWinTitles, savesFilePath, currProjPath, "pluginWinTitles")
    mainWinTitles := windowsIdToTitle(mainWinHistory)
    dumpToFile(mainWinTitles, savesFilePath, currProjPath, "mainWinTitles")    
}
; ----


; -- Clear from history --------------------------
winHistoryClosePluginsExceptLast(n := 3)
{
    ;; use only plugin list
    currIndexWinId := pluginWinHistory[pluginWinHistoryIndex]
    index := pluginWinHistoryIndex
    
    i := 1
    numWins := pluginWinHistory.MaxIndex()
    while (i <= numWins)
    {
        incrIndex := True
        if (isPlugin(pluginWinHistory[index]))
        {
            if (n > 0)
                n := n - 1
            else
            {
                pluginId := pluginWinHistory[index]
                if (WinExist("ahk_id " pluginId))
                    WinClose, ahk_id %pluginId%
                if (index < pluginWinHistory.MaxIndex())
                    incrIndex := False
                pluginWinHistory.RemoveAt(index)
            }
        }
        if (incrIndex)
        {
            index := index + 1
            if (index > pluginWinHistory.MaxIndex())
                index := 1  
        }
        i := i + 1
    }

    for i, winId in pluginWinHistory
    {
        if (currIndexWinId == winId)
        {
            pluginWinHistoryIndex := i
            break
        }
    }
}
; ----

; -- Gui ----------------------------------------
winHistoryDebugToggle()
{
    GuiControlGet, checked,, winHistoryDebugGui
    debugWindowHistory := checked
    if (!debugWindowHistory)
        toolTip("", toolTipIndex["debug"])    
}
; ----