global copypasteNameValue
global randomizingNameLoop := False

startRandomizeNameLoop(randomizeColor = False, pasteCol = False)
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

randomizeName(randomizeColor = False, pasteCol = False, forceKeepPos = False, prevName = "")
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

rename(name = "", randomizeColor = False, pasteCol = False, forceKeepPos = False)
{
    WinGet, winId, ID, A
    nameEditorId := bringNameEditor(winId)
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
        unfreezeMouse()
        acceptAbort := waitAcceptAbort(True, True)
        freezeMouse()
    }
    if (!forceKeepPos)
        centerMouse(winId)
    return acceptAbort
}

copyName(nameEditorId = "")
{
    MouseGetPos, mX, mY
    WinGetClass, class, A
    if (class == "TNameEditForm")
    {
        WinGet, nameEditorId, ID, A
        Send {CtrlDown}a{CtrlUp}
    }
    else
        nameEditorId := bringNameEditor() 

    clipboardSave := clipboard
    Send {CtrlDown}c{CtrlUp}{Esc}
    copypasteNameValue := clipboard
    clipboard := clipboardSave
    MouseMove, %mX%, %mY%
    return copypasteNameValue
}

pasteName(suffix = "", autoConfirm = True)
{
    WinGetClass, class, A
    if (class == "TNameEditForm")
    {
        WinGet, nameEditorId, ID, A
        Send {CtrlDown}a{CtrlUp}
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

pasteColor(nameEditorId = "", autoConfirm = True)
{
    if (!nameEditorId)
    {
        WinGetClass, class, A
        if (class == "TNameEditForm")
            WinGet, nameEditorId, ID, A
        else
            nameEditorId := bringNameEditor()
    }
    MouseMove, 205, 22, 0
    Click                       ; open color palette
    waitNewWindowOfClass("TPaletteEditorForm", nameEditorId)
    MouseMove, 41, 345
    Click                       ; choose last color
    Send {Enter}
    WinActivate, ahk_id %nameEditorId%
    if (autoConfirm)
        Send {Enter}
}


bringNameEditor(winId = "")
{
    if (!winId)
        WinGet, winId, ID, A
    if (isPlugin(winId))
    {
        if (isRaveGen())
        {
            QuickClick(10, 10)
            Loop, 6
            {
                Sleep, 20
                Send {WheelUp}
            }
            Send {Enter}
        }
        else
            Send {F2}
    }
    else if (mouseOverPlaylistTrackNames())
    {
        Click, Right
        Send {Down}{Enter}
    }
    else
        Send {F2}
    nameEditorId := waitNewWindowOfClass("TNameEditForm", winId)
    ;WinGetPos, currWinX,,,, ahk_id %nameEditorId%
    WinGetPos, winX, winY,,, ahk_id %winId%
    ;winX := winX + 20
    ;winY := winY + 30
    ;winX := 639
    ;winY := 421
    ;CoordMode, Mouse, Screen
    ;MouseGetPos, mx
    ;CoordMode, Mouse, Client
    ;if (mx < 0)
    ;{
    ;   winX := winX - 1920 
    ;   winY := winY + 568
    ;}
    WinMove, ahk_id %nameEditorId%,, %winX%, %winY%
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