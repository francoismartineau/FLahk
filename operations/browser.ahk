global readyToDrag := False
global packsPath := "C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs"


; --- Packs ----------------------------------------
browsePacks(folderRow)
{
    toolTip("Reaching pos")
    moveWinsOverBrowser()
    wasRevealed := revealBrowserPacks() ;;;;;;
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

    fileRow := getRandomFileRowInFolderInPacks(folderRow)    ;;;;;
    browserJumpToFile(folderRow + packsRow, fileRow)
    startHighlight("browser")
    readyToDrag := True
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

    fileQty := getSoundQtyInFolderInsidePacks(folderRow)
    maxFileRowForThisFolder := min(fileQty, maxFileRow)

    fileRow := randInt(1, maxFileRowForThisFolder)       ;;;;; use a distribution that tends to go up
    return fileRow
}

browseRandomGenFolder()
{
    genPath := packsPath "\_gen"
    weights := [fileNumInDir(genPath)]
    i := 2
    genFolderQty := 3
    while (i <= genFolderQty)
    {
        weights.Push(fileNumInDir(genPath . i))
        i := i + 1
    }
    genNum := weightedRandomChoiceIndexOnly(weights)
    foldersBeforeGen1 := 1
    browsePacks(genNum + foldersBeforeGen1)
}
; ----




; -- Utils --------------------------------------------------------
moveWinsOverBrowser()
{
    moveWinsOver([[217, 287], [186, 696]], 310, 287)
}

browserGetFolderY(n)
{
    channelPresetTriangleY := 145
    folderHeight := 23
    y := channelPresetTriangleY + (n-1)*folderHeight
    return y
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

browserRelMove(dir, n = 1)
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
; ----


; -- Vision -----------------------------------------------------
browserSoundTabOpen()
{
    setPixelCoordMode("Screen")
    x := 198
    y := 116
    blue := [0x547992, 0x66A7D4]
    res := colorsMatch(198, 116, blue, 50)
    setPixelCoordMode("Client")
    return res
}

browserScrolledToTop()
{
    res := True
    setPixelCoordMode("Screen")
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
    setPixelCoordMode("Client")
    return res
}

browserFolderOpen(n)
{
    res := False
    setPixelCoordMode("Screen")
    x := 216
    y := browserGetFolderY(n)                               ; precisely the height of the "open folder triangle"
    res := colorsMatch(x, y, [0x2A3338])                    ; selected
    x := 233 
    res := res and colorsMatch(x, y, [0x131C21])            ; little triangle
    setPixelCoordMode("Client")
    return res
}
; ----


; -- File info --------------------------------------------------
getSoundQtyInFolderInsidePacks(folderRow)
{
    path := packsPath "\" getSortedPacksFolders()[folderRow]
    return soundNumInDir(path)
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
