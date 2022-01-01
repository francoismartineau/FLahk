patcherActivateMap(patcherId)
{
    WinActivate, ahk_id %patcherId%
    mapY := 88 - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    mapX := 71
    moveMouse(mapX, mapY)
    Click
    return mapY
}

patcherActivateSurface(patcherId)
{
    WinActivate, ahk_id %patcherId%
    surfaceY := 88 - isWrapperPlugin(patcherId)*yOffsetWrapperPlugin
    surfaceX := 125    
    moveMouse(surfaceX, surfaceY)
    Click
    return surfaceY
}

patcherActivatePlugin(x, y)
{
    WinGet, currWinId, ID, A
    moveMouse(x, y)
    Click, 2
    pluginId := waitNewWindowOfClass("TWrapperPluginForm", currWinId, 0)
    return pluginId
}