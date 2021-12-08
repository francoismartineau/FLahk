
global lastPatcher4Pos := 1
patcher4ChangeFx()
{
    ; regarde le coin haut gauche, adjacent diagonal au pixel manquand convexe
    static buttonX := [71, 217, 353, 499]
    static buttonY := [228, 226, 225, 225]
    activeColor := [0x628c31]

    Loop, 4
    {
        i := lastPatcher4Pos + A_Index-1
        if (i > 4)
            i := 1
        if (colorsMatch(buttonX[i], buttonY[i], activeColor))
        {
            pos := i
            break
        }
    }

    ; deact current
    if (pos)
    {
        MouseMove, buttonX[pos], buttonY[pos], 0
        Click
    }

    ; act new
    Switch A_ThisHotkey
    {
    Case "Left":
        pos := pos - 1
        if (pos < 1)
            pos := 4
    Case "Right":
        pos := pos + 1
        if (pos > 4)
            pos := 1
    Default:
        pos := SubStr(A_ThisHotkey, 1, 1)
    }
    MouseMove, buttonX[pos], buttonY[pos], 0
    Click
    
    if pos is digit
        lastPatcher4Pos := pos
}

patcher4MouseOnShowPlugin()
{
    res := False
    MouseGetPos, mX, mY
    if (mY > 270 and mY < 292)
        res := colorsMatch(mX, mY, [0xA8B985])
    return res
}

patcher4ShowPlugin()
{
    MouseGetPos, mX
    if (mX < 165)
        n := 1
    else if (mX < 309)
        n := 2
    else if (mX < 454)
        n := 3
    else
        n := 4

    WinGet, patcher4Id, ID, A
    surfaceButtX := 122
    surfaceButtY := 40    
    mapButtX := 59
    mapButtY := 41     
    moveMouse(mapButtX, mapButtY)
    Click

    Switch n
    {
    Case 1:
        mY := 166
    Case 2:
        mY := 248
    Case 3:
        mY := 319
    Case 4:
        mY := 403
    }
    mX := 1168

    moveMouse(mX, mY)
    if (!patcherPluginInArea(mX, mY))
    {
        toolTip("Move mouse on plugin and accept")
        unfreezeMouse()
        res := waitAcceptAbort()
        freezeMouse()
        toolTip()
        if (res == "abort")
        {
            msg(res)
            if (WinActive("ahk_id " patcher4Id))
                quickClick(surfaceButtX, surfaceButtY)
            return
        }
    }

    SendInput !{LButton}
    pluginId := waitNewWindow(patcher4Id, 500)
    if (!pluginId)
    {
        msg("can't open plugin")
        quickClick(surfaceButtX, surfaceButtY)
        return        
    }
    else
    {
        WinActivate, ahk_id %patcher4Id%
        quickClick(surfaceButtX, surfaceButtY)
        WinActivate, ahk_id %pluginId%
        centerMouse(pluginId)
    }
}