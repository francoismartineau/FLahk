isFLWindow(winId := "")
{
    if (winId == "")
        WinGet, winId, ID, A
    WinGet, program, ProcessName, ahk_id %winId%
    return program == "FL64.exe"
}

isBrowser(winId := "")
{
    if (winId == "")
        WinGet, winId, ID, A
    WinGetClass, resClass, ahk_id %winId%
    return resClass == "#32770"
}

isPureData(winId := "")
{
    if (winId == "")
        WinGet, winId, ID, A
    WinGet, program, ProcessName, ahk_id %winId%
    return program == "wish85.exe"
}

isOneOfMainWindows(winId := "")
{
    if (!winId)
        WinGet, winId, ID, A
    return isMixer(winId) or isMainFlWindow(winId) or Playlist.isWin(winId) or isMasterEdison(winId) or isTouchKeyboard(winId)
}

isWindowHistoryExclude(winId := "")
{
    if (!winId)
        WinGet, winId, ID, A
    return isMainFlWindow(winId) or isTouchKeyboard(winId) or isControlSurface(winId)

}

isNameEditor(winId := "")
{
    if (!winId)
        WinGet, winId, ID, A
    WinGetClass, winClass, ahk_id %winId%
    return winClass == "TNameEditForm"

}

isMixer(winId := "", underMouse := False)
{
    if (!winId)
    {
        if (underMouse)
            MouseGetPos,,, winId
        else
            WinGet, winId, ID, A
    }
    WinGetClass, class, ahk_id %winId%
    return class == "TFXForm"
}

isMainFlWindow(winId := "", underMouse := False)
{
    if (!winId)
    {
        if (underMouse)
            MouseGetPos,,, winId
        else
            WinGet, winId, ID, A
    }
    WinGetClass, class, ahk_id %winId%
    return class == "TFruityLoopsMainForm"
}

isTouchKeyboard(winId := "")
{
    if (!winId)
        WinGetClass, class, A
    WinGetClass, class, ahk_id %winId%
    return class == "TTouchKeybForm"    
}

isAudacity(winId := "")
{
    if (winId == "")
        WinGet, winId, ID, A
    WinGet, exe, ProcessName, ahk_id %winId%
    WinGetClass, class, ahk_id %winId%
    return exe == "audacity.exe" and class == "wxWindowNR"
}

isMelodyne(winId := "")
{
    if (winId == "")
        WinGet, exe, ProcessName, A
    else
        WinGet, exe, ProcessName, ahk_id %winId%
    return exe == "Melodyne singletrack.exe"
}

isControlSurface(winId := "")
{
    if (!winId)
        WinGetTitle, title, A    
    else
        WinGetTitle, title, ahk_id %winId%
    return InStr(title, "Control Surface")
}

isAhkGui()
{
    WinGetClass, class, A
    return class == "AutoHotkeyGUI"
}
; -- EventEditForms ---------------
isPianoRoll(winId := "")
{
    success := False
    if (!winId)
        WinGet, winId, ID, A
    WinGetClass, class, ahk_id %winId%
    if (class == "TEventEditForm")
    {
        WinGetTitle, title, ahk_id %winId%
        success := InStr(title, "Piano roll -")
    }
    if (success)
        PianoRoll.winId := winId
    return success
}



isEventEditForm(winId := "")
{
    if (!winId)
        WinGetClass, class, A
    else 
        WinGetClass, class, ahk_id %winId%
    return class == "TEventEditForm"
}

isEventEditor(winId := "")
{
    if (!winId)
        WinGet, winId, ID, A
    WinGetClass, class, ahk_id %winId%
    WinGetTitle, title, ahk_id %winId%
    return class == "TEventEditForm" and InStr(title, "Events -")
}

; -- PianoRoll Tool Windows ------
isPianoRollTool(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return InStr(class, "TPR")
}

isPianorollLen(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRLegatoForm"    
}

isPianorollArp(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRArpForm"    
}

isPianorollRand(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRRandomForm"    
}

isPianorollGen(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRScoreCreatorForm"    
}

isPianorollQuantize(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRQuantizeForm"    
}

isPianoRollLfo(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRLFOForm" 
}

; -- Plugins ---------------------
isMidiWin(id := "", underMouse := False)
{
    success := False
    if (id == "")
    {
        if (underMouse)
            MouseGetPos,,, id
        else
            WinGet, id, ID, A
    }
    if (isInstr(id))
    {
        WinGetTitle, winTitle, ahk_id %id%
        success := SubStr(winTitle, 1, 2) == "PY"
    }
    return success
}

isInstr(id := "", underMouse := False)
{
    ; look at the red around the pitch bend range
    res := False
    if (id == "")
    {
        if (underMouse)
            MouseGetPos,,, id
        else
            WinGet, id, ID, A
    }
    if (isPlugin(id))
    {
        WinGetPos,,, winW,, ahk_id %id%
        x1 := winW - 100
        x2 := x1 - instrFullScreenXoffset ; - because right side
        y := 36
        col := [0x79434A]
        if colorsMatch(x1, y, col, 10) or colorsMatch(x2, y, col, 10)
            res := True
    }
    return res
}

isPluginWithKeyboard(id := "")
{
    if (!id)
        WinGet, id, ID, A
    res := False
    if (isPlugin(id)) 
    {
        WinGetPos,,, winW, winH, ahk_id %id%
        if (winW == 568 and winH == 466)
        {
            res := colorsMatch(527, 452, [0x868A91])
        }
    }
    return res
}

isFormulaCtl(id := "")
{
    if (!id)
        WinGet, id, ID, A
    res := False
    if (isPlugin(id))    
        res := colorsMatch(228, 63, [0x8da56c]) ; green from a knob
    return res
}

is3xosc(id := "")
{
    res := False
    if (!id)
        WinGet, id, ID, A    
    WinGetPos,,, winW, winH, ahk_id %id%
    res := winW == 568 or winH == 466
    return res
}

isMasterEdison(id := "", underMouse := False)
{
    if (id == "")
    {
        if (underMouse)
            MouseGetPos,,, id
        else
            WinGet, id, ID, A
    }
    WinGetTitle, title, ahk_id %id%
    return InStr(title, "Master Edison")
}

isEdison(winId := "", underMouse = False)
{
    ;;; Idée: donner une taille fixe à la fenetre.
    ;;;       ensuite regarder les couleurs
    res := False
    if (id == "")
    {
        if (underMouse)
            MouseGetPos,,, id
        else
            WinGet, id, ID, A
    }
    if (isPlugin(winId))
    {
        WinGetPos,,, winW, winH, ahk_id %winId%
        res := colorsMatch(11, 33, [0x797E83]) and colorsMatch(8, 126, [0x202329])
    }
    return res
}

isPlugin(id := "", underMouse := False)
{
    if (id == "")
    {
        if (underMouse)
            MouseGetPos,,, id
        else
            WinGet, id, ID, A
    }
    WinGetClass, class, ahk_id %id%
    return class == "TPluginForm" or isWrapperPlugin(id, underMouse)
}


isPatcherMap(id := "")
{
    res := False
    if (!id)
        WinGet, id, ID, A
    if (isPlugin(id))
    {
        ; look at top left colors of Map button while pressed
        colorListX := 32
        colorListY := 77 - isWrapperPlugin(id)*yOffsetWrapperPlugin
        colorList := [0x23292c, 0x252c31, 0x273035]
        res := scanColorsLine(colorListX, colorListY, colorList)
    }
    return res
}

global yOffsetWrapperPlugin := 46
isWrapperPlugin(id := "", underMouse := False)
{
    if (id == "")
    {
        if (underMouse)
            MouseGetPos,,, id
        else
            WinGet, id, ID, A
    }
    WinGetClass, class, ahk_id %id%
    return class == "TWrapperPluginForm"    
}

isOneOfTheSamplers(id := "", underMouse = False)
{
    return isPatcherSampler(id, underMouse) or isPatcherSlicex(id, underMouse) or isPatcherGrnl(id)
}

isPatcherSampler(id := "", underMouse = False)
{
    if (id == "")
    {
        if (underMouse)
            MouseGetPos,,, id
        else
            WinGet, id, ID, A
    }
    x := 380
    y := 120 + 4

    if (isWrapperPlugin(id))
        y := y - yOffsetWrapperPlugin

    col := [0x353A4A]
    WinGetPos, winX, winY,,, ahk_id %id%
    setPixelCoordMode("Screen")
    res := colorsMatch(winX + x, winY + y, col) 
    setPixelCoordMode("Client")
    return res  
}

isPatcherSlicex(id := "", underMouse = False)
{
    if (id == "")
    {
        if (underMouse)
            MouseGetPos,,, id
        else
            WinGet, id, ID, A
    }
    x := 103
    y := 116

    if (isWrapperPlugin(id))
        y := y - yOffsetWrapperPlugin

    col := [0x8D4E86]
    WinGetPos, winX, winY,,, ahk_id %id%
    setPixelCoordMode("Screen")
    res := colorsMatch(winX + x, winY + y, col) 
    setPixelCoordMode("Client")
    return res    
}

isPatcherGrnl(id := "", underMouse = False)
{
    if (id == "")
    {
        if (underMouse)
            MouseGetPos,,, id
        else
            WinGet, id, ID, A
    }
    x := 30
    y := 162
    if (isWrapperPlugin(id))
        y := y - yOffsetWrapperPlugin
    col := [0x574D5A]
    WinGetPos, winX, winY,,, ahk_id %id%
    setPixelCoordMode("Screen")
    res := colorsMatch(winX + x, winY + y, col) 
    if (res)
    {
        x := 48
        y := 161
        if (isWrapperPlugin(id))
            y := y - yOffsetWrapperPlugin        
        col := [0x2D4E52]    
        res := res and colorsMatch(winX + x, winY + y, col) 
    }
    setPixelCoordMode("Client")
    return res  
}

isHarmless(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    h := 646
    y := 237
    if (isWrapperPlugin(id))
    {
        y := y - yOffsetWrapperPlugin
        h := h - yOffsetWrapperPlugin
    }
    return winW == 858 and winH == h and colorsMatch(255, y, [0x584451])
}



isRaveGen(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    y1 := 415
    y2 := 366
    if (isWrapperPlugin(id))
    {
        y1 := y1 - yOffsetWrapperPlugin
        y2 := y2 - yOffsetWrapperPlugin
    }    
    return colorsMatch(472, y1, [0x425B6B]) and colorsMatch(691, y2, [0x433D36])
}

isSytrus(id := "")
{
    if (id == "")
        WinGet, id, ID, A   
    y1 := 105
    y2 := 369
    y3 := 210
    if (isWrapperPlugin(id))
    {
        y1 := y1 - yOffsetWrapperPlugin
        y2 := y2 - yOffsetWrapperPlugin
        y3 := y3 - yOffsetWrapperPlugin
    }    
    return colorsMatch(35, y1, [0x2C3338]) and colorsMatch(10, y2, [0x31373B]) and colorsMatch(23, y3, [0x2C3338])
}

isPlucked(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    h := 233
    y := 134
    if (isWrapperPlugin(id))
    {
        y := y - yOffsetWrapperPlugin
        h := h - yOffsetWrapperPlugin
    }    
    return winW == 370 and winH == h and colorsMatch(31, y, [0xBD883F])
}

isPiano(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    h := 351
    y := 91
    if (isWrapperPlugin(id))
    {
        y := y - yOffsetWrapperPlugin
        h := h - yOffsetWrapperPlugin
    }      
    return and winW == 494 and winH == h and colorsMatch(162, y, [0x242424])
}

isBeepMap(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    h1 := 220
    h2 := 275
    y := 80
    if (isWrapperPlugin(id))
    {
        y := y - yOffsetWrapperPlugin
        h1 := h1 - yOffsetWrapperPlugin
        h2 := h2 - yOffsetWrapperPlugin
    }      
    return winW == 390 and h1 < winH and winH < h2 and colorsMatch(144, y, [0x2F424E])
}

isAutogun(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    h := 456
    if (isWrapperPlugin(id))
        h := h - yOffsetWrapperPlugin
    return winW == 312 and winH == h
}

isFlex(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    y := 164
    if (isWrapperPlugin(id))
        y := y - yOffsetWrapperPlugin       
    return colorsMatch(399, y, [0xD8833A])
}

isSampleClip(id := "")
{
    res := False
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    if (winW == 568 or winH == 466)
    {
        res := colorsMatch(94, 267, [0x31373B]) and colorsMatch(274, 131, [0x363C40]) and colorsMatch(294, 143, [0x363C40])
    }
    return res    
}

is5lfo(id := "")
{
    res := False
    if (id == "")
        WinGet, id, ID, A
    if (isPlugin(id))
    {
        res := colorsMatch(252, 250, [0x6E7FB7])
    }
    return res
}

isPercEnv(id := "")
{
    success := False
    if (id == "")
        WinGet, id, ID, A
    if (isInstr(id))
        success := colorsMatch(18, 110, [0xD92628]) and colorsMatch(15, 127, [0xB449B6])
    if (success)
        PercEnv.winId := id
    return success    
}

; -- fx ---------------------------------------------
isPatcher4(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    y := 74
    return isPlugin(id) and colorsMatch(315, y, [0x9B8E8A]) and colorsMatch(250, y, [0xA8B985])
}

isPatcherMod(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    return isPlugin(id) and colorsMatch(185, 82, [0x40354A]) and colorsMatch(211, 86, [0xA5375D])
}

isDelB(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    return isPlugin(id) and colorsMatch(272, 110, [0xDBADD6]) and colorsMatch(182, 154, [0x3F2A7D])   
}

is3xGross(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    return isPlugin(id) and colorsMatch(14, 82, [0xBACFBF]) and colorsMatch(14, 100, [0x624456])
}


isDelay(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 757 and winH == 248   
}

isProbablyEq(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 646 and winH == 354 ;and colorsMatch(10, 32, [0x2D3537]) and colorsMatch(18, 42, [0x565C5F])
}

isLfo(id := "")
{
    if (id == "")
        WinGet, id, ID, A

    if (isPianoRollLfo(id))
        return False

    res := False
    WinGetTitle, title, ahk_id %id%
    if (InStr(title, "LFO"))
        res := True
    else
    {
        WinGetPos,,, winW,, ahk_id %id%    
        res := winW == 535 and colorsMatch(174, 44, [0x363C40]) and colorsMatch(236, 43, [0x31373B])
    }
    return res
}

isRev(id := "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 543 and winH == 195
}

isDistructor(id := "")
{
    res := False
    if (!id)
        WinGet, id, ID, A
    if (isPlugin(id))
    {
        WinGetPos,,, winW, winH, ahk_id %id%
        if (winW == 934 and winH == 416)
            res := colorsMatch(745, 391, [0x1C2429]) and colorsMatch(754, 393, [0x66767E]) 
    } 
    return  res 
}