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
            if (isPlugin(id) or isWrapperPlugin(id))
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
        res := id != pluginWinHistory[pluginWinHistoryIndex] and id != mainWinHistory[mainWinHistoryIndex]
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
        historyIndex := "pluginWinHistoryIndex"
    Case "mainWin":
        history := "mainWinHistory"
        historyIndex := "mainWinHistoryIndex"
    }    
    %history%.RemoveAt(index)
    if (%historyIndex% >= index)
        %historyIndex% := %historyIndex% - 1
}

removeWinFromHistoryById(winId, mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
        historyIndex := "pluginWinHistoryIndex"
    Case "mainWin":
        history := "mainWinHistory"
        historyIndex := "mainWinHistoryIndex"
    }    

    index := pluginWinHistoryIndex
    i := 1
    while (%history%.MaxIndex() >= 1 and i <= %history%.MaxIndex())
    {
        if (index > %history%.MaxIndex())
            index := 1            
        currWinId := %history%[index]
        if (winId == currWinId)
        {
            removeWinFromHistory(index, mode)
            break
        }
        i := i + 1
        index := index + 1
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
        historyIndex := "pluginWinHistoryIndex"
    Case "mainWin":
        history := "mainWinHistory"
        historyIndex := "mainWinHistoryIndex"
    }    
    %history%.InsertAt(%historyIndex%, id)
}

displayHistoryContent(moreInfo = "")
{
    msg = %moreInfo% `r`n`r`n
    lookingBackInHistory := mainWinHistoryIndex > 1
    n := mainWinHistory.MaxIndex()
    msg = %msg% mainWins %n%     looking back: %lookingBackInHistory%
    Loop %n%
    {
        id := mainWinHistory[A_Index]
        WinGetTitle, title, ahk_id %id%
        msg = %msg% `r`n
        if (A_Index == mainWinHistoryIndex)
            msg := msg ">"
        else
            msg := msg " "
        msg = %msg%%A_Index% : %title%
    }

    lookingBackInHistory := pluginWinHistoryIndex > 1
    n := pluginWinHistory.MaxIndex()
    msg = %msg% `r`n`r`n
    msg = %msg% pluginWins %n%     looking back: %lookingBackInHistory%
    Loop %n%
    {
        id := pluginWinHistory[A_Index]
        WinGetTitle, title, ahk_id %id%
        msg = %msg% `r`n
        if (A_Index == pluginWinHistoryIndex)
            msg := msg ">"
        else
            msg := msg " "
        msg = %msg%%A_Index% : %title%
    }
    toolTip(msg, toolTipIndex["debug"], 1422, 82, "Screen")
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
        historyIndex := "pluginWinHistoryIndex"
        notFoundFunc := "activateAhkFoundPlugin"
    Case "mainWin":
        history := "mainWinHistory"
        historyIndex := "mainWinHistoryIndex"
        notFoundFunc := "bringStepSeq"
    }   
    found := False
    index := %historyIndex% 

    if (currentIndexWinIsNotActive(mode))
    {
        found := True
        id := %history%[%historyIndex%]
    }

    if (dir == "prev")
        incr := 1
    else if (dir == "next")
        incr := -1

    while (%history%.MaxIndex() > 1 and !found)
    {
        index := index + incr
        if (index > %history%.MaxIndex())
            index := 1        
        else if (index < 1)
            index := %history%.MaxIndex()     
        id := %history%[index]
        if (WinExist("ahk_id " id) and isVisible(id))
            found := True
        else
            removeWinFromHistory(index, mode)
    }   
    
    if (found)
    {
        %historyIndex% := index
        WinActivate, ahk_id %id%
        centerMouse(id)
    }
    else
        id := %notFoundFunc%()
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
    whileToolTipChoiceActivateWin := True
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
        historyIndex := "pluginWinHistoryIndex"
        notFoundFunc := "activateAhkFoundPlugin"
    Case "mainWin":
        history := "mainWinHistory"
        historyIndex := "mainWinHistoryIndex"
        notFoundFunc := "bringStepSeq"
    }    
    presentToolTip := True
    while (presentToolTip)
    {
        cleanHistory(mode)
        winTitleList := historyToWinTitleList(mode)
        initIndex := Min(2, winTitleList.MaxIndex())
        res := toolTipChoice(winTitleList, "-------- R: close", initIndex, "", True)
        id := %history%[toolTipChoiceIndex]
        if (res == "alternative")
        {
            presentToolTip := True
            removeWinFromHistory(toolTipChoiceIndex, mode)
            WinClose, ahk_id %id%
        }
        else if (res != "")
        {
            WinActivate, ahk_id %id%
            centerMouse(id)
            presentToolTip := False
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
        historyIndex := "pluginWinHistoryIndex"
    Case "mainWin":
        history := "mainWinHistory"
        historyIndex := "mainWinHistoryIndex"
    Default:
        waitToolTip("cleanHistory(mode): mode is == to """". Error")
        return
    }
    index := %historyIndex%
    count := 1
    while (count <= %history%.MaxIndex())
    {   
        id := %history%[index]
        if (!WinExist("ahk_id " id) or !isVisible(id))
        {
            removeWinFromHistory(index, mode)
            continue
        }
        else
        {
            index += 1
            if (index > %history%.MaxIndex())
                index := 1        
            count += 1
        }
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
        title := StrSplit(title, " ")[1]
        titleList.Push(title)
    }
    return titleList
}
; ----

; ---------------------------------------------------
currentIndexWinIsNotActive(mode)
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
        historyIndex := "pluginWinHistoryIndex"
    Case "mainWin":
        history := "mainWinHistory"
        historyIndex := "mainWinHistoryIndex"
    }     
    WinGet, id, ID, A
    return id != %history%[%historyIndex%]
}

bringHistoryWins(mode = "plugin")
{
    Switch mode
    {
    Case "plugin":
        history := "pluginWinHistory"
        historyIndex := "pluginWinHistoryIndex"
    Case "mainWin":
        history := "mainWinHistory"
        historyIndex := "mainWinHistoryIndex"
    } 
    i := 1
    n := %history%.MaxIndex()
    Loop, %n%
    {
        %historyIndex% := %historyIndex% - 1
        if (%historyIndex% < 1)
            %historyIndex% := %history%.MaxIndex()
        id := %history%[%historyIndex%]
        if (id)
            WinActivate, ahk_id %id%
    }
    centerMouse(id)
}


findInPluginWinHistory(filterFunction)
{
    ; mode plugin or mainWin
    found := False
    index := pluginWinHistoryIndex
    i := 1
    while (pluginWinHistory.MaxIndex() >= 1 and !found and i <= pluginWinHistory.MaxIndex())
    {
        index := index + 1
        if (index > pluginWinHistory.MaxIndex())
            index := 1            
        id := pluginWinHistory[index]
        if (WinExist("ahk_id " id))
        {
            if (%filterFunction%(id))
                found := True
        }
        else
            removeWinFromHistory(index, mode)
        i := i + 1
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
winHistoryClosePluginsExceptLast(n = 3)
{
    ;; use only plugin hist
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