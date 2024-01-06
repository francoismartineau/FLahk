denoise()
{
    edisonId := bringMasterEdison(True)
    res := waitToolTip("Select silence and accept")
    if (!res)
        return
    SendInput ^u
    denoiserId := WaitNewWindowOfClass("TMEDenoiseToolForm", edisonId)
    Sleep, 500
    quickClick(391, 441)        ; Acquire Noise profile
    edisonId := WaitNewWindowOfClass("TPluginForm", denoiserId)
    if (!isEdison(edisonId))
        edisonId := bringMasterEdison(False)
    SendInput ^a
    SendInput ^u
    denoiserId := WaitNewWindowOfClass("TMEDenoiseToolForm", edisonId)
    Sleep, 500
    quickClick(565, 440)        ; Accept
    Sleep, 500
    WinActivate, ahk_id %edisonId%
    centerMouse(edisonId)
}