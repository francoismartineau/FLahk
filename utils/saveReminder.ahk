global lastSaveTime := 0
global saveReminderMinutes := 5
global saveReminderSeconds := saveReminderMinutes * 60
global saveReminderMilliseconds := saveReminderSeconds * 1000


saveReminder()
{
    timeSinceLastSave := timeOfDaySeconds() - lastSaveTime
    Sleep, 1000
    if (timeSinceLastSave > saveReminderSeconds)
        msgTip("save?")
}
