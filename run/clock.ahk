startMainClock()
{
    SetTimer, MAIN_CLOCK, 500           ; montrer FLAHK seulement quand FL est ouvert
    return

    MAIN_CLOCK:
    hideShowFLahk()
    knobSavesDebuger()
    startStopObsClock()
    return   
}

stopMainClock()
{
    SetTimer, MAIN_CLOCK, Off
    return
}

startWinHistoryClock()
{
    SetTimer, WINDOW_HISTORY_CLOCK, 500             ; pour maintenir l'historique des fenêtres intéressantes
    return

    WINDOW_HISTORY_CLOCK:
    winHistoryTick()
    return  
}

stopWinHistoryClock()
{
    SetTimer, WINDOW_HISTORY_CLOCK, Off           
}

startGuiClock(speed := 400)
{
    SetTimer, GUI_CLOCK, %speed%
    return

    GUI_CLOCK:
    guiTick()
    return
}

stopGuiClock()
{
    SetTimer, GUI_CLOCK, Off
}

startMouseCtlClock()
{
    SetTimer, MOUSE_CTL_TICK, 100
    return

    MOUSE_CTL_TICK:
    mouseCtlTick()
    return
}

stopMouseCtlClock()
{
    SetTimer, MOUSE_CTL_TICK, Off
}

startMsgRefreshClock()
{
    SetTimer, MSG_REFRESH_TICK, 100
    return

    MSG_REFRESH_TICK:
    msgRefreshTick()
    return
}

stopMsgRefreshClock()
{
    SetTimer, MSG_REFRESH_TICK, Off
}

startObsClock()
{
    SetTimer, OBS_CHECK_MOUSE_POS_TICK, 100
    return

    OBS_CHECK_MOUSE_POS_TICK:
    obsCheckMousePosTick()
    return
}

stopObsClock()
{
    SetTimer, OBS_CHECK_MOUSE_POS_TICK, Off
}

startRecordEnabledClock()
{
    SetTimer, RECORD_ENABLED_CLOCK, 50
    return

    RECORD_ENABLED_CLOCK:
    mouseGetPos(mX, mY, "Screen")
    showRecordEnabledGui(mX-recordGuiW/3, mY+50)
    return
}

stopRecordEnabledClock()
{
    SetTimer, RECORD_ENABLED_CLOCK, Off
}

startPYbootClock()
{
    SetTimer, PY_CHECK, 5000
    return

    PY_CHECK:
    ; if (!checkIfPYrunning())
    ;     restartPY()
    return
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
    return

    MOVE_WIN_AT_MOUSE:
    moveWinAtMouse()
    return
}

stopBringWinAtMouseClock()
{
    SetTimer, MOVE_WIN_AT_MOUSE, Off
    bringWinAtMouseToggle := False
}

startSaveReminder()
{
    SetTimer, SAVE_REMINDER_CLOCK, %saveReminderMilliseconds%
    return

    SAVE_REMINDER_CLOCK:
    saveReminder()
    return
}

startIdeasClock()
{
    sec := 240
    ms := sec*1000
    SetTimer, IDEAS_CLOCK, %ms%
    return 
    
    IDEAS_CLOCK:
    displayRandomIdea()
    return
}

startClocks()
{
    startMainClock()
    startWinHistoryClock()
    startGuiClock()
    startPYbootClock()
    startSaveReminder()
    startIdeasClock()
    ;startMouseCtlClock()
}
