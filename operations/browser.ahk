global browserPosCount := 40
global browserPos := 0 ;Floor(browserPosCount / 2)
global browserLeft := 0
global browserRight := 239  
global browserTop := 24 ;130
global browsingFiles := False

global packsPath := "C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs"


; --- Conclusion ----------------------------------------
dragSample(proposeEdison = True)
{
    choices := ["Sp", "slcx", "gran"]
    if (proposeEdison)
        choices.Push("Edison")    
    if (findInWinHistory("isOneOfTheSamplers"))
        choices.Push("existing sampler")

    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY, winId
    CoordMode, Mouse, Client
    res := toolTipChoice(choices, "", randInt(1, choices.MaxIndex()))
    if (res == "accept")
    {
        Switch choices[toolTipChoiceIndex]
        {
        Case "Sp":
            createPatcherSampler(mX, mY, winId)   
        Case "slcx":
            createPatcherSlicex(mX, mY, winId)  
        Case "gran":
            granId := loadGranular(False)
            dragDropAnyPatcherSampler(mX, mY, winId, granId)
        Case "Edison":
            dragSampleToEdison(mX, mY)           
        Case "existing sampler":
            dragDropAnyPatcherSampler(mX, mY, winId)               
        }
    }
    browsingFiles := False
}

stopDragSample()
{
    browsingFiles := False
}

dragSampleToEdison(mX, mY)
{
    if (!isMasterEdison(masterEdisonId))
        masterEdisonId := bringMasterEdison(False)
    if (isMasterEdison(masterEdisonId))
    {
        moveMouse(mX, mY, "Screen")
        Send {LButton down}
        toolTip("Click down")
        Sleep, 30
        WinActivate, ahk_id %masterEdisonId%
        moveMouse(926, 285)
        toolTip("Click down")
        Sleep, 30
        Send {LButton up}
        toolTip("Click up")
        Sleep, 30
        toolTip()
    }
}


; --- Start Browsing ----------------------------------------
browseRandomGenFolder()
{
    gen1Pos := 2
    genFolderQty := 3
    
    basicGenPath := packsPath "\_gen"
    p := basicGenPath
    numFiles := fileNumInDir(p)
    weights := [numFiles]
    i := 2
    while (i <= genFolderQty)
    {
        p := basicGenPath . i
        numFiles := fileNumInDir(p)
        weights.Push(numFiles)
        i := i + 1
    }
    genNum := weightedRandomChoiceIndexOnly(weights)
    packsRowNum := gen1Pos-1 + genNum
    browsePacks(packsRowNum)
}

browsePacks(n)
{
    toolTip("Reaching pos")
    setPixelCoordMode("Screen")
    bringMainFLWindow()
    browsingFiles := True
    moveWinsOver([[217, 287], [186, 696]], 310, 287)

    colorsMatchDebug := False
    if (!browserSoundTabOpen())
        browserOpenSoundTab()
    if (!browserScrolledToTop())
        scrollBrowserToTop()
    i := 1
    packsRowNum := 2
    rowNum := n + packsRowNum
    while (i <= rowNum)
    {
        if (browserFolderOpen(i))
        {
            if (i != packsRowNum and i != rowNum)
            {
                browserJumpToPos(i)
                Click
            }
        }
        else
        {
            if (i == packsRowNum or i == rowNum)
            {
                browserJumpToPos(i)
                Click
            }            
        }
        i := i + 1
    }
    if (!browserFolderOpen(rowNum))
    {
        browserJumpToPos(i)
        Click
    }        
    
    fileQty := getFileQtyInFolderInsidePacks(rowNum-packsRowNum)
    ;;;;;;;;;;;;
    maxPos := min(fileQty, 43)
    n := randInt(1, maxPos)
    browserJumpToPos(rowNum + n)
    colorsMatchDebug := False
    toolTip()
    setPixelCoordMode("Client")
}

; ----
browserSoundTabOpen()
{
    x := 198
    y := 116
    whiteIcon := [0xd3d8dc]
    return !colorsMatch(198, 116, whiteIcon, 20)
}

browserOpenSoundTab()
{
    x := 198
    y := 116
    moveMouse(x, y)
    Click
}

browserScrolledToTop()
{
    res := True
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
    return res
}

scrollBrowserToTop()
{
    moveMouse(5, 154)
    Click
    Sleep, 300
}

browserFolderOpen(n)
{
    res := False
    y := 145 + (n-1)*23
    x := 216
    res := colorsMatch(x, y, [0x2A3338])                    ; selected
    x := 233 
    res := res and colorsMatch(x, y, [0x131C21])            ; little triangle
    return res
}


getFileQtyInFolderInsidePacks(n)
{
    path := packsPath "\" getSortedPacksFolders()[n]
    return fileNumInDir(path)
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

browserJumpToPos(n)
{
    y := getBrowserPosY(n)
    moveMouse(136, y)
    browserPos := n
}
; --

; -- Free scroll ------
global browserFreeScroll := False
browserMoveFromCurrentMousePos(dir, n = 1)
{
    browserFreeScroll := True
    browsingFiles := True
    if (!isMainFlWindow())
        WinActivate, ahk_class TFruityLoopsMainForm
    mouseOverBrowser()        
    browserPos := getMouseBrowserPos()
    n := n
    browserMove(dir, n)
    if (mouseOverBrowserScroll)
    {
        Switch dir
        {
        Case "up":
            wheel := "{WheelUp}"
        Case "down":
            wheel := "{WheelDown}"
        }
        Send %wheel%
    }
    browserFreeScroll := False
}

browserMove(dir, n = 1)
{
    lastBrowserTime := A_Now
    WinActivate, ahk_class TFruityLoopsMainForm

    Switch dir
    {
    Case "up":
        posAfterLimitReached := 5
        wheel := "WheelUp"
        n := -n
    Case "down":
        posAfterLimitReached := 35
        wheel := "WheelDown"    
    }

    browserPos := browserPos + n
    if (browserPos > browserPosCount or browserPos < 1)
    {
        browserPos := posAfterLimitReached
        Send {%wheel%}
    }
    MouseGetPos, x
    y := getBrowserPosY(browserPos)
    MouseMove %x%, %y%
}

getMouseBrowserPos()
{
    WinGet, mainFlWin, ID, ahk_class TFruityLoopsMainForm
    WinGetPos, winX, winY,,,ahk_id %mainFlWin%
    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY
    CoordMode, Mouse, Client
    mY := winY + mY
    return Floor((mY-132)/23)+1
}

getBrowserPosY(browserPos)
{
    ; fite pas avec getMouseBrowserPos que je viens de faire. stu ok?
    return 142 + (browserPos-1) * 23
}

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
        res :=  mouseX >= browserLeft and mouseX <= browserRight and mouseY >= browserTop   
        mouseOverBrowserScroll := res and mouseX <= 30
    }
    return res     
}


/*
clickBrowser()
{
    MouseGetPos,,, winId
    if (!isMainFlWindow(winId))
        WinMove, ahk_id %winId%,, %browserRight%
    Click
}
*/