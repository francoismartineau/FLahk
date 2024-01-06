insertPattern(copyCurrName := False)
{
    toolTip("new pattern")

    SendInput +^{Insert}        ; insert patt above, brings name editor
    if (copyCurrName)
        name := copyName()
    SendInput +^{Down}          ; move patt down
    nameEditorId := bringNameEditor()
    if (copyCurrName)
    {
        pasteName("", False)
        pasteColor(nameEditorId, False)
    }
    else
    {
        SendInput ^a
        typeText("Pat " randString(2))
        randomizeColor(True)
    }
    moveWinAtMouse(nameEditorId)
}

movePattern(dir)
{
    StringUpper, key, dir, T
    if (key == "Up" or key == "Down")
        SendInput +^{key}
}

clonePattern()
{
    toolTip("clone pattern")
    Send {ShiftDown}{CtrlDown}c{ShiftUp}{CtrlUp}
    Playlist.bringWin(False)
    cloneSetName()
    toolTip()
}

moveToPatternRow()
{
    toolTip("Patterns")
    mX := 314
    mY := 873
    moveMouse(mX, mY, "Screen")
    toolTip("Patterns")
    WinGet, playlistId, ID, ahk_class TEventEditForm, Playlist
    res := clearWayToMouse(playlistId, mX, mY)
    if (!res)
        return
    retrieveMouse := False
    Sleep, 300
    toolTip()
}