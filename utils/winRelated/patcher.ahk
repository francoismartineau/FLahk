patcherActivateMap(patcherId)
{
    WinActivate, ahk_id %patcherId%
    mapY := 88 - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    mapX := 40
    moveMouse(mapX, mapY)
    Click
    return mapY
}

patcherGetSurfaceX(patcherId, panelsSectionClosed)
{
    x := 88 ; check line between Map Surface Button (location when longest Surface name is "Surface")
    y := 33 + (!panelsSectionClosed)*yOffsetWrapperPlugin
    cols := [0x1c2124, 0x202628] ; when Map is selected, when Surface is selected
    if (colorsMatch(x, y, cols))
        surfaceX := 125
    return surfaceX
}

patcherActivateSurface(patcherId)
{
    WinActivate, ahk_id %patcherId%
    Sleep, 200
    if (isWrapperPlugin(patcherId))
        panelsSectionClosed := True
    else
        panelsSectionClosed := !colorsMatch(31, 10, [0x8CFE7C])
    surfaceY := 88 - panelsSectionClosed*yOffsetWrapperPlugin
    surfaceX := patcherGetSurfaceX(patcherId, panelsSectionClosed)  
    if (surfaceX)
        moveMouse(surfaceX, surfaceY)
    else
    {
        moveMouse(125, surfaceY)
        res := waitToolTip("Place mouse on Surface button")
        if (!res)
            return False
    }
    Click
    return True
}

patcherActivatePlugin(x, y)
{
    WinGet, currWinId, ID, A
    moveMouse(x, y)
    Click, 2
    pluginId := waitNewWindowOfClass("TWrapperPluginForm", currWinId, 0)
    return pluginId
}

