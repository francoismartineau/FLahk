startMainClock() {
    SetTimer, MAIN_CLOCK, 500           ; montrer FLAHK seulement quand FL est ouvert
}

stopMainClock() {
    SetTimer, MAIN_CLOCK, Off
}

startWinHistoryClock() {
    SetTimer, WINDOW_HISTORY_CLOCK, 500             ; pour maintenir l'historique des fenêtres intéressantes
}

stopWinHistoryClock() {
    SetTimer, WINDOW_HISTORY_CLOCK, Off           
}

startWinMenusClock(speed := 400) {
    SetTimer, WINDOW_MENUS_CLOCK, %speed%
}

stopWinMenusClock() {
    SetTimer, WINDOW_MENUS_CLOCK, Off
}

startMouseCtlClock()
{
    SetTimer, MOUSE_CTL_TICK, 100
}

stopMouseCtlClock()
{
    SetTimer, MOUSE_CTL_TICK, Off
}

startMsgRefreshClock()
{
}
    SetTimer, MSG_REFRESH_TICK, 100

hideMsgRefreshClock()
{
    SetTimer, MSG_REFRESH_TICK, Off
}

startObsClock()
{
    SetTimer, OBS_CHECK_MOUSE_POS_TICK, 100
}

stopObsClock()
{
    SetTimer, OBS_CHECK_MOUSE_POS_TICK, Off
}

startRecordEnabledClock()
{
    SetTimer, RECORD_ENABLED_CLOCK, 50
}

stopRecordEnabledClock()
{
    SetTimer, RECORD_ENABLED_CLOCK, Off

}

startPYbootClock()
{
    SetTimer, PY_CHECK, 5000
}
stopPYbootClock()
{
    SetTimer, PY_CHECK, Off
}


global bringWinAtMouseToggle := False
startBringWinAtMouseClock()
{
    SetTimer, MOVE_WIN_AT_MOUSE, 100
    bringWinAtMouseToggle := True
}

stopBringWinAtMouseClock()
{
    SetTimer, MOVE_WIN_AT_MOUSE, Off
    bringWinAtMouseToggle := False
}


SetTimer, SAVE_REMINDER_CLOCK, %saveReminderMilliseconds%
startMainClock()
startWinHistoryClock()
startWinMenusClock()
startPYbootClock()
;startMouseCtlClock()