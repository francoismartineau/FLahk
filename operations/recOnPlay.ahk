recOnPlay()
{
    WinGet, winId, ID, A
    if (isEdison(winId))
    {
        if (edisonArmed())
            setOnInput(winId)
        else
            setOnPlay(winId)
        toggleArmEdison()        
    }
    else
        recOnPlayCreatePlugin(winId)
}




recOnPlayCreatePlugin(currWinId)
{
    copyName()
    placePlayHead()
    edisonID := loadFx(7)       ; Edison
    registerWinToHistory(edisonID)
    setOnPlay(edisonID)
    toggleArmEdison()
    pasteName("recOnPlay", True)
    WinActivate, ahk_id %currWinId%
}

placePlayHead()
{
    bringPlaylist(False)
    playlistToolTip("Place the play head and press Enter")
    unfreezeMouse()
    waitAcceptAbort()
    ToolTip
    freezeMouse()
    bringHistoryWins()
}

