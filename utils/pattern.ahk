insertPattern(copyCurrName := False)
{
    toolTip("new pattern")
    WinGet, winId, ID, A
    mouseGetPos(mX, mY, "Screen")

    if (copyCurrName)
    {
        copyName("")
        moveMouse(mX, mY, "Screen")
    }
    Send {ShiftDown}{F4}{ShiftUp}

    nameEditorId := waitNewWindowOfClass("TNameEditForm", winId)
    if (copyName)
        pasteName("", False)
    Send {F2}

    WinGetPos,,, neW, neH, ahk_id %nameEditorId%
    neX := mX - Floor(neW/2)
    neY := mY - Floor(neH/2)
    WinMove, ahk_id %nameEditorId%,, %neX%, %neY%
    WinActivate, ahk_id %nameEditorId%
    if (!copyCurrName)
        typeText("Pat " randString(2))
    centerMouse(nameEditorId)
    unfreezeMouse()
    waitAcceptAbort(True)
    toolTip()
}

clonePattern()
{
    toolTip("clone pattern")
    Send {ShiftDown}{CtrlDown}c{ShiftUp}{CtrlUp}
    bringPlaylist(False)
    cloneSetName()
    toolTip()
}

moveToPatternRow()
{
    mX := 314
    mY := 873
    moveMouse(mX, mY, "Screen")
    WinGet, playlistId, ID, ahk_class TEventEditForm, Playlist
    clearWayToMouse(playlistId, mX, mY)
    retrieveMouse := False
}