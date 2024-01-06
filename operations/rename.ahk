global copypasteNameValue
global randomizingNameLoop := False


rename(name := "", randomizeColor := False, pasteCol := False, forceKeepPos := False)
{
    WinGet, winId, ID, A
    nameEditorId := bringNameEditor(winId)
    if (!nameEditorId)
        return False
    if (randomizeColor)
        Send {F2}
    if (pasteCol)
        pasteColor(nameEditorId, False)

    if (name != "")
    {
        TypeText(name)
        Send {Enter}
    }
    else
    {
        if (!forceKeepPos)
            centerMouse(nameEditorId)
        res := waitToolTip("Accept / Abort")
        if (isNameEditor())
        {
            if (res)
                Send {Enter}
            else
                Send {Esc}
        }
    }
    return res
}

startRandomizeNameLoop(randomizeColor := False, pasteCol := False)
{
    randomizingNameLoop := True
    while (randomizingNameLoop)
    {
        waitWindowNotOfClass("TNameEditForm")
        randomizeName(False, False, True)
        Sleep, 200
        if (!keyDown("r") and !keyDown("F2"))
            randomizingNameLoop := False
    }
}

randomizeName(randomizeColor := False, pasteCol := False, forceKeepPos := False, prevName := "")
{
    if (!prevName)
    {
        prevName := copyName()
        prevName := StrSplit(prevName, [A_Tab, A_Space])[1]
    }

    if (oneChanceOver(3))
        prevName := randomizeStringOrder(prevName)
    if (oneChanceOver(4, "invert"))
        len := randInt(1, 4)
    else
        len := Ceil(expRand(3, 10, .1))
    name := prevName " " randString(len)
    rename(name, randomizeColor, pasteCol, forceKeepPos)
}

randomizeColor(nameEditorOpen := False, winId := "")
{
    if (nameEditorOpen)
    {
        Send {F2}
        return
    }

    if (winId == "")
        WinGet, winId, ID, A
    if (!isNameEditor(winId))
        nameEditorId := bringNameEditor(winId)
    else
        nameEditorId := winId
    if (nameEditorId)
        Send {F2}
}



copyName(winId := "")
{
    if (winId == "")
        WinGet, winId, ID, A
    WinGetClass, winClass, ahk_id %winId%
    if (isWrapperPlugin(winId))
    {
        WinGetTitle, winTitle, ahk_id %winId%
        name := StrSplit(winTitle, " ")[1]
    }    
    else 
    {
        if (isNameEditor(winId))
            SendInput ^a
        else
            bringNameEditor() 
        name := copyTextWithClipboard()
        Send {Esc}
    }
    return name
}

pasteName(suffix := "", autoConfirm := True)
{
    WinGet, currWinId, ID, A

    if (isNameEditor(currWinId))
    {
        nameEditorId := currWinId
        WinGet, nameEditorId, ID, A
        SendInput ^a
    }
    else
        nameEditorId := bringNameEditor()    

    pasteColor(nameEditorId, False)

    if (suffix)
        copypasteNameValue := copypasteNameValue " " suffix    

    Sleep, 50    
    TypeText(copypasteNameValue)

    if (autoConfirm)
        Send {Enter}
    else
        centerMouse(nameEditorId)
}

pasteColor(nameEditorId := "", autoConfirm := True)
{
    if (!nameEditorId)
    {
        WinGet, currWinId, ID, A
        if (isNameEditor(currWinId))
            nameEditorId := currWinId
        else
            nameEditorId := bringNameEditor()
    }
    quickClick(205, 22)         ; open color palette
    waitNewWindowOfClass("TPaletteEditorForm", nameEditorId)
    quickClick(41, 345)         ; choose last color
    Send {Enter}
    WinActivate, ahk_id %nameEditorId%
    if (autoConfirm)
        Send {Enter}
}


bringNameEditor(currWinId := "")
{
    if (!currWinId)
        WinGet, currWinId, ID, A

    if (isNameEditor(currWinId))
        return currWinId
    if (isWrapperPlugin(currWinId))
        return False

    saveMousePos()
    if (isRaveGen(currWinId))
    {
        quickClick(10, 10)
        Loop, 6
        {
            Sleep, 20
            Send {WheelUp}
        }
        Send {Enter}
    }
    else if (mouseOverPlaylistTrackNames())
    {
        Click, Right
        Send {Down}{Enter}
    }
    else
        Send {F2}
    nameEditorId := waitNewWindowOfClass("TNameEditForm", currWinId)
    WinGetPos, winX, winY,,, ahk_id %currWinId%
    WinMove, ahk_id %nameEditorId%,, %winX%, %winY%
    retrieveMousePos()
    return nameEditorId
}

bringPluginNameEditor()
{
    MouseMove, 18, 16, 0
    Click
    Sleep, 100 
    len := getPluginCtxMenuLength()
    Switch len
    {
    Case "fx":
        y := 376
    Case "layer":
        y := 330
    Case "other":
        y := 355
    }
    MouseMove, 30, %y%, 0
    Click
}

getPluginCtxMenuLength()
{
    menuColor := [0xBBC3C8]
    if (!colorsMatch(249, 109, menuColor, 10))
        result := "fx"         
    else if (colorsMatch(138, 442, menuColor, 10))
        result := "other"   
    else if (colorsMatch(350, 236, menuColor, 10))
        result := "layer"      
    return result
}

makeControllerName(prefix, oriPluginName, suffix = "", autoAutomationName = "")
{
    pluginName := StrSplit(oriPluginName, " ")[1]
    if (autoAutomationName)
    {
        autoAutomationName := StrSplit(autoAutomationName, " ")
        suffix := autoAutomationName[autoAutomationName.MaxIndex()]
    }
    return prefix " " pluginName " " suffix
}