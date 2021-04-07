goForwardInSong() {
    ;stopWinHistoryClock()
    ;WinGet, id, ID, A
    ;bringPlaylist(False)
    Send {NumpadMult}
    ;WinActivate, ahk_id %id%
    ;startWinHistoryClock()
}

goBackWardInSong() {
    Send {NumpadDiv}
}