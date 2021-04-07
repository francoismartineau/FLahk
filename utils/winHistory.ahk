global windowHistory := []
global windowHistoryIndex := 1
global duringWinHistoryTic := False
global currFlWin
global lastFlWin

winHistoryTic()
{
    if (!duringWinHistoryTic)
    {
        duringWinHistoryTic := True
        WinGet, id, ID, A
    
        if (isFLWindow(id) and justChangedWindow(id))
        {
            if (!isWindowHistoryExclude(id))
            {
                index := inWinHistory(id)
                if (index)
                    removeWinFromHistory(index)

                registerWinToHistory(id)
            }
            lastFlWin := currFlWin
            currFlWin := id
        }
        if (debugWindowHistory)
            displayHistoryContent()   
        duringWinHistoryTic := False
    }
}


justChangedWindow(id)
{
    global windowHistory, windowHistoryIndex
    return id != "" and id != windowHistory[windowHistoryIndex]
}

inWinHistory(id)
{
    global windowHistory
    index := HasVal(windowHistory, id)
    return index
}

removeWinFromHistory(index)
{
    global windowHistory, windowHistoryIndex
    windowHistory.RemoveAt(index)
    if (windowHistoryIndex >= index) {
        windowHistoryIndex := windowHistoryIndex - 1
    }
}

registerWinToHistory(id)
{
    global windowHistory, windowHistoryIndex
    windowHistory.InsertAt(windowHistoryIndex, id)
}

displayHistoryContent(msg = "")
{
    global windowHistory, windowHistoryIndex
    lookingBackInHistory := windowHistoryIndex > 1
    n := windowHistory.MaxIndex()
    msg = %msg% `r`n displayHistoryContent %n%     looking back: %lookingBackInHistory%
    Loop %n%
    {
        id := windowHistory[A_Index]
        WinGetTitle, title, ahk_id %id%
        msg = %msg% `r`n
        if (A_Index == windowHistoryIndex)
            msg := msg ">"
        else
            msg := msg " "
        msg = %msg%%A_Index% : %title%
    }
    toolTip(msg)
}

; -- Tab Caps -------------------------------------
activatePrevWin()
{
    global windowHistory, windowHistoryIndex
    found := False
    index := windowHistoryIndex
    if (!currentIndexWinIsActive())
    {
        found := True
        id := windowHistory[index]
    }
    else
    {
        while (windowHistory.MaxIndex()>1 and !found)
        {
            index := index + 1
            if (index > windowHistory.MaxIndex())
                index := 1            
            id := windowHistory[index]
            if (WinExist("ahk_id " id))
                found := True
            else
                removeWinFromHistory(index)
        }
    }
    if (found)
    {
        windowHistoryIndex := index
        WinActivate, ahk_id %id%
        centerMouse(id)
    }
    return id
}


activateNextWin()
{
    global windowHistory, windowHistoryIndex
    found := False
    index := windowHistoryIndex
    if (!currentIndexWinIsActive())
    {
        found := True
        id := windowHistory[index]
    }
    else
    {    
        while (windowHistory.MaxIndex()>1 and !found)
        {
            index := index - 1
            if (index < 1)
                index := windowHistory.MaxIndex()        
            id := windowHistory[index]
            if (WinExist("ahk_id " id))
                found := True
            else
                removeWinFromHistory(index)
        }
    }
    if (found)
    {
        windowHistoryIndex := index
        WinActivate, ahk_id %id%
        centerMouse(id)
    }
}

activatePrevNextWinFlag := False
activatePrevNextWin()
{
    ;; currently doesn't use currentIndexWinIsActive() which I made in case a win that isn't saved to history is active)
    global windowHistory, windowHistoryIndex
    global activatePrevNextWinFlag
    if (!activatePrevNextWinFlag) {
        id := activatePrevWin()
        activatePrevNextWinFlag := True
    } else {
        id := activateNextWin()
        activatePrevNextWinFlag := False
    }
    return id
}
; ----

; ---------------------------------------------------
currentIndexWinIsActive()
{
    global windowHistory, windowHistoryIndex
    WinGet, id, ID, A
    return id == windowHistory[windowHistoryIndex]
}

bringHistoryWins()
{
    global windowHistory, windowHistoryIndex
    i := 1
    n := windowHistory.MaxIndex()
    Loop, %n%
    {
        windowHistoryIndex := windowHistoryIndex - 1
        if (windowHistoryIndex < 1)
            windowHistoryIndex := windowHistory.MaxIndex()
        id := windowHistory[windowHistoryIndex]
        if (id)
        {
            WinActivate, ahk_id %id%
        }
    }
    centerMouse(id)
}

activateLastFlWin()
{
    WinActivate, ahk_id lastFlWin
    centerMouse(lastFlWin)
    if (isMixer(lastFlWin))
        moveMouseOnMixerSlot()    
}

closeAllWinHistory(closeStepSeq = True)
{
    global windowHistory
    for i, winId in windowHistory
    {
        if (closeStepSeq)
            WinClose, ahk_id %winId%
        else if (!isStepSeq(winId))
            WinClose, ahk_id %winId%
    }    
}
; ----

; -- Clear from history --------------------------
winHistoryRemoveMainWins()
{
    i := 1
    while (i <= windowHistory.MaxIndex())
    {
        winId := windowHistory[i]
        if (isMixer(winId) or isStepSeq(winId) or isPianoRoll(winId) or isMasterEdison(winId))
            windowHistory.RemoveAt(i)
        else
            i := i + 1
    }
}

winHistoryRemovePluginsExceptLast(n = 3)
{
    currIndexWinId := windowHistory[windowHistoryIndex]
    index := windowHistoryIndex
    
    i := 1
    numWins := windowHistory.MaxIndex()
    while (i <= numWins)
    {
        incrIndex := True
        if (isPlugin(windowHistory[index]))
        {
            if (n > 0)
                n := n - 1
            else
            {
                pluginId := windowHistory[index]
                WinClose, ahk_id %pluginId%
                if (index < windowHistory.MaxIndex())
                    incrIndex := False
                windowHistory.RemoveAt(index)
            }
        }
        if (incrIndex)
        {
            index := index + 1
            if (index > windowHistory.MaxIndex())
                index := 1  
        }
        i := i + 1
    }

    for i, winId in windowHistory
    {
        if (currIndexWinId == winId)
        {
            windowHistoryIndex := i
            break
        }
    }
}
; ----

