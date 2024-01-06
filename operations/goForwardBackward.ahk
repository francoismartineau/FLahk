goForwardInSong() {
    ;stopWinHistoryClock()
    ;WinGet, id, ID, A
    ;Playlist.bringWin(False)
    Send {NumpadMult}
    ;WinActivate, ahk_id %id%
    ;startWinHistoryClock()
}

goBackWardInSong() {
    Send {NumpadDiv}
}