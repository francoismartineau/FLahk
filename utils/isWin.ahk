isFLWindow(winId)
{
    WinGet, program, ProcessName, ahk_id %winId%
    return program == "FL64.exe"
}

isOneOfMainWindows(winId = "")
{
    if (!winId)
        WinGet, winId, ID, A
    return isMixer(winId) or isMainFlWindow(winId) or isPlaylist(winId) or isMasterEdison(winId) or isTouchKeyboard(winId)
}

isWindowHistoryExclude(winId = "")
{
    if (!winId)
        WinGet, winId, ID, A
    return isMainFlWindow(winId) or isPlaylist(winId) or isTouchKeyboard(winId)

}

isMixer(winId = "", underMouse = False)
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



isStepSeq(winId = "")
{
    if (!winId)
        WinGetClass, class, A
    else
        WinGetClass, class, ahk_id %winId%
    return class == "TStepSeqForm"
}

isMainFlWindow(winId = "")
{
    if (!winId)
        WinGetClass, class, A
    else
        WinGetClass, class, ahk_id %winId%
    return class == "TFruityLoopsMainForm"
}

isTouchKeyboard(winId = "")
{
    if (!winId)
        WinGetClass, class, A
    else
        WinGetClass, class, ahk_id %winId%
    return class == "TTouchKeybForm"    
}

; -- EventEditForms ---------------
isPianoRoll(winId = "")
{
    res := False
    if (!winId)
        WinGet, winId, ID, A
    WinGetClass, class, ahk_id %winId%
    if (class == "TEventEditForm")
    {
        WinGetTitle, title, ahk_id %winId%
        res := InStr(title, "Piano roll -")
    }
    return res or winId == PianoRollMenuId
}

isPlaylist(winId = "")
{
    res := False
    if (!winId)
        WinGet, winId, ID, A
    WinGetClass, class, ahk_id %winId%
    if (class == "TEventEditForm")
    {
        WinGetTitle, title, ahk_id %winId%
        res := InStr(title, "Playlist -")
    }
    return res
}

isEventEditForm(winId = "")
{
    if (!winId)
        WinGetClass, class, A
    else 
        WinGetClass, class, ahk_id %winId%
    return class == "TEventEditForm"
}

isEventEditor(winId = "")
{
    if (!winId)
        WinGet, winId, ID, A
    WinGetClass, class, ahk_id %winId%
    WinGetTitle, title, ahk_id %winId%
    return class == "TEventEditForm" and InStr(title, "Events -")
}

; -- PianoRoll Tool Windows ------
isPianoRollTool(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return InStr(class, "TPR")
}

isPianorollLen(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRLegatoForm"    
}

isPianorollArp(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRArpForm"    
}

isPianorollRand(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRRandomForm"    
}

isPianorollGen(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRScoreCreatorForm"    
}

isPianorollQuantize(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPRQuantizeForm"    
}

; -- Plugins ---------------------
isInstr(id = "")
{
    ; look at the red around the pitch bend range
    res := False
    if (!id)
        WinGet, id, ID, A
    if (isPlugin(id))
    {
        WinGetPos,,, winW,, ahk_id %id%
        x := winW - 100
        y := 36
        col := [0x79434A]
        if colorsMatch(x, y, col, 10, "")
            res := True
    }
    return res
}

isPluginWithKeyboard(id = "")
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


is3xosc(id = "")
{
    res := False
    if (!id)
    WinGet, id, ID, A    
    WinGetPos,,, winW, winH, ahk_id %id%
    res := winW == 568 or winH == 466
    ;if (correctSize)
    ;    res := colorsMatch(489, 409, [0x252D32]) and colorsMatch(499, 409, [0x687176])
    return res
}

isMasterEdison(winId = "")
{
    if (!winId)
        WinGet, winId, ID, A
    WinGetTitle, title, ahk_id %winId%
    return InStr(title, "Master Edison")
}

isEdison(winId = "")
{
    ;;; Idée: donner une taille fixe à la fenetre.
    ;;;       ensuite regarder les couleurs
    res := False
    if (!winId)
        WinGet, winId, ID, A
    if (isPlugin(winId))
    {
        WinGetPos,,, winW, winH, ahk_id %winId%
        res := colorsMatch(11, 30, [0x777C81], 10) and colorsMatch(8, winH-9, [0x2A3141])
    }
    return res
}

isPlugin(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TPluginForm" 
}

isOneOfTheSamplers(id = "", underMouse = False)
{
    return isPatcherSampler(id, underMouse) or isPatcherSlicex(id, underMouse) or isPatcherGranular(id)
}

isPatcherSampler(id = "", underMouse = False)
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
    col := [0x353A4A]
    WinGetPos, winX, winY,,, ahk_id %id%
    setPixelCoordMode("Screen")
    res := colorsMatch(winX + x, winY + y, col) 
    setPixelCoordMode("Client")
    return res  
}

isPatcherSlicex(id = "", underMouse = False)
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
    col := [0x8D4E86]
    WinGetPos, winX, winY,,, ahk_id %id%
    setPixelCoordMode("Screen")
    res := colorsMatch(winX + x, winY + y, col) 
    setPixelCoordMode("Client")
    return res    
}

isPatcherGranular(id = "", underMouse = False)
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
    col := [0x574D5A]
    WinGetPos, winX, winY,,, ahk_id %id%
    setPixelCoordMode("Screen")
    res := colorsMatch(winX + x, winY + y, col) 
    if (res)
    {
        x := 48
        y := 161
        col := [0x2D4E52]    
        res := res and colorsMatch(winX + x, winY + y, col) 
    }
    setPixelCoordMode("Client")
    return res  
}

isPatcher4(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    return colorsMatch(315, 73, [0x9B8E8A]) and colorsMatch(250, 74, [0xA8B985])
}

isHarmless(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 858 and winH == 646 and colorsMatch(255, 237, [0x584451])
}

isWrapperPlugin(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    return class == "TWrapperPluginForm"    
}

isRaveGen(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    return colorsMatch(472, 415, [0x425B6B]) and colorsMatch(691, 366, [0x433D36])
}

isSytrus(id = "")
{
    if (id == "")
        WinGet, id, ID, A   
    return colorsMatch(35, 105, [0x2C3338]) and colorsMatch(10, 369, [0x31373B]) and colorsMatch(23, 210, [0x2C3338])
}

isPlucked(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 370 and winH == 233 and colorsMatch(31, 134, [0xBD883F])
}

isPiano(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return and winW == 494 and winH == 351 and colorsMatch(162, 91, [0x242424])
}

isBeepMap(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 390 and 220 < winH and winH < 275 and colorsMatch(144, 80, [0x2F424E])
}

isAutogun(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 312 and winH == 456
}

isFlex(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    return colorsMatch(399, 164, [0xD8833A])
}

; -- fx ---------------------------------------------
isDelB(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    return colorsMatch(272, 110, [0xDBADD6]) and colorsMatch(182, 154, [0x3F2A7D])   
}

isDelay(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 757 and winH == 248   
}

isProbablyEq(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 646 and winH == 354 ;and colorsMatch(10, 32, [0x2D3537]) and colorsMatch(18, 42, [0x565C5F])
}

isLfo(id = "")
{
    if (id == "")
        WinGet, id, ID, A

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

isRev(id = "")
{
    if (id == "")
        WinGet, id, ID, A
    WinGetPos,,, winW, winH, ahk_id %id%
    return winW == 543 and winH == 195
}

isDistructor(id = "")
{
    res := False
    if (!id)
        WinGet, id, ID, A
    if (isPlugin(id))
    {
        WinGetPos,,, winW, winH, ahk_id %id%
        if (winW == 934 and winH == 416)
            res := colorsMatch(745, 391, [0x1C2429], 0, "") and colorsMatch(754, 393, [0x66767E], 0, "") 
    } 
    return  res 
}