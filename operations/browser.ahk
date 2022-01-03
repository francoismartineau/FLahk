global readyToDrag := False


; --- Packs ----------------------------------------
browsePacks(folderRow, mode := "postGen")
{
    toolTip("Reaching pos")
    moveWinsOverBrowser()
    wasRevealed := revealBrowserPacks()
    packsRow := 2

    i := 1
    while (i < folderRow)
    {
        if (browserFolderOpen(i + packsRow))
            clickBrowserFolder(i + packsRow)
        i := i + 1
    }
    if (!browserFolderOpen(folderRow + packsRow))
            clickBrowserFolder(folderRow + packsRow)

    Switch (mode)
    {
    Case "preGen":
        browserJumpToFile(folderRow + packsRow, 1)
        while (mouseOverBrowser() and mouseOverFolder())
        {
            Click
            folderRow++
            browserJumpToFile(folderRow + packsRow, 1)
        } 
    Case "postGen":
        fileRow := getRandomFileRowInFolderInPacks(folderRow)
        browserJumpToFile(folderRow + packsRow, fileRow)        
        startHighlight("browser")
        readyToDrag := True    
    }
    toolTip()
}

revealBrowserPacks()
{
    wasRevealed := True
    if (!browserSoundTabOpen())
    {
        browserOpenSoundTab()
        wasRevealed := False
    }
    if (!browserScrolledToTop())
    {
        scrollBrowserToTop()
        wasRevealed := False
    }
    if (browserFolderOpen(1))
    {
        clickBrowserFolder(1)
        wasRevealed := False
    }
    if (!browserFolderOpen(2))
    {
        clickBrowserFolder(2)
        wasRevealed := False
    }
    return wasRevealed
}

getRandomFileRowInFolderInPacks(folderRow)
{
    packsRow := 2
    global Mon2Bottom
    a := Mon2Bottom - (browserGetFolderY(folderRow + packsRow) + 10)
    fileHeight := 21
    maxFileRow := Floor(a/fileHeight)

    fileQty := getSoundAndFolderQtyInFolderInsidePacks(folderRow)
    maxFileRowForThisFolder := min(fileQty, maxFileRow)

    fileRow := randInt(1, maxFileRowForThisFolder)       ;;;;; use a distribution that tends to go up
    return fileRow
}
; ----




; -- Utils --------------------------------------------------------
moveWinsOverBrowser()
{

    saveMousePos()
    WinGet, id, ID, ahk_class TFruityLoopsMainForm
    moveMouse(217, 287, "Screen")
    clearWayToMouse(id, 310, 287)    
    moveMouse(186, 696, "Screen")
    clearWayToMouse(id, 310, 287)  
}

browserGetFolderY(n)
{
    channelPresetTriangleY := 145
    folderHeight := 23
    y := channelPresetTriangleY + (n-1)*folderHeight
    return y
}

browserGetFolderN(y)
{
    channelPresetTriangleY := 145
    folderHeight := 23
    n := (y-channelPresetTriangleY) / folderHeight + 1
    return Floor(n)
}
; ----

; -- Clicks -------------------------------------------------------
clickBrowserFolder(i)
{
    browserJumpToFolder(i)
    Click
}

browserOpenSoundTab()
{
    x := 198
    y := 116
    moveMouse(x, y, "Screen")
    Click
}

scrollBrowserToTop()
{
    moveMouse(5, 154, "Screen")
    Click
    Sleep, 300
}

closeCurrentlyOpenPacksFolder()
{
    ; from mouse, look to top until first opened folder
    foundOpenFolder := False
    bringMainFLWindow()
    mouseGetPos(_, mY)
    n := browserGetFolderN(mY)
    packsRow := 2
    while (n > 0 and !foundOpenFolder)
    {
        foundOpenFolder := browserFolderOpen(n + packsRow, folderY)
        n--
    }
    if (foundOpenFolder)
    {
        moveMouse("", folderY)
        Click
        res := True
    }
    else
        res := False
    return res
}

findOpenedFoldersFromPacksToFiles()
{
    ;; reliable only if scrolled to top
    prevMode := setMouseCoordMode("Screen")
    mouseGetPos(_, mY)
    currRow := browserGetFolderN(mY)
    n := 3
    openedRows := []
    toolTip("start")
    while (n < currRow)
    {   
        if (browserFolderOpen(n, folderY))
            openedRows.Push(n)
        n++
    }
    toolTip("done")
    setMouseCoordMode(prevMode)
    return openedRows
}

closeOpenedFoldersFromPacksToFiles()
{
    ;; reliable only if scrolled to top
    folders := findOpenedFoldersFromPacksToFiles()
    i := folders.MaxIndex()
    while (i >= 1)
    {
        browserJumpToFolder(folders[i])
        Click
        i--
    }
}
; ----

; -- Move ---------------------------------------------------------
browserJumpToFolder(folderRow)
{
    y := browserGetFolderY(folderRow)
    moveMouse(136, y, "Screen")
}

browserJumpToFile(folderRow, fileRow)
{
    folderY := browserGetFolderY(folderRow)
    fileHeight := 21
    y := folderY + fileRow*fileHeight + 2
    moveMouse(136, y, "Screen")
}

browserRelMove(dir, n := 1)
{
    WinActivate, ahk_class TFruityLoopsMainForm
    if (dir == "up")
        n := -n

    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY
    CoordMode, Mouse, Client
    fileHeight := 21
    y := mY + fileHeight * n
    packsFirstFolderY := 186
    if (y > packsFirstFolderY or y < Mon2Bottom)
        MouseMove, %mX%, %y% , 0
}
; ----

; -- Mouse position ---------------------------------------------
global mouseOverBrowserScroll := False
mouseOverBrowser()
{
    res := False
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY, winID
    CoordMode, Mouse, Client
    if (isMainFlWindow(winId))
    {
        WinGetPos, winX, winY, winW, winH, ahk_id %winID%
        mouseX := mouseX - winX
        mouseY := mouseY - winY
        browserRight := 239
        browserTop := 131
        res :=  mouseX >= 0 and mouseX <= browserRight and mouseY >= browserTop   
    }
    return res     
}

mouseOverBrowserScroll()
{
    res := False
    if (mouseOverBrowser())
    {
        CoordMode, Mouse, Screen
        MouseGetPos, mouseX, mouseY, winID
        CoordMode, Mouse, Client
        res :=  mouseX <= 30
    }
    return res         
}

mouseOverFolder()
{
    mouseGetPos(_, mY, "Screen")
    x := 237  
    folderColors := [0x2A3338, 0x1A2328]
    colVar := 3
    prevMode := setPixelCoordMode("Screen")
    res := colorsMatch(x, mY, folderColors, colVar)
    setPixelCoordMode(prevMode)
    return res
}
; ----


; -- Vision -----------------------------------------------------
browserSoundTabOpen()
{
    prevMode := setPixelCoordMode("Screen")
    x := 198
    y := 116
    blue := [0x547992, 0x66A7D4]
    res := colorsMatch(198, 116, blue, 50)
    setPixelCoordMode(prevMode)
    return res
}

browserScrolledToTop()
{
    res := True
    prevMode := setPixelCoordMode("Screen")
    scrollBarArrowX := 6
    scrollBarArrowY := 140
    scrollBarArrowCol := [0x1d262b]
    if (colorsMatch(scrollBarArrowX, scrollBarArrowY, scrollBarArrowCol, 10))
    {
        scrollBarX := 6
        scrollBarY := 156
        scrollBarCol := [0x121b20]
        res := colorsMatch(scrollBarX, scrollBarY, scrollBarCol, 10)
    }
    setPixelCoordMode(prevMode)
    return res
}

browserFolderOpen(n, ByRef y := "")
{
    res := False
    prevMode := setPixelCoordMode("Screen")
    x := 237
    if (isBrowserFolder(n, y))
    {
        colVar := 3
        res := colorsMatch(x, y, [0x2A3338], colVar)                    ; selected
        x := 233 
        if (res)
            res := colorsMatch(x, y, [0x131C21], colVar)                ; little triangle
    }
    setPixelCoordMode(prevMode)
    return res
}

isBrowserFolder(n, ByRef y := "")
{
    prevMode := setPixelCoordMode("Screen")
    y := browserGetFolderY(n)                               ; precisely the height of the "open folder triangle"
    x := 237   
    folderColors := [0x2A3338, 0x1A2328]
    colVar := 3
    res := colorsMatch(x, y, folderColors, colVar)
    setPixelCoordMode(prevMode)
    return res
}
; ----


; -- File info --------------------------------------------------
getSoundAndFolderQtyInFolderInsidePacks(folderRow)
{
    path := packsPath "\" getSortedPacksFolders()[folderRow]
    return soundNumInDir(path) + folderNumInDir(path)
}

getSortedPacksFolders()
{
    packsFolders := []
    underscorePacksFolders := []
    Loop, Files, %packsPath%\*, D
    {

        folder := A_LoopFileName
        if (StrSplit(folder)[1] == "_")
            underscorePacksFolders.Push(folder)
        else
            packsFolders.Push(folder)
    }
    for _, folder in packsFolders
    {
        underscorePacksFolders.Push(folder)
    }
    return underscorePacksFolders
}
; ----
