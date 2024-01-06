global whileRecOnPlay := False
recOnPlay()
{
    masterEdisonId := bringMasterEdison(False)
    setMasterEdisonMode("onPlay", masterEdisonId)
    armEdison()
    whileRecOnPlay := True
}

stopRecOnPlay()
{

}


/*

recOnPlayCreatePlugin(currWinId)
{
    copyName()
    placePlayHead()
    edisonID := loadFx(7)       ; Edison
    registerWinToHistory(edisonID, "mainWin")
    setMasterEdisonMode(edisonID)
    toggleArmEdison()
    pasteName("recOnPlay", True)
    WinActivate, ahk_id %currWinId%
}

placePlayHead()
{
    Playlist.bringWin(False)
    playlistToolTip("Place the play head and press Enter")
    unfreezeMouse()
    waitAcceptAbort()
    ToolTip
    freezeMouse()
    bringHistoryWins()
}
*/

