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

startWinMenusClock(speed = 400) {
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


SetTimer, SAVE_REMINDER_CLOCK, %saveReminderMilliseconds%
startMainClock()
startWinHistoryClock()
startWinMenusClock()
startMouseCtlClock()